Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60414 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933657AbaGVXAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 19:00:08 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  Improve 'hard' simulate fw crash.
Date: Tue, 22 Jul 2014 16:00:04 -0700
Message-Id: <1406070004-6238-1-git-send-email-greearb@candelatech.com> (sfid-20140723_010025_409037_8C46FC31)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Different firmware may support different numbers of
vdevs.  Use value that is always out of range for all
firmware.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 3030158..c9e35c87e 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -531,7 +531,10 @@ static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
 		ret = ath10k_wmi_force_fw_hang(ar, WMI_FORCE_FW_HANG_ASSERT, 0);
 	} else if (!strcmp(buf, "hard")) {
 		ath10k_info("simulating hard firmware crash\n");
-		ret = ath10k_wmi_vdev_set_param(ar, TARGET_NUM_VDEVS + 1,
+		/* 0x7fff is vdev id, and it is always out of range for all
+		 * firmware variants in order to force a firmware crash.
+		 */
+		ret = ath10k_wmi_vdev_set_param(ar, 0x7fff,
 					ar->wmi.vdev_param->rts_threshold, 0);
 	} else {
 		ret = -EINVAL;
-- 
1.7.11.7

