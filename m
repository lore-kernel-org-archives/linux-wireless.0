Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:33201 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbdCGVOe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 16:14:34 -0500
Received: by mail-pg0-f50.google.com with SMTP id 25so4825440pgy.0
        for <linux-wireless@vger.kernel.org>; Tue, 07 Mar 2017 13:14:34 -0800 (PST)
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH] mwifiex: pcie: clean up error prints in mwifiex_pcie_reset_notify()
Date: Tue,  7 Mar 2017 12:47:46 -0800
Message-Id: <20170307204746.6294-1-briannorris@chromium.org> (sfid-20170307_221445_746330_61C12AFA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We shouldn't be printing a kernel pointer as a decimal integer. But we
really shouldn't be printing this case at all; we should never get here
with NULL drvdata. We've eliminated this unnecessary conditional in
several other places, so kill it here too.

Similarly, there's no need to check for '!pdev'; we are guaranteed to
have a real device here.

And finally, use dev_err() instead of pr_err().

This yields (for failed PCIe resets):

[   68.286586] mwifiex_pcie 0000:01:00.0: mwifiex_pcie_reset_notify: adapter structure is not valid

instead of:

[   82.932658] mwifiex_pcie: mwifiex_pcie_reset_notify: Card or adapter structure is not valid (-270880688088)

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index a0d918094889..5438483fcefe 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -350,22 +350,15 @@ MODULE_DEVICE_TABLE(pci, mwifiex_ids);
 
 static void mwifiex_pcie_reset_notify(struct pci_dev *pdev, bool prepare)
 {
-	struct mwifiex_adapter *adapter;
-	struct pcie_service_card *card;
-
-	if (!pdev) {
-		pr_err("%s: PCIe device is not specified\n", __func__);
-		return;
-	}
+	struct pcie_service_card *card = pci_get_drvdata(pdev);
+	struct mwifiex_adapter *adapter = card->adapter;
 
-	card = (struct pcie_service_card *)pci_get_drvdata(pdev);
-	if (!card || !card->adapter) {
-		pr_err("%s: Card or adapter structure is not valid (%ld)\n",
-		       __func__, (long)card);
+	if (!adapter) {
+		dev_err(&pdev->dev, "%s: adapter structure is not valid\n",
+			__func__);
 		return;
 	}
 
-	adapter = card->adapter;
 	mwifiex_dbg(adapter, INFO,
 		    "%s: vendor=0x%4.04x device=0x%4.04x rev=%d %s\n",
 		    __func__, pdev->vendor, pdev->device,
-- 
2.12.0.rc1.440.g5b76565f74-goog
