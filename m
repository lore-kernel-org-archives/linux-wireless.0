Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44514 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab1I1LNM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 07:13:12 -0400
Received: by mail-fx0-f46.google.com with SMTP id 4so428931fxe.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2011 04:13:11 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Kalyan C Gaddam <chakkal@iit.edu>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v3 5/5] mac80211: data path modification for TDLS peers
Date: Wed, 28 Sep 2011 14:12:54 +0300
Message-Id: <1317208374-19286-5-git-send-email-arik@wizery.com> (sfid-20110928_131324_364862_898407C9)
In-Reply-To: <1317208374-19286-1-git-send-email-arik@wizery.com>
References: <1317208374-19286-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mark the STA entries of enabled TDLS peers with a new "peer authorized"
flag.

During link setup, allow special TDLS setup frames through the AP, but
otherwise drop all packets destined to the peer. This is required by the
TDLS (802.11z) specification in order to prevent reordering of MSDUs
between the AP and direct paths.

When setup completes and the peer is authorized, send data directly,
bypassing the AP.

In the Rx path, allow data to be received directly from TDLS peers.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Cc: Kalyan C Gaddam <chakkal@iit.edu>
---
 net/mac80211/cfg.c      |   10 ++++++++++
 net/mac80211/sta_info.h |    5 ++++-
 net/mac80211/tx.c       |   42 ++++++++++++++++++++++++++++++++++++++----
 net/wireless/util.c     |    5 +++--
 4 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 866677e..993d6b3 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2425,6 +2425,7 @@ fail:
 static int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 			       u8 *peer, enum nl80211_tdls_operation oper)
 {
+	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (!(wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS))
@@ -2439,6 +2440,15 @@ static int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 
 	switch (oper) {
 	case NL80211_TDLS_ENABLE_LINK:
+		rcu_read_lock();
+		sta = sta_info_get(sdata, peer);
+		if (!sta) {
+			rcu_read_unlock();
+			return -ENOLINK;
+		}
+
+		set_sta_flags(sta, WLAN_STA_TDLS_PEER_AUTH);
+		rcu_read_unlock();
 		break;
 	case NL80211_TDLS_DISABLE_LINK:
 		return sta_info_destroy_addr(sdata, peer);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index b6bd4e9..c10e2e8 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -45,7 +45,9 @@
  *	station in power-save mode, reply when the driver unblocks.
  * @WLAN_STA_PS_DRIVER_BUF: Station has frames pending in driver internal
  *	buffers. Automatically cleared on station wake-up.
- * @WLAN_STA_TDLS_PEER: station is a TDLS peer.
+ * @WLAN_STA_TDLS_PEER: Station is a TDLS peer.
+ * @WLAN_STA_TDLS_PEER_AUTH: This TDLS peer is authorized to send direct
+ *	packets. This means the link is enabled.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH		= 1<<0,
@@ -63,6 +65,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_PSPOLL		= 1<<13,
 	WLAN_STA_PS_DRIVER_BUF	= 1<<14,
 	WLAN_STA_TDLS_PEER	= 1<<15,
+	WLAN_STA_TDLS_PEER_AUTH	= 1<<16,
 };
 
 #define STA_TID_NUM 16
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 542272a..0ca1688 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1726,6 +1726,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	struct sta_info *sta = NULL;
 	u32 sta_flags = 0;
 	struct sk_buff *tmp_skb;
+	bool tdls_direct = false;
 
 	if (unlikely(skb->len < ETH_HLEN)) {
 		ret = NETDEV_TX_OK;
@@ -1837,11 +1838,43 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		break;
 #endif
 	case NL80211_IFTYPE_STATION:
-		memcpy(hdr.addr1, sdata->u.mgd.bssid, ETH_ALEN);
-		if (sdata->u.mgd.use_4addr &&
-		    cpu_to_be16(ethertype) != sdata->control_port_protocol) {
-			fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
+		if (sdata->wdev.wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS) {
+			rcu_read_lock();
+			sta = sta_info_get(sdata, skb->data);
+			if (sta)
+				sta_flags = get_sta_flags(sta);
+			rcu_read_unlock();
+
+			/*
+			 * If the TDLS link is enabled, send everything
+			 * directly. Otherwise, allow TDLS setup frames
+			 * to be transmitted indirectly.
+			 */
+			tdls_direct =
+				(sta_flags & WLAN_STA_TDLS_PEER) &&
+				((sta_flags & WLAN_STA_TDLS_PEER_AUTH) ||
+				 !(ethertype == ETH_P_TDLS && skb->len > 14 &&
+				   skb->data[14] == WLAN_TDLS_SNAP_RFTYPE));
+		}
+
+		if (tdls_direct) {
+			/* link during setup - throw out frames to peer */
+			if (!(sta_flags & WLAN_STA_TDLS_PEER_AUTH)) {
+				ret = NETDEV_TX_OK;
+				goto fail;
+			}
+
+			/* DA SA BSSID */
+			memcpy(hdr.addr1, skb->data, ETH_ALEN);
+			memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
+			memcpy(hdr.addr3, sdata->u.mgd.bssid, ETH_ALEN);
+			hdrlen = 24;
+		}  else if (sdata->u.mgd.use_4addr &&
+			    cpu_to_be16(ethertype) != sdata->control_port_protocol) {
+			fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS |
+					  IEEE80211_FCTL_TODS);
 			/* RA TA DA SA */
+			memcpy(hdr.addr1, sdata->u.mgd.bssid, ETH_ALEN);
 			memcpy(hdr.addr2, sdata->vif.addr, ETH_ALEN);
 			memcpy(hdr.addr3, skb->data, ETH_ALEN);
 			memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
@@ -1849,6 +1882,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		} else {
 			fc |= cpu_to_le16(IEEE80211_FCTL_TODS);
 			/* BSSID SA DA */
+			memcpy(hdr.addr1, sdata->u.mgd.bssid, ETH_ALEN);
 			memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
 			memcpy(hdr.addr3, skb->data, ETH_ALEN);
 			hdrlen = 24;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 6304ed6..2f178f7 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -396,8 +396,9 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 		}
 		break;
 	case cpu_to_le16(0):
-		if (iftype != NL80211_IFTYPE_ADHOC)
-			return -1;
+		if (iftype != NL80211_IFTYPE_ADHOC &&
+		    iftype != NL80211_IFTYPE_STATION)
+				return -1;
 		break;
 	}
 
-- 
1.7.4.1

