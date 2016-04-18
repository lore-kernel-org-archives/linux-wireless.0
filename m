Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbcDRPti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 11:49:38 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 16/16] rtl8xxxu: Rename rtl8723au_iqk_phy_iq_bb_reg
Date: Mon, 18 Apr 2016 11:49:36 -0400
Message-Id: <1460994576-24091-17-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160418_180721_868477_16B44977)
In-Reply-To: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

There is nothing 8723au specific about rtl8723au_iqk_phy_iq_bb_reg so
rename the array to rtl8xxxu_iqk_phy_iq_bb_reg.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 240b361..c48ca20 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1743,7 +1743,7 @@ static struct rtl8xxxu_rfregs rtl8xxxu_rfregs[] = {
 	},
 };
 
-static const u32 rtl8723au_iqk_phy_iq_bb_reg[RTL8XXXU_BB_REGS] = {
+static const u32 rtl8xxxu_iqk_phy_iq_bb_reg[RTL8XXXU_BB_REGS] = {
 	REG_OFDM0_XA_RX_IQ_IMBALANCE,
 	REG_OFDM0_XB_RX_IQ_IMBALANCE,
 	REG_OFDM0_ENERGY_CCA_THRES,
@@ -6201,7 +6201,7 @@ static void rtl8xxxu_gen1_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_fill_iqk_matrix_b(priv, path_b_ok, result,
 					   candidate, (reg_ec4 == 0));
 
-	rtl8xxxu_save_regs(priv, rtl8723au_iqk_phy_iq_bb_reg,
+	rtl8xxxu_save_regs(priv, rtl8xxxu_iqk_phy_iq_bb_reg,
 			   priv->bb_recovery_backup, RTL8XXXU_BB_REGS);
 
 	rtl8xxxu_prepare_calibrate(priv, 0);
@@ -6309,7 +6309,7 @@ static void rtl8723bu_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_fill_iqk_matrix_b(priv, path_b_ok, result,
 					   candidate, (reg_ec4 == 0));
 
-	rtl8xxxu_save_regs(priv, rtl8723au_iqk_phy_iq_bb_reg,
+	rtl8xxxu_save_regs(priv, rtl8xxxu_iqk_phy_iq_bb_reg,
 			   priv->bb_recovery_backup, RTL8XXXU_BB_REGS);
 
 	rtl8xxxu_write32(priv, REG_BT_CONTROL_8723BU, bt_control);
@@ -6420,7 +6420,7 @@ static void rtl8192eu_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_fill_iqk_matrix_b(priv, path_b_ok, result,
 					   candidate, (reg_ec4 == 0));
 
-	rtl8xxxu_save_regs(priv, rtl8723au_iqk_phy_iq_bb_reg,
+	rtl8xxxu_save_regs(priv, rtl8xxxu_iqk_phy_iq_bb_reg,
 			   priv->bb_recovery_backup, RTL8XXXU_BB_REGS);
 }
 
-- 
2.5.5

