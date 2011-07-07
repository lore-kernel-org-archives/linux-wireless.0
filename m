Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:54558 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab1GGU7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 16:59:42 -0400
Received: by fxd18 with SMTP id 18so1414136fxd.11
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jul 2011 13:59:41 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] carl9170: Implement tx_frames_pending mac80211 callback function
Date: Thu, 7 Jul 2011 23:01:25 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201107072301.25725.chunkeey@googlemail.com> (sfid-20110707_225948_662084_FE3064F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implementing this callback function will cause mac80211 refrain from
going to powersave state when there are still untransmitted TX frames
in the queues.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 28029a4..7daf47f 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1588,6 +1588,13 @@ static void carl9170_op_sta_notify(struct ieee80211_hw *hw,
 	}
 }
 
+static bool carl9170_tx_frames_pending(struct ieee80211_hw *hw)
+{
+	struct ar9170 *ar = hw->priv;
+
+	return !!atomic_read(&ar->tx_total_queued);
+}
+
 static const struct ieee80211_ops carl9170_ops = {
 	.start			= carl9170_op_start,
 	.stop			= carl9170_op_stop,
@@ -1608,6 +1615,7 @@ static const struct ieee80211_ops carl9170_ops = {
 	.get_survey		= carl9170_op_get_survey,
 	.get_stats		= carl9170_op_get_stats,
 	.ampdu_action		= carl9170_op_ampdu_action,
+	.tx_frames_pending	= carl9170_tx_frames_pending,
 };
 
 void *carl9170_alloc(size_t priv_size)
