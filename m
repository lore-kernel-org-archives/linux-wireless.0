Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbcB2WFy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:54 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 035/113] rtl8xxxu: Make rtl8xxxu_add_path_on() use device specific init values
Date: Mon, 29 Feb 2016 17:04:33 -0500
Message-Id: <1456783551-28315-36-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230611_630291_CFD81907)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

rtl8192cu/rtl8188cu/rtl8723au use the same values, but 8723bu and
8192eu have their own.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 24 +++++++++++++++++++++---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  4 ++++
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 9d8b69a..e543a26 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -3557,11 +3557,13 @@ static void rtl8xxxu_path_adda_on(struct rtl8xxxu_priv *priv, const u32 *regs,
 	u32 path_on;
 	int i;
 
-	path_on = path_a_on ? 0x04db25a4 : 0x0b1b25a4;
 	if (priv->tx_paths == 1) {
-		path_on = 0x0bdb25a0;
-		rtl8xxxu_write32(priv, regs[0], 0x0b1b25a0);
+		path_on = priv->fops->adda_1t_path_on;
+		rtl8xxxu_write32(priv, regs[0], priv->fops->adda_1t_init);
 	} else {
+		path_on = path_a_on ? priv->fops->adda_2t_path_on_a :
+			priv->fops->adda_2t_path_on_b;
+
 		rtl8xxxu_write32(priv, regs[0], path_on);
 	}
 
@@ -6537,6 +6539,10 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
+	.adda_1t_init = 0x0b1b25a0,
+	.adda_1t_path_on = 0x0bdb25a0,
+	.adda_2t_path_on_a = 0x04db25a4,
+	.adda_2t_path_on_b = 0x0b1b25a4,
 };
 
 static struct rtl8xxxu_fileops rtl8723bu_fops = {
@@ -6548,6 +6554,10 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
+	.adda_1t_init = 0x01c00014,
+	.adda_1t_path_on = 0x01c00014,
+	.adda_2t_path_on_a = 0x01c00014,
+	.adda_2t_path_on_b = 0x01c00014,
 };
 
 #ifdef CONFIG_RTL8XXXU_UNTESTED
@@ -6560,6 +6570,10 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
+	.adda_1t_init = 0x0b1b25a0,
+	.adda_1t_path_on = 0x0bdb25a0,
+	.adda_2t_path_on_a = 0x04db25a4,
+	.adda_2t_path_on_b = 0x0b1b25a4,
 };
 
 #endif
@@ -6572,6 +6586,10 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
+	.adda_1t_init = 0x0fc01616,
+	.adda_1t_path_on = 0x0fc01616,
+	.adda_2t_path_on_a = 0x0fc01616,
+	.adda_2t_path_on_b = 0x0fc01616,
 };
 
 static struct usb_device_id dev_table[] = {
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 07533ac..4b8431d 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -854,4 +854,8 @@ struct rtl8xxxu_fileops {
 	int writeN_block_size;
 	u16 mbox_ext_reg;
 	char mbox_ext_width;
+	u32 adda_1t_init;
+	u32 adda_1t_path_on;
+	u32 adda_2t_path_on_a;
+	u32 adda_2t_path_on_b;
 };
-- 
2.5.0

