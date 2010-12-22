Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40878 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab0LVUhU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 15:37:20 -0500
Subject: [PATCH] compat: simplify pci_try_set_mwi
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 21:37:20 +0100
Message-ID: <1293050240.3531.25.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 compat/compat-2.6.23.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/compat/compat-2.6.23.c b/compat/compat-2.6.23.c
index 87f2a8c..67d0075 100644
--- a/compat/compat-2.6.23.c
+++ b/compat/compat-2.6.23.c
@@ -217,14 +217,6 @@ void __dev_set_rx_mode(struct net_device *dev)
 		dev->set_multicast_list(dev);
 }
 
-#ifndef HAVE_PCI_SET_MWI
-int pci_try_set_mwi(struct pci_dev *dev)
-{
-	return 0;
-}
-EXPORT_SYMBOL(pci_try_set_mwi);
-#else
-
 /**
  * pci_try_set_mwi - enables memory-write-invalidate PCI transaction
  * @dev: the PCI device for which MWI is enabled
@@ -236,7 +228,10 @@ EXPORT_SYMBOL(pci_try_set_mwi);
  */
 int pci_try_set_mwi(struct pci_dev *dev)
 {
-	int rc = pci_set_mwi(dev);
+	int rc = 0;
+#ifdef HAVE_PCI_SET_MWI
+	rc = pci_set_mwi(dev);
+#endif
 	return rc;
 }
 EXPORT_SYMBOL(pci_try_set_mwi);
-- 
1.7.2.3



