Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21173 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754901AbbEZNfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 09:35:14 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t4QDYmKD003446
	for <linux-wireless@vger.kernel.org>; Tue, 26 May 2015 06:35:13 -0700
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0b-0016f401.pphosted.com with ESMTP id 1umqg00bpu-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 26 May 2015 06:35:13 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/6] mwifiex: dump driver information for PCIe interface
Date: Tue, 26 May 2015 06:34:29 -0700
Message-ID: <1432647272-5734-4-git-send-email-akarwar@marvell.com> (sfid-20150526_153527_731515_9DD580DC)
In-Reply-To: <1432647272-5734-1-git-send-email-akarwar@marvell.com>
References: <1432647272-5734-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently we are dumping driver information only for SDIO
interface. This patch adds missing mwifiex_dump_drv_info()
call for PCIe interface.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 7219243..86ed396 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -2316,6 +2316,8 @@ static void mwifiex_pcie_fw_dump_work(struct mwifiex_adapter *adapter)
 	int ret;
 	static char *env[] = { "DRIVER=mwifiex_pcie", "EVENT=fw_dump", NULL };
 
+	mwifiex_dump_drv_info(adapter);
+
 	if (!card->pcie.can_dump_fw)
 		return;
 
-- 
1.8.1.4

