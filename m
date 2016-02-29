Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbcB2WGI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:08 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 106/113] rtl8xxxu: convert rtl8723bu_init_bt() into rtl8723b_enable_rf()
Date: Mon, 29 Feb 2016 17:05:44 -0500
Message-Id: <1456783551-28315-107-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230622_641778_0E070DCF)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

rtl8723bu_init_bt() is effectively the function enabling RF, so name
it appropriately.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 11 +----------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  1 -
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 67ea89b..b5ab899 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1596,10 +1596,6 @@ static void rtl8723a_enable_rf(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write8(priv, REG_TXPAUSE, 0x00);
 }
 
-static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
-{
-}
-
 static void rtl8723a_disable_rf(struct rtl8xxxu_priv *priv)
 {
 	u8 sps0;
@@ -5953,7 +5949,7 @@ static void rtl8723bu_set_ps_tdma(struct rtl8xxxu_priv *priv,
 }
 #endif
 
-static void rtl8723bu_init_bt(struct rtl8xxxu_priv *priv)
+static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
 {
 	struct h2c_cmd h2c;
 	u32 val32;
@@ -6508,10 +6504,6 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	else
 		rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_T_METER, 0x60);
 
-	/* Init BT hw config. */
-	if (priv->fops->init_bt)
-		priv->fops->init_bt(priv);
-
 	/* Set NAV_UPPER to 30000us */
 	val8 = ((30000 + NAV_UPPER_UNIT - 1) / NAV_UPPER_UNIT);
 	rtl8xxxu_write8(priv, REG_NAV_UPPER, val8);
@@ -8300,7 +8292,6 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.phy_init_antenna_selection = rtl8723bu_phy_init_antenna_selection,
 	.phy_iq_calibrate = rtl8723bu_phy_iq_calibrate,
 	.config_channel = rtl8723bu_config_channel,
-	.init_bt = rtl8723bu_init_bt,
 	.parse_rx_desc = rtl8723bu_parse_rx_desc,
 	.init_aggregation = rtl8723bu_init_aggregation,
 	.init_statistics = rtl8723bu_init_statistics,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index b44cb59..776fd17 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1261,7 +1261,6 @@ struct rtl8xxxu_fileops {
 	void (*phy_init_antenna_selection) (struct rtl8xxxu_priv *priv);
 	void (*phy_iq_calibrate) (struct rtl8xxxu_priv *priv);
 	void (*config_channel) (struct ieee80211_hw *hw);
-	void (*init_bt) (struct rtl8xxxu_priv *priv);
 	int (*parse_rx_desc) (struct rtl8xxxu_priv *priv, struct sk_buff *skb,
 			      struct ieee80211_rx_status *rx_status);
 	void (*init_aggregation) (struct rtl8xxxu_priv *priv);
-- 
2.5.0

