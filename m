Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53951 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017AbaDWVlM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2014 17:41:12 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: fix adapter pointer dereference
Date: Wed, 23 Apr 2014 14:40:53 -0700
Message-ID: <1398289253-21398-1-git-send-email-bzhao@marvell.com> (sfid-20140423_234516_174870_81DC5685)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/mwifiex/pcie.c:2252 mwifiex_pcie_fw_dump_work()
error: we previously assumed 'adapter' could be null (see line 2251)

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 51989b3..249fdbd 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -2248,7 +2248,7 @@ static void mwifiex_pcie_fw_dump_work(struct work_struct *work)
 	};
 
 	if (!adapter) {
-		dev_err(adapter->dev, "Could not dump firmwware info\n");
+		pr_err("adapter is null. Could not dump firmware info\n");
 		return;
 	}
 
-- 
1.8.2.3

