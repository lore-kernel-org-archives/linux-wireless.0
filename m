Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50846 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753182AbcI1MtV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 08:49:21 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8SCjCwX019740
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2016 05:49:20 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 25r7vna8qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2016 05:49:20 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/8] mwifiex: report error to PCIe for suspend failure
Date: Wed, 28 Sep 2016 18:18:22 +0530
Message-ID: <1475066908-11771-2-git-send-email-akarwar@marvell.com> (sfid-20160928_144924_240346_A8C9F172)
In-Reply-To: <1475066908-11771-1-git-send-email-akarwar@marvell.com>
References: <1475066908-11771-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When host_sleep_config command fails, we should return an error to
PCIe, instead of continuing (and possibly panicking, when we try to keep
processing a timed-out ioctl after we return "successfully" from
suspend).

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 2833d47..063c707 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -101,7 +101,6 @@ static int mwifiex_pcie_suspend(struct device *dev)
 {
 	struct mwifiex_adapter *adapter;
 	struct pcie_service_card *card;
-	int hs_actived;
 	struct pci_dev *pdev = to_pci_dev(dev);
 
 	if (pdev) {
@@ -117,7 +116,14 @@ static int mwifiex_pcie_suspend(struct device *dev)
 
 	adapter = card->adapter;
 
-	hs_actived = mwifiex_enable_hs(adapter);
+	/* Enable the Host Sleep */
+	if (!mwifiex_enable_hs(adapter)) {
+		mwifiex_dbg(adapter, ERROR,
+			    "cmd: failed to suspend\n");
+		adapter->hs_enabling = false;
+		return -EFAULT;
+	}
+
 	flush_workqueue(adapter->workqueue);
 
 	/* Indicate device suspended */
-- 
1.9.1
