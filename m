Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:18005 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756853Ab0ESBdQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 21:33:16 -0400
Received: from vs3014.wh2.ocn.ne.jp (125.206.180.187)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0971882795
	for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 10:33:15 +0900 (JST)
Subject: [PATCH v2 16/20] ath5k: remove setting ANI and antenna thru debugfs
	files
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 19 May 2010 10:32:03 +0900
Message-ID: <20100519013203.22206.86837.stgit@tt-desk>
In-Reply-To: <20100519012528.22206.77550.stgit@tt-desk>
References: <20100519012528.22206.77550.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the possibility to set ANI parameters and antenna iconfiguration thru
debugfs, since we have proper interfaces for both now:

  * /sys/class/ieee80211/phy0/device/ani/* for ANI

  * "iw antenna set X" for antenna configuration.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/debug.c |   33 +-------------------------------
 1 files changed, 1 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 97c5ada..d178d63 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -439,16 +439,7 @@ static ssize_t write_file_antenna(struct file *file,
 	if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
 		return -EFAULT;
 
-	if (strncmp(buf, "diversity", 9) == 0) {
-		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_DEFAULT);
-		printk(KERN_INFO "ath5k debug: enable diversity\n");
-	} else if (strncmp(buf, "fixed-a", 7) == 0) {
-		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_FIXED_A);
-		printk(KERN_INFO "ath5k debugfs: fixed antenna A\n");
-	} else if (strncmp(buf, "fixed-b", 7) == 0) {
-		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_FIXED_B);
-		printk(KERN_INFO "ath5k debug: fixed antenna B\n");
-	} else if (strncmp(buf, "clear", 5) == 0) {
+	if (strncmp(buf, "clear", 5) == 0) {
 		for (i = 0; i < ARRAY_SIZE(sc->stats.antenna_rx); i++) {
 			sc->stats.antenna_rx[i] = 0;
 			sc->stats.antenna_tx[i] = 0;
@@ -694,28 +685,6 @@ static ssize_t write_file_ani(struct file *file,
 		ath5k_ani_init(sc->ah, ATH5K_ANI_MODE_OFF);
 	} else if (strncmp(buf, "ani-on", 6) == 0) {
 		ath5k_ani_init(sc->ah, ATH5K_ANI_MODE_AUTO);
-	} else if (strncmp(buf, "noise-low", 9) == 0) {
-		ath5k_ani_set_noise_immunity_level(sc->ah, 0);
-	} else if (strncmp(buf, "noise-high", 10) == 0) {
-		ath5k_ani_set_noise_immunity_level(sc->ah,
-						   ATH5K_ANI_MAX_NOISE_IMM_LVL);
-	} else if (strncmp(buf, "spur-low", 8) == 0) {
-		ath5k_ani_set_spur_immunity_level(sc->ah, 0);
-	} else if (strncmp(buf, "spur-high", 9) == 0) {
-		ath5k_ani_set_spur_immunity_level(sc->ah,
-						  sc->ani_state.max_spur_level);
-	} else if (strncmp(buf, "fir-low", 7) == 0) {
-		ath5k_ani_set_firstep_level(sc->ah, 0);
-	} else if (strncmp(buf, "fir-high", 8) == 0) {
-		ath5k_ani_set_firstep_level(sc->ah, ATH5K_ANI_MAX_FIRSTEP_LVL);
-	} else if (strncmp(buf, "ofdm-off", 8) == 0) {
-		ath5k_ani_set_ofdm_weak_signal_detection(sc->ah, false);
-	} else if (strncmp(buf, "ofdm-on", 7) == 0) {
-		ath5k_ani_set_ofdm_weak_signal_detection(sc->ah, true);
-	} else if (strncmp(buf, "cck-off", 7) == 0) {
-		ath5k_ani_set_cck_weak_signal_detection(sc->ah, false);
-	} else if (strncmp(buf, "cck-on", 6) == 0) {
-		ath5k_ani_set_cck_weak_signal_detection(sc->ah, true);
 	}
 	return count;
 }

