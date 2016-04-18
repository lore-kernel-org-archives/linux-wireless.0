Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbcDRPti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 11:49:38 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 04/16] rtl8xxxu: Rename rtl8723bu_config_channel() to rtl8xxxu_gen2_config_channel()
Date: Mon, 18 Apr 2016 11:49:24 -0400
Message-Id: <1460994576-24091-5-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160418_174948_038285_5DC5CD60)
In-Reply-To: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Rename the function to indicate it is applicable to most/all gen2
parts.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index a7f7031..0928352 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2341,7 +2341,7 @@ static void rtl8723au_config_channel(struct ieee80211_hw *hw)
 	}
 }
 
-static void rtl8723bu_config_channel(struct ieee80211_hw *hw)
+static void rtl8xxxu_gen2_config_channel(struct ieee80211_hw *hw)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
 	u32 val32, rsr;
@@ -9913,7 +9913,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.init_phy_rf = rtl8723bu_init_phy_rf,
 	.phy_init_antenna_selection = rtl8723bu_phy_init_antenna_selection,
 	.phy_iq_calibrate = rtl8723bu_phy_iq_calibrate,
-	.config_channel = rtl8723bu_config_channel,
+	.config_channel = rtl8xxxu_gen2_config_channel,
 	.parse_rx_desc = rtl8xxxu_parse_rxdesc24,
 	.init_aggregation = rtl8723bu_init_aggregation,
 	.init_statistics = rtl8723bu_init_statistics,
@@ -9986,7 +9986,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.init_phy_bb = rtl8192eu_init_phy_bb,
 	.init_phy_rf = rtl8192eu_init_phy_rf,
 	.phy_iq_calibrate = rtl8192eu_phy_iq_calibrate,
-	.config_channel = rtl8723bu_config_channel,
+	.config_channel = rtl8xxxu_gen2_config_channel,
 	.parse_rx_desc = rtl8xxxu_parse_rxdesc24,
 	.enable_rf = rtl8192e_enable_rf,
 	.disable_rf = rtl8723b_disable_rf,
-- 
2.5.5

