Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41576 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab2KSSh7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 13:37:59 -0500
From: Bill Pemberton <wfp5p@virginia.edu>
To: gregkh@linuxfoundation.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=20040/493=5D=20bcma=3A=20remove=20use=20of=20=5F=5Fdevexit=5Fp?=
Date: Mon, 19 Nov 2012 13:19:49 -0500
Message-Id: <1353349642-3677-40-git-send-email-wfp5p@virginia.edu> (sfid-20121119_194006_236292_32605C92)
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devexit_p is no longer
needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: "Rafał Miłecki" <zajec5@gmail.com> 
Cc: linux-wireless@vger.kernel.org 
---
 drivers/bcma/host_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 98fdc3e..fdd8dde 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -284,7 +284,7 @@ static struct pci_driver bcma_pci_bridge_driver = {
 	.name = "bcma-pci-bridge",
 	.id_table = bcma_pci_bridge_tbl,
 	.probe = bcma_host_pci_probe,
-	.remove = __devexit_p(bcma_host_pci_remove),
+	.remove = bcma_host_pci_remove,
 	.driver.pm = BCMA_PM_OPS,
 };
 
-- 
1.8.0

