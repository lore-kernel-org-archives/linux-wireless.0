Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:59750 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaFKOSg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 10:18:36 -0400
Received: by mail-wg0-f42.google.com with SMTP id z12so5379951wgg.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 07:18:35 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 01/10] mac80211: clarify TDLS Tx handling
Date: Wed, 11 Jun 2014 17:18:18 +0300
Message-Id: <1402496307-32522-1-git-send-email-arik@wizery.com> (sfid-20140611_161839_982243_C8D51176)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename the flags used in the Tx path and add an explanation for the
reasons to drop, send directly or through the AP.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0a519a5..023c74d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1813,7 +1813,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	int nh_pos, h_pos;
 	struct sta_info *sta = NULL;
 	bool wme_sta = false, authorized = false, tdls_auth = false;
-	bool tdls_direct = false;
+	bool tdls_peer = false, tdls_setup_frame = false;
 	bool multicast;
 	u32 info_flags = 0;
 	u16 info_id = 0;
@@ -1955,34 +1955,35 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 #endif
 	case NL80211_IFTYPE_STATION:
 		if (sdata->wdev.wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS) {
-			bool tdls_peer = false;
-
 			sta = sta_info_get(sdata, skb->data);
 			if (sta) {
 				authorized = test_sta_flag(sta,
 							WLAN_STA_AUTHORIZED);
 				wme_sta = test_sta_flag(sta, WLAN_STA_WME);
 				tdls_peer = test_sta_flag(sta,
-							 WLAN_STA_TDLS_PEER);
+							  WLAN_STA_TDLS_PEER);
 				tdls_auth = test_sta_flag(sta,
 						WLAN_STA_TDLS_PEER_AUTH);
 			}
 
-			/*
-			 * If the TDLS link is enabled, send everything
-			 * directly. Otherwise, allow TDLS setup frames
-			 * to be transmitted indirectly.
-			 */
-			tdls_direct = tdls_peer && (tdls_auth ||
-				 !(ethertype == ETH_P_TDLS && skb->len > 14 &&
-				   skb->data[14] == WLAN_TDLS_SNAP_RFTYPE));
+			if (tdls_peer)
+				tdls_setup_frame =
+					ethertype == ETH_P_TDLS &&
+					skb->len > 14 &&
+					skb->data[14] == WLAN_TDLS_SNAP_RFTYPE;
 		}
 
-		if (tdls_direct) {
-			/* link during setup - throw out frames to peer */
-			if (!tdls_auth)
-				goto fail_rcu;
+		/*
+		 * TDLS link during setup - throw out frames to peer. We allow
+		 * TDLS-setup frames to unauthorized peers for the special case
+		 * of a link teardown after a TDLS sta is removed due to being
+		 * unreachable.
+		 */
+		if (tdls_peer && !tdls_auth && !tdls_setup_frame)
+			goto fail_rcu;
 
+		/* send direct packets to authorized TDLS peers */
+		if (tdls_peer && tdls_auth) {
 			/* DA SA BSSID */
 			memcpy(hdr.addr1, skb->data, ETH_ALEN);
 			memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
-- 
1.9.1

