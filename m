Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52934 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756064AbcBCGKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 01:10:19 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u136A9mo002545
	for <linux-wireless@vger.kernel.org>; Tue, 2 Feb 2016 22:10:19 -0800
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0b-0016f401.pphosted.com with ESMTP id 20sw0hqndu-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 02 Feb 2016 22:10:19 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 7/8] mwifiex: increase the priority of firmware dump message
Date: Tue, 2 Feb 2016 22:05:08 -0800
Message-ID: <1454479509-27129-8-git-send-email-akarwar@marvell.com> (sfid-20160203_071058_827342_D89468E7)
In-Reply-To: <1454479509-27129-1-git-send-email-akarwar@marvell.com>
References: <1454479509-27129-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware dump operation takes few seconds. Hence it's
important to notify user in dmesg that firmware dump
has started or completed.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index a62a09b..14fe316 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2422,7 +2422,7 @@ static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
 		entry->mem_size = 0;
 	}
 
-	mwifiex_dbg(adapter, DUMP, "== mwifiex firmware dump start ==\n");
+	mwifiex_dbg(adapter, MSG, "== mwifiex firmware dump start ==\n");
 
 	/* Read the number of the memories which will dump */
 	stat = mwifiex_pcie_rdwr_firmware(adapter, doneflag);
@@ -2512,7 +2512,7 @@ static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
 			break;
 		} while (true);
 	}
-	mwifiex_dbg(adapter, DUMP, "== mwifiex firmware dump end ==\n");
+	mwifiex_dbg(adapter, MSG, "== mwifiex firmware dump end ==\n");
 }
 
 static void mwifiex_pcie_device_dump_work(struct mwifiex_adapter *adapter)
-- 
1.8.1.4

