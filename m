Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37905 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752975AbcKROBs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 09:01:48 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v4 04/11] mwifiex: remove redundant pdev check in suspend/resume handlers
Date: Fri, 18 Nov 2016 19:30:27 +0530
Message-ID: <1479477634-27841-4-git-send-email-akarwar@marvell.com> (sfid-20161118_150203_737440_ED548B66)
In-Reply-To: <1479477634-27841-1-git-send-email-akarwar@marvell.com>
References: <1479477634-27841-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

to_pci_dev() would just do struct offset arithmetic on struct
device to get 'pdev' pointer. We never get NULL pdev pointer.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Tested-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
v4: Same v1, v2, v3
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 547806f..86ae084 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -117,14 +117,9 @@ static int mwifiex_pcie_suspend(struct device *dev)
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
 
@@ -162,14 +157,9 @@ static int mwifiex_pcie_resume(struct device *dev)
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
+		dev_err(dev, "Card or adapter structure is not valid\n");
 		return 0;
 	}
 
-- 
1.9.1
