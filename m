Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524AbcB2WGD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 085/113] rtl8xxxu: Set 8723bu TX power for CCK and OFDM rates
Date: Mon, 29 Feb 2016 17:05:23 -0500
Message-Id: <1456783551-28315-86-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232951_467690_547E672F)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This implements support for setting TX power for CCK and OFDM rates on
8723bu. MCS rates is still pending.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 970f0ec..daea712 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2062,9 +2062,30 @@ rtl8723a_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 static void
 rtl8723b_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 {
-	int group;
+	u32 val32, ofdm;
+	u8 cck, ofdmbase;
+	int group, tx_idx;
 
+	tx_idx = 0;
 	group = rtl8723b_channel_to_group(channel);
+
+	cck = priv->cck_tx_power_index_B[group];
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
+	ofdmbase = priv->ht40_1s_tx_power_index_B[group];
+	ofdmbase += priv->ofdm_tx_power_diff[tx_idx].b;
+	ofdm = ofdmbase | ofdmbase << 8 | ofdmbase << 16 | ofdmbase << 24;
+
+	rtl8xxxu_write32(priv, REG_TX_AGC_A_RATE18_06, ofdm);
+	rtl8xxxu_write32(priv, REG_TX_AGC_A_RATE54_24, ofdm);
 }
 
 static void rtl8xxxu_set_linktype(struct rtl8xxxu_priv *priv,
-- 
2.5.0

