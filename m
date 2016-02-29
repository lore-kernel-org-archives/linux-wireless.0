Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbcB2WF5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:57 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 079/113] rtl8xxxu: Do not use hard-wired RF enable settings for 8723bu
Date: Mon, 29 Feb 2016 17:05:17 -0500
Message-Id: <1456783551-28315-80-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230801_176297_A0575008)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

These settings simply block the 8723bu, for now leave an empty
function.

With this change we can finally communicate with aliens using the
8723bu!

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 10 +++++++++-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 7fb9830..9caee4dc 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1596,6 +1596,10 @@ static void rtl8723a_enable_rf(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write8(priv, REG_TXPAUSE, 0x00);
 }
 
+static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
+{
+}
+
 static void rtl8723a_disable_rf(struct rtl8xxxu_priv *priv)
 {
 	u8 sps0;
@@ -7665,7 +7669,7 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 	init_usb_anchor(&priv->tx_anchor);
 	init_usb_anchor(&priv->int_anchor);
 
-	rtl8723a_enable_rf(priv);
+	priv->fops->enable_rf(priv);
 	if (priv->usb_interrupts) {
 		ret = rtl8xxxu_submit_int_urb(hw);
 		if (ret)
@@ -8031,6 +8035,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.phy_iq_calibrate = rtl8723au_phy_iq_calibrate,
 	.config_channel = rtl8723au_config_channel,
 	.parse_rx_desc = rtl8723au_parse_rx_desc,
+	.enable_rf = rtl8723a_enable_rf,
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
@@ -8052,6 +8057,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.parse_rx_desc = rtl8723bu_parse_rx_desc,
 	.init_aggregation = rtl8723bu_init_aggregation,
 	.init_statistics = rtl8723bu_init_statistics,
+	.enable_rf = rtl8723b_enable_rf,
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
@@ -8072,6 +8078,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.phy_iq_calibrate = rtl8723au_phy_iq_calibrate,
 	.config_channel = rtl8723au_config_channel,
 	.parse_rx_desc = rtl8723au_parse_rx_desc,
+	.enable_rf = rtl8723a_enable_rf,
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
@@ -8091,6 +8098,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.phy_iq_calibrate = rtl8723bu_phy_iq_calibrate,
 	.config_channel = rtl8723bu_config_channel,
 	.parse_rx_desc = rtl8723bu_parse_rx_desc,
+	.enable_rf = rtl8723b_enable_rf,
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index b75678b..ac8f47f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1135,6 +1135,7 @@ struct rtl8xxxu_fileops {
 			      struct ieee80211_rx_status *rx_status);
 	void (*init_aggregation) (struct rtl8xxxu_priv *priv);
 	void (*init_statistics) (struct rtl8xxxu_priv *priv);
+	void (*enable_rf) (struct rtl8xxxu_priv *priv);
 	int writeN_block_size;
 	u16 mbox_ext_reg;
 	char mbox_ext_width;
-- 
2.5.0

