Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:9832 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab3KYBvL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 20:51:11 -0500
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MWS003DXQHA13B0@mailout1.samsung.com> for
 linux-wireless@vger.kernel.org; Mon, 25 Nov 2013 10:51:10 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>
References: <000601cee980$a2d1b0a0$e87511e0$%han@samsung.com>
In-reply-to: <000601cee980$a2d1b0a0$e87511e0$%han@samsung.com>
Subject: [PATCH 2/3] wireless: prism54: remove unnecessary pci_set_drvdata()
Date: Mon, 25 Nov 2013 10:51:09 +0900
Message-id: <000701cee980$d0046e00$700d4a00$%han@samsung.com> (sfid-20131125_025115_752790_19673728)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/prism54/islpci_dev.c     |    1 -
 drivers/net/wireless/prism54/islpci_hotplug.c |    2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/wireless/prism54/islpci_dev.c b/drivers/net/wireless/prism54/islpci_dev.c
index e05d9b4..7fa2898 100644
--- a/drivers/net/wireless/prism54/islpci_dev.c
+++ b/drivers/net/wireless/prism54/islpci_dev.c
@@ -914,7 +914,6 @@ islpci_setup(struct pci_dev *pdev)
       do_islpci_free_memory:
 	islpci_free_memory(priv);
       do_free_netdev:
-	pci_set_drvdata(pdev, NULL);
 	free_netdev(ndev);
 	priv = NULL;
 	return NULL;
diff --git a/drivers/net/wireless/prism54/islpci_hotplug.c b/drivers/net/wireless/prism54/islpci_hotplug.c
index 9e68e0c..d7b9e63 100644
--- a/drivers/net/wireless/prism54/islpci_hotplug.c
+++ b/drivers/net/wireless/prism54/islpci_hotplug.c
@@ -199,7 +199,6 @@ prism54_probe(struct pci_dev *pdev, const struct pci_device_id *id)
       do_unregister_netdev:
 	unregister_netdev(ndev);
 	islpci_free_memory(priv);
-	pci_set_drvdata(pdev, NULL);
 	free_netdev(ndev);
 	priv = NULL;
       do_pci_clear_mwi:
@@ -247,7 +246,6 @@ prism54_remove(struct pci_dev *pdev)
 	/* free the PCI memory and unmap the remapped page */
 	islpci_free_memory(priv);
 
-	pci_set_drvdata(pdev, NULL);
 	free_netdev(ndev);
 	priv = NULL;
 
-- 
1.7.10.4


