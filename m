Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34161 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751065AbdG3ICe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Jul 2017 04:02:34 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Malcolm Priestley <tvboxspy@gmail.com>, stable@vger.kernel.org
Subject: [PATCH][BUG] rtlwifi: rtl_pci_probe: Fix fail path of _rtl_pci_find_adapter
Date: Sun, 30 Jul 2017 09:02:19 +0100
Message-Id: <20170730080219.5925-1-tvboxspy@gmail.com> (sfid-20170730_100252_890989_C0BED9CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

_rtl_pci_find_adapter fail path will jump to label fail3 for
unsupported adapter types.

However, on course for fail3 there will be call rtl_deinit_core
before rtl_init_core.

For the inclusion of checking pci_iounmap this fail can be moved to
fail2.

Fixes
[    4.492963] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    4.493067] IP: rtl_deinit_core+0x31/0x90 [rtlwifi]

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org>
---
Although this is the first time I have encounted this bug in 4.13-rc1
there are some historical references so I have included stable.

 drivers/net/wireless/realtek/rtlwifi/pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 032b6317690d..08dc8919ef60 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2257,7 +2257,7 @@ int rtl_pci_probe(struct pci_dev *pdev,
 	/* find adapter */
 	if (!_rtl_pci_find_adapter(pdev, hw)) {
 		err = -ENODEV;
-		goto fail3;
+		goto fail2;
 	}
 
 	/* Init IO handler */
@@ -2318,10 +2318,10 @@ int rtl_pci_probe(struct pci_dev *pdev,
 	pci_set_drvdata(pdev, NULL);
 	rtl_deinit_core(hw);
 
+fail2:
 	if (rtlpriv->io.pci_mem_start != 0)
 		pci_iounmap(pdev, (void __iomem *)rtlpriv->io.pci_mem_start);
 
-fail2:
 	pci_release_regions(pdev);
 	complete(&rtlpriv->firmware_loading_complete);
 
-- 
2.11.0
