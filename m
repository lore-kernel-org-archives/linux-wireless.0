Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbcDRPti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 11:49:38 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 11/16] rtl8xxxu: Rename rtl8723a_set_tx_power() to rtl8xxxu_gen1_set_tx_power()
Date: Mon, 18 Apr 2016 11:49:31 -0400
Message-Id: <1460994576-24091-12-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160418_180721_626272_17AD6578)
In-Reply-To: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

All gen1 parts use the same interface for setting TX power, so rename
the function to reflect this.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 5c86965..1499aa0 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2472,7 +2472,7 @@ static void rtl8xxxu_gen2_config_channel(struct ieee80211_hw *hw)
 }
 
 static void
-rtl8723a_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
+rtl8xxxu_gen1_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 {
 	struct rtl8xxxu_power_base *power_base = priv->power_base;
 	u8 cck[RTL8723A_MAX_RF_PATHS], ofdm[RTL8723A_MAX_RF_PATHS];
@@ -9884,7 +9884,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.enable_rf = rtl8723a_enable_rf,
 	.disable_rf = rtl8xxxu_gen1_disable_rf,
 	.usb_quirks = rtl8xxxu_gen1_usb_quirks,
-	.set_tx_power = rtl8723a_set_tx_power,
+	.set_tx_power = rtl8xxxu_gen1_set_tx_power,
 	.update_rate_mask = rtl8xxxu_update_rate_mask,
 	.report_connect = rtl8xxxu_gen1_report_connect,
 	.writeN_block_size = 1024,
@@ -9956,7 +9956,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.enable_rf = rtl8723a_enable_rf,
 	.disable_rf = rtl8xxxu_gen1_disable_rf,
 	.usb_quirks = rtl8xxxu_gen1_usb_quirks,
-	.set_tx_power = rtl8723a_set_tx_power,
+	.set_tx_power = rtl8xxxu_gen1_set_tx_power,
 	.update_rate_mask = rtl8xxxu_update_rate_mask,
 	.report_connect = rtl8xxxu_gen1_report_connect,
 	.writeN_block_size = 128,
-- 
2.5.5

