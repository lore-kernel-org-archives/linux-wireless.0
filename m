Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40732 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751201AbcJFRbZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Oct 2016 13:31:25 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v3 3/3] mwifiex: check hw_status in suspend and resume handlers
Date: Thu, 6 Oct 2016 23:00:28 +0530
Message-ID: <1475775028-20306-3-git-send-email-akarwar@marvell.com> (sfid-20161006_193128_121047_EED5E6DF)
In-Reply-To: <1475775028-20306-1-git-send-email-akarwar@marvell.com>
References: <1475775028-20306-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have observed a kernel crash when system immediately suspends
after booting. There is a race between suspend and driver initialization
paths. This patch adds hw_status checks in suspend/resume to fix this issue
and other corner cases.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v2: Return failure in suspend/resume handler in this scenario.
v3: Handle "hw_status" not READY cases carefully. Return 0 if
init or shutdown is in progress. Return -EBUSY if firmware download
failed or command timeout ocurred(non-recoverable). (Brian Norris)
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 1e27dbf..cc18e4d 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -121,13 +121,22 @@ static int mwifiex_pcie_suspend(struct device *dev)
 	struct pci_dev *pdev = to_pci_dev(dev);
 
 	card = pci_get_drvdata(pdev);
-	if (!card || !card->adapter) {
-		pr_err("Card or adapter structure is not valid\n");
+	if (!card || !card->adapter ||
+	    card->adapter->hw_status == MWIFIEX_HW_STATUS_RESET ||
+	    card->adapter->hw_status == MWIFIEX_HW_STATUS_NOT_READY) {
+		pr_err("Card or adapter structure is not valid or hw_status not ready\n");
 		return 0;
 	}
 
 	adapter = card->adapter;
 
+	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING ||
+	    adapter->hw_status == MWIFIEX_HW_STATUS_INIT_DONE ||
+	    adapter->hw_status == MWIFIEX_HW_STATUS_CLOSING) {
+		pr_err("We are in the middle of initialzaion or closing\n");
+		return -EBUSY;
+	}
+
 	/* Enable the Host Sleep */
 	if (!mwifiex_enable_hs(adapter)) {
 		mwifiex_dbg(adapter, ERROR,
@@ -160,13 +169,23 @@ static int mwifiex_pcie_resume(struct device *dev)
 	struct pci_dev *pdev = to_pci_dev(dev);
 
 	card = pci_get_drvdata(pdev);
-	if (!card || !card->adapter) {
-		pr_err("Card or adapter structure is not valid\n");
+
+	if (!card || !card->adapter ||
+	    card->adapter->hw_status == MWIFIEX_HW_STATUS_RESET ||
+	    card->adapter->hw_status == MWIFIEX_HW_STATUS_NOT_READY) {
+		pr_err("Card or adapter structure is not valid or hw_status not ready\n");
 		return 0;
 	}
 
 	adapter = card->adapter;
 
+	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING ||
+	    adapter->hw_status == MWIFIEX_HW_STATUS_INIT_DONE ||
+	    adapter->hw_status == MWIFIEX_HW_STATUS_CLOSING) {
+		pr_err("We are in the middle of initialzaion or closing\n");
+		return -EBUSY;
+	}
+
 	if (!adapter->is_suspended) {
 		mwifiex_dbg(adapter, WARN,
 			    "Device already resumed\n");
-- 
1.9.1
