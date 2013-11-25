Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:10157 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab3KYBwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 20:52:41 -0500
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MWS0032TQJM15B0@mailout1.samsung.com> for
 linux-wireless@vger.kernel.org; Mon, 25 Nov 2013 10:52:34 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>,
	'Ivo van Doorn' <IvDoorn@gmail.com>,
	'Gertjan van Wingerde' <gwingerde@gmail.com>,
	'Helmut Schaa' <helmut.schaa@googlemail.com>
References: <000601cee980$a2d1b0a0$e87511e0$%han@samsung.com>
In-reply-to: <000601cee980$a2d1b0a0$e87511e0$%han@samsung.com>
Subject: [PATCH 3/3] wireless: rt2x00: remove unnecessary pci_set_drvdata()
Date: Mon, 25 Nov 2013 10:52:33 +0900
Message-id: <000801cee981$02414cd0$06c3e670$%han@samsung.com> (sfid-20131125_025244_679450_E0AEBEEF)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/rt2x00/rt2x00pci.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 25da20e..af72183 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -156,8 +156,6 @@ exit_release_regions:
 exit_disable_device:
 	pci_disable_device(pci_dev);
 
-	pci_set_drvdata(pci_dev, NULL);
-
 	return retval;
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_probe);
@@ -177,7 +175,6 @@ void rt2x00pci_remove(struct pci_dev *pci_dev)
 	/*
 	 * Free the PCI device data.
 	 */
-	pci_set_drvdata(pci_dev, NULL);
 	pci_disable_device(pci_dev);
 	pci_release_regions(pci_dev);
 }
-- 
1.7.10.4


