Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53530 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752901AbcJDKfE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 06:35:04 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/2] mwifiex: check hw_status in suspend and resume handlers
Date: Tue, 4 Oct 2016 16:04:13 +0530
Message-ID: <1475577253-1126-2-git-send-email-akarwar@marvell.com> (sfid-20161004_123506_822448_30814106)
In-Reply-To: <1475577253-1126-1-git-send-email-akarwar@marvell.com>
References: <1475577253-1126-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

We have observed a kernel crash when system immediately suspends
after booting. There is a race between suspend and driver
initialization paths.
This patch adds hw_status checks to fix the problem

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index ba9e068..376e01c 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -122,7 +122,8 @@ static int mwifiex_pcie_suspend(struct device *dev)
 
 	if (pdev) {
 		card = pci_get_drvdata(pdev);
-		if (!card || !card->adapter) {
+		if (!card || !card->adapter ||
+		    card->adapter->hw_status != MWIFIEX_HW_STATUS_READY) {
 			pr_err("Card or adapter structure is not valid\n");
 			return 0;
 		}
@@ -166,7 +167,8 @@ static int mwifiex_pcie_resume(struct device *dev)
 
 	if (pdev) {
 		card = pci_get_drvdata(pdev);
-		if (!card || !card->adapter) {
+		if (!card || !card->adapter ||
+		    card->adapter->hw_status != MWIFIEX_HW_STATUS_READY) {
 			pr_err("Card or adapter structure is not valid\n");
 			return 0;
 		}
-- 
1.9.1
