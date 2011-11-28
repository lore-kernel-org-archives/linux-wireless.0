Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40816 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab1K1AWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 19:22:48 -0500
Received: by vcbfk14 with SMTP id fk14so3226995vcb.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Nov 2011 16:22:47 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH v2 3/4] ath9k: use config.enable_ani to check if ani should be performed
Date: Sun, 27 Nov 2011 19:22:13 -0500
Message-Id: <1322439734-14520-4-git-send-email-mar.kolya@gmail.com> (sfid-20111128_012250_464484_46C1EB22)
In-Reply-To: <1322439734-14520-1-git-send-email-mar.kolya@gmail.com>
References: <1322439734-14520-1-git-send-email-mar.kolya@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Currently in ath9k code there is an attempt which is meant to
disable ANI for ar9100 and ar9340. But it doesn't really achieve
this. All it does is disable ANI init and setup (i.e. calls to
ath9k_hw_ani_setup and ath9k_hw_ani_init). Since ath9k_hw_ani_setup is
not called ah->config.ani_poll_interval is never initialized (i.e. it
is always zero) and ath_ani_calibrate always executes ANI procedures
(over uninitialized ANI parameters).
  Moreover, ath_ani_calibrate is being called each 1ms because
common->ani.timer is set to zero interval because
ah->config.ani_poll_interval==0 (and thus smallest value of all
intervals). Normally it should not be called this often.
  This patch changes the code so config.enable_ani is used to check if
ANI should be performed.
  config.enable_ani is initialized to true by default. This patch sets
it to false for ar9100 and ar9340.

Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    3 ++-
 drivers/net/wireless/ath/ath9k/hw.c           |   12 ++++++++----
 drivers/net/wireless/ath/ath9k/main.c         |    4 ++--
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 0b9a0e8..0843565 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -808,7 +808,8 @@ void ath9k_htc_ani_work(struct work_struct *work)
 	}
 
 	/* Verify whether we must check ANI */
-	if ((timestamp - common->ani.checkani_timer) >= ATH_ANI_POLLINTERVAL) {
+	if (sc->sc_ah->config.enable_ani &&
+            (timestamp - common->ani.checkani_timer) >= ATH_ANI_POLLINTERVAL) {
 		aniflag = true;
 		common->ani.checkani_timer = timestamp;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 662ab7e..e890104 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -504,10 +504,10 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 		return ecode;
 	}
 
-	if (!AR_SREV_9100(ah) && !AR_SREV_9340(ah)) {
-		ath9k_hw_ani_setup(ah);
-		ath9k_hw_ani_init(ah);
-	}
+        if (ah->config.enable_ani) {
+                ath9k_hw_ani_setup(ah);
+                ath9k_hw_ani_init(ah);
+        }
 
 	return 0;
 }
@@ -610,6 +610,10 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	if (!AR_SREV_9300_20_OR_LATER(ah))
 		ah->ani_function &= ~ATH9K_ANI_MRC_CCK;
 
+        /* disable ANI for 9100 and 9340 */
+        if (AR_SREV_9100(ah) || AR_SREV_9340(ah))
+                ah->config.enable_ani = false;
+
 	ath9k_hw_init_mode_regs(ah);
 
 	if (!ah->is_pciexpress)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9ce3dff..880106b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -581,8 +581,8 @@ void ath_ani_calibrate(unsigned long data)
 	}
 
 	/* Verify whether we must check ANI */
-	if ((timestamp - common->ani.checkani_timer) >=
-	     ah->config.ani_poll_interval) {
+	if (sc->sc_ah->config.enable_ani &&
+            (timestamp - common->ani.checkani_timer) >= ah->config.ani_poll_interval) {
 		aniflag = true;
 		common->ani.checkani_timer = timestamp;
 	}
-- 
1.7.4.1

