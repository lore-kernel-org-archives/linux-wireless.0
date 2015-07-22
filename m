Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27451 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964841AbbGVLyY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 07:54:24 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t6MBnm6O028385
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 04:54:23 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0a-0016f401.pphosted.com with ESMTP id 1vqm5jkw4t-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 04:54:23 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Zhaoyang Liu <liuzy@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/4] mwifiex: fix system crash observed during initialisation
Date: Wed, 22 Jul 2015 04:53:44 -0700
Message-ID: <1437566025-3324-3-git-send-email-akarwar@marvell.com> (sfid-20150722_135432_816507_E61478A6)
In-Reply-To: <1437566025-3324-1-git-send-email-akarwar@marvell.com>
References: <1437566025-3324-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

System crash was observed if one of the driver initialisation
commands is timed out. The reason is our timeout handler triggers
firmware dump, meanwhile driver initialisation error paths have
already freed the adapter structure.

Firmware hasn't yet completely initialized. So collecting firmware
dump is not needed in this case. Command timeout handler is
modified in this patch to fix the crash issue.

Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 207da40..dbfbbdf 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -993,8 +993,10 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 			mwifiex_cancel_pending_ioctl(adapter);
 		}
 	}
-	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING)
+	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING) {
 		mwifiex_init_fw_complete(adapter);
+		return;
+	}
 
 	if (adapter->if_ops.device_dump)
 		adapter->if_ops.device_dump(adapter);
-- 
1.8.1.4

