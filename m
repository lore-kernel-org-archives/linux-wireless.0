Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbcDRPti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 11:49:38 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 10/16] rtl8xxxu: Rename rtl8723au_init_phy_bb() to rtl8xxxu_gen1_init_phy_bb()
Date: Mon, 18 Apr 2016 11:49:30 -0400
Message-Id: <1460994576-24091-11-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160418_174957_268648_98BB5E3E)
In-Reply-To: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

All gen1 parts use the same init_phy_bb() function, so rename it to
reflect this.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index d5c2117..5c86965 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -3810,7 +3810,7 @@ static int rtl8xxxu_init_phy_regs(struct rtl8xxxu_priv *priv,
 	return 0;
 }
 
-static void rtl8723au_init_phy_bb(struct rtl8xxxu_priv *priv)
+static void rtl8xxxu_gen1_init_phy_bb(struct rtl8xxxu_priv *priv)
 {
 	u8 val8, ldoa15, ldov12d, lpldo, ldohci12;
 	u16 val16;
@@ -9876,7 +9876,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.power_off = rtl8xxxu_power_off,
 	.reset_8051 = rtl8xxxu_reset_8051,
 	.llt_init = rtl8xxxu_init_llt_table,
-	.init_phy_bb = rtl8723au_init_phy_bb,
+	.init_phy_bb = rtl8xxxu_gen1_init_phy_bb,
 	.init_phy_rf = rtl8723au_init_phy_rf,
 	.phy_iq_calibrate = rtl8xxxu_gen1_phy_iq_calibrate,
 	.config_channel = rtl8xxxu_gen1_config_channel,
@@ -9948,7 +9948,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.power_off = rtl8xxxu_power_off,
 	.reset_8051 = rtl8xxxu_reset_8051,
 	.llt_init = rtl8xxxu_init_llt_table,
-	.init_phy_bb = rtl8723au_init_phy_bb,
+	.init_phy_bb = rtl8xxxu_gen1_init_phy_bb,
 	.init_phy_rf = rtl8192cu_init_phy_rf,
 	.phy_iq_calibrate = rtl8xxxu_gen1_phy_iq_calibrate,
 	.config_channel = rtl8xxxu_gen1_config_channel,
-- 
2.5.5

