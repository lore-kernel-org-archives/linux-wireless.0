Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbcB2WGA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:00 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 081/113] rtl8xxxu: Introduce set_tx_power() fileop and a new 8723b dummy derivative
Date: Mon, 29 Feb 2016 17:05:19 -0500
Message-Id: <1456783551-28315-82-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232949_689734_A0005864)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The 8723b series is significantly different from the older generation
in this sense. So far the 8723b version doesn't do anything useful.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 34 ++++++++++++++++++++++--
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  2 ++
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 0afa9a9..f640306 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1680,6 +1680,24 @@ static int rtl8723a_channel_to_group(int channel)
 	return group;
 }
 
+static int rtl8723b_channel_to_group(int channel)
+{
+	int group;
+
+	if (channel < 3)
+		group = 0;
+	else if (channel < 6)
+		group = 1;
+	else if (channel < 9)
+		group = 2;
+	else if (channel < 12)
+		group = 3;
+	else
+		group = 4;
+
+	return group;
+}
+
 static void rtl8723au_config_channel(struct ieee80211_hw *hw)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
@@ -2041,6 +2059,14 @@ rtl8723a_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 	}
 }
 
+static void
+rtl8723b_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
+{
+	int group;
+
+	group = rtl8723b_channel_to_group(channel);
+}
+
 static void rtl8xxxu_set_linktype(struct rtl8xxxu_priv *priv,
 				  enum nl80211_iftype linktype)
 {
@@ -6378,7 +6404,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	/*
 	 * Start out with default power levels for channel 6, 20MHz
 	 */
-	rtl8723a_set_tx_power(priv, 1, false);
+	priv->fops->set_tx_power(priv, 1, false);
 
 	/* Let the 8051 take control of antenna setting */
 	val8 = rtl8xxxu_read8(priv, REG_LEDCFG2);
@@ -7401,7 +7427,7 @@ static int rtl8xxxu_config(struct ieee80211_hw *hw, u32 changed)
 
 		channel = hw->conf.chandef.chan->hw_value;
 
-		rtl8723a_set_tx_power(priv, channel, ht40);
+		priv->fops->set_tx_power(priv, channel, ht40);
 
 		priv->fops->config_channel(hw);
 	}
@@ -8026,6 +8052,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.config_channel = rtl8723au_config_channel,
 	.parse_rx_desc = rtl8723au_parse_rx_desc,
 	.enable_rf = rtl8723a_enable_rf,
+	.set_tx_power = rtl8723a_set_tx_power,
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
@@ -8048,6 +8075,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.init_aggregation = rtl8723bu_init_aggregation,
 	.init_statistics = rtl8723bu_init_statistics,
 	.enable_rf = rtl8723b_enable_rf,
+	.set_tx_power = rtl8723b_set_tx_power,
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
@@ -8069,6 +8097,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.config_channel = rtl8723au_config_channel,
 	.parse_rx_desc = rtl8723au_parse_rx_desc,
 	.enable_rf = rtl8723a_enable_rf,
+	.set_tx_power = rtl8723a_set_tx_power,
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
@@ -8089,6 +8118,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.config_channel = rtl8723bu_config_channel,
 	.parse_rx_desc = rtl8723bu_parse_rx_desc,
 	.enable_rf = rtl8723b_enable_rf,
+	.set_tx_power = rtl8723b_set_tx_power,
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 6d56581..c7b4c92 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1149,6 +1149,8 @@ struct rtl8xxxu_fileops {
 	void (*init_aggregation) (struct rtl8xxxu_priv *priv);
 	void (*init_statistics) (struct rtl8xxxu_priv *priv);
 	void (*enable_rf) (struct rtl8xxxu_priv *priv);
+	void (*set_tx_power) (struct rtl8xxxu_priv *priv, int channel,
+			      bool ht40);
 	int writeN_block_size;
 	u16 mbox_ext_reg;
 	char mbox_ext_width;
-- 
2.5.0

