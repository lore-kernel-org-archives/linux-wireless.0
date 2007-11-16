Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:19248 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbXKPJPL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 04:15:11 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	flamingice@sourmilk.net
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Ben Cahill <ben.m.cahill@intel.com>
Subject: [PATCH] mac80211: hardware scan rework
Date: Fri, 16 Nov 2007 17:14:54 +0800
Message-Id: <1195204494710-git-send-email-yi.zhu@intel.com> (sfid-20071116_091518_350833_139AA89C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The scan code in mac80211 makes the software scan assumption in various
places. For example, we stop the Tx queue during a software scan so that
all the Tx packets will be queued by the stack. We also drop frames not
related to scan in the software scan process. But these are not true for
hardware scan.

Some wireless hardwares (for example iwl3945/4965) has the ability to
perform the whole scan process by hardware and/or firmware. The hardware
scan is relative powerful in that it tries to maintain normal network
traffic while doing a scan in the background. Some drivers (i.e iwlwifi)
do provide a way to tune the hardware scan parameters (for example if the
STA is associated, what's the max time could the STA leave from the
associated channel, how long the scans get suspended after returning to
the service channel, etc). But basically this is transparent to the
stack. mac80211 should not stop Tx queues or drop Rx packets during a
hardware scan.

This patch resolves the above problem by spliting the current scan
indicator local->sta_scanning into local->sta_sw_scanning and
local->sta_hw_scanning. It then changes the scan related code to be aware
of hardware scan or software scan in various places. With this patch,
iwlwifi performs much better in the scan-while-associated condition and
disable_hw_scan=1 should never be required.

Cc: Mohamed Abbas <mohamed.abbas@intel.com>
Cc: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/mac80211/ieee80211.c       |    4 ++--
 net/mac80211/ieee80211_i.h     |    6 ++++--
 net/mac80211/ieee80211_ioctl.c |    4 ++--
 net/mac80211/ieee80211_sta.c   |   37 ++++++++++++++++++++-----------------
 net/mac80211/rx.c              |   12 +++++++++---
 net/mac80211/tx.c              |    2 +-
 6 files changed, 38 insertions(+), 27 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index e0ee65a..1c2a1b6 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -330,7 +330,7 @@ static int ieee80211_stop(struct net_device *dev)
 
 		if (!local->ops->hw_scan &&
 		    local->scan_dev == sdata->dev) {
-			local->sta_scanning = 0;
+			local->sta_sw_scanning = 0;
 			cancel_delayed_work(&local->scan_work);
 		}
 		flush_workqueue(local->hw.workqueue);
@@ -500,7 +500,7 @@ int ieee80211_hw_config(struct ieee80211_local *local)
 	struct ieee80211_channel *chan;
 	int ret = 0;
 
-	if (local->sta_scanning) {
+	if (local->sta_sw_scanning) {
 		chan = local->scan_channel;
 		mode = local->scan_hw_mode;
 	} else {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 72e1c93..2f946b8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -470,7 +470,8 @@ struct ieee80211_local {
 
 	struct list_head interfaces;
 
-	int sta_scanning;
+	int sta_sw_scanning;
+	int sta_hw_scanning;
 	int scan_channel_idx;
 	enum { SCAN_SET_CHANNEL, SCAN_SEND_PROBE } scan_state;
 	unsigned long last_scan_completed;
@@ -749,7 +750,8 @@ int ieee80211_sta_req_scan(struct net_device *dev, u8 *ssid, size_t ssid_len);
 void ieee80211_sta_req_auth(struct net_device *dev,
 			    struct ieee80211_if_sta *ifsta);
 int ieee80211_sta_scan_results(struct net_device *dev, char *buf, size_t len);
-void ieee80211_sta_rx_scan(struct net_device *dev, struct sk_buff *skb,
+ieee80211_txrx_result ieee80211_sta_rx_scan(struct net_device *dev,
+					    struct sk_buff *skb,
 			   struct ieee80211_rx_status *rx_status);
 void ieee80211_rx_bss_list_init(struct net_device *dev);
 void ieee80211_rx_bss_list_deinit(struct net_device *dev);
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index 942b9cc..bf7e523 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -315,7 +315,7 @@ int ieee80211_set_channel(struct ieee80211_local *local, int channel, int freq)
 	}
 
 	if (set) {
-		if (local->sta_scanning)
+		if (local->sta_sw_scanning)
 			ret = 0;
 		else
 			ret = ieee80211_hw_config(local);
@@ -558,7 +558,7 @@ static int ieee80211_ioctl_giwscan(struct net_device *dev,
 {
 	int res;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	if (local->sta_scanning)
+	if (local->sta_sw_scanning || local->sta_hw_scanning)
 		return -EAGAIN;
 	res = ieee80211_sta_scan_results(dev, extra, data->length);
 	if (res >= 0) {
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 015b3f8..0ae14e9 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1487,7 +1487,7 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 		u32 supp_rates, prev_rates;
 		int i, j;
 
-		mode = local->sta_scanning ?
+		mode = local->sta_sw_scanning ?
 		       local->scan_hw_mode : local->oper_hw_mode;
 		rates = mode->rates;
 		num_rates = mode->num_rates;
@@ -1871,16 +1871,15 @@ static void ieee80211_sta_rx_queued_mgmt(struct net_device *dev,
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
+	if (skb->len < 24)
+		return TXRX_DROP;
 
 	mgmt = (struct ieee80211_mgmt *) skb->data;
 	fc = le16_to_cpu(mgmt->frame_control);
@@ -1889,13 +1888,16 @@ void ieee80211_sta_rx_scan(struct net_device *dev, struct sk_buff *skb,
 		if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_RESP) {
 			ieee80211_rx_mgmt_probe_resp(dev, mgmt,
 						     skb->len, rx_status);
+			dev_kfree_skb(skb);
+			return TXRX_QUEUED;
 		} else if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON) {
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
 
 
@@ -1985,7 +1987,7 @@ void ieee80211_sta_work(struct work_struct *work)
 	if (!netif_running(dev))
 		return;
 
-	if (local->sta_scanning)
+	if (local->sta_sw_scanning || local->sta_hw_scanning)
 		return;
 
 	if (sdata->type != IEEE80211_IF_TYPE_STA &&
@@ -2644,7 +2646,8 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
 
 	local->last_scan_completed = jiffies;
 	wmb();
-	local->sta_scanning = 0;
+	local->sta_hw_scanning = 0;
+	local->sta_sw_scanning = 0;
 
 	if (ieee80211_hw_config(local))
 		printk(KERN_DEBUG "%s: failed to restore operational"
@@ -2703,7 +2706,7 @@ void ieee80211_sta_scan_work(struct work_struct *work)
 	int skip;
 	unsigned long next_delay = 0;
 
-	if (!local->sta_scanning)
+	if (!local->sta_sw_scanning)
 		return;
 
 	switch (local->scan_state) {
@@ -2766,7 +2769,7 @@ void ieee80211_sta_scan_work(struct work_struct *work)
 		break;
 	}
 
-	if (local->sta_scanning)
+	if (local->sta_sw_scanning)
 		queue_delayed_work(local->hw.workqueue, &local->scan_work,
 				   next_delay);
 }
@@ -2798,7 +2801,7 @@ static int ieee80211_sta_start_scan(struct net_device *dev,
 	  * ResultCode: SUCCESS, INVALID_PARAMETERS
 	 */
 
-	if (local->sta_scanning) {
+	if (local->sta_sw_scanning || local->sta_hw_scanning) {
 		if (local->scan_dev == dev)
 			return 0;
 		return -EBUSY;
@@ -2808,13 +2811,13 @@ static int ieee80211_sta_start_scan(struct net_device *dev,
 		int rc = local->ops->hw_scan(local_to_hw(local),
 					    ssid, ssid_len);
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
@@ -2869,7 +2872,7 @@ int ieee80211_sta_req_scan(struct net_device *dev, u8 *ssid, size_t ssid_len)
 	if (sdata->type != IEEE80211_IF_TYPE_STA)
 		return ieee80211_sta_start_scan(dev, ssid, ssid_len);
 
-	if (local->sta_scanning) {
+	if (local->sta_sw_scanning || local->sta_hw_scanning) {
 		if (local->scan_dev == dev)
 			return 0;
 		return -EBUSY;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 428a9fc..5c50eba 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -338,8 +338,14 @@ ieee80211_rx_h_passive_scan(struct ieee80211_txrx_data *rx)
 	struct ieee80211_local *local = rx->local;
 	struct sk_buff *skb = rx->skb;
 
-	if (unlikely(local->sta_scanning != 0)) {
-		ieee80211_sta_rx_scan(rx->dev, skb, rx->u.rx.status);
+	if (unlikely(local->sta_hw_scanning != 0))
+		return ieee80211_sta_rx_scan(rx->dev, skb, rx->u.rx.status);
+
+	if (unlikely(local->sta_sw_scanning != 0)) {
+		/* drop all the other packets during a software scan anyway */
+		if (ieee80211_sta_rx_scan(rx->dev, skb, rx->u.rx.status)
+		    != TXRX_QUEUED)
+			dev_kfree_skb(skb);
 		return TXRX_QUEUED;
 	}
 
@@ -1486,7 +1492,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		goto end;
 	}
 
-	if (unlikely(local->sta_scanning))
+	if (unlikely(local->sta_sw_scanning || local->sta_hw_scanning))
 		rx.flags |= IEEE80211_TXRXD_RXIN_SCAN;
 
 	if (__ieee80211_invoke_rx_handlers(local, local->rx_pre_handlers, &rx,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1a53154..07b2d9e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -225,7 +225,7 @@ ieee80211_tx_h_check_assoc(struct ieee80211_txrx_data *tx)
 	if (unlikely(tx->flags & IEEE80211_TXRXD_TX_INJECTED))
 		return TXRX_CONTINUE;
 
-	if (unlikely(tx->local->sta_scanning != 0) &&
+	if (unlikely(tx->local->sta_sw_scanning != 0) &&
 	    ((tx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT ||
 	     (tx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_PROBE_REQ))
 		return TXRX_DROP;
-- 
1.5.2
