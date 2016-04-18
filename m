Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbcDRPti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 11:49:38 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 03/16] rtl8xxxu: Rename rtl8723au_report_connect() to rtl8xxxu_gen1_report_connect()
Date: Mon, 18 Apr 2016 11:49:23 -0400
Message-Id: <1460994576-24091-4-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160418_174947_231216_50F3D889)
In-Reply-To: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Rename the function to reflect it is for all/most gen1 parts.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 0f2946d..a7f7031 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -8245,8 +8245,8 @@ static void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
 	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.b_macid_cfg));
 }
 
-static void rtl8723au_report_connect(struct rtl8xxxu_priv *priv,
-				     u8 macid, bool connect)
+static void rtl8xxxu_gen1_report_connect(struct rtl8xxxu_priv *priv,
+					 u8 macid, bool connect)
 {
 	struct h2c_cmd h2c;
 
@@ -9886,7 +9886,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.usb_quirks = rtl8xxxu_gen1_usb_quirks,
 	.set_tx_power = rtl8723a_set_tx_power,
 	.update_rate_mask = rtl8723au_update_rate_mask,
-	.report_connect = rtl8723au_report_connect,
+	.report_connect = rtl8xxxu_gen1_report_connect,
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
@@ -9958,7 +9958,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.usb_quirks = rtl8xxxu_gen1_usb_quirks,
 	.set_tx_power = rtl8723a_set_tx_power,
 	.update_rate_mask = rtl8723au_update_rate_mask,
-	.report_connect = rtl8723au_report_connect,
+	.report_connect = rtl8xxxu_gen1_report_connect,
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
-- 
2.5.5

