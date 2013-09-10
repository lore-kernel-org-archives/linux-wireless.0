Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:59249 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab3IJLTm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 07:19:42 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSW00AFOQ4OBH30@mailout4.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 10 Sep 2013 20:19:41 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>,
	'Stanislaw Gruszka' <sgruszka@redhat.com>
References: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
In-reply-to: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
Subject: [PATCH 03/12] wireless: iwlegacy: remove unnecessary pci_set_drvdata()
Date: Tue, 10 Sep 2013 20:19:41 +0900
Message-id: <00b401ceae17$a4ccf760$ee66e620$%han@samsung.com> (sfid-20130910_131946_653773_4EC636EA)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    2 --
 drivers/net/wireless/iwlegacy/4965-mac.c |    2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 9581d07..dea3b50 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -3811,7 +3811,6 @@ out_iounmap:
 out_pci_release_regions:
 	pci_release_regions(pdev);
 out_pci_disable_device:
-	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
 out_ieee80211_free_hw:
 	ieee80211_free_hw(il->hw);
@@ -3888,7 +3887,6 @@ il3945_pci_remove(struct pci_dev *pdev)
 	iounmap(il->hw_base);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
 
 	il_free_channel_map(il);
 	il_free_geos(il);
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 5ab50a5..3982ab7 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -6706,7 +6706,6 @@ out_free_eeprom:
 out_iounmap:
 	iounmap(il->hw_base);
 out_pci_release_regions:
-	pci_set_drvdata(pdev, NULL);
 	pci_release_regions(pdev);
 out_pci_disable_device:
 	pci_disable_device(pdev);
@@ -6787,7 +6786,6 @@ il4965_pci_remove(struct pci_dev *pdev)
 	iounmap(il->hw_base);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
 
 	il4965_uninit_drv(il);
 
-- 
1.7.10.4


