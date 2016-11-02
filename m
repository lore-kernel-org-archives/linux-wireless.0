Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35940 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755059AbcKBCZq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Nov 2016 22:25:46 -0400
Received: by mail-pf0-f195.google.com with SMTP id n85so262184pfi.3
        for <linux-wireless@vger.kernel.org>; Tue, 01 Nov 2016 19:25:46 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2 05/12] mwifiex: remove redundant pdev check in suspend/resume handlers
Date: Wed,  2 Nov 2016 10:24:41 +0800
Message-Id: <1478053488-16042-3-git-send-email-huxinming820@marvell.com> (sfid-20161102_032549_396278_127B15B1)
In-Reply-To: <1478053488-16042-1-git-send-email-huxinming820@marvell.com>
References: <1478053488-16042-1-git-send-email-huxinming820@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

to_pci_dev() would just do struct offset arithmetic on struct
device to get 'pdev' pointer. We never get NULL pdev pointer.

---
v2: Same as v1
---
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 5507c89..fb34b99 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -101,14 +101,9 @@ static int mwifiex_pcie_suspend(struct device *dev)
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
 
@@ -145,14 +140,9 @@ static int mwifiex_pcie_resume(struct device *dev)
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
1.8.1.4
