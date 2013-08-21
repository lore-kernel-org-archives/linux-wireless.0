Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26512 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab3HUQ06 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 12:26:58 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath10k: Fix mutex unlock balance
Date: Wed, 21 Aug 2013 21:56:44 +0530
Message-ID: <1377102404-14742-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20130821_182701_770739_975B5106)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

ath10k_debug_read_target_stats is properly
protected by data_lock (spinlock). Remove
the unwanted mutex_unlock(&ar->conf_mutex)

[ BUG: bad unlock balance detected! ]
-------------------------------------
kworker/u4:0/12459 is trying to release lock
(&ar->conf_mutex) at:
[<c16a170d>] mutex_unlock+0xd/0x10
but there are no more locks to release!

 Call Trace:
  [<c16a170d>] ? mutex_unlock+0xd/0x10
  [<c10b697d>] __lock_release+0x4d/0xe0
  [<f88ca0fc>] ? ath10k_debug_read_target_stats+0xac/0x290

  [<c16a170d>] ? mutex_unlock+0xd/0x10
  [<c10b6a5b>] lock_release+0x4b/0x150
  [<c16a1580>] __mutex_unlock_slowpath+0x70/0x150
  [<f88ca0fc>] ? ath10k_debug_read_target_stats+0xac/0x290

  [<c10b456b>] ? trace_hardirqs_on+0xb/0x10
  [<c16a170d>] mutex_unlock+0xd/0x10
  [<f88ca107>] ath10k_debug_read_target_stats+0xb7/0x290

  [<f88d337a>] ath10k_wmi_event_process+0x3fa/0x6e0

  [<c10b456b>] ? trace_hardirqs_on+0xb/0x10
  [<f88d36e1>] ath10k_wmi_event_work+0x21/0x40
               [ath10k_core]

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 3d65594..fcb40cc 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -260,7 +260,6 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
 	}
 
 	spin_unlock_bh(&ar->data_lock);
-	mutex_unlock(&ar->conf_mutex);
 	complete(&ar->debug.event_stats_compl);
 }
 
-- 
1.7.9.5

