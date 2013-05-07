Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:44188 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab3EGXf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 19:35:58 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] ath9k: Use bitops for scan flag
Date: Wed,  8 May 2013 05:03:31 +0530
Message-Id: <1367969613-1867-2-git-send-email-sujith@msujith.org> (sfid-20130508_013603_331076_EB6E9D4B)
In-Reply-To: <1367969613-1867-1-git-send-email-sujith@msujith.org>
References: <1367969613-1867-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 2 +-
 drivers/net/wireless/ath/ath9k/main.c  | 8 +++-----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 8a1888d..579ed9c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -646,6 +646,7 @@ enum sc_op_flags {
 	SC_OP_ANI_RUN,
 	SC_OP_PRIM_STA_VIF,
 	SC_OP_HW_RESET,
+	SC_OP_SCANNING,
 };
 
 /* Powersave flags */
@@ -759,7 +760,6 @@ struct ath_softc {
 	struct rchan *rfs_chan_spec_scan;
 	enum spectral_mode spectral_mode;
 	struct ath_spec_scan spec_config;
-	int scanning;
 
 #ifdef CONFIG_PM_SLEEP
 	atomic_t wow_got_bmiss_intr;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 04bf88a..74a0482 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1272,7 +1272,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 				curchan->center_freq);
 		} else {
 			/* perform spectral scan if requested. */
-			if (sc->scanning &&
+			if (test_bit(SC_OP_SCANNING, &sc->sc_flags) &&
 			    sc->spectral_mode == SPECTRAL_CHANSCAN)
 				ath9k_spectral_scan_trigger(hw);
 		}
@@ -2338,15 +2338,13 @@ static void ath9k_set_wakeup(struct ieee80211_hw *hw, bool enabled)
 static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
-
-	sc->scanning = 1;
+	set_bit(SC_OP_SCANNING, &sc->sc_flags);
 }
 
 static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
-
-	sc->scanning = 0;
+	clear_bit(SC_OP_SCANNING, &sc->sc_flags);
 }
 
 struct ieee80211_ops ath9k_ops = {
-- 
1.8.2.2

