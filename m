Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65487 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759165Ab0I0R7H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 13:59:07 -0400
Received: by mail-bw0-f46.google.com with SMTP id 11so3540044bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 10:59:06 -0700 (PDT)
Message-Id: <0d871d6b95c93ae9ebd8acbc9aa6f42fb94ad3c6.1285544496.git.chunkeey@googlemail.com>
In-Reply-To: <cover.1285544496.git.chunkeey@googlemail.com>
References: <cover.1285544496.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 26 Sep 2010 21:48:31 +0200
Subject: [PATCH 3/6] carl9170: remove lost-frame workaround
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes some cruft, which survived
the RFC review phase.

Originally, carl9170_tx_ampdu_queue erroneously
dropped a lot of frames. As a result the ampdu
scheduler bogged down quite frequently and the
affected BA session timed out.

However this bug has been fixed and the WA and
its debugfs counter is no longer useful.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/carl9170.h |    1 -
 drivers/net/wireless/ath/carl9170/debug.c    |    4 ---
 drivers/net/wireless/ath/carl9170/tx.c       |   37 +------------------------
 3 files changed, 2 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index d7c5482..20f2a77 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -364,7 +364,6 @@ struct ar9170 {
 	unsigned int tx_dropped;
 	unsigned int tx_ack_failures;
 	unsigned int tx_fcs_errors;
-	unsigned int tx_ampdu_timeout;
 	unsigned int rx_dropped;
 
 	/* EEPROM */
diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
index dbb35c3..19f45e9 100644
--- a/drivers/net/wireless/ath/carl9170/debug.c
+++ b/drivers/net/wireless/ath/carl9170/debug.c
@@ -799,8 +799,6 @@ DEBUGFS_READONLY_FILE(tx_total_queued, 20, "%d",
 		      atomic_read(&ar->tx_total_queued));
 DEBUGFS_READONLY_FILE(tx_ampdu_scheduler, 20, "%d",
 		      atomic_read(&ar->tx_ampdu_scheduler));
-DEBUGFS_READONLY_FILE(tx_ampdu_timeout, 20, "%d",
-		      ar->tx_ampdu_timeout);
 
 DEBUGFS_READONLY_FILE(tx_total_pending, 20, "%d",
 		      atomic_read(&ar->tx_total_pending));
@@ -873,8 +871,6 @@ void carl9170_debugfs_register(struct ar9170 *ar)
 	DEBUGFS_ADD(ampdu_density);
 	DEBUGFS_ADD(ampdu_factor);
 
-	DEBUGFS_ADD(tx_ampdu_timeout);
-
 	DEBUGFS_ADD(tx_janitor_last_run);
 
 	DEBUGFS_ADD(tx_status_0);
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index e0d2374..e6be5e6 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -1042,41 +1042,8 @@ retry:
 		queue = TID_TO_WME_AC(tid_info->tid);
 
 		spin_lock_bh(&tid_info->lock);
-		if (tid_info->state != CARL9170_TID_STATE_XMIT) {
-			first = skb_peek(&tid_info->queue);
-			if (first) {
-				struct ieee80211_tx_info *txinfo;
-				struct carl9170_tx_info *arinfo;
-
-				txinfo = IEEE80211_SKB_CB(first);
-				arinfo = (void *) txinfo->rate_driver_data;
-
-				if (time_is_after_jiffies(arinfo->timeout +
-				    msecs_to_jiffies(CARL9170_QUEUE_TIMEOUT))
-				    == true)
-					goto processed;
-
-				/*
-				 * We've been waiting for the frame which
-				 * matches "snx" (start sequence of the
-				 * next aggregate) for some time now.
-				 *
-				 * But it never arrived. Therefore
-				 * jump to the next available frame
-				 * and kick-start the transmission.
-				 *
-				 * Note: This might induce odd latency
-				 * spikes because the receiver will be
-				 * waiting for the lost frame too.
-				 */
-				ar->tx_ampdu_timeout++;
-
-				tid_info->snx = carl9170_get_seq(first);
-				tid_info->state = CARL9170_TID_STATE_XMIT;
-			} else {
-				goto processed;
-			}
-		}
+		if (tid_info->state != CARL9170_TID_STATE_XMIT)
+			goto processed;
 
 		tid_info->counter++;
 		first = skb_peek(&tid_info->queue);
-- 
1.7.1

