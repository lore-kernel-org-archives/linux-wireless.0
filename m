Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53906 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935962AbcJTN0r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Oct 2016 09:26:47 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <briannorris@google.com>, <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v5 2/4] mwifiex: remove redundant pdev check in suspend/resume handlers
Date: Thu, 20 Oct 2016 18:56:17 +0530
Message-ID: <1476969979-28554-2-git-send-email-akarwar@marvell.com> (sfid-20161020_152650_495526_3B0F95A5)
In-Reply-To: <1476969979-28554-1-git-send-email-akarwar@marvell.com>
References: <1476969979-28554-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

to_pci_dev() would just do struct offset arithmetic on struct
device to get 'pdev' pointer. We never get NULL pdev pointer

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
New patch introduced in v3 as per inputs from Brian Norris.
v5: Same as v3, v4
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 302ffd1..dd4006e 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -103,14 +103,9 @@ static int mwifiex_pcie_suspend(struct device *dev)
 	struct pcie_service_card *card;
 	struct pci_dev *pdev = to_pci_dev(dev);
 
-	if (pdev) {
-		card = pci_get_drvdata(pdev);
-		if (!card || !card->adapter) {
-			pr_err("Card or adapter structure is not valid\n");
-			return 0;
-		}
-	} else {
-		pr_err("PCIE device is not specified\n");
+	card = pci_get_drvdata(pdev);
+	if (!card || !card->adapter) {
+		pr_err("Card or adapter structure is not valid\n");
 		return 0;
 	}
 
@@ -147,14 +142,9 @@ static int mwifiex_pcie_resume(struct device *dev)
 	struct pcie_service_card *card;
 	struct pci_dev *pdev = to_pci_dev(dev);
 
-	if (pdev) {
-		card = pci_get_drvdata(pdev);
-		if (!card || !card->adapter) {
-			pr_err("Card or adapter structure is not valid\n");
-			return 0;
-		}
-	} else {
-		pr_err("PCIE device is not specified\n");
+	card = pci_get_drvdata(pdev);
+	if (!card || !card->adapter) {
+		pr_err("Card or adapter structure is not valid\n");
 		return 0;
 	}
 
-- 
1.9.1
