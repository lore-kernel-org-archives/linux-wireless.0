Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbcDRPti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 11:49:38 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 12/16] rtl8xxxu: Rename rtl8723a_enable_rf() to rtl8xxxu_gen1_enable_rf()
Date: Mon, 18 Apr 2016 11:49:32 -0400
Message-Id: <1460994576-24091-13-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160418_180721_326868_9A645138)
In-Reply-To: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

All gen1 parts use the same enable_rf() function, so rename it to
reflect this.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 1499aa0..a2f5609 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2076,7 +2076,7 @@ static void rtl8723bu_write_btreg(struct rtl8xxxu_priv *priv, u8 reg, u8 data)
 	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.bt_mp_oper));
 }
 
-static void rtl8723a_enable_rf(struct rtl8xxxu_priv *priv)
+static void rtl8xxxu_gen1_enable_rf(struct rtl8xxxu_priv *priv)
 {
 	u8 val8;
 	u32 val32;
@@ -9881,7 +9881,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.phy_iq_calibrate = rtl8xxxu_gen1_phy_iq_calibrate,
 	.config_channel = rtl8xxxu_gen1_config_channel,
 	.parse_rx_desc = rtl8xxxu_parse_rxdesc16,
-	.enable_rf = rtl8723a_enable_rf,
+	.enable_rf = rtl8xxxu_gen1_enable_rf,
 	.disable_rf = rtl8xxxu_gen1_disable_rf,
 	.usb_quirks = rtl8xxxu_gen1_usb_quirks,
 	.set_tx_power = rtl8xxxu_gen1_set_tx_power,
@@ -9953,7 +9953,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.phy_iq_calibrate = rtl8xxxu_gen1_phy_iq_calibrate,
 	.config_channel = rtl8xxxu_gen1_config_channel,
 	.parse_rx_desc = rtl8xxxu_parse_rxdesc16,
-	.enable_rf = rtl8723a_enable_rf,
+	.enable_rf = rtl8xxxu_gen1_enable_rf,
 	.disable_rf = rtl8xxxu_gen1_disable_rf,
 	.usb_quirks = rtl8xxxu_gen1_usb_quirks,
 	.set_tx_power = rtl8xxxu_gen1_set_tx_power,
-- 
2.5.5

