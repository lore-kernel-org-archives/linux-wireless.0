Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:47828 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758341Ab3CEA2M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 19:28:12 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Paul Fox <pgf@laptop.org>, Daniel Drake <dsd@laptop.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/7] mwifiex: remove static forward declarations in pcie.c
Date: Mon,  4 Mar 2013 16:27:53 -0800
Message-Id: <1362443279-6064-2-git-send-email-bzhao@marvell.com> (sfid-20130305_012816_648489_6BD9B1E6)
In-Reply-To: <1362443279-6064-1-git-send-email-bzhao@marvell.com>
References: <1362443279-6064-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move functions up just to avoid static forward declaration for
mwifiex_pcie_resume.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |  150 +++++++++++++++++------------------
 1 files changed, 74 insertions(+), 76 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 5c395e2..c3270e8 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -36,8 +36,6 @@ static u8 user_rmmod;
 static struct mwifiex_if_ops pcie_ops;
 
 static struct semaphore add_remove_card_sem;
-static int mwifiex_pcie_enable_host_int(struct mwifiex_adapter *adapter);
-static int mwifiex_pcie_resume(struct pci_dev *pdev);
 
 static int
 mwifiex_map_pci_memory(struct mwifiex_adapter *adapter, struct sk_buff *skb,
@@ -79,6 +77,80 @@ static bool mwifiex_pcie_ok_to_access_hw(struct mwifiex_adapter *adapter)
 }
 
 /*
+ * Kernel needs to suspend all functions separately. Therefore all
+ * registered functions must have drivers with suspend and resume
+ * methods. Failing that the kernel simply removes the whole card.
+ *
+ * If already not suspended, this function allocates and sends a host
+ * sleep activate request to the firmware and turns off the traffic.
+ */
+static int mwifiex_pcie_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct mwifiex_adapter *adapter;
+	struct pcie_service_card *card;
+	int hs_actived;
+
+	if (pdev) {
+		card = (struct pcie_service_card *) pci_get_drvdata(pdev);
+		if (!card || !card->adapter) {
+			pr_err("Card or adapter structure is not valid\n");
+			return 0;
+		}
+	} else {
+		pr_err("PCIE device is not specified\n");
+		return 0;
+	}
+
+	adapter = card->adapter;
+
+	hs_actived = mwifiex_enable_hs(adapter);
+
+	/* Indicate device suspended */
+	adapter->is_suspended = true;
+
+	return 0;
+}
+
+/*
+ * Kernel needs to suspend all functions separately. Therefore all
+ * registered functions must have drivers with suspend and resume
+ * methods. Failing that the kernel simply removes the whole card.
+ *
+ * If already not resumed, this function turns on the traffic and
+ * sends a host sleep cancel request to the firmware.
+ */
+static int mwifiex_pcie_resume(struct pci_dev *pdev)
+{
+	struct mwifiex_adapter *adapter;
+	struct pcie_service_card *card;
+
+	if (pdev) {
+		card = (struct pcie_service_card *) pci_get_drvdata(pdev);
+		if (!card || !card->adapter) {
+			pr_err("Card or adapter structure is not valid\n");
+			return 0;
+		}
+	} else {
+		pr_err("PCIE device is not specified\n");
+		return 0;
+	}
+
+	adapter = card->adapter;
+
+	if (!adapter->is_suspended) {
+		dev_warn(adapter->dev, "Device already resumed\n");
+		return 0;
+	}
+
+	adapter->is_suspended = false;
+
+	mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
+			  MWIFIEX_ASYNC_CMD);
+
+	return 0;
+}
+
+/*
  * This function probes an mwifiex device and registers it. It allocates
  * the card structure, enables PCIE function number and initiates the
  * device registration and initialization procedure by adding a logical
@@ -159,80 +231,6 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	kfree(card);
 }
 
-/*
- * Kernel needs to suspend all functions separately. Therefore all
- * registered functions must have drivers with suspend and resume
- * methods. Failing that the kernel simply removes the whole card.
- *
- * If already not suspended, this function allocates and sends a host
- * sleep activate request to the firmware and turns off the traffic.
- */
-static int mwifiex_pcie_suspend(struct pci_dev *pdev, pm_message_t state)
-{
-	struct mwifiex_adapter *adapter;
-	struct pcie_service_card *card;
-	int hs_actived;
-
-	if (pdev) {
-		card = (struct pcie_service_card *) pci_get_drvdata(pdev);
-		if (!card || !card->adapter) {
-			pr_err("Card or adapter structure is not valid\n");
-			return 0;
-		}
-	} else {
-		pr_err("PCIE device is not specified\n");
-		return 0;
-	}
-
-	adapter = card->adapter;
-
-	hs_actived = mwifiex_enable_hs(adapter);
-
-	/* Indicate device suspended */
-	adapter->is_suspended = true;
-
-	return 0;
-}
-
-/*
- * Kernel needs to suspend all functions separately. Therefore all
- * registered functions must have drivers with suspend and resume
- * methods. Failing that the kernel simply removes the whole card.
- *
- * If already not resumed, this function turns on the traffic and
- * sends a host sleep cancel request to the firmware.
- */
-static int mwifiex_pcie_resume(struct pci_dev *pdev)
-{
-	struct mwifiex_adapter *adapter;
-	struct pcie_service_card *card;
-
-	if (pdev) {
-		card = (struct pcie_service_card *) pci_get_drvdata(pdev);
-		if (!card || !card->adapter) {
-			pr_err("Card or adapter structure is not valid\n");
-			return 0;
-		}
-	} else {
-		pr_err("PCIE device is not specified\n");
-		return 0;
-	}
-
-	adapter = card->adapter;
-
-	if (!adapter->is_suspended) {
-		dev_warn(adapter->dev, "Device already resumed\n");
-		return 0;
-	}
-
-	adapter->is_suspended = false;
-
-	mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
-			  MWIFIEX_ASYNC_CMD);
-
-	return 0;
-}
-
 static DEFINE_PCI_DEVICE_TABLE(mwifiex_ids) = {
 	{
 		PCIE_VENDOR_ID_MARVELL, PCIE_DEVICE_ID_MARVELL_88W8766P,
-- 
1.7.0.2

