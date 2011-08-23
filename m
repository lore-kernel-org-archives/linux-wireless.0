Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2099 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab1HWMOU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 08:14:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 3/8] staging: brcm80211: make use of cordic library
 function
Date: Tue, 23 Aug 2011 14:13:55 +0200
Message-ID: <1314101640-4229-4-git-send-email-arend@broadcom.com> (sfid-20110823_141434_298776_A58B322A)
In-Reply-To: <1314101640-4229-1-git-send-email-arend@broadcom.com>
References: <1314101640-4229-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The cordic function which calculates cosine and sine values for given
angle is now provided in library module. The phy code now uses this
module function.

Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/Kconfig                |    1 +
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |   62 ----------------------
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h |    1 -
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c |    7 ++-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |   14 +++--
 5 files changed, 13 insertions(+), 72 deletions(-)

diff --git a/drivers/staging/brcm80211/Kconfig b/drivers/staging/brcm80211/Kconfig
index 816a7af..59e9c85 100644
--- a/drivers/staging/brcm80211/Kconfig
+++ b/drivers/staging/brcm80211/Kconfig
@@ -12,6 +12,7 @@ config BRCMSMAC
 	select FW_LOADER
 	select CRC_CCITT
 	select CRC8
+	select CORDIC
 	---help---
 	  This module adds support for PCIe wireless adapters based on Broadcom
 	  IEEE802.11n SoftMAC chipsets.  If you choose to build a module, it'll
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 448afae..5307bd8 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -2779,68 +2779,6 @@ wlc_phy_papd_decode_epsilon(u32 epsilon, s32 *eps_real, s32 *eps_imag)
 		*eps_real -= 0x2000;
 }
 
-static const s32 AtanTbl[] = {
-	2949120,
-	1740967,
-	919879,
-	466945,
-	234379,
-	117304,
-	58666,
-	29335,
-	14668,
-	7334,
-	3667,
-	1833,
-	917,
-	458,
-	229,
-	115,
-	57,
-	29
-};
-
-void wlc_phy_cordic(s32 theta, struct cs32 *val)
-{
-	s32 angle, valtmp;
-	unsigned iter;
-	int signx = 1;
-	int signtheta;
-
-	val[0].i = CORDIC_AG;
-	val[0].q = 0;
-	angle = 0;
-
-	signtheta = (theta < 0) ? -1 : 1;
-	theta =	((theta + FIXED(180) * signtheta) % FIXED(360)) -
-		FIXED(180) * signtheta;
-
-	if (FLOAT(theta) > 90) {
-		theta -= FIXED(180);
-		signx = -1;
-	} else if (FLOAT(theta) < -90) {
-		theta += FIXED(180);
-		signx = -1;
-	}
-
-	for (iter = 0; iter < CORDIC_NI; iter++) {
-		if (theta > angle) {
-			valtmp = val[0].i - (val[0].q >> iter);
-			val[0].q = (val[0].i >> iter) + val[0].q;
-			val[0].i = valtmp;
-			angle += AtanTbl[iter];
-		} else {
-			valtmp = val[0].i + (val[0].q >> iter);
-			val[0].q = -(val[0].i >> iter) + val[0].q;
-			val[0].i = valtmp;
-			angle -= AtanTbl[iter];
-		}
-	}
-
-	val[0].i = val[0].i * signx;
-	val[0].q = val[0].q * signx;
-}
-
 void wlc_phy_cal_perical_mphase_reset(struct brcms_phy *pi)
 {
 	wlapi_del_timer(pi->sh->physhim, pi->phycal_timer);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index b98d76b..0594a08 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -1039,7 +1039,6 @@ extern void wlc_phy_table_data_write(struct brcms_phy *pi, uint width, u32 val);
 extern void write_phy_channel_reg(struct brcms_phy *pi, uint val);
 extern void wlc_phy_txpower_update_shm(struct brcms_phy *pi);
 
-extern void wlc_phy_cordic(s32 theta, struct cs32 *val);
 extern u8 wlc_phy_nbits(s32 value);
 extern void wlc_phy_compute_dB(u32 *cmplx_pwr, s8 *p_dB, u8 core);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index dcf626e5..269346e 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/cordic.h>
 
 #include <pmu.h>
 #include <d11.h>
@@ -2723,7 +2724,7 @@ wlc_lcnphy_start_tx_tone(struct brcms_phy *pi, s32 f_kHz, u16 max_val,
 	u16 num_samps, t, k;
 	u32 bw;
 	s32 theta = 0, rot = 0;
-	struct cs32 tone_samp;
+	struct cordic_iq tone_samp;
 	u32 data_buf[64];
 	u16 i_samp, q_samp;
 	struct phytbl_info tab;
@@ -2751,12 +2752,12 @@ wlc_lcnphy_start_tx_tone(struct brcms_phy *pi, s32 f_kHz, u16 max_val,
 	} else
 		num_samps = 2;
 
-	rot = FIXED((f_kHz * 36) / phy_bw) / 100;
+	rot = ((f_kHz * 36) / phy_bw) / 100;
 	theta = 0;
 
 	for (t = 0; t < num_samps; t++) {
 
-		wlc_phy_cordic(theta, &tone_samp);
+		tone_samp = cordic_calc_iq(theta);
 
 		theta += rot;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index 2e8aa64..2d90f09 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/cordic.h>
 
 #include <brcm_hw_ids.h>
 #include <aiutils.h>
@@ -14214,7 +14215,8 @@ static u16 wlc_phy_gen_load_samples_nphy(struct brcms_phy *pi, u32 f_kHz,
 					 u16 max_val,
 					 u8 dac_test_mode);
 static void wlc_phy_loadsampletable_nphy(struct brcms_phy *pi,
-					 struct cs32 *tone_buf, u16 num_samps);
+					 struct cordic_iq *tone_buf,
+					 u16 num_samps);
 static void wlc_phy_runsamples_nphy(struct brcms_phy *pi, u16 n, u16 lps,
 				    u16 wait, u8 iq, u8 dac_test_mode,
 				    bool modify_bbmult);
@@ -22179,7 +22181,7 @@ wlc_phy_gen_load_samples_nphy(struct brcms_phy *pi, u32 f_kHz, u16 max_val,
 	u16 num_samps, t, spur;
 	s32 theta = 0, rot = 0;
 	u32 tbl_len;
-	struct cs32 *tone_buf = NULL;
+	struct cordic_iq *tone_buf = NULL;
 
 	is_phybw40 = CHSPEC_IS40(pi->radio_chanspec);
 	phy_bw = (is_phybw40 == 1) ? 40 : 20;
@@ -22194,17 +22196,17 @@ wlc_phy_gen_load_samples_nphy(struct brcms_phy *pi, u32 f_kHz, u16 max_val,
 		tbl_len = (phy_bw << 1);
 	}
 
-	tone_buf = kmalloc(sizeof(struct cs32) * tbl_len, GFP_ATOMIC);
+	tone_buf = kmalloc(sizeof(struct cordic_iq) * tbl_len, GFP_ATOMIC);
 	if (tone_buf == NULL)
 		return 0;
 
 	num_samps = (u16) tbl_len;
-	rot = FIXED((f_kHz * 36) / phy_bw) / 100;
+	rot = ((f_kHz * 36) / phy_bw) / 100;
 	theta = 0;
 
 	for (t = 0; t < num_samps; t++) {
 
-		wlc_phy_cordic(theta, &tone_buf[t]);
+		tone_buf[t] = cordic_calc_iq(theta);
 
 		theta += rot;
 
@@ -22239,7 +22241,7 @@ wlc_phy_tx_tone_nphy(struct brcms_phy *pi, u32 f_kHz, u16 max_val,
 }
 
 static void
-wlc_phy_loadsampletable_nphy(struct brcms_phy *pi, struct cs32 *tone_buf,
+wlc_phy_loadsampletable_nphy(struct brcms_phy *pi, struct cordic_iq *tone_buf,
 			     u16 num_samps)
 {
 	u16 t;
-- 
1.7.4.1


