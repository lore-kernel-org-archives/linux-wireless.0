Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:38100 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab0ELVHw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 17:07:52 -0400
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH] mac80211: Use struct ieee80211_ht_cap to build HT Capabilities IE
Date: Wed, 12 May 2010 23:07:39 +0200
Message-Id: <1273698460-18061-3-git-send-email-benoit.papillault@free.fr>
In-Reply-To: <1273698460-18061-2-git-send-email-benoit.papillault@free.fr>
References: <1273698460-18061-1-git-send-email-benoit.papillault@free.fr>
 <1273698460-18061-2-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of writing the HT Capabilities IE byte after byte, we use the
existing ieee80211_ht_cap structure.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 net/mac80211/util.c |   55 +++++++++++++++++++++++++--------------------------
 1 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 4a76fa5..047acb8 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1402,7 +1402,7 @@ u8 *ieee80211_add_ht_cap(u8 *pos,
 {
 	if (sband->ht_cap.ht_supported) {
 		u16 cap = sband->ht_cap.cap;
-		__le16 tmp;
+		struct ieee80211_ht_cap ht_cap;
 
 		if (ieee80211_disable_40mhz_24ghz &&
 		    sband->band == IEEE80211_BAND_2GHZ) {
@@ -1410,18 +1410,20 @@ u8 *ieee80211_add_ht_cap(u8 *pos,
 			cap &= ~IEEE80211_HT_CAP_SGI_40;
 		}
 
-		*pos++ = WLAN_EID_HT_CAPABILITY;
-		*pos++ = sizeof(struct ieee80211_ht_cap);
-		memset(pos, 0, sizeof(struct ieee80211_ht_cap));
-		tmp = cpu_to_le16(cap);
-		memcpy(pos, &tmp, sizeof(u16));
-		pos += sizeof(u16);
-		*pos++ = sband->ht_cap.ampdu_factor |
+		ht_cap.cap_info = cpu_to_le16(cap);
+		ht_cap.ampdu_params_info = sband->ht_cap.ampdu_factor |
 			(sband->ht_cap.ampdu_density <<
 			 IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
-		memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
-		pos += sizeof(sband->ht_cap.mcs);
-		pos += 2 + 4 + 1; /* ext info, BF cap, antsel */
+		ht_cap.mcs = sband->ht_cap.mcs;
+		ht_cap.extended_ht_cap_info = cpu_to_le16(0);
+		ht_cap.tx_BF_cap_info = cpu_to_le32(0);
+		ht_cap.antenna_selection_info = 0;
+
+		/* HT Capabilities element */
+		*pos++ = WLAN_EID_HT_CAPABILITY;
+		*pos++ = sizeof(struct ieee80211_ht_cap);
+		memcpy(pos, &ht_cap, sizeof(struct ieee80211_ht_cap));
+		pos += sizeof(struct ieee80211_ht_cap);
 	}
 
 	return pos;
@@ -1436,7 +1438,7 @@ void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
 	u8 *pos;
 	u32 flags = channel->flags;
 	u16 cap = sband->ht_cap.cap;
-	__le16 tmp;
+	struct ieee80211_ht_cap ht_cap;
 
 	if (!sband->ht_cap.ht_supported)
 		return;
@@ -1492,33 +1494,30 @@ void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
 		break;
 	}
 
-	/* reserve and fill IE */
-
-	pos = skb_put(skb, sizeof(struct ieee80211_ht_cap) + 2);
-	*pos++ = WLAN_EID_HT_CAPABILITY;
-	*pos++ = sizeof(struct ieee80211_ht_cap);
-	memset(pos, 0, sizeof(struct ieee80211_ht_cap));
-
 	/* capability flags */
-	tmp = cpu_to_le16(cap);
-	memcpy(pos, &tmp, sizeof(u16));
-	pos += sizeof(u16);
+	ht_cap.cap_info = cpu_to_le16(cap);
 
 	/* AMPDU parameters */
-	*pos++ = sband->ht_cap.ampdu_factor |
+	ht_cap.ampdu_params_info = sband->ht_cap.ampdu_factor |
 		 (sband->ht_cap.ampdu_density <<
 			IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
 
 	/* MCS set */
-	memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
-	pos += sizeof(sband->ht_cap.mcs);
+	ht_cap.mcs = sband->ht_cap.mcs;
 
 	/* extended capabilities */
-	pos += sizeof(__le16);
+	ht_cap.extended_ht_cap_info = cpu_to_le16(0);
 
 	/* BF capabilities */
-	pos += sizeof(__le32);
+	ht_cap.tx_BF_cap_info = cpu_to_le32(0);
 
 	/* antenna selection */
-	pos += sizeof(u8);
+	ht_cap.antenna_selection_info = 0;
+
+	/* reserve and fill IE */
+	pos = skb_put(skb, 2 + sizeof(struct ieee80211_ht_cap));
+
+	*pos++ = WLAN_EID_HT_CAPABILITY;
+	*pos++ = sizeof(struct ieee80211_ht_cap);
+	memcpy(pos, &ht_cap, sizeof(struct ieee80211_ht_cap));
 }
-- 
1.5.6.5

