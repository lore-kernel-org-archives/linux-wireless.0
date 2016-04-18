Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbcDRPti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 11:49:38 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 06/16] rtl8xxxu: Rename rtl8723a_disable_rf() to rtl8xxxu_gen1_disable_rf()
Date: Mon, 18 Apr 2016 11:49:26 -0400
Message-Id: <1460994576-24091-7-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160418_174945_125665_25393680)
In-Reply-To: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

All currently supported gen1 parts use the same disable_rf() routine,
so rename the function to reflect that.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 7a28b78..4aab4f5 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2120,7 +2120,7 @@ static void rtl8723a_enable_rf(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write8(priv, REG_TXPAUSE, 0x00);
 }
 
-static void rtl8723a_disable_rf(struct rtl8xxxu_priv *priv)
+static void rtl8xxxu_gen1_disable_rf(struct rtl8xxxu_priv *priv)
 {
 	u8 sps0;
 	u32 val32;
@@ -9882,7 +9882,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.config_channel = rtl8723au_config_channel,
 	.parse_rx_desc = rtl8xxxu_parse_rxdesc16,
 	.enable_rf = rtl8723a_enable_rf,
-	.disable_rf = rtl8723a_disable_rf,
+	.disable_rf = rtl8xxxu_gen1_disable_rf,
 	.usb_quirks = rtl8xxxu_gen1_usb_quirks,
 	.set_tx_power = rtl8723a_set_tx_power,
 	.update_rate_mask = rtl8723au_update_rate_mask,
@@ -9954,7 +9954,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.config_channel = rtl8723au_config_channel,
 	.parse_rx_desc = rtl8xxxu_parse_rxdesc16,
 	.enable_rf = rtl8723a_enable_rf,
-	.disable_rf = rtl8723a_disable_rf,
+	.disable_rf = rtl8xxxu_gen1_disable_rf,
 	.usb_quirks = rtl8xxxu_gen1_usb_quirks,
 	.set_tx_power = rtl8723a_set_tx_power,
 	.update_rate_mask = rtl8723au_update_rate_mask,
-- 
2.5.5

