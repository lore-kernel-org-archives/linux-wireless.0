Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbcDRPti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 11:49:38 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 08/16] rtl8xxxu: Rename rtl8723au_update_rate_mask() to rtl8xxxu_update_rate_mask()
Date: Mon, 18 Apr 2016 11:49:28 -0400
Message-Id: <1460994576-24091-9-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160418_180721_500243_68219E39)
In-Reply-To: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

All currently supported gen1 parts use the same function for updating
the rate mask, so rename it to reflect this.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index d0557ad..469bc9a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -8199,8 +8199,8 @@ static void rtl8xxxu_sw_scan_complete(struct ieee80211_hw *hw,
 	rtl8xxxu_write8(priv, REG_BEACON_CTRL, val8);
 }
 
-static void rtl8723au_update_rate_mask(struct rtl8xxxu_priv *priv,
-				       u32 ramask, int sgi)
+static void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv,
+				      u32 ramask, int sgi)
 {
 	struct h2c_cmd h2c;
 
@@ -9885,7 +9885,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.disable_rf = rtl8xxxu_gen1_disable_rf,
 	.usb_quirks = rtl8xxxu_gen1_usb_quirks,
 	.set_tx_power = rtl8723a_set_tx_power,
-	.update_rate_mask = rtl8723au_update_rate_mask,
+	.update_rate_mask = rtl8xxxu_update_rate_mask,
 	.report_connect = rtl8xxxu_gen1_report_connect,
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
@@ -9957,7 +9957,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.disable_rf = rtl8xxxu_gen1_disable_rf,
 	.usb_quirks = rtl8xxxu_gen1_usb_quirks,
 	.set_tx_power = rtl8723a_set_tx_power,
-	.update_rate_mask = rtl8723au_update_rate_mask,
+	.update_rate_mask = rtl8xxxu_update_rate_mask,
 	.report_connect = rtl8xxxu_gen1_report_connect,
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
-- 
2.5.5

