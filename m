Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28906 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750774AbdFOFuk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 01:50:40 -0400
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2 1/3] wil6210: prevent platform callbacks after uninit
Date: Thu, 15 Jun 2017 08:50:32 +0300
Message-Id: <1497505834-9704-2-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170615_075047_911646_0DA2CC49)
In-Reply-To: <1497505834-9704-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1497505834-9704-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <qca_dlansky@qca.qualcomm.com>

After calling platform_ops.uninit() it is still possible to invoke
platform callbacks.
To prevent this, zero platform_ops right after invoking uninit.

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index bf9f265..a874d8d 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -191,6 +191,13 @@ static int wil_platform_rop_fw_recovery(void *wil_handle)
 	return 0;
 }
 
+static void wil_platform_ops_uninit(struct wil6210_priv *wil)
+{
+	if (wil->platform_ops.uninit)
+		wil->platform_ops.uninit(wil->platform_handle);
+	memset(&wil->platform_ops, 0, sizeof(wil->platform_ops));
+}
+
 static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct wil6210_priv *wil;
@@ -327,8 +334,7 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_disable_pdev:
 	pci_disable_device(pdev);
 err_plat:
-	if (wil->platform_ops.uninit)
-		wil->platform_ops.uninit(wil->platform_handle);
+	wil_platform_ops_uninit(wil);
 if_free:
 	wil_if_free(wil);
 
@@ -357,8 +363,7 @@ static void wil_pcie_remove(struct pci_dev *pdev)
 	pci_iounmap(pdev, csr);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
-	if (wil->platform_ops.uninit)
-		wil->platform_ops.uninit(wil->platform_handle);
+	wil_platform_ops_uninit(wil);
 	wil_if_free(wil);
 }
 
-- 
1.9.1
