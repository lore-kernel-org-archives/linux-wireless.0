Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:63709 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaA2Ocb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 09:32:31 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 02/14] brcmfmac: add owner info to sdio_driver structure
Date: Wed, 29 Jan 2014 15:32:12 +0100
Message-ID: <1391005944-3220-3-git-send-email-arend@broadcom.com> (sfid-20140129_153235_229858_6B0E442B)
In-Reply-To: <1391005944-3220-1-git-send-email-arend@broadcom.com>
References: <1391005944-3220-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

To link module attribute with sdio device driver attribute in sysfs.

Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index fa35b23..9eb6f78 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -1115,11 +1115,12 @@ static struct sdio_driver brcmf_sdmmc_driver = {
 	.remove = brcmf_ops_sdio_remove,
 	.name = BRCMFMAC_SDIO_PDATA_NAME,
 	.id_table = brcmf_sdmmc_ids,
-#ifdef CONFIG_PM_SLEEP
 	.drv = {
+		.owner = THIS_MODULE,
+#ifdef CONFIG_PM_SLEEP
 		.pm = &brcmf_sdio_pm_ops,
-	},
 #endif	/* CONFIG_PM_SLEEP */
+	},
 };
 
 static int brcmf_sdio_pd_probe(struct platform_device *pdev)
-- 
1.7.10.4

