Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25561 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753284AbcBCGKL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 01:10:11 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u136A8Tg002542
	for <linux-wireless@vger.kernel.org>; Tue, 2 Feb 2016 22:10:10 -0800
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0b-0016f401.pphosted.com with ESMTP id 20sw0hqnd8-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 02 Feb 2016 22:10:10 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/8] mwifiex: skip firmware dump when read_regs() fails
Date: Tue, 2 Feb 2016 22:05:04 -0800
Message-ID: <1454479509-27129-4-git-send-email-akarwar@marvell.com> (sfid-20160203_071017_978988_0F8113B2)
In-Reply-To: <1454479509-27129-1-git-send-email-akarwar@marvell.com>
References: <1454479509-27129-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

If we are not able to read registers or PCIe memory,
it means PCIe device is in bad state. We will skip
firmware dump in this case.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index b9fe181..a18d944 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2366,9 +2366,13 @@ mwifiex_pcie_rdwr_firmware(struct mwifiex_adapter *adapter, u8 doneflag)
 {
 	int ret, tries;
 	u8 ctrl_data;
+	u32 fw_status;
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
+	if (mwifiex_read_reg(adapter, reg->fw_status, &fw_status))
+		return RDWR_STATUS_FAILURE;
+
 	ret = mwifiex_write_reg(adapter, reg->fw_dump_ctrl, FW_DUMP_HOST_READY);
 	if (ret) {
 		mwifiex_dbg(adapter, ERROR,
-- 
1.8.1.4

