Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbaAaMQK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 07:16:10 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com
Subject: [PATCH] rt2x00: move frequent messages to debug level
Date: Fri, 31 Jan 2014 13:18:09 +0100
Message-Id: <1391170689-23038-1-git-send-email-sgruszka@redhat.com> (sfid-20140131_131614_327218_BA3FA97D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On commit 28f2bce9f8bbf704c86f8c684337f82c51592c81 I make change that
print various messages as default. This can cause flood of messages
related to TX status timeout on some environments. I partially fixed
problem on commit bb9c298f3193ac5b80e47b325c690700580b6bcf, but forgot
to move two more messages to debug level.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index caddc1b..14a90dd 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -125,9 +125,9 @@ static inline bool rt2800usb_entry_txstatus_timeout(struct queue_entry *entry)
 
 	tout = time_after(jiffies, entry->last_action + msecs_to_jiffies(100));
 	if (unlikely(tout))
-		rt2x00_warn(entry->queue->rt2x00dev,
-			    "TX status timeout for entry %d in queue %d\n",
-			    entry->entry_idx, entry->queue->qid);
+		rt2x00_dbg(entry->queue->rt2x00dev,
+			   "TX status timeout for entry %d in queue %d\n",
+			   entry->entry_idx, entry->queue->qid);
 	return tout;
 
 }
@@ -566,8 +566,8 @@ static void rt2800usb_txdone(struct rt2x00_dev *rt2x00dev)
 		queue = rt2x00queue_get_tx_queue(rt2x00dev, qid);
 
 		if (unlikely(rt2x00queue_empty(queue))) {
-			rt2x00_warn(rt2x00dev, "Got TX status for an empty queue %u, dropping\n",
-				    qid);
+			rt2x00_dbg(rt2x00dev, "Got TX status for an empty queue %u, dropping\n",
+				   qid);
 			break;
 		}
 
-- 
1.7.11.7

