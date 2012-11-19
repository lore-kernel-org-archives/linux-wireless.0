Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41484 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab2KSSev (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 13:34:51 -0500
From: Bill Pemberton <wfp5p@virginia.edu>
To: gregkh@linuxfoundation.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=20391/493=5D=20bcma=3A=20remove=20use=20of=20=5F=5Fdevexit?=
Date: Mon, 19 Nov 2012 13:25:40 -0500
Message-Id: <1353349642-3677-391-git-send-email-wfp5p@virginia.edu> (sfid-20121119_193505_622176_1C7F737F)
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devexit is no
longer needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: "Rafał Miłecki" <zajec5@gmail.com> 
Cc: linux-wireless@vger.kernel.org 
---
 drivers/bcma/host_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index efb8cec..b5c42bc9 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -226,7 +226,7 @@ err_kfree_bus:
 	return err;
 }
 
-static void __devexit bcma_host_pci_remove(struct pci_dev *dev)
+static void bcma_host_pci_remove(struct pci_dev *dev)
 {
 	struct bcma_bus *bus = pci_get_drvdata(dev);
 
-- 
1.8.0

