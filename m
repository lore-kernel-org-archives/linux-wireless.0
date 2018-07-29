Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:63193 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726255AbeG2Nnv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Jul 2018 09:43:51 -0400
From: Dedy Lansky <dlansky@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: [PATCH] cfg80211/mac80211: make ieee80211_send_layer2_update a public function
Date: Sun, 29 Jul 2018 14:59:16 +0300
Message-Id: <1532865556-25398-1-git-send-email-dlansky@codeaurora.org> (sfid-20180729_141604_940145_586BCA54)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make ieee80211_send_layer2_update() a common function so other drivers
can re-use it.
Add support in wil6210 to send L2UF on behalf of newly associated
station by calling the common function.

Change-Id: Ic2daa1b8392122931103eb5a963e14f8270818bb
Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/wmi.c |  2 ++
 include/net/cfg80211.h                 | 11 ++++++++
 net/mac80211/cfg.c                     | 48 ++--------------------------------
 net/wireless/util.c                    | 45 +++++++++++++++++++++++++++++++
 4 files changed, 60 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 5d99124..e63d136 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -962,6 +962,8 @@ static void wmi_evt_connect(struct wil6210_vif *vif, int id, void *d, int len)
 		}
 
 		cfg80211_new_sta(ndev, evt->bssid, sinfo, GFP_KERNEL);
+		if (wdev->iftype == NL80211_IFTYPE_AP)
+			cfg80211_send_layer2_update(ndev, wil->sta[evt->cid].addr);
 
 		kfree(sinfo);
 	} else {
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9a85097..4f57f77 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4733,6 +4733,17 @@ const u8 *cfg80211_find_vendor_ie(unsigned int oui, int oui_type,
 				  const u8 *ies, int len);
 
 /**
+ * cfg80211_send_layer2_update - send layer 2 update frame
+ *
+ * @dev: network device
+ * @addr: STA MAC address
+ *
+ * Wireless drivers can use this function to update forwarding tables in bridge
+ * devices upon STA association.
+ */
+void cfg80211_send_layer2_update(struct net_device *dev, const u8 *addr);
+
+/**
  * DOC: Regulatory enforcement infrastructure
  *
  * TODO
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d25da0e..da1b85d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1092,50 +1092,6 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	return 0;
 }
 
-/* Layer 2 Update frame (802.2 Type 1 LLC XID Update response) */
-struct iapp_layer2_update {
-	u8 da[ETH_ALEN];	/* broadcast */
-	u8 sa[ETH_ALEN];	/* STA addr */
-	__be16 len;		/* 6 */
-	u8 dsap;		/* 0 */
-	u8 ssap;		/* 0 */
-	u8 control;
-	u8 xid_info[3];
-} __packed;
-
-static void ieee80211_send_layer2_update(struct sta_info *sta)
-{
-	struct iapp_layer2_update *msg;
-	struct sk_buff *skb;
-
-	/* Send Level 2 Update Frame to update forwarding tables in layer 2
-	 * bridge devices */
-
-	skb = dev_alloc_skb(sizeof(*msg));
-	if (!skb)
-		return;
-	msg = skb_put(skb, sizeof(*msg));
-
-	/* 802.2 Type 1 Logical Link Control (LLC) Exchange Identifier (XID)
-	 * Update response frame; IEEE Std 802.2-1998, 5.4.1.2.1 */
-
-	eth_broadcast_addr(msg->da);
-	memcpy(msg->sa, sta->sta.addr, ETH_ALEN);
-	msg->len = htons(6);
-	msg->dsap = 0;
-	msg->ssap = 0x01;	/* NULL LSAP, CR Bit: Response */
-	msg->control = 0xaf;	/* XID response lsb.1111F101.
-				 * F=0 (no poll command; unsolicited frame) */
-	msg->xid_info[0] = 0x81;	/* XID format identifier */
-	msg->xid_info[1] = 1;	/* LLC types/classes: Type 1 LLC */
-	msg->xid_info[2] = 0;	/* XID sender's receive window size (RW) */
-
-	skb->dev = sta->sdata->dev;
-	skb->protocol = eth_type_trans(skb, sta->sdata->dev);
-	memset(skb->cb, 0, sizeof(skb->cb));
-	netif_rx_ni(skb);
-}
-
 static int sta_apply_auth_flags(struct ieee80211_local *local,
 				struct sta_info *sta,
 				u32 mask, u32 set)
@@ -1499,7 +1455,7 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	if (layer2_update)
-		ieee80211_send_layer2_update(sta);
+		cfg80211_send_layer2_update(sta->sdata->dev, sta->sta.addr);
 
 	rcu_read_unlock();
 
@@ -1601,7 +1557,7 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 		if (test_sta_flag(sta, WLAN_STA_AUTHORIZED))
 			ieee80211_vif_inc_num_mcast(sta->sdata);
 
-		ieee80211_send_layer2_update(sta);
+		cfg80211_send_layer2_update(sta->sdata->dev, sta->sta.addr);
 	}
 
 	err = sta_apply_parameters(local, sta, params);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index e0825a0..7bdcfe1 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1893,3 +1893,48 @@ int cfg80211_sinfo_alloc_tid_stats(struct station_info *sinfo, gfp_t gfp)
 const unsigned char bridge_tunnel_header[] __aligned(2) =
 	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8 };
 EXPORT_SYMBOL(bridge_tunnel_header);
+
+/* Layer 2 Update frame (802.2 Type 1 LLC XID Update response) */
+struct iapp_layer2_update {
+	u8 da[ETH_ALEN];	/* broadcast */
+	u8 sa[ETH_ALEN];	/* STA addr */
+	__be16 len;		/* 6 */
+	u8 dsap;		/* 0 */
+	u8 ssap;		/* 0 */
+	u8 control;
+	u8 xid_info[3];
+} __packed;
+
+void cfg80211_send_layer2_update(struct net_device *dev, const u8 *addr)
+{
+	struct iapp_layer2_update *msg;
+	struct sk_buff *skb;
+
+	/* Send Level 2 Update Frame to update forwarding tables in layer 2
+	 * bridge devices */
+
+	skb = dev_alloc_skb(sizeof(*msg));
+	if (!skb)
+		return;
+	msg = skb_put(skb, sizeof(*msg));
+
+	/* 802.2 Type 1 Logical Link Control (LLC) Exchange Identifier (XID)
+	 * Update response frame; IEEE Std 802.2-1998, 5.4.1.2.1 */
+
+	eth_broadcast_addr(msg->da);
+	ether_addr_copy(msg->sa, addr);
+	msg->len = htons(6);
+	msg->dsap = 0;
+	msg->ssap = 0x01;	/* NULL LSAP, CR Bit: Response */
+	msg->control = 0xaf;	/* XID response lsb.1111F101.
+				 * F=0 (no poll command; unsolicited frame) */
+	msg->xid_info[0] = 0x81;	/* XID format identifier */
+	msg->xid_info[1] = 1;	/* LLC types/classes: Type 1 LLC */
+	msg->xid_info[2] = 0;	/* XID sender's receive window size (RW) */
+
+	skb->dev = dev;
+	skb->protocol = eth_type_trans(skb, dev);
+	memset(skb->cb, 0, sizeof(skb->cb));
+	netif_rx_ni(skb);
+}
+EXPORT_SYMBOL(cfg80211_send_layer2_update);
-- 
1.9.1
