Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62183 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab0LCEHf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 23:07:35 -0500
Received: by eye27 with SMTP id 27so4779063eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 20:07:33 -0800 (PST)
Date: Fri, 3 Dec 2010 06:07:13 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org,
	sedat.dilek@googlemail.com
Subject: [PATCH 3/6] ath5k: Disable ANI during reset
Message-ID: <20101203040713.GC2988@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Stop ANI durring reset to prevent false PHY error reports

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
 drivers/net/wireless/ath/ath5k/base.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 047b2a0..6edfa9f 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2504,7 +2504,7 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
 							bool skip_pcu)
 {
 	struct ath5k_hw *ah = sc->ah;
-	int ret;
+	int ret, ani_mode;
 
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "resetting\n");
 
@@ -2512,6 +2512,12 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
 	synchronize_irq(sc->pdev->irq);
 	stop_tasklets(sc);
 
+	/* Save ani mode and disable ANI durring
+	 * reset. If we don't we might get false
+	 * PHY error interrupts. */
+	ani_mode = ah->ah_sc->ani_state.ani_mode;
+	ath5k_ani_init(ah, ATH5K_ANI_MODE_OFF);
+
 	/* We are going to empty hw queues
 	 * so we should also free any remaining
 	 * tx buffers */
@@ -2533,7 +2539,7 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
 		goto err;
 	}
 
-	ath5k_ani_init(ah, ah->ah_sc->ani_state.ani_mode);
+	ath5k_ani_init(ah, ani_mode);
 
 	ah->ah_cal_next_full = jiffies;
 	ah->ah_cal_next_ani = jiffies;
