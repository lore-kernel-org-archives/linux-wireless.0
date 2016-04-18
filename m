Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbcDRPti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 11:49:38 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 02/16] rtl8xxxu: Rename rtl8723bu_report_connect() to rtl8xxxu_gen2_report_connect()
Date: Mon, 18 Apr 2016 11:49:22 -0400
Message-Id: <1460994576-24091-3-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160418_174943_956961_2C0E9C7A)
In-Reply-To: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Make the name reflect this is for most/all gen2 parts.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 4ec18a4..0f2946d 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -8262,8 +8262,8 @@ static void rtl8723au_report_connect(struct rtl8xxxu_priv *priv,
 	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.joinbss));
 }
 
-static void rtl8723bu_report_connect(struct rtl8xxxu_priv *priv,
-				     u8 macid, bool connect)
+static void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
+					 u8 macid, bool connect)
 {
 	struct h2c_cmd h2c;
 
@@ -9922,7 +9922,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.usb_quirks = rtl8xxxu_gen2_usb_quirks,
 	.set_tx_power = rtl8723b_set_tx_power,
 	.update_rate_mask = rtl8xxxu_gen2_update_rate_mask,
-	.report_connect = rtl8723bu_report_connect,
+	.report_connect = rtl8xxxu_gen2_report_connect,
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
@@ -9993,7 +9993,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.usb_quirks = rtl8xxxu_gen2_usb_quirks,
 	.set_tx_power = rtl8192e_set_tx_power,
 	.update_rate_mask = rtl8xxxu_gen2_update_rate_mask,
-	.report_connect = rtl8723bu_report_connect,
+	.report_connect = rtl8xxxu_gen2_report_connect,
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
-- 
2.5.5

