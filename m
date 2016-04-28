Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbcD1TTR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2016 15:19:17 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 10/11] rtl8xxxu: rtl8xxxu_prepare_calibrate() is never used on gen1
Date: Thu, 28 Apr 2016 15:19:14 -0400
Message-Id: <1461871155-11826-11-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160428_211938_717070_17CB8E41)
In-Reply-To: <1461871155-11826-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1461871155-11826-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Rename it to rtl8xxxu_gen2_prepare_calibrate() and remove the calls to
it from rtl8xxxu_gen1_phy_iq_calibrate()

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h       | 2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 4 ++--
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 9 +--------
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 17f62ba..1edb3ad 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1388,7 +1388,7 @@ void rtl8xxxu_firmware_self_reset(struct rtl8xxxu_priv *priv);
 void rtl8xxxu_power_off(struct rtl8xxxu_priv *priv);
 void rtl8xxxu_reset_8051(struct rtl8xxxu_priv *priv);
 int rtl8xxxu_auto_llt_table(struct rtl8xxxu_priv *priv, u8 last_tx_page);
-void rtl8xxxu_prepare_calibrate(struct rtl8xxxu_priv *priv, u8 start);
+void rtl8xxxu_gen2_prepare_calibrate(struct rtl8xxxu_priv *priv, u8 start);
 int rtl8xxxu_flush_fifo(struct rtl8xxxu_priv *priv);
 int rtl8xxxu_gen2_h2c_cmd(struct rtl8xxxu_priv *priv,
 			  struct h2c_cmd *h2c, int len);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
index 9d4bcd9..3472f6c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
@@ -1108,7 +1108,7 @@ static void rtl8723bu_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 	s32 reg_tmp = 0;
 	bool simu;
 
-	rtl8xxxu_prepare_calibrate(priv, 1);
+	rtl8xxxu_gen2_prepare_calibrate(priv, 1);
 
 	memset(result, 0, sizeof(result));
 	candidate = -1;
@@ -1217,7 +1217,7 @@ static void rtl8723bu_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 	if (priv->rf_paths > 1)
 		dev_dbg(dev, "%s: 8723BU 2T not supported\n", __func__);
 
-	rtl8xxxu_prepare_calibrate(priv, 0);
+	rtl8xxxu_gen2_prepare_calibrate(priv, 0);
 }
 
 static int rtl8723bu_active_to_emu(struct rtl8xxxu_priv *priv)
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 7aecbe7..9f6dbb4 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -3307,13 +3307,10 @@ static void rtl8xxxu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
 	}
 }
 
-void rtl8xxxu_prepare_calibrate(struct rtl8xxxu_priv *priv, u8 start)
+void rtl8xxxu_gen2_prepare_calibrate(struct rtl8xxxu_priv *priv, u8 start)
 {
 	struct h2c_cmd h2c;
 
-	if (priv->fops->mbox_ext_width < 4)
-		return;
-
 	memset(&h2c, 0, sizeof(struct h2c_cmd));
 	h2c.bt_wlan_calibration.cmd = H2C_8723B_BT_WLAN_CALIBRATION;
 	h2c.bt_wlan_calibration.data = start;
@@ -3332,8 +3329,6 @@ void rtl8xxxu_gen1_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 	s32 reg_tmp = 0;
 	bool simu;
 
-	rtl8xxxu_prepare_calibrate(priv, 1);
-
 	memset(result, 0, sizeof(result));
 	candidate = -1;
 
@@ -3421,8 +3416,6 @@ void rtl8xxxu_gen1_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 
 	rtl8xxxu_save_regs(priv, rtl8xxxu_iqk_phy_iq_bb_reg,
 			   priv->bb_recovery_backup, RTL8XXXU_BB_REGS);
-
-	rtl8xxxu_prepare_calibrate(priv, 0);
 }
 
 static void rtl8723a_phy_lc_calibrate(struct rtl8xxxu_priv *priv)
-- 
2.5.5

