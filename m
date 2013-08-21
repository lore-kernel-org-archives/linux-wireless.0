Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:44164 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab3HUGeX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 02:34:23 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/3] ath10k: fix issues on non-preemptible systems
Date: Wed, 21 Aug 2013 08:34:14 +0200
Message-ID: <1377066854-13981-4-git-send-email-michal.kazior@tieto.com> (sfid-20130821_083428_609956_E89D5884)
In-Reply-To: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com>
References: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Workers may not call into a sleepable function
(e.g. mutex_lock). Since ath10k workers can run
for a very long time it is necessary to explicitly
allow process rescheduling in case there's no
preemption.

This fixes some issues with system freezes, hangs,
watchdogs being triggered, userspace being
unresponsive on slow host machines under heavy
load.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htc.c    |    4 ++++
 drivers/net/wireless/ath/ath10k/htt_rx.c |    4 ++++
 drivers/net/wireless/ath/ath10k/wmi.c    |    4 ++++
 3 files changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 7d445d3..99f1dbd 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -237,6 +237,10 @@ static void ath10k_htc_send_work(struct work_struct *work)
 		ret = ath10k_htc_issue_skb(htc, ep, skb, credits);
 		if (ret == -ENOSR)
 			break;
+
+#ifndef CONFIG_PREEMPT
+		cond_resched();
+#endif
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 6cf4d95..80ea398 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1229,6 +1229,10 @@ static void ath10k_htt_rx_work(struct work_struct *work)
 			break;
 
 		ath10k_htt_rx_process_skb(htt->ar, skb);
+
+#ifndef CONFIG_PREEMPT
+		cond_resched();
+#endif
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 32fd5e7..f36f0be 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1155,6 +1155,10 @@ static void ath10k_wmi_event_work(struct work_struct *work)
 			break;
 
 		ath10k_wmi_event_process(ar, skb);
+
+#ifndef CONFIG_PREEMPT
+		cond_resched();
+#endif
 	}
 }
 
-- 
1.7.9.5

