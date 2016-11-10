Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:32853 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755507AbcKJL5s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Nov 2016 06:57:48 -0500
Received: by mail-pf0-f196.google.com with SMTP id 144so3985854pfv.0
        for <linux-wireless@vger.kernel.org>; Thu, 10 Nov 2016 03:57:48 -0800 (PST)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH RESEND v2 04/11] mwifiex: remove redundant pdev check in suspend/resume handlers
Date: Thu, 10 Nov 2016 19:57:05 +0800
Message-Id: <1478779032-5165-4-git-send-email-huxinming820@marvell.com> (sfid-20161110_125752_339051_60DA797D)
In-Reply-To: <1478779032-5165-1-git-send-email-huxinming820@marvell.com>
References: <1478779032-5165-1-git-send-email-huxinming820@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

to_pci_dev() would just do struct offset arithmetic on struct
device to get 'pdev' pointer. We never get NULL pdev pointer.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
v2: Same as v1
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index c4bd64b..6152f08 100644
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
1.8.1.4
