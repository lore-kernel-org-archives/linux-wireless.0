Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:60606 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbXKIICS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 03:02:18 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, flamingice@sourmilk.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 05/14] mac80211: adding 802.11n essential A-MPDU addBA capability
Date: Fri,  9 Nov 2007 10:01:57 +0200
Message-Id: <11945953312456-git-send-email-ron.rindjunsky@intel.com> (sfid-20071109_080227_506555_FCA26345)
In-Reply-To: <1194595331658-git-send-email-ron.rindjunsky@intel.com>
References: <1194595326527-git-send-email-ron.rindjunsky@intel.com>
 <11945953311871-git-send-email-ron.rindjunsky@intel.com>
 <11945953312850-git-send-email-ron.rindjunsky@intel.com>
 <11945953312367-git-send-email-ron.rindjunsky@intel.com>
 <1194595331658-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the capability to identify and answer an add block ACK
request.
As this series of patches only adds HT handling with no aggregations,
(A-MPDU aggregations acceptance is not obligatory according to 802.11n draft)
we are currently sending back a refusal upon this request.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/ieee80211_sta.c |  130 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 130 insertions(+), 0 deletions(-)

Index: wl2_6_24_HT/net/mac80211/ieee80211_sta.c
===================================================================
--- wl2_6_24_HT.orig/net/mac80211/ieee80211_sta.c
+++ wl2_6_24_HT/net/mac80211/ieee80211_sta.c
@@ -57,6 +57,15 @@
 
 #define ERP_INFO_USE_PROTECTION BIT(1)
 
+#ifdef CONFIG_MAC80211_HT
+/* mgmt header + 1 byte action code */
+#define IEEE80211_MIN_ACTION_SIZE (24 + 1)
+
+#define IEEE80211_ADDBA_PARAM_POLICY_MASK 0x0002
+#define IEEE80211_ADDBA_PARAM_TID_MASK 0x003C
+#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFA0
+#endif /* CONFIG_MAC80211_HT */
+
 static void ieee80211_send_probe_req(struct net_device *dev, u8 *dst,
 				     u8 *ssid, size_t ssid_len);
 static struct ieee80211_sta_bss *
@@ -1003,6 +1012,87 @@ static void ieee80211_auth_challenge(str
 			    elems.challenge_len + 2, 1);
 }
 
+#ifdef CONFIG_MAC80211_HT
+
+static void ieee80211_send_addba_resp(struct net_device *dev, u8 *da, u16 tid,
+					u8 dialog_token, u16 status, u16 policy,
+					u16 buf_size, u16 timeout)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+	u16 capab;
+
+	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom);
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer "
+		       "for addba resp frame\n", dev->name);
+		return;
+	}
+
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
+	memset(mgmt, 0, 24);
+	memcpy(mgmt->da, da, ETH_ALEN);
+	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	if (sdata->type == IEEE80211_IF_TYPE_AP)
+		memcpy(mgmt->bssid, dev->dev_addr, ETH_ALEN);
+	else
+		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
+	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
+					   IEEE80211_STYPE_ACTION);
+
+	skb_put(skb, 1 + sizeof(mgmt->u.action.u.addba_resp));
+	mgmt->u.action.category = WLAN_CATEGORY_BACK;
+	mgmt->u.action.u.addba_resp.action_code = WLAN_ACTION_ADDBA_RESP;
+	mgmt->u.action.u.addba_resp.dialog_token = dialog_token;
+
+	capab = (u16)(policy << 1);	/* bit 1 aggregation policy */
+	capab |= (u16)(tid << 2); 	/* bit 5:2 TID number */
+	capab |= (u16)(buf_size << 6);	/* bit 15:6 max size of aggergation */
+
+	mgmt->u.action.u.addba_resp.capab = cpu_to_le16(capab);
+	mgmt->u.action.u.addba_resp.timeout = cpu_to_le16(timeout);
+	mgmt->u.action.u.addba_resp.status = cpu_to_le16(status);
+
+	ieee80211_sta_tx(dev, skb, 0);
+
+	return;
+}
+
+static void ieee80211_sta_process_addba_request(struct net_device *dev,
+						struct ieee80211_mgmt *mgmt,
+						size_t len)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sta_info *sta;
+	u16 capab, tid, timeout, ba_policy, buf_size, status;
+	u8 dialog_token;
+
+	sta = sta_info_get(local, mgmt->sa);
+	if (!sta)
+		return;
+
+	/* extract session parameters from addba request frame */
+	dialog_token = mgmt->u.action.u.addba_req.dialog_token;
+	timeout = le16_to_cpu(mgmt->u.action.u.addba_req.timeout);
+
+	capab = le16_to_cpu(mgmt->u.action.u.addba_req.capab);
+	ba_policy = (capab & IEEE80211_ADDBA_PARAM_POLICY_MASK) >> 1;
+	tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
+	buf_size = (capab & IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK) >> 6;
+
+	/* TODO - add here aggregation support */
+	status = WLAN_STATUS_REQUEST_DECLINED;
+
+	ieee80211_send_addba_resp(sta->dev, sta->addr, tid, dialog_token,
+				status, 1, buf_size, timeout);
+	sta_info_put(sta);
+}
+
+#endif /* CONFIG_MAC80211_HT */
 
 static void ieee80211_rx_mgmt_auth(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta,
@@ -1879,6 +1969,37 @@ static void ieee80211_rx_mgmt_probe_req(
 	ieee80211_sta_tx(dev, skb, 0);
 }
 
+#ifdef CONFIG_MAC80211_HT
+
+void ieee80211_rx_mgmt_action(struct net_device *dev,
+			     struct ieee80211_if_sta *ifsta,
+			     struct ieee80211_mgmt *mgmt,
+			     size_t len)
+{
+	if (len < IEEE80211_MIN_ACTION_SIZE)
+		return;
+
+	switch (mgmt->u.action.category) {
+	case WLAN_CATEGORY_BACK:
+		switch (mgmt->u.action.u.addba_req.action_code) {
+		case WLAN_ACTION_ADDBA_REQ:
+			if (len < (IEEE80211_MIN_ACTION_SIZE +
+				   sizeof(mgmt->u.action.u.addba_req)))
+				break;
+			ieee80211_sta_process_addba_request(dev, mgmt, len);
+			break;
+		default:
+			printk(KERN_DEBUG "%s: received unsupported BACK\n",
+					dev->name);
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+#endif /* CONFIG_MAC80211_HT */
 
 void ieee80211_sta_rx_mgmt(struct net_device *dev, struct sk_buff *skb,
 			   struct ieee80211_rx_status *rx_status)
@@ -1908,6 +2029,9 @@ void ieee80211_sta_rx_mgmt(struct net_de
 	case IEEE80211_STYPE_REASSOC_RESP:
 	case IEEE80211_STYPE_DEAUTH:
 	case IEEE80211_STYPE_DISASSOC:
+#ifdef CONFIG_MAC80211_HT
+	case IEEE80211_STYPE_ACTION:
+#endif /* CONFIG_MAC80211_HT */
 		skb_queue_tail(&ifsta->skb_queue, skb);
 		queue_work(local->hw.workqueue, &ifsta->work);
 		return;
@@ -1965,6 +2089,11 @@ static void ieee80211_sta_rx_queued_mgmt
 	case IEEE80211_STYPE_DISASSOC:
 		ieee80211_rx_mgmt_disassoc(dev, ifsta, mgmt, skb->len);
 		break;
+#ifdef CONFIG_MAC80211_HT
+	case IEEE80211_STYPE_ACTION:
+		ieee80211_rx_mgmt_action(dev, ifsta, mgmt, skb->len);
+		break;
+#endif /* CONFIG_MAC80211_HT */
 	}
 
 	kfree_skb(skb);
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
