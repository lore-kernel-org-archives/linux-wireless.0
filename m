Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbcDRPti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 11:49:38 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 05/16] rtl8xxxu: Rename rtl8723b_disable_rf() to rtl8xxxu_gen2_disable_rf()
Date: Mon, 18 Apr 2016 11:49:25 -0400
Message-Id: <1460994576-24091-6-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160418_180721_745414_65F1CCB0)
In-Reply-To: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

At least for now, all gen2 parts use the same disable_rf() function

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 0928352..7a28b78 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7659,7 +7659,7 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
 	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.ignore_wlan));
 }
 
-static void rtl8723b_disable_rf(struct rtl8xxxu_priv *priv)
+static void rtl8xxxu_gen2_disable_rf(struct rtl8xxxu_priv *priv)
 {
 	u32 val32;
 
@@ -9918,7 +9918,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.init_aggregation = rtl8723bu_init_aggregation,
 	.init_statistics = rtl8723bu_init_statistics,
 	.enable_rf = rtl8723b_enable_rf,
-	.disable_rf = rtl8723b_disable_rf,
+	.disable_rf = rtl8xxxu_gen2_disable_rf,
 	.usb_quirks = rtl8xxxu_gen2_usb_quirks,
 	.set_tx_power = rtl8723b_set_tx_power,
 	.update_rate_mask = rtl8xxxu_gen2_update_rate_mask,
@@ -9989,7 +9989,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.config_channel = rtl8xxxu_gen2_config_channel,
 	.parse_rx_desc = rtl8xxxu_parse_rxdesc24,
 	.enable_rf = rtl8192e_enable_rf,
-	.disable_rf = rtl8723b_disable_rf,
+	.disable_rf = rtl8xxxu_gen2_disable_rf,
 	.usb_quirks = rtl8xxxu_gen2_usb_quirks,
 	.set_tx_power = rtl8192e_set_tx_power,
 	.update_rate_mask = rtl8xxxu_gen2_update_rate_mask,
-- 
2.5.5

