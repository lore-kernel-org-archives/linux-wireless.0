Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:46857 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbaEIMm5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 08:42:57 -0400
Received: by mail-ee0-f52.google.com with SMTP id e53so2640382eek.39
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2014 05:42:56 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 4/7] ath10k: wake up everything on core restart
Date: Fri,  9 May 2014 14:35:54 +0200
Message-Id: <1399638957-20449-5-git-send-email-michal.kazior@tieto.com> (sfid-20140509_144303_365112_B1FAC940)
In-Reply-To: <1399638957-20449-1-git-send-email-michal.kazior@tieto.com>
References: <1399638957-20449-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It makes sense to finish completions as they may
be waited for while holding conf_mutex thus
delaying hw restart.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 3f4d28f..bf7c323 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -709,6 +709,18 @@ void ath10k_core_restart(struct ath10k *ar)
 	spin_lock_bh(&ar->data_lock);
 	ar->wmi.drop = true;
 	wake_up(&ar->wmi.tx_credits_wq);
+
+	complete(&ar->target_suspend);
+	complete(&ar->debug.event_stats_compl);
+	complete(&ar->htt.target_version_received);
+	complete(&ar->install_key_done);
+	complete(&ar->offchan_tx_completed);
+	complete(&ar->scan.started);
+	complete(&ar->scan.on_channel);
+	complete(&ar->vdev_setup_done);
+	complete(&ar->wmi.service_ready);
+	complete(&ar->wmi.unified_ready);
+	complete_all(&ar->scan.completed);
 	spin_unlock_bh(&ar->data_lock);
 
 	queue_work(ar->workqueue, &ar->restart_work);
-- 
1.8.5.3

