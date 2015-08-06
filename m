Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42491 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754744AbbHFK1Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 06:27:25 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	<stable@vger.kernel.org>, Zhaoyang Liu <liuzy@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.2 3/3] mwifiex: fix system crash observed during initialisation
Date: Thu, 6 Aug 2015 03:26:15 -0700
Message-ID: <1438856775-3666-3-git-send-email-akarwar@marvell.com> (sfid-20150806_122734_579175_D5B50F3C)
In-Reply-To: <1438856775-3666-1-git-send-email-akarwar@marvell.com>
References: <1438856775-3666-1-git-send-email-akarwar@marvell.com>
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

Cc: stable@vger.kernel.org # 3.19+
Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 27b778d..45ae38e 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -979,8 +979,10 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
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

