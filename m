Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:62851 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758822AbYAJWc6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 17:32:58 -0500
Date: Thu, 10 Jan 2008 14:31:30 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: j@w1.fi, linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: samr <sam@ravnborg.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] hostap: section mismatch warning
Message-Id: <20080110143130.7efb2460.randy.dunlap@oracle.com> (sfid-20080110_223308_594440_5807BDFC)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch by changing variable name to match one of the
whitelisted (allowable) names for pointing into init data:

WARNING: vmlinux.o(.data+0xce618): Section mismatch: reference to .init.data:prism2_plx_id_table (between 'prism2_plx_drv_id' and 'dev_info')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/wireless/hostap/hostap_plx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.24-rc7-git1.orig/drivers/net/wireless/hostap/hostap_plx.c
+++ linux-2.6.24-rc7-git1/drivers/net/wireless/hostap/hostap_plx.c
@@ -608,7 +608,7 @@ static void prism2_plx_remove(struct pci
 
 MODULE_DEVICE_TABLE(pci, prism2_plx_id_table);
 
-static struct pci_driver prism2_plx_drv_id = {
+static struct pci_driver prism2_plx_driver = {
 	.name		= "hostap_plx",
 	.id_table	= prism2_plx_id_table,
 	.probe		= prism2_plx_probe,
@@ -618,13 +618,13 @@ static struct pci_driver prism2_plx_drv_
 
 static int __init init_prism2_plx(void)
 {
-	return pci_register_driver(&prism2_plx_drv_id);
+	return pci_register_driver(&prism2_plx_driver);
 }
 
 
 static void __exit exit_prism2_plx(void)
 {
-	pci_unregister_driver(&prism2_plx_drv_id);
+	pci_unregister_driver(&prism2_plx_driver);
 }
 
 
