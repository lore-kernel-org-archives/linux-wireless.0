Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:58924
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752324AbbCLQv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 12:51:27 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 4.0] ath9k: fix tracking of enabled AP beacons
Date: Thu, 12 Mar 2015 17:17:18 +0100
Message-Id: <1426177038-24164-1-git-send-email-nbd@openwrt.org> (sfid-20150312_175130_656412_BBB53ADB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sc->nbcnvifs tracks assigned beacon slots, not enabled beacons.
Therefore, it cannot be used to decide if cur_conf->enable_beacon (bool)
should be updated, or if beacons have been enabled already.
With the current code (depending on the order of calls), beacons often
do not get enabled in an AP+STA setup.
To fix tracking of enabled beacons, convert cur_conf->enable_beacon to a
bitmask of enabled beacon slots.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/beacon.c | 20 ++++++++++++--------
 drivers/net/wireless/ath/ath9k/common.h |  2 +-
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index cb366ad..f50a6bc 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -219,12 +219,15 @@ void ath9k_beacon_remove_slot(struct ath_softc *sc, struct ieee80211_vif *vif)
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	struct ath_buf *bf = avp->av_bcbuf;
+	struct ath_beacon_config *cur_conf = &sc->cur_chan->beacon;
 
 	ath_dbg(common, CONFIG, "Removing interface at beacon slot: %d\n",
 		avp->av_bslot);
 
 	tasklet_disable(&sc->bcon_tasklet);
 
+	cur_conf->enable_beacon &= ~BIT(avp->av_bslot);
+
 	if (bf && bf->bf_mpdu) {
 		struct sk_buff *skb = bf->bf_mpdu;
 		dma_unmap_single(sc->dev, bf->bf_buf_addr,
@@ -521,8 +524,7 @@ static bool ath9k_allow_beacon_config(struct ath_softc *sc,
 	}
 
 	if (sc->sc_ah->opmode == NL80211_IFTYPE_AP) {
-		if ((vif->type != NL80211_IFTYPE_AP) ||
-		    (sc->nbcnvifs > 1)) {
+		if (vif->type != NL80211_IFTYPE_AP) {
 			ath_dbg(common, CONFIG,
 				"An AP interface is already present !\n");
 			return false;
@@ -616,12 +618,14 @@ void ath9k_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif,
 	 * enabling/disabling SWBA.
 	 */
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
-		if (!bss_conf->enable_beacon &&
-		    (sc->nbcnvifs <= 1)) {
-			cur_conf->enable_beacon = false;
-		} else if (bss_conf->enable_beacon) {
-			cur_conf->enable_beacon = true;
-			ath9k_cache_beacon_config(sc, ctx, bss_conf);
+		bool enabled = cur_conf->enable_beacon;
+
+		if (!bss_conf->enable_beacon) {
+			cur_conf->enable_beacon &= ~BIT(avp->av_bslot);
+		} else {
+			cur_conf->enable_beacon |= BIT(avp->av_bslot);
+			if (!enabled)
+				ath9k_cache_beacon_config(sc, ctx, bss_conf);
 		}
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 2b79a56..d237373 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -54,7 +54,7 @@ struct ath_beacon_config {
 	u16 dtim_period;
 	u16 bmiss_timeout;
 	u8 dtim_count;
-	bool enable_beacon;
+	u8 enable_beacon;
 	bool ibss_creator;
 	u32 nexttbtt;
 	u32 intval;
-- 
2.2.2

