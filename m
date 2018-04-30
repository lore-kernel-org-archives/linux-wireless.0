Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34910 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753704AbeD3NTY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 09:19:24 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 051E4401DEA8
        for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2018 13:19:24 +0000 (UTC)
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/2] rt2x00: check against flushing empty queue
Date: Mon, 30 Apr 2018 15:19:17 +0200
Message-Id: <1525094357-24782-2-git-send-email-sgruszka@redhat.com> (sfid-20180430_151929_499312_1A8C8B68)
In-Reply-To: <1525094357-24782-1-git-send-email-sgruszka@redhat.com>
References: <1525094357-24782-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have check if queue is not empty when start flushing queues on
by mac80211 callback, but we also can start flushing queues by internal
driver calls. So move check into rt2x00queue_flush_queue() to assure
we do not flush empty queue anytime.

Additionally add warning if we start to kick empty queue as in such
situation we set wrong index in the HW queue, what can confuse the HW
and have various negative consequences.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c  | 1 +
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c   | 3 +--
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c | 2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
index 1123e2bed803..e1a7ed7e4892 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
@@ -600,6 +600,7 @@ void rt2800mmio_kick_queue(struct data_queue *queue)
 	case QID_AC_VI:
 	case QID_AC_BE:
 	case QID_AC_BK:
+		WARN_ON_ONCE(rt2x00queue_empty(queue));
 		entry = rt2x00queue_get_entry(queue, Q_INDEX);
 		rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX(queue->qid),
 					  entry->entry_idx);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
index a971bc7a6b63..c380c1f56ba6 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
@@ -739,8 +739,7 @@ void rt2x00mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		return;
 
 	tx_queue_for_each(rt2x00dev, queue)
-		if (!rt2x00queue_empty(queue))
-			rt2x00queue_flush_queue(queue, drop);
+		rt2x00queue_flush_queue(queue, drop);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_flush);
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
index a6884e73d2ab..7c1f8f561d4a 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
@@ -1000,6 +1000,8 @@ void rt2x00queue_flush_queue(struct data_queue *queue, bool drop)
 		(queue->qid == QID_AC_BE) ||
 		(queue->qid == QID_AC_BK);
 
+	if (rt2x00queue_empty(queue))
+		return;
 
 	/*
 	 * If we are not supposed to drop any pending
-- 
1.9.3
