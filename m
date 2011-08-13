Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38978 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab1HMFA5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 01:00:57 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 07/11] ath9k: Remove SC_OP_ENABLE_APM
Date: Sat, 13 Aug 2011 10:28:14 +0530
Message-ID: <1313211498-14442-7-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110813_070059_498662_C3120C1F)
In-Reply-To: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    3 +--
 drivers/net/wireless/ath/ath9k/main.c  |    4 ----
 drivers/net/wireless/ath/ath9k/xmit.c  |    6 +++---
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index c03949e..4b08a3d 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -558,8 +558,7 @@ struct ath_ant_comb {
 #define SC_OP_BT_PRIORITY_DETECTED   BIT(12)
 #define SC_OP_BT_SCAN		     BIT(13)
 #define SC_OP_ANI_RUN		     BIT(14)
-#define SC_OP_ENABLE_APM	     BIT(15)
-#define SC_OP_PRIM_STA_VIF	     BIT(16)
+#define SC_OP_PRIM_STA_VIF	     BIT(15)
 
 /* Powersave flags */
 #define PS_WAIT_FOR_BEACON        BIT(0)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 097c1eb..e828799 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -565,7 +565,6 @@ set_timer:
 static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta)
 {
 	struct ath_node *an;
-	struct ath_hw *ah = sc->sc_ah;
 	an = (struct ath_node *)sta->drv_priv;
 
 #ifdef CONFIG_ATH9K_DEBUGFS
@@ -574,9 +573,6 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta)
 	spin_unlock(&sc->nodes_lock);
 	an->sta = sta;
 #endif
-	if ((ah->caps.hw_caps) & ATH9K_HW_CAP_APM)
-		sc->sc_flags |= SC_OP_ENABLE_APM;
-
 	if (sc->sc_flags & SC_OP_TXAGGR) {
 		ath_tx_node_init(sc, an);
 		an->maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index feef013..2062672 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1584,9 +1584,9 @@ u8 ath_txchainmask_reduction(struct ath_softc *sc, u8 chainmask, u32 rate)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath9k_channel *curchan = ah->curchan;
-	if ((sc->sc_flags & SC_OP_ENABLE_APM) &&
-			(curchan->channelFlags & CHANNEL_5GHZ) &&
-			(chainmask == 0x7) && (rate < 0x90))
+	if ((ah->caps.hw_caps & ATH9K_HW_CAP_APM) &&
+	    (curchan->channelFlags & CHANNEL_5GHZ) &&
+	    (chainmask == 0x7) && (rate < 0x90))
 		return 0x3;
 	else
 		return chainmask;
-- 
1.7.6

