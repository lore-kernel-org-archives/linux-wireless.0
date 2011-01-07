Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49550 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab1AGSBG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 13:01:06 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/2] ath9k:  More xmit queue debugfs information.
Date: Fri,  7 Jan 2011 10:00:58 -0800
Message-Id: <1294423259-8163-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

To try to figure out why xmit logic hangs.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 650f00f... 9e009cc... M	drivers/net/wireless/ath/ath9k/debug.c
 drivers/net/wireless/ath/ath9k/debug.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 650f00f..9e009cc 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -679,6 +679,32 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 		PRQLE(tmp, txq_fifo[i]);
 	}
 
+	/* Print out more detailed queue-info */
+	for (i = 0; i <= WME_AC_BK; i++) {
+		struct ath_txq *txq = &(sc->tx.txq[i]);
+		struct ath_atx_ac *ac;
+		struct ath_atx_tid *tid;
+		if (len >= size)
+			goto done;
+		spin_lock_bh(&txq->axq_lock);
+		if (!list_empty(&txq->axq_acq)) {
+			ac = list_first_entry(&txq->axq_acq, struct ath_atx_ac,
+					      list);
+			len += snprintf(buf + len, size - len,
+					"txq[%i] first-ac: %p sched: %i\n",
+					i, ac, ac->sched);
+			if (list_empty(&ac->tid_q) || (len >= size))
+				goto done_for;
+			tid = list_first_entry(&ac->tid_q, struct ath_atx_tid,
+					       list);
+			len += snprintf(buf + len, size - len,
+					" first-tid: %p sched: %i paused: %i\n",
+					tid, tid->sched, tid->paused);
+		}
+	done_for:
+		spin_unlock_bh(&txq->axq_lock);
+	}
+
 done:
 	if (len > size)
 		len = size;
-- 
1.7.2.3

