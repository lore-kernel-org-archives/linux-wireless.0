Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbcDRPti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 11:49:38 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 01/16] rtl8xxxu: Rename rtl8723bu_update_rate_mask() to rtl8xxxu_gen2_update_rate_mask()
Date: Mon, 18 Apr 2016 11:49:21 -0400
Message-Id: <1460994576-24091-2-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160418_174945_670905_239B1EAD)
In-Reply-To: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Update the name of rtl8723bu_update_rate_mask() to make it reflect
it's applicable for all/most gen2 N parts.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 928ca56..4ec18a4 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -8219,8 +8219,8 @@ static void rtl8723au_update_rate_mask(struct rtl8xxxu_priv *priv,
 	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.ramask));
 }
 
-static void rtl8723bu_update_rate_mask(struct rtl8xxxu_priv *priv,
-				       u32 ramask, int sgi)
+static void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
+					   u32 ramask, int sgi)
 {
 	struct h2c_cmd h2c;
 	u8 bw = 0;
@@ -9921,7 +9921,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.disable_rf = rtl8723b_disable_rf,
 	.usb_quirks = rtl8xxxu_gen2_usb_quirks,
 	.set_tx_power = rtl8723b_set_tx_power,
-	.update_rate_mask = rtl8723bu_update_rate_mask,
+	.update_rate_mask = rtl8xxxu_gen2_update_rate_mask,
 	.report_connect = rtl8723bu_report_connect,
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
@@ -9992,7 +9992,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.disable_rf = rtl8723b_disable_rf,
 	.usb_quirks = rtl8xxxu_gen2_usb_quirks,
 	.set_tx_power = rtl8192e_set_tx_power,
-	.update_rate_mask = rtl8723bu_update_rate_mask,
+	.update_rate_mask = rtl8xxxu_gen2_update_rate_mask,
 	.report_connect = rtl8723bu_report_connect,
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
-- 
2.5.5

