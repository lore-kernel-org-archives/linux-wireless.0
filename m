Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35166 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbbICInY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2015 04:43:24 -0400
Received: by lbpo4 with SMTP id o4so20219848lbp.2
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2015 01:43:23 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: move hw_scan worker queuing
Date: Thu,  3 Sep 2015 10:43:45 +0200
Message-Id: <1441269825-344-1-git-send-email-michal.kazior@tieto.com> (sfid-20150903_104330_855824_A974F16A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The remain_on_channel callback needs different
timeout. Calling ieee80211_queue_work() with a
shorter delay after calling it with a longer delay
will not change the timer. This caused the
offchannel timeout worker to not trigger in time
and caused the device to stay on channel longer
then expected. This could cause some problems and
was be easily reproduced with `iw offchannel`
command.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 64674c955d44..708fc2d2de2f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3617,9 +3617,6 @@ static int ath10k_start_scan(struct ath10k *ar,
 	}
 	spin_unlock_bh(&ar->data_lock);
 
-	/* Add a 200ms margin to account for event/command processing */
-	ieee80211_queue_delayed_work(ar->hw, &ar->scan.timeout,
-				     msecs_to_jiffies(arg->max_scan_time+200));
 	return 0;
 }
 
@@ -4751,6 +4748,11 @@ static int ath10k_hw_scan(struct ieee80211_hw *hw,
 		spin_unlock_bh(&ar->data_lock);
 	}
 
+	/* Add a 200ms margin to account for event/command processing */
+	ieee80211_queue_delayed_work(ar->hw, &ar->scan.timeout,
+				     msecs_to_jiffies(arg.max_scan_time +
+						      200));
+
 exit:
 	mutex_unlock(&ar->conf_mutex);
 	return ret;
-- 
2.1.4

