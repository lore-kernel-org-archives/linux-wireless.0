Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:20618 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751988AbbDQLTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 07:19:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t3HBF0ND007041
	for <linux-wireless@vger.kernel.org>; Fri, 17 Apr 2015 04:19:06 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1ttjf31wkd-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Apr 2015 04:19:06 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: reduce spinlock usage in main process
Date: Fri, 17 Apr 2015 04:18:29 -0700
Message-ID: <1429269509-21310-1-git-send-email-akarwar@marvell.com> (sfid-20150417_131915_793144_C6A5B7F5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Cathy Luo <cluo@marvell.com>

We will reset more_task_flag at the end of main process
routine. This optimization will help to remove spinlock
operations at couple of places in the code.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 03a95c7..213aa98 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -231,11 +231,10 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
 		goto exit_main_proc;
 	} else {
 		adapter->mwifiex_processing = true;
+		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
 	}
 process_start:
 	do {
-		adapter->more_task_flag = false;
-		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
 		if ((adapter->hw_status == MWIFIEX_HW_STATUS_CLOSING) ||
 		    (adapter->hw_status == MWIFIEX_HW_STATUS_NOT_READY))
 			break;
@@ -275,7 +274,6 @@ process_start:
 			adapter->pm_wakeup_fw_try = true;
 			mod_timer(&adapter->wakeup_timer, jiffies + (HZ*3));
 			adapter->if_ops.wakeup(adapter);
-			spin_lock_irqsave(&adapter->main_proc_lock, flags);
 			continue;
 		}
 
@@ -335,7 +333,6 @@ process_start:
 		    (adapter->ps_state == PS_STATE_PRE_SLEEP) ||
 		    (adapter->ps_state == PS_STATE_SLEEP_CFM) ||
 		    adapter->tx_lock_flag){
-			spin_lock_irqsave(&adapter->main_proc_lock, flags);
 			continue;
 		}
 
@@ -386,12 +383,14 @@ process_start:
 			}
 			break;
 		}
-		spin_lock_irqsave(&adapter->main_proc_lock, flags);
 	} while (true);
 
 	spin_lock_irqsave(&adapter->main_proc_lock, flags);
-	if (adapter->more_task_flag)
+	if (adapter->more_task_flag) {
+		adapter->more_task_flag = false;
+		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
 		goto process_start;
+	}
 	adapter->mwifiex_processing = false;
 	spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
 
-- 
1.8.1.4

