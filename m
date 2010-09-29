Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:43703 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519Ab0I2PPh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 11:15:37 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 4/6] ath9k: remove the noise floor value in the ani struct
Date: Wed, 29 Sep 2010 17:15:29 +0200
Message-Id: <1285773331-73439-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1285773331-73439-3-git-send-email-nbd@openwrt.org>
References: <1285773331-73439-1-git-send-email-nbd@openwrt.org>
 <1285773331-73439-2-git-send-email-nbd@openwrt.org>
 <1285773331-73439-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

common->ani.noise_floor is now only used for a similar redundant debug
message similar to the one that was removed from ath9k_htc in an earlier
patch. Remove it from ath9k as well now.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath.h        |    1 -
 drivers/net/wireless/ath/ath9k/init.c |    1 -
 drivers/net/wireless/ath/ath9k/main.c |   10 ----------
 3 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index dd236c3..5894fcc 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -35,7 +35,6 @@ static const u8 ath_bcast_mac[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
 struct ath_ani {
 	bool caldone;
-	int16_t noise_floor;
 	unsigned int longcal_timer;
 	unsigned int shortcal_timer;
 	unsigned int resetcal_timer;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index de33938..11dc3ac 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -506,7 +506,6 @@ static void ath9k_init_misc(struct ath_softc *sc)
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	int i = 0;
 
-	common->ani.noise_floor = ATH_DEFAULT_NOISE_FLOOR;
 	setup_timer(&common->ani.timer, ath_ani_calibrate, (unsigned long)sc);
 
 	sc->config.txpowlimit = ATH_TXPOWER_MAX;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index fcba402..a801a08 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -459,16 +459,6 @@ void ath_ani_calibrate(unsigned long data)
 						   ah->curchan,
 						   common->rx_chainmask,
 						   longcal);
-
-			if (longcal)
-				common->ani.noise_floor = ath9k_hw_getchan_noise(ah,
-								     ah->curchan);
-
-			ath_print(common, ATH_DBG_ANI,
-				  " calibrate chan %u/%x nf: %d\n",
-				  ah->curchan->channel,
-				  ah->curchan->channelFlags,
-				  common->ani.noise_floor);
 		}
 	}
 
-- 
1.7.2.2

