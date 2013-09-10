Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:48373 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab3IJIvt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 04:51:49 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSW00MT2J6T6QW0@mailout3.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 10 Sep 2013 17:51:47 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>,
	'Jiri Slaby' <jirislaby@gmail.com>,
	'Nick Kossifidis' <mickflemm@gmail.com>,
	"'Luis R. Rodriguez'" <mcgrof@qca.qualcomm.com>
References: <005101ceae02$9cbb95f0$d632c1d0$%han@samsung.com>
In-reply-to: <005101ceae02$9cbb95f0$d632c1d0$%han@samsung.com>
Subject: [PATCH 1/8] wireless: ath5k: use dev_get_platdata()
Date: Tue, 10 Sep 2013 17:51:47 +0900
Message-id: <005301ceae02$fbabc8f0$f3035ad0$%han@samsung.com> (sfid-20130910_105156_017344_83993DC8)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/ath/ath5k/ahb.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
index e9bc9e6..79bffe1 100644
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -37,12 +37,9 @@ ath5k_ahb_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 {
 	struct ath5k_hw *ah = common->priv;
 	struct platform_device *pdev = to_platform_device(ah->dev);
-	struct ar231x_board_config *bcfg = pdev->dev.platform_data;
+	struct ar231x_board_config *bcfg = dev_get_platdata(&pdev->dev);
 	u16 *eeprom, *eeprom_end;
 
-
-
-	bcfg = pdev->dev.platform_data;
 	eeprom = (u16 *) bcfg->radio;
 	eeprom_end = ((void *) bcfg->config) + BOARD_CONFIG_BUFSZ;
 
@@ -57,7 +54,7 @@ ath5k_ahb_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 int ath5k_hw_read_srev(struct ath5k_hw *ah)
 {
 	struct platform_device *pdev = to_platform_device(ah->dev);
-	struct ar231x_board_config *bcfg = pdev->dev.platform_data;
+	struct ar231x_board_config *bcfg = dev_get_platdata(&pdev->dev);
 	ah->ah_mac_srev = bcfg->devid;
 	return 0;
 }
@@ -65,7 +62,7 @@ int ath5k_hw_read_srev(struct ath5k_hw *ah)
 static int ath5k_ahb_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac)
 {
 	struct platform_device *pdev = to_platform_device(ah->dev);
-	struct ar231x_board_config *bcfg = pdev->dev.platform_data;
+	struct ar231x_board_config *bcfg = dev_get_platdata(&pdev->dev);
 	u8 *cfg_mac;
 
 	if (to_platform_device(ah->dev)->id == 0)
@@ -87,7 +84,7 @@ static const struct ath_bus_ops ath_ahb_bus_ops = {
 /*Initialization*/
 static int ath_ahb_probe(struct platform_device *pdev)
 {
-	struct ar231x_board_config *bcfg = pdev->dev.platform_data;
+	struct ar231x_board_config *bcfg = dev_get_platdata(&pdev->dev);
 	struct ath5k_hw *ah;
 	struct ieee80211_hw *hw;
 	struct resource *res;
@@ -96,7 +93,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	int ret = 0;
 	u32 reg;
 
-	if (!pdev->dev.platform_data) {
+	if (!dev_get_platdata(&pdev->dev)) {
 		dev_err(&pdev->dev, "no platform data specified\n");
 		ret = -EINVAL;
 		goto err_out;
@@ -193,7 +190,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 
 static int ath_ahb_remove(struct platform_device *pdev)
 {
-	struct ar231x_board_config *bcfg = pdev->dev.platform_data;
+	struct ar231x_board_config *bcfg = dev_get_platdata(&pdev->dev);
 	struct ieee80211_hw *hw = platform_get_drvdata(pdev);
 	struct ath5k_hw *ah;
 	u32 reg;
-- 
1.7.10.4


