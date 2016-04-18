Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbcDRPti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 11:49:38 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 07/16] rtl8xxxu: Rename rtl8723au_config_channel() to rtl8xxxu_gen1_config_channel()
Date: Mon, 18 Apr 2016 11:49:27 -0400
Message-Id: <1460994576-24091-8-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160418_174956_685584_4ACCAC0E)
In-Reply-To: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

All supported gen1 parts use the same config_channel() function, so
rename it to reflect this.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 4aab4f5..d0557ad 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2219,7 +2219,7 @@ static int rtl8723b_channel_to_group(int channel)
 	return group;
 }
 
-static void rtl8723au_config_channel(struct ieee80211_hw *hw)
+static void rtl8xxxu_gen1_config_channel(struct ieee80211_hw *hw)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
 	u32 val32, rsr;
@@ -9879,7 +9879,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.init_phy_bb = rtl8723au_init_phy_bb,
 	.init_phy_rf = rtl8723au_init_phy_rf,
 	.phy_iq_calibrate = rtl8723au_phy_iq_calibrate,
-	.config_channel = rtl8723au_config_channel,
+	.config_channel = rtl8xxxu_gen1_config_channel,
 	.parse_rx_desc = rtl8xxxu_parse_rxdesc16,
 	.enable_rf = rtl8723a_enable_rf,
 	.disable_rf = rtl8xxxu_gen1_disable_rf,
@@ -9951,7 +9951,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.init_phy_bb = rtl8723au_init_phy_bb,
 	.init_phy_rf = rtl8192cu_init_phy_rf,
 	.phy_iq_calibrate = rtl8723au_phy_iq_calibrate,
-	.config_channel = rtl8723au_config_channel,
+	.config_channel = rtl8xxxu_gen1_config_channel,
 	.parse_rx_desc = rtl8xxxu_parse_rxdesc16,
 	.enable_rf = rtl8723a_enable_rf,
 	.disable_rf = rtl8xxxu_gen1_disable_rf,
-- 
2.5.5

