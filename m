Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43904 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S970459AbdIZUX6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Sep 2017 16:23:58 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  Retry pci probe on failure.
Date: Tue, 26 Sep 2017 13:23:55 -0700
Message-Id: <1506457435-26945-1-git-send-email-greearb@candelatech.com> (sfid-20170926_222519_797069_656A26A3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This works around a problem we see when sometimes the wifi NIC does
not respond the first time.  This seems to happen especially often on
some of the 9984 NICs in mid-range platforms.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index e0a7b338..8f3c5b1 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3492,8 +3492,8 @@ static const struct ath10k_bus_ops ath10k_pci_bus_ops = {
 	.get_num_banks	= ath10k_pci_get_num_banks,
 };
 
-static int ath10k_pci_probe(struct pci_dev *pdev,
-			    const struct pci_device_id *pci_dev)
+static int __ath10k_pci_probe(struct pci_dev *pdev,
+			      const struct pci_device_id *pci_dev)
 {
 	int ret = 0;
 	struct ath10k *ar;
@@ -3668,6 +3668,22 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	return ret;
 }
 
+static int ath10k_pci_probe(struct pci_dev *pdev,
+			    const struct pci_device_id *pci_dev)
+{
+	int cnt = 0;
+	int rv;
+	do {
+		rv = __ath10k_pci_probe(pdev, pci_dev);
+		if (rv == 0)
+			return rv;
+		pr_err("ath10k: failed to probe PCI : %d, retry-count: %d\n", rv, cnt);
+		udelay(10000); /* let the ath10k firmware gerbil take a small break */
+	} while (cnt++ < 10);
+	return rv;
+}
+
+
 static void ath10k_pci_remove(struct pci_dev *pdev)
 {
 	struct ath10k *ar = pci_get_drvdata(pdev);
-- 
2.4.11
