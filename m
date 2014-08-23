Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:53689 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaHWNmQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 09:42:16 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 3/4] ath9k: Move ath9k_beacon_add_noa to channel.c
Date: Sat, 23 Aug 2014 19:12:15 +0530
Message-Id: <1408801336-7626-4-git-send-email-sujith@msujith.org> (sfid-20140823_154223_102686_5F3F6A54)
In-Reply-To: <1408801336-7626-1-git-send-email-sujith@msujith.org>
References: <1408801336-7626-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  7 +++++
 drivers/net/wireless/ath/ath9k/beacon.c  | 49 --------------------------------
 drivers/net/wireless/ath/ath9k/channel.c | 49 ++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a2f4fa7..9e61679 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -31,6 +31,7 @@
 #include "spectral.h"
 
 struct ath_node;
+struct ath_vif;
 
 extern struct ieee80211_ops ath9k_ops;
 extern int ath9k_modparam_nohwcrypt;
@@ -434,6 +435,8 @@ void ath9k_p2p_remove_vif(struct ath_softc *sc,
 void ath9k_p2p_beacon_sync(struct ath_softc *sc);
 void ath9k_p2p_bss_info_changed(struct ath_softc *sc,
 				struct ieee80211_vif *vif);
+void ath9k_beacon_add_noa(struct ath_softc *sc, struct ath_vif *avp,
+			  struct sk_buff *skb);
 void ath9k_p2p_ps_timer(void *priv);
 void ath9k_chanctx_wake_queues(struct ath_softc *sc);
 void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx);
@@ -496,6 +499,10 @@ static inline void ath9k_p2p_bss_info_changed(struct ath_softc *sc,
 					      struct ieee80211_vif *vif)
 {
 }
+static inline void ath9k_beacon_add_noa(struct ath_softc *sc, struct ath_vif *avp,
+					struct sk_buff *skb)
+{
+}
 static inline void ath9k_p2p_ps_timer(struct ath_softc *sc)
 {
 }
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index dc68d11..b2f56d8 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -108,55 +108,6 @@ static void ath9k_beacon_setup(struct ath_softc *sc, struct ieee80211_vif *vif,
 	ath9k_hw_set_txdesc(ah, bf->bf_desc, &info);
 }
 
-static void ath9k_beacon_add_noa(struct ath_softc *sc, struct ath_vif *avp,
-				 struct sk_buff *skb)
-{
-	static const u8 noa_ie_hdr[] = {
-		WLAN_EID_VENDOR_SPECIFIC,	/* type */
-		0,				/* length */
-		0x50, 0x6f, 0x9a,		/* WFA OUI */
-		0x09,				/* P2P subtype */
-		0x0c,				/* Notice of Absence */
-		0x00,				/* LSB of little-endian len */
-		0x00,				/* MSB of little-endian len */
-	};
-
-	struct ieee80211_p2p_noa_attr *noa;
-	int noa_len, noa_desc, i = 0;
-	u8 *hdr;
-
-	if (!avp->offchannel_duration && !avp->periodic_noa_duration)
-		return;
-
-	noa_desc = !!avp->offchannel_duration + !!avp->periodic_noa_duration;
-	noa_len = 2 + sizeof(struct ieee80211_p2p_noa_desc) * noa_desc;
-
-	hdr = skb_put(skb, sizeof(noa_ie_hdr));
-	memcpy(hdr, noa_ie_hdr, sizeof(noa_ie_hdr));
-	hdr[1] = sizeof(noa_ie_hdr) + noa_len - 2;
-	hdr[7] = noa_len;
-
-	noa = (void *) skb_put(skb, noa_len);
-	memset(noa, 0, noa_len);
-
-	noa->index = avp->noa_index;
-	if (avp->periodic_noa_duration) {
-		u32 interval = TU_TO_USEC(sc->cur_chan->beacon.beacon_interval);
-
-		noa->desc[i].count = 255;
-		noa->desc[i].start_time = cpu_to_le32(avp->periodic_noa_start);
-		noa->desc[i].duration = cpu_to_le32(avp->periodic_noa_duration);
-		noa->desc[i].interval = cpu_to_le32(interval);
-		i++;
-	}
-
-	if (avp->offchannel_duration) {
-		noa->desc[i].count = 1;
-		noa->desc[i].start_time = cpu_to_le32(avp->offchannel_start);
-		noa->desc[i].duration = cpu_to_le32(avp->offchannel_duration);
-	}
-}
-
 static struct ath_buf *ath9k_beacon_generate(struct ieee80211_hw *hw,
 					     struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 7aa9535..0e64b73 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1042,6 +1042,55 @@ static void ath9k_update_p2p_ps(struct ath_softc *sc, struct ieee80211_vif *vif)
 	ath9k_update_p2p_ps_timer(sc, avp);
 }
 
+void ath9k_beacon_add_noa(struct ath_softc *sc, struct ath_vif *avp,
+			  struct sk_buff *skb)
+{
+	static const u8 noa_ie_hdr[] = {
+		WLAN_EID_VENDOR_SPECIFIC,	/* type */
+		0,				/* length */
+		0x50, 0x6f, 0x9a,		/* WFA OUI */
+		0x09,				/* P2P subtype */
+		0x0c,				/* Notice of Absence */
+		0x00,				/* LSB of little-endian len */
+		0x00,				/* MSB of little-endian len */
+	};
+
+	struct ieee80211_p2p_noa_attr *noa;
+	int noa_len, noa_desc, i = 0;
+	u8 *hdr;
+
+	if (!avp->offchannel_duration && !avp->periodic_noa_duration)
+		return;
+
+	noa_desc = !!avp->offchannel_duration + !!avp->periodic_noa_duration;
+	noa_len = 2 + sizeof(struct ieee80211_p2p_noa_desc) * noa_desc;
+
+	hdr = skb_put(skb, sizeof(noa_ie_hdr));
+	memcpy(hdr, noa_ie_hdr, sizeof(noa_ie_hdr));
+	hdr[1] = sizeof(noa_ie_hdr) + noa_len - 2;
+	hdr[7] = noa_len;
+
+	noa = (void *) skb_put(skb, noa_len);
+	memset(noa, 0, noa_len);
+
+	noa->index = avp->noa_index;
+	if (avp->periodic_noa_duration) {
+		u32 interval = TU_TO_USEC(sc->cur_chan->beacon.beacon_interval);
+
+		noa->desc[i].count = 255;
+		noa->desc[i].start_time = cpu_to_le32(avp->periodic_noa_start);
+		noa->desc[i].duration = cpu_to_le32(avp->periodic_noa_duration);
+		noa->desc[i].interval = cpu_to_le32(interval);
+		i++;
+	}
+
+	if (avp->offchannel_duration) {
+		noa->desc[i].count = 1;
+		noa->desc[i].start_time = cpu_to_le32(avp->offchannel_start);
+		noa->desc[i].duration = cpu_to_le32(avp->offchannel_duration);
+	}
+}
+
 void ath9k_p2p_ps_timer(void *priv)
 {
 	struct ath_softc *sc = priv;
-- 
2.0.4

