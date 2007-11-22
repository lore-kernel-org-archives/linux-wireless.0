Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1347 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbXKVFUD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 00:20:03 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH 1/2] mac80211: hardware scan rework (V3)
Date: Wed, 21 Nov 2007 21:18:52 -0800
Message-ID: <33E1C72C74DBE747B7B59C1740F74437027F3900@orsmsx417.amr.corp.intel.com> (sfid-20071122_052009_217598_79E2433F)
In-Reply-To: <11957000022000-git-send-email-yi.zhu@intel.com>
References: <11957000022000-git-send-email-yi.zhu@intel.com>
From: "Abbas, Mohamed" <mohamed.abbas@intel.com>
To: "Zhu, Yi" <yi.zhu@intel.com>, <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>,
	"Cahill, Ben M" <ben.m.cahill@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Actually ignore the previous email your patch still make sure we don't
handle management frame while scanning. The patch looks good and I will
run more test to make sure it covers all cases. Excellent job Yi.
Mohamed

-----Original Message-----
From: Zhu, Yi 
Sent: Wednesday, November 21, 2007 6:53 PM
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org; Zhu, Yi; Abbas, Mohamed; Cahill, Ben
M
Subject: [PATCH 1/2] mac80211: hardware scan rework (V3)

Hi,

This is the third version of the hardware scan rework patch. Comparing
with the second version, it allows mac80211 to set channel during the
hardware scan case. If the low level driver doesn't support setting
channels in the hardware scan process, the driver should cache this
setting and replay it after the scan is finished.

See Patch 2/2 for such modification for the iwlwifi drivers.


The scan code in mac80211 makes the software scan assumption in various
places. For example, we stop the Tx queue during a software scan so that
all the Tx packets will be queued by the stack. We also drop frames not
related to scan in the software scan process. But these are not true for
hardware scan.

Some wireless hardwares (for example iwl3945/4965) has the ability to
perform the whole scan process by hardware and/or firmware. The hardware
scan is relative powerful in that it tries to maintain normal network
traffic while doing a scan in the background. Some drivers (i.e iwlwifi)
do provide a way to tune the hardware scan parameters (for example if
the
STA is associated, what's the max time could the STA leave from the
associated channel, how long the scans get suspended after returning to
the service channel, etc). But basically this is transparent to the
stack. mac80211 should not stop Tx queues or drop Rx packets during a
hardware scan.

This patch resolves the above problem by spliting the current scan
indicator local->sta_scanning into local->sta_sw_scanning and
local->sta_hw_scanning. It then changes the scan related code to be
aware
of hardware scan or software scan in various places. With this patch,
iwlwifi performs much better in the scan-while-associated condition and
disable_hw_scan=1 should never be required.

Cc: Mohamed Abbas <mohamed.abbas@intel.com>
Cc: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>


diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 59350b8..acbe717 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -351,11 +351,14 @@ static int ieee80211_stop(struct net_device *dev)
 		synchronize_rcu();
 		skb_queue_purge(&sdata->u.sta.skb_queue);
 
-		if (!local->ops->hw_scan &&
-		    local->scan_dev == sdata->dev) {
-			local->sta_scanning = 0;
-			cancel_delayed_work(&local->scan_work);
+		if (local->scan_dev == sdata->dev) {
+			if (!local->ops->hw_scan) {
+				local->sta_sw_scanning = 0;
+				cancel_delayed_work(&local->scan_work);
+			} else
+				local->sta_hw_scanning = 0;
 		}
+
 		flush_workqueue(local->hw.workqueue);
 		/* fall through */
 	default:
@@ -523,7 +526,7 @@ int ieee80211_hw_config(struct ieee80211_local
*local)
 	struct ieee80211_channel *chan;
 	int ret = 0;
 
-	if (local->sta_scanning) {
+	if (local->sta_sw_scanning) {
 		chan = local->scan_channel;
 		mode = local->scan_hw_mode;
 	} else {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 72e1c93..35829b1 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -470,7 +470,8 @@ struct ieee80211_local {
 
 	struct list_head interfaces;
 
-	int sta_scanning;
+	bool sta_sw_scanning;
+	bool sta_hw_scanning;
 	int scan_channel_idx;
 	enum { SCAN_SET_CHANNEL, SCAN_SEND_PROBE } scan_state;
 	unsigned long last_scan_completed;
@@ -749,7 +750,8 @@ int ieee80211_sta_req_scan(struct net_device *dev,
u8 *ssid, size_t ssid_len);
 void ieee80211_sta_req_auth(struct net_device *dev,
 			    struct ieee80211_if_sta *ifsta);
 int ieee80211_sta_scan_results(struct net_device *dev, char *buf,
size_t len);
-void ieee80211_sta_rx_scan(struct net_device *dev, struct sk_buff *skb,
+ieee80211_txrx_result ieee80211_sta_rx_scan(struct net_device *dev,
+					    struct sk_buff *skb,
 			   struct ieee80211_rx_status *rx_status);
 void ieee80211_rx_bss_list_init(struct net_device *dev);
 void ieee80211_rx_bss_list_deinit(struct net_device *dev);
diff --git a/net/mac80211/ieee80211_ioctl.c
b/net/mac80211/ieee80211_ioctl.c
index 942b9cc..f2d84f3 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -315,7 +315,7 @@ int ieee80211_set_channel(struct ieee80211_local
*local, int channel, int freq)
 	}
 
 	if (set) {
-		if (local->sta_scanning)
+		if (local->sta_sw_scanning)
 			ret = 0;
 		else
 			ret = ieee80211_hw_config(local);
@@ -558,8 +558,10 @@ static int ieee80211_ioctl_giwscan(struct
net_device *dev,
 {
 	int res;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	if (local->sta_scanning)
+
+	if (local->sta_sw_scanning || local->sta_hw_scanning)
 		return -EAGAIN;
+
 	res = ieee80211_sta_scan_results(dev, extra, data->length);
 	if (res >= 0) {
 		data->length = res;
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 015b3f8..26f404a 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1487,8 +1487,18 @@ static void ieee80211_rx_bss_info(struct
net_device *dev,
 		u32 supp_rates, prev_rates;
 		int i, j;
 
-		mode = local->sta_scanning ?
+		mode = local->sta_sw_scanning ?
 		       local->scan_hw_mode : local->oper_hw_mode;
+
+		if (local->sta_hw_scanning) {
+			/* search for the correct mode matches the
beacon */
+			list_for_each_entry(mode, &local->modes_list,
list)
+				if (mode->mode == rx_status->phymode)
+					break;
+
+			if (mode == NULL)
+				mode = local->oper_hw_mode;
+		}
 		rates = mode->rates;
 		num_rates = mode->num_rates;
 
@@ -1871,31 +1881,39 @@ static void ieee80211_sta_rx_queued_mgmt(struct
net_device *dev,
 }
 
 
-void ieee80211_sta_rx_scan(struct net_device *dev, struct sk_buff *skb,
-			   struct ieee80211_rx_status *rx_status)
+ieee80211_txrx_result
+ieee80211_sta_rx_scan(struct net_device *dev, struct sk_buff *skb,
+		      struct ieee80211_rx_status *rx_status)
 {
 	struct ieee80211_mgmt *mgmt;
 	u16 fc;
 
-	if (skb->len < 24) {
-		dev_kfree_skb(skb);
-		return;
-	}
+	if (skb->len < 2)
+		return TXRX_DROP;
 
 	mgmt = (struct ieee80211_mgmt *) skb->data;
 	fc = le16_to_cpu(mgmt->frame_control);
 
+	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL)
+		return TXRX_CONTINUE;
+
+	if (skb->len < 24)
+		return TXRX_DROP;
+
 	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) {
 		if ((fc & IEEE80211_FCTL_STYPE) ==
IEEE80211_STYPE_PROBE_RESP) {
 			ieee80211_rx_mgmt_probe_resp(dev, mgmt,
 						     skb->len,
rx_status);
+			dev_kfree_skb(skb);
+			return TXRX_QUEUED;
 		} else if ((fc & IEEE80211_FCTL_STYPE) ==
IEEE80211_STYPE_BEACON) {
 			ieee80211_rx_mgmt_beacon(dev, mgmt, skb->len,
 						 rx_status);
+			dev_kfree_skb(skb);
+			return TXRX_QUEUED;
 		}
 	}
-
-	dev_kfree_skb(skb);
+	return TXRX_CONTINUE;
 }
 
 
@@ -1985,7 +2003,7 @@ void ieee80211_sta_work(struct work_struct *work)
 	if (!netif_running(dev))
 		return;
 
-	if (local->sta_scanning)
+	if (local->sta_sw_scanning || local->sta_hw_scanning)
 		return;
 
 	if (sdata->type != IEEE80211_IF_TYPE_STA &&
@@ -2643,9 +2661,15 @@ void ieee80211_scan_completed(struct ieee80211_hw
*hw)
 	union iwreq_data wrqu;
 
 	local->last_scan_completed = jiffies;
-	wmb();
-	local->sta_scanning = 0;
+	memset(&wrqu, 0, sizeof(wrqu));
+	wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
 
+	if (local->sta_hw_scanning) {
+		local->sta_hw_scanning = 0;
+		goto done;
+	}
+
+	local->sta_sw_scanning = 0;
 	if (ieee80211_hw_config(local))
 		printk(KERN_DEBUG "%s: failed to restore operational"
 		       "channel after scan\n", dev->name);
@@ -2661,9 +2685,6 @@ void ieee80211_scan_completed(struct ieee80211_hw
*hw)
 
 	netif_tx_unlock_bh(local->mdev);
 
-	memset(&wrqu, 0, sizeof(wrqu));
-	wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
-
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 
@@ -2681,6 +2702,7 @@ void ieee80211_scan_completed(struct ieee80211_hw
*hw)
 	}
 	rcu_read_unlock();
 
+done:
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->type == IEEE80211_IF_TYPE_IBSS) {
 		struct ieee80211_if_sta *ifsta = &sdata->u.sta;
@@ -2703,7 +2725,7 @@ void ieee80211_sta_scan_work(struct work_struct
*work)
 	int skip;
 	unsigned long next_delay = 0;
 
-	if (!local->sta_scanning)
+	if (!local->sta_sw_scanning)
 		return;
 
 	switch (local->scan_state) {
@@ -2766,7 +2788,7 @@ void ieee80211_sta_scan_work(struct work_struct
*work)
 		break;
 	}
 
-	if (local->sta_scanning)
+	if (local->sta_sw_scanning)
 		queue_delayed_work(local->hw.workqueue,
&local->scan_work,
 				   next_delay);
 }
@@ -2798,7 +2820,7 @@ static int ieee80211_sta_start_scan(struct
net_device *dev,
 	  * ResultCode: SUCCESS, INVALID_PARAMETERS
 	 */
 
-	if (local->sta_scanning) {
+	if (local->sta_sw_scanning || local->sta_hw_scanning) {
 		if (local->scan_dev == dev)
 			return 0;
 		return -EBUSY;
@@ -2806,15 +2828,15 @@ static int ieee80211_sta_start_scan(struct
net_device *dev,
 
 	if (local->ops->hw_scan) {
 		int rc = local->ops->hw_scan(local_to_hw(local),
-					    ssid, ssid_len);
+					     ssid, ssid_len);
 		if (!rc) {
-			local->sta_scanning = 1;
+			local->sta_hw_scanning = 1;
 			local->scan_dev = dev;
 		}
 		return rc;
 	}
 
-	local->sta_scanning = 1;
+	local->sta_sw_scanning = 1;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
@@ -2869,7 +2891,7 @@ int ieee80211_sta_req_scan(struct net_device *dev,
u8 *ssid, size_t ssid_len)
 	if (sdata->type != IEEE80211_IF_TYPE_STA)
 		return ieee80211_sta_start_scan(dev, ssid, ssid_len);
 
-	if (local->sta_scanning) {
+	if (local->sta_sw_scanning || local->sta_hw_scanning) {
 		if (local->scan_dev == dev)
 			return 0;
 		return -EBUSY;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 428a9fc..596ff71 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -338,8 +338,14 @@ ieee80211_rx_h_passive_scan(struct
ieee80211_txrx_data *rx)
 	struct ieee80211_local *local = rx->local;
 	struct sk_buff *skb = rx->skb;
 
-	if (unlikely(local->sta_scanning != 0)) {
-		ieee80211_sta_rx_scan(rx->dev, skb, rx->u.rx.status);
+	if (unlikely(local->sta_hw_scanning))
+		return ieee80211_sta_rx_scan(rx->dev, skb,
rx->u.rx.status);
+
+	if (unlikely(local->sta_sw_scanning)) {
+		/* drop all the other packets during a software scan
anyway */
+		if (ieee80211_sta_rx_scan(rx->dev, skb, rx->u.rx.status)
+		    != TXRX_QUEUED)
+			dev_kfree_skb(skb);
 		return TXRX_QUEUED;
 	}
 
@@ -1486,7 +1492,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw,
struct sk_buff *skb,
 		goto end;
 	}
 
-	if (unlikely(local->sta_scanning))
+	if (unlikely(local->sta_sw_scanning || local->sta_hw_scanning))
 		rx.flags |= IEEE80211_TXRXD_RXIN_SCAN;
 
 	if (__ieee80211_invoke_rx_handlers(local,
local->rx_pre_handlers, &rx,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1a53154..a6a657f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -225,7 +225,7 @@ ieee80211_tx_h_check_assoc(struct
ieee80211_txrx_data *tx)
 	if (unlikely(tx->flags & IEEE80211_TXRXD_TX_INJECTED))
 		return TXRX_CONTINUE;
 
-	if (unlikely(tx->local->sta_scanning != 0) &&
+	if (unlikely(tx->local->sta_sw_scanning) &&
 	    ((tx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT ||
 	     (tx->fc & IEEE80211_FCTL_STYPE) !=
IEEE80211_STYPE_PROBE_REQ))
 		return TXRX_DROP;
