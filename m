Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42166 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760204AbXG3X3e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2007 19:29:34 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] mac80211: [HT] IEEE_802.11n TX AMPDU send action frames
Date: Tue, 31 Jul 2007 02:29:27 +0300
Message-Id: <1185838167686-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add function for sending ADDBA and DELBA
action frames

Signed-of-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/ieee80211_sta.c |   92 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 91 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 0d748a8..007dd08 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2562,7 +2562,97 @@ static void ieee80211_send_addba_resp(struct net_device *dev,
 
 	return;
 }
-#endif /* CONFIG_MAC80211_HT */
+
+void ieee80211_send_addba_request(struct net_device *dev, u8 *da, u16 tid,
+					u8 dialog_token, u16 start_seq_num,
+					u16 agg_size, u16 timeout)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+	u16 capab = 0;
+
+	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom + 1 +
+				sizeof(mgmt->u.action.u.addba_req));
+
+
+	if (!skb) {
+		printk(KERN_ERR "%s: failed to allocate buffer "
+				"for addba request frame\n", dev->name);
+		return;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
+	memset(mgmt, 0, 24);
+	memcpy(mgmt->da, da, ETH_ALEN);
+	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
+	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
+					IEEE80211_STYPE_ACTION);
+
+	skb_put(skb, 1 + sizeof(mgmt->u.action.u.addba_req));
+
+	mgmt->u.action.category = WLAN_CATEGORY_BACK;
+	mgmt->u.action.u.addba_req.action_code = WLAN_ACTION_ADDBA_REQ;
+
+	mgmt->u.action.u.addba_req.dialog_token = dialog_token;
+	capab |= (u16)(1 << 1);		/* bit 1 agg policy
+					(1 - immediate 0 - delayed )*/
+	capab |= (u16)(tid << 2); 	/* bit 5:2 TID number */
+	capab |= (u16)(agg_size << 6);	/* bit 15:6 size of aggergation */
+
+	mgmt->u.action.u.addba_req.capab = cpu_to_le16(capab);
+
+	mgmt->u.action.u.addba_req.timeout = cpu_to_le16(timeout);
+	mgmt->u.action.u.addba_req.start_seq_num = cpu_to_le16(start_seq_num);
+
+	ieee80211_sta_tx(dev, skb, 0);
+}
+
+void ieee80211_send_delba(struct net_device *dev, u8 *da, u16 tid,
+				u16 initiator, u16 reason_code)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+	u16 params = 0;
+
+	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom + 1 +
+					sizeof(mgmt->u.action.u.delba));
+
+	if (!skb) {
+		printk(KERN_ERR "%s: failed to allocate buffer "
+					"for delba frame\n", dev->name);
+		return;
+	}
+
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
+	memset(mgmt, 0, 24);
+	memcpy(mgmt->da, da, ETH_ALEN);
+	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
+	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
+					IEEE80211_STYPE_ACTION);
+
+	skb_put(skb, 1 + sizeof(mgmt->u.action.u.delba));
+
+	mgmt->u.action.category = WLAN_CATEGORY_BACK;
+	mgmt->u.action.u.delba.action_code = WLAN_ACTION_DELBA;
+						/* bit 10:0 reserved */
+	params |= (u16)(initiator << 11);	/* bit 11 initiator */
+	params |= (u16)(tid << 12);		/* bit 15:12 TID number */
+
+	mgmt->u.action.u.delba.params = cpu_to_le16(params);
+	mgmt->u.action.u.delba.reason_code = cpu_to_le16(reason_code);
+
+	ieee80211_sta_tx(dev, skb, 0);
+}
+#endif	/* CONFIG_MAC80211_HT */
 
 static void ieee80211_rx_mgmt_action(struct net_device *dev,
 				     struct ieee80211_if_sta *ifsta,
-- 
1.5.2.2
