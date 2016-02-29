Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbcB2WGD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 086/113] rtl8xxxu: Set 8723bu MCS TX power
Date: Mon, 29 Feb 2016 17:05:24 -0500
Message-Id: <1456783551-28315-87-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232950_728825_AF2D8735)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This adds the missing support for setting MCS TX power rates on 8723bu.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index daea712..cca3b92 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2062,8 +2062,8 @@ rtl8723a_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 static void
 rtl8723b_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 {
-	u32 val32, ofdm;
-	u8 cck, ofdmbase;
+	u32 val32, ofdm, mcs;
+	u8 cck, ofdmbase, mcsbase;
 	int group, tx_idx;
 
 	tx_idx = 0;
@@ -2086,6 +2086,16 @@ rtl8723b_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 
 	rtl8xxxu_write32(priv, REG_TX_AGC_A_RATE18_06, ofdm);
 	rtl8xxxu_write32(priv, REG_TX_AGC_A_RATE54_24, ofdm);
+
+	mcsbase = priv->ht40_1s_tx_power_index_B[group];
+	if (ht40)
+		mcsbase += priv->ht40_tx_power_diff[tx_idx++].b;
+	else
+		mcsbase += priv->ht20_tx_power_diff[tx_idx++].b;
+	mcs = mcsbase | mcsbase << 8 | mcsbase << 16 | mcsbase << 24;
+
+	rtl8xxxu_write32(priv, REG_TX_AGC_A_MCS03_MCS00, mcs);
+	rtl8xxxu_write32(priv, REG_TX_AGC_A_MCS07_MCS04, mcs);
 }
 
 static void rtl8xxxu_set_linktype(struct rtl8xxxu_priv *priv,
-- 
2.5.0

