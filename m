Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:36411 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab3IJIyx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 04:54:53 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSW00KX5JF3ZO01@mailout4.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 10 Sep 2013 17:54:47 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>,
	'Brett Rudley' <brudley@broadcom.com>,
	'Arend van Spriel' <arend@broadcom.com>,
	"'Franky (Zhenhui) Lin'" <frankyl@broadcom.com>,
	'Hante Meuleman' <meuleman@broadcom.com>
References: <005101ceae02$9cbb95f0$d632c1d0$%han@samsung.com>
In-reply-to: <005101ceae02$9cbb95f0$d632c1d0$%han@samsung.com>
Subject: [PATCH 3/8] wireless: brcmfmac: use dev_get_platdata()
Date: Tue, 10 Sep 2013 17:54:47 +0900
Message-id: <005501ceae03$66c0cf50$34426df0$%han@samsung.com> (sfid-20130910_105457_441670_464487F0)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 64f4a2b..592ae13 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -468,7 +468,7 @@ static int brcmf_sdio_pd_probe(struct platform_device *pdev)
 
 	brcmf_dbg(SDIO, "Enter\n");
 
-	brcmfmac_sdio_pdata = pdev->dev.platform_data;
+	brcmfmac_sdio_pdata = dev_get_platdata(&pdev->dev);
 
 	if (brcmfmac_sdio_pdata->power_on)
 		brcmfmac_sdio_pdata->power_on();
-- 
1.7.10.4


