Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbcDRPti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 11:49:38 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 09/16] rtl8xxxu: Rename rtl8723au_phy_iq_calibrate() to rtl8xxxu_gen1_phy_iq_calibrate()
Date: Mon, 18 Apr 2016 11:49:29 -0400
Message-Id: <1460994576-24091-10-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160418_174952_487617_BA3C3A23)
In-Reply-To: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

All supported gen1 parts use the same phy_iq_calibrate() function
(unlike their gen2 counterparts). Rename the function to reflect this.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 469bc9a..d5c2117 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6103,7 +6103,7 @@ static void rtl8xxxu_prepare_calibrate(struct rtl8xxxu_priv *priv, u8 start)
 	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.bt_wlan_calibration));
 }
 
-static void rtl8723au_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
+static void rtl8xxxu_gen1_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 {
 	struct device *dev = &priv->udev->dev;
 	int result[4][8];	/* last is final result */
@@ -9878,7 +9878,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.llt_init = rtl8xxxu_init_llt_table,
 	.init_phy_bb = rtl8723au_init_phy_bb,
 	.init_phy_rf = rtl8723au_init_phy_rf,
-	.phy_iq_calibrate = rtl8723au_phy_iq_calibrate,
+	.phy_iq_calibrate = rtl8xxxu_gen1_phy_iq_calibrate,
 	.config_channel = rtl8xxxu_gen1_config_channel,
 	.parse_rx_desc = rtl8xxxu_parse_rxdesc16,
 	.enable_rf = rtl8723a_enable_rf,
@@ -9950,7 +9950,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.llt_init = rtl8xxxu_init_llt_table,
 	.init_phy_bb = rtl8723au_init_phy_bb,
 	.init_phy_rf = rtl8192cu_init_phy_rf,
-	.phy_iq_calibrate = rtl8723au_phy_iq_calibrate,
+	.phy_iq_calibrate = rtl8xxxu_gen1_phy_iq_calibrate,
 	.config_channel = rtl8xxxu_gen1_config_channel,
 	.parse_rx_desc = rtl8xxxu_parse_rxdesc16,
 	.enable_rf = rtl8723a_enable_rf,
-- 
2.5.5

