Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 09/26] rtl8xxxu: Use has_s0s1 for REG_S0S1 issues only
Date: Thu, 14 Apr 2016 14:58:50 -0400
Message-Id: <1460660347-26299-10-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_212530_520184_DCED3032)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Instead use tx_desc_size() to distinguish between gen1
(8723a/8192c/8188c) and gen2 (8723b/8192e) parts.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 7ab009f..8b0b6c9 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2758,7 +2758,8 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 	} else if (val32 & SYS_CFG_TYPE_ID) {
 		bonding = rtl8xxxu_read32(priv, REG_HPON_FSM);
 		bonding &= HPON_FSM_BONDING_MASK;
-		if (priv->fops->has_s0s1) {
+		if (priv->fops->tx_desc_size ==
+		    sizeof(struct rtl8xxxu_txdesc40)) {
 			if (bonding == HPON_FSM_BONDING_1T2R) {
 				sprintf(priv->chip_name, "8191EU");
 				priv->rf_paths = 2;
@@ -7993,7 +7994,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	/*
 	 * This should enable thermal meter
 	 */
-	if (priv->fops->has_s0s1)
+	if (priv->fops->tx_desc_size == sizeof(struct rtl8xxxu_txdesc40))
 		rtl8xxxu_write_rfreg(priv,
 				     RF_A, RF6052_REG_T_METER_8723B, 0x37cf8);
 	else
@@ -9867,7 +9868,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
 	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc40),
-	.has_s0s1 = 1,
+	.has_s0s1 = 0,
 	.adda_1t_init = 0x0fc01616,
 	.adda_1t_path_on = 0x0fc01616,
 	.adda_2t_path_on_a = 0x0fc01616,
-- 
2.5.5

