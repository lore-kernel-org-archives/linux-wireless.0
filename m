Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbcDNUhX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 16:37:23 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 06/16] rtl8xxxu: Use rtl_chip == RTL8188R to identify high PA parts
Date: Thu, 14 Apr 2016 16:37:11 -0400
Message-Id: <1460666241-5365-7-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_223740_362281_A94409F4)
In-Reply-To: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This is simpler than checking for RTL8188C && hi_pa.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index bebe484..8bf9a74 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -3054,6 +3054,7 @@ static int rtl8192cu_parse_efuse(struct rtl8xxxu_priv *priv)
 
 	if (efuse->rf_regulatory & 0x20) {
 		sprintf(priv->chip_name, "8188RU");
+		priv->rtl_chip = RTL8188R;
 		priv->hi_pa = 1;
 	}
 
@@ -4059,11 +4060,8 @@ static int rtl8192cu_init_phy_rf(struct rtl8xxxu_priv *priv)
 	struct rtl8xxxu_rfregval *rftable;
 	int ret;
 
-	if (priv->rtl_chip == RTL8188C) {
-		if (priv->hi_pa)
-			rftable = rtl8188ru_radioa_1t_highpa_table;
-		else
-			rftable = rtl8192cu_radioa_1t_init_table;
+	if (priv->rtl_chip == RTL8188R) {
+		rftable = rtl8188ru_radioa_1t_highpa_table;
 		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
 	} else if (priv->rf_paths == 1) {
 		rftable = rtl8192cu_radioa_1t_init_table;
@@ -7219,7 +7217,7 @@ static int rtl8192cu_power_on(struct rtl8xxxu_priv *priv)
 	/*
 	 * Workaround for 8188RU LNA power leakage problem.
 	 */
-	if (priv->rtl_chip == RTL8188C && priv->hi_pa) {
+	if (priv->rtl_chip == RTL8188R) {
 		val32 = rtl8xxxu_read32(priv, REG_FPGA0_XCD_RF_PARM);
 		val32 &= ~BIT(1);
 		rtl8xxxu_write32(priv, REG_FPGA0_XCD_RF_PARM, val32);
@@ -7323,7 +7321,7 @@ static void rtl8xxxu_power_off(struct rtl8xxxu_priv *priv)
 	/*
 	 * Workaround for 8188RU LNA power leakage problem.
 	 */
-	if (priv->rtl_chip == RTL8188C && priv->hi_pa) {
+	if (priv->rtl_chip == RTL8188R) {
 		val32 = rtl8xxxu_read32(priv, REG_FPGA0_XCD_RF_PARM);
 		val32 |= BIT(1);
 		rtl8xxxu_write32(priv, REG_FPGA0_XCD_RF_PARM, val32);
-- 
2.5.5

