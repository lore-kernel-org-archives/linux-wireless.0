Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33727 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab1KTH56 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 02:57:58 -0500
Received: by mail-bw0-f46.google.com with SMTP id 11so5187685bke.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2011 23:57:58 -0800 (PST)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 11/13] ath5k: ath5k_ani_period_restart only touches struct ath5k_ani_state
Date: Sun, 20 Nov 2011 09:56:26 +0200
Message-Id: <1321775788-12520-12-git-send-email-mickflemm@gmail.com> (sfid-20111120_085802_144908_7BAF0F20)
In-Reply-To: <1321775788-12520-1-git-send-email-mickflemm@gmail.com>
References: <1321775788-12520-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to take ath5k_hw as an argument.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ani.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ani.c b/drivers/net/wireless/ath/ath5k/ani.c
index 2dfcf1a..bf67416 100644
--- a/drivers/net/wireless/ath/ath5k/ani.c
+++ b/drivers/net/wireless/ath/ath5k/ani.c
@@ -440,13 +440,12 @@ ath5k_ani_save_and_clear_phy_errors(struct ath5k_hw *ah,
 
 /**
  * ath5k_ani_period_restart() - Restart ANI period
- * @ah: The &struct ath5k_hw
  * @as: The &struct ath5k_ani_state
  *
  * Just reset counters, so they are clear for the next "ani period".
  */
 static void
-ath5k_ani_period_restart(struct ath5k_hw *ah, struct ath5k_ani_state *as)
+ath5k_ani_period_restart(struct ath5k_ani_state *as)
 {
 	/* keep last values for debugging */
 	as->last_ofdm_errors = as->ofdm_errors;
@@ -502,7 +501,7 @@ ath5k_ani_calibration(struct ath5k_hw *ah)
 		/* too many PHY errors - we have to raise immunity */
 		bool ofdm_flag = as->ofdm_errors > ofdm_high ? true : false;
 		ath5k_ani_raise_immunity(ah, as, ofdm_flag);
-		ath5k_ani_period_restart(ah, as);
+		ath5k_ani_period_restart(as);
 
 	} else if (as->listen_time > 5 * ATH5K_ANI_LISTEN_PERIOD) {
 		/* If more than 5 (TODO: why 5?) periods have passed and we got
@@ -514,7 +513,7 @@ ath5k_ani_calibration(struct ath5k_hw *ah)
 		if (as->ofdm_errors <= ofdm_low && as->cck_errors <= cck_low)
 			ath5k_ani_lower_immunity(ah, as);
 
-		ath5k_ani_period_restart(ah, as);
+		ath5k_ani_period_restart(as);
 	}
 }
 
-- 
1.7.8.rc1

