Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933801AbcBCSkE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:04 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 27/28] rtl8xxxu: Make device_init kludge 8723au only
Date: Wed,  3 Feb 2016 13:40:01 -0500
Message-Id: <1454524802-26763-28-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_194140_090726_E664ED6B)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index af17ae7..fdeae3b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -4343,14 +4343,17 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	val8 = ((30000 + NAV_UPPER_UNIT - 1) / NAV_UPPER_UNIT);
 	rtl8xxxu_write8(priv, REG_NAV_UPPER, val8);
 
-	/*
-	 * 2011/03/09 MH debug only, UMC-B cut pass 2500 S5 test,
-	 * but we need to fin root cause.
-	 */
-	val32 = rtl8xxxu_read32(priv, REG_FPGA0_RF_MODE);
-	if ((val32 & 0xff000000) != 0x83000000) {
-		val32 |= FPGA_RF_MODE_CCK;
-		rtl8xxxu_write32(priv, REG_FPGA0_RF_MODE, val32);
+	if (priv->rtlchip == 0x8723a) {
+		/*
+		 * 2011/03/09 MH debug only, UMC-B cut pass 2500 S5 test,
+		 * but we need to find root cause.
+		 * This is 8723au only.
+		 */
+		val32 = rtl8xxxu_read32(priv, REG_FPGA0_RF_MODE);
+		if ((val32 & 0xff000000) != 0x83000000) {
+			val32 |= FPGA_RF_MODE_CCK;
+			rtl8xxxu_write32(priv, REG_FPGA0_RF_MODE, val32);
+		}
 	}
 
 	val32 = rtl8xxxu_read32(priv, REG_FWHW_TXQ_CTRL);
-- 
2.5.0

