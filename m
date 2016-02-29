Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203AbcB2WFz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:55 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 038/113] rtl8xxxu: Handle S0S1 register in lc_calibrate()
Date: Mon, 29 Feb 2016 17:04:36 -0500
Message-Id: <1456783551-28315-39-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231001_257753_5A478A30)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Newer chips (8723bu/8192eu) has S0S1 settings which needs to be dealt
with during LC calibration.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 7 +++++++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index b2aa723..c990a09 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -4835,12 +4835,17 @@ static void rtl8723a_phy_lc_calibrate(struct rtl8xxxu_priv *priv)
 	}
 
 	/* Start LC calibration */
+	if (priv->fops->has_s0s1)
+		rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_S0S1, 0xdfbe0);
 	val32 = rtl8xxxu_read_rfreg(priv, RF_A, RF6052_REG_MODE_AG);
 	val32 |= 0x08000;
 	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_MODE_AG, val32);
 
 	msleep(100);
 
+	if (priv->fops->has_s0s1)
+		rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_S0S1, 0xdffe0);
+
 	/* Restore original parameters */
 	if (lstf & OFDM_LSTF_MASK) {
 		/* Path-A */
@@ -7359,6 +7364,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
+	.has_s0s1 = 1,
 	.adda_1t_init = 0x01c00014,
 	.adda_1t_path_on = 0x01c00014,
 	.adda_2t_path_on_a = 0x01c00014,
@@ -7393,6 +7399,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
+	.has_s0s1 = 1,
 	.adda_1t_init = 0x0fc01616,
 	.adda_1t_path_on = 0x0fc01616,
 	.adda_2t_path_on_a = 0x0fc01616,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 76398de..4a974a6 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -855,6 +855,7 @@ struct rtl8xxxu_fileops {
 	int writeN_block_size;
 	u16 mbox_ext_reg;
 	char mbox_ext_width;
+	char has_s0s1;
 	u32 adda_1t_init;
 	u32 adda_1t_path_on;
 	u32 adda_2t_path_on_a;
-- 
2.5.0

