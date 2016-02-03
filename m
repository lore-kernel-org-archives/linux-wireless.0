Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64110 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028AbcBCGKJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 01:10:09 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u136A8Tf002542
	for <linux-wireless@vger.kernel.org>; Tue, 2 Feb 2016 22:10:08 -0800
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0b-0016f401.pphosted.com with ESMTP id 20sw0hqnd7-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 02 Feb 2016 22:10:08 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/8] mwifiex: process pcie io memory read failure case
Date: Tue, 2 Feb 2016 22:05:03 -0800
Message-ID: <1454479509-27129-3-git-send-email-akarwar@marvell.com> (sfid-20160203_071015_480233_B58ADD95)
In-Reply-To: <1454479509-27129-1-git-send-email-akarwar@marvell.com>
References: <1454479509-27129-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

It is observed that ioread32 may fail to read pcie register
in certain scenarios, this patch handles these cases.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 918e049..b9fe181 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -323,6 +323,8 @@ static int mwifiex_read_reg(struct mwifiex_adapter *adapter, int reg, u32 *data)
 	struct pcie_service_card *card = adapter->card;
 
 	*data = ioread32(card->pci_mmap1 + reg);
+	if (*data == 0xffffffff)
+		return 0xffffffff;
 
 	return 0;
 }
-- 
1.8.1.4

