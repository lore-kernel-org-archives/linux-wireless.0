Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12375 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751773AbcGOMt1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2016 08:49:27 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u6FClLLC029309
	for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2016 05:49:26 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0b-0016f401.pphosted.com with ESMTP id 246gatku5r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2016 05:49:26 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Karthik D A <karthida@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: Fix request_irq() failure handling
Date: Fri, 15 Jul 2016 18:18:39 +0530
Message-ID: <1468586919-7534-1-git-send-email-akarwar@marvell.com> (sfid-20160715_144931_215288_E3DA4E57)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karthik D A <karthida@marvell.com>

It's been observed that request_irq() failure leads to a system crash
due to a bug in mwifiex driver.
When this failure happens, mwifiex_add_card() already takes care of
clearing and freeing adapter->card pointer. This patch removes the
redundant cleanup code causing crash.

Signed-off-by: Karthik D A <karthida@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index e54a98a..d61d4ad 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -202,7 +202,6 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 	if (mwifiex_add_card(card, &add_remove_card_sem, &pcie_ops,
 			     MWIFIEX_PCIE)) {
 		pr_err("%s failed\n", __func__);
-		kfree(card);
 		return -1;
 	}
 
@@ -2843,7 +2842,6 @@ static int mwifiex_pcie_request_irq(struct mwifiex_adapter *adapter)
 			  "MRVL_PCIE", &card->share_irq_ctx);
 	if (ret) {
 		pr_err("request_irq failed: ret=%d\n", ret);
-		adapter->card = NULL;
 		return -1;
 	}
 
-- 
1.9.1

