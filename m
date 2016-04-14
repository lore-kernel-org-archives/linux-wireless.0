Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 08/26] rtl8xxxu: Implment rtl8192e_set_tx_power()
Date: Thu, 14 Apr 2016 14:58:49 -0400
Message-Id: <1460660347-26299-9-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_212529_876875_3FD61776)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

8192eu is a 2T part, so setting TX power for path A only, as done by
rtl8723bu_set_tx_power() is not sufficient.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 78 +++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 99cf4aa..7ab009f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2555,6 +2555,82 @@ rtl8723b_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 	rtl8xxxu_write32(priv, REG_TX_AGC_A_MCS07_MCS04, mcs);
 }
 
+static void
+rtl8192e_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
+{
+	u32 val32, ofdm, mcs;
+	u8 cck, ofdmbase, mcsbase;
+	int group, tx_idx;
+
+	tx_idx = 0;
+	group = rtl8723b_channel_to_group(channel);
+
+	cck = priv->cck_tx_power_index_A[group];
+
+	val32 = rtl8xxxu_read32(priv, REG_TX_AGC_A_CCK1_MCS32);
+	val32 &= 0xffff00ff;
+	val32 |= (cck << 8);
+	rtl8xxxu_write32(priv, REG_TX_AGC_A_CCK1_MCS32, val32);
+
+	val32 = rtl8xxxu_read32(priv, REG_TX_AGC_B_CCK11_A_CCK2_11);
+	val32 &= 0xff;
+	val32 |= ((cck << 8) | (cck << 16) | (cck << 24));
+	rtl8xxxu_write32(priv, REG_TX_AGC_B_CCK11_A_CCK2_11, val32);
+
+	ofdmbase = priv->ht40_1s_tx_power_index_A[group];
+	ofdmbase += priv->ofdm_tx_power_diff[tx_idx].a;
+	ofdm = ofdmbase | ofdmbase << 8 | ofdmbase << 16 | ofdmbase << 24;
+
+	rtl8xxxu_write32(priv, REG_TX_AGC_A_RATE18_06, ofdm);
+	rtl8xxxu_write32(priv, REG_TX_AGC_A_RATE54_24, ofdm);
+
+	mcsbase = priv->ht40_1s_tx_power_index_A[group];
+	if (ht40)
+		mcsbase += priv->ht40_tx_power_diff[tx_idx++].a;
+	else
+		mcsbase += priv->ht20_tx_power_diff[tx_idx++].a;
+	mcs = mcsbase | mcsbase << 8 | mcsbase << 16 | mcsbase << 24;
+
+	rtl8xxxu_write32(priv, REG_TX_AGC_A_MCS03_MCS00, mcs);
+	rtl8xxxu_write32(priv, REG_TX_AGC_A_MCS07_MCS04, mcs);
+	rtl8xxxu_write32(priv, REG_TX_AGC_A_MCS11_MCS08, mcs);
+	rtl8xxxu_write32(priv, REG_TX_AGC_A_MCS15_MCS12, mcs);
+
+	if (priv->tx_paths > 1) {
+		cck = priv->cck_tx_power_index_B[group];
+
+		val32 = rtl8xxxu_read32(priv, REG_TX_AGC_B_CCK1_55_MCS32);
+		val32 &= 0xff;
+		val32 |= ((cck << 8) | (cck << 16) | (cck << 24));
+		rtl8xxxu_write32(priv, REG_TX_AGC_B_CCK1_55_MCS32, val32);
+
+		val32 = rtl8xxxu_read32(priv, REG_TX_AGC_B_CCK11_A_CCK2_11);
+		val32 &= 0xffffff00;
+		val32 |= cck;
+		rtl8xxxu_write32(priv, REG_TX_AGC_B_CCK11_A_CCK2_11, val32);
+
+		ofdmbase = priv->ht40_1s_tx_power_index_B[group];
+		ofdmbase += priv->ofdm_tx_power_diff[tx_idx].b;
+		ofdm = ofdmbase | ofdmbase << 8 |
+			ofdmbase << 16 | ofdmbase << 24;
+
+		rtl8xxxu_write32(priv, REG_TX_AGC_B_RATE18_06, ofdm);
+		rtl8xxxu_write32(priv, REG_TX_AGC_B_RATE54_24, ofdm);
+
+		mcsbase = priv->ht40_1s_tx_power_index_B[group];
+		if (ht40)
+			mcsbase += priv->ht40_tx_power_diff[tx_idx++].b;
+		else
+			mcsbase += priv->ht20_tx_power_diff[tx_idx++].b;
+		mcs = mcsbase | mcsbase << 8 | mcsbase << 16 | mcsbase << 24;
+
+		rtl8xxxu_write32(priv, REG_TX_AGC_B_MCS03_MCS00, mcs);
+		rtl8xxxu_write32(priv, REG_TX_AGC_B_MCS07_MCS04, mcs);
+		rtl8xxxu_write32(priv, REG_TX_AGC_B_MCS11_MCS08, mcs);
+		rtl8xxxu_write32(priv, REG_TX_AGC_B_MCS15_MCS12, mcs);
+	}
+}
+
 static void rtl8xxxu_set_linktype(struct rtl8xxxu_priv *priv,
 				  enum nl80211_iftype linktype)
 {
@@ -9784,7 +9860,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.parse_rx_desc = rtl8723bu_parse_rx_desc,
 	.enable_rf = rtl8723b_enable_rf,
 	.disable_rf = rtl8723b_disable_rf,
-	.set_tx_power = rtl8723b_set_tx_power,
+	.set_tx_power = rtl8192e_set_tx_power,
 	.update_rate_mask = rtl8723bu_update_rate_mask,
 	.report_connect = rtl8723bu_report_connect,
 	.writeN_block_size = 128,
-- 
2.5.5

