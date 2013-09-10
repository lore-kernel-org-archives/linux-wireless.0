Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:31122 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3IJIxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 04:53:05 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSW005NLJCCP850@mailout2.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 10 Sep 2013 17:53:02 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>,
	"'Luis R. Rodriguez'" <mcgrof@qca.qualcomm.com>,
	'Jouni Malinen' <jouni@qca.qualcomm.com>,
	'Vasanthakumar Thiagarajan' <vthiagar@qca.qualcomm.com>,
	'Senthil Balasubramanian' <senthilb@qca.qualcomm.com>
References: <005101ceae02$9cbb95f0$d632c1d0$%han@samsung.com>
In-reply-to: <005101ceae02$9cbb95f0$d632c1d0$%han@samsung.com>
Subject: [PATCH 2/8] wireless: ath9k: use dev_get_platdata()
Date: Tue, 10 Sep 2013 17:53:02 +0900
Message-id: <005401ceae03$281c6ed0$78554c70$%han@samsung.com> (sfid-20130910_105313_086192_7BF64029)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/ath/ath9k/ahb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 072e4b5..2dff276 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -54,7 +54,7 @@ static bool ath_ahb_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 	struct platform_device *pdev = to_platform_device(sc->dev);
 	struct ath9k_platform_data *pdata;
 
-	pdata = (struct ath9k_platform_data *) pdev->dev.platform_data;
+	pdata = dev_get_platdata(&pdev->dev);
 	if (off >= (ARRAY_SIZE(pdata->eeprom_data))) {
 		ath_err(common,
 			"%s: flash read failed, offset %08x is out of range\n",
@@ -84,7 +84,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	struct ath_hw *ah;
 	char hw_name[64];
 
-	if (!pdev->dev.platform_data) {
+	if (!dev_get_platdata(&pdev->dev)) {
 		dev_err(&pdev->dev, "no platform data specified\n");
 		return -EINVAL;
 	}
-- 
1.7.10.4


