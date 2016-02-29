Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383AbcB2WF7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:59 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 108/113] rtl8xxxu: Implement 8723bu specific disable_rf() function
Date: Mon, 29 Feb 2016 17:05:46 -0500
Message-Id: <1456783551-28315-109-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232951_579344_D4185D62)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Powering up the 8723bu RF should probably be matched by the ability to
power it down again.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 17 ++++++++++++++++-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  1 +
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index c7984ab..1095c18 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6056,6 +6056,17 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
 	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.ignore_wlan));
 }
 
+static void rtl8723b_disable_rf(struct rtl8xxxu_priv *priv)
+{
+	u32 val32;
+
+	rtl8xxxu_write8(priv, REG_TXPAUSE, 0xff);
+
+	val32 = rtl8xxxu_read32(priv, REG_RX_WAIT_CCA);
+	val32 &= ~(BIT(22) | BIT(23));
+	rtl8xxxu_write32(priv, REG_RX_WAIT_CCA, val32);
+}
+
 static void rtl8723bu_init_aggregation(struct rtl8xxxu_priv *priv)
 {
 	u32 agg_rx;
@@ -7987,7 +7998,7 @@ static void rtl8xxxu_stop(struct ieee80211_hw *hw)
 	if (priv->usb_interrupts)
 		usb_kill_anchored_urbs(&priv->int_anchor);
 
-	rtl8723a_disable_rf(priv);
+	priv->fops->disable_rf(priv);
 
 	/*
 	 * Disable interrupts
@@ -8271,6 +8282,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.config_channel = rtl8723au_config_channel,
 	.parse_rx_desc = rtl8723au_parse_rx_desc,
 	.enable_rf = rtl8723a_enable_rf,
+	.disable_rf = rtl8723a_disable_rf,
 	.set_tx_power = rtl8723a_set_tx_power,
 	.update_rate_mask = rtl8723au_update_rate_mask,
 	.report_connect = rtl8723au_report_connect,
@@ -8296,6 +8308,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.init_aggregation = rtl8723bu_init_aggregation,
 	.init_statistics = rtl8723bu_init_statistics,
 	.enable_rf = rtl8723b_enable_rf,
+	.disable_rf = rtl8723b_disable_rf,
 	.set_tx_power = rtl8723b_set_tx_power,
 	.update_rate_mask = rtl8723bu_update_rate_mask,
 	.report_connect = rtl8723bu_report_connect,
@@ -8321,6 +8334,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.config_channel = rtl8723au_config_channel,
 	.parse_rx_desc = rtl8723au_parse_rx_desc,
 	.enable_rf = rtl8723a_enable_rf,
+	.disable_rf = rtl8723a_disable_rf,
 	.set_tx_power = rtl8723a_set_tx_power,
 	.update_rate_mask = rtl8723au_update_rate_mask,
 	.report_connect = rtl8723au_report_connect,
@@ -8345,6 +8359,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.config_channel = rtl8723bu_config_channel,
 	.parse_rx_desc = rtl8723bu_parse_rx_desc,
 	.enable_rf = rtl8723b_enable_rf,
+	.disable_rf = rtl8723b_disable_rf,
 	.set_tx_power = rtl8723b_set_tx_power,
 	.update_rate_mask = rtl8723au_update_rate_mask,
 	.report_connect = rtl8723au_report_connect,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 776fd17..9c535e8 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1266,6 +1266,7 @@ struct rtl8xxxu_fileops {
 	void (*init_aggregation) (struct rtl8xxxu_priv *priv);
 	void (*init_statistics) (struct rtl8xxxu_priv *priv);
 	void (*enable_rf) (struct rtl8xxxu_priv *priv);
+	void (*disable_rf) (struct rtl8xxxu_priv *priv);
 	void (*set_tx_power) (struct rtl8xxxu_priv *priv, int channel,
 			      bool ht40);
 	void (*update_rate_mask) (struct rtl8xxxu_priv *priv,
-- 
2.5.0

