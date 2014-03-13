Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258AbaCMWVL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2014 18:21:11 -0400
Date: Thu, 13 Mar 2014 23:21:08 +0100
From: Jean Delvare <jdelvare@suse.de>
To: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Cc: Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] brcmfmac: Make probe function __init
Message-ID: <20140313232108.7e760e11@endymion.delvare> (sfid-20140313_232116_141409_2E3092FA)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One of the benefits of platform_driver_probe() is that you can make
the probe function __init.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Hante Meuleman <meuleman@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>
Cc: John W. Linville <linville@tuxdriver.com>
---
Build tested only, no hardware.

 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.14-rc6.orig/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c	2014-02-09 16:53:04.065657732 +0100
+++ linux-3.14-rc6/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c	2014-03-13 19:46:25.083526576 +0100
@@ -1122,7 +1122,7 @@ static struct sdio_driver brcmf_sdmmc_dr
 #endif	/* CONFIG_PM_SLEEP */
 };
 
-static int brcmf_sdio_pd_probe(struct platform_device *pdev)
+static int __init brcmf_sdio_pd_probe(struct platform_device *pdev)
 {
 	brcmf_dbg(SDIO, "Enter\n");
 


-- 
Jean Delvare
SUSE L3 Support
