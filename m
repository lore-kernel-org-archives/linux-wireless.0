Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:26941 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759854AbXJ2SWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 14:22:08 -0400
Date: Mon, 29 Oct 2007 11:20:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, akpm <akpm@linux-foundation.org>
Subject: [PATCH] hostap: fix section mismatch warning
Message-Id: <20071029112026.f66473c5.randy.dunlap@oracle.com> (sfid-20071029_182238_606437_9158BFD7)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch warning:

WARNING: vmlinux.o(.data+0x36fcc): Section mismatch: reference to .init.data:prism2_pci_id_table (between 'prism2_pci_drv_id' and 'prism2_pci_funcs')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/wireless/hostap/hostap_pci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2624-rc1g4-v1.orig/drivers/net/wireless/hostap/hostap_pci.c
+++ linux-2624-rc1g4-v1/drivers/net/wireless/hostap/hostap_pci.c
@@ -444,7 +444,7 @@ static int prism2_pci_resume(struct pci_
 
 MODULE_DEVICE_TABLE(pci, prism2_pci_id_table);
 
-static struct pci_driver prism2_pci_drv_id = {
+static struct pci_driver prism2_pci_driver = {
 	.name		= "hostap_pci",
 	.id_table	= prism2_pci_id_table,
 	.probe		= prism2_pci_probe,
@@ -458,13 +458,13 @@ static struct pci_driver prism2_pci_drv_
 
 static int __init init_prism2_pci(void)
 {
-	return pci_register_driver(&prism2_pci_drv_id);
+	return pci_register_driver(&prism2_pci_driver);
 }
 
 
 static void __exit exit_prism2_pci(void)
 {
-	pci_unregister_driver(&prism2_pci_drv_id);
+	pci_unregister_driver(&prism2_pci_driver);
 }
 
 
