Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:35419 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754700Ab0IQCgl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 22:36:41 -0400
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-012166999
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 11:36:39 +0900 (JST)
Subject: [PATCH 08/11] ath5k: Count how many times a queue got stuck
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Fri, 17 Sep 2010 11:37:02 +0900
Message-ID: <20100917023702.24997.19042.stgit@tt-desk>
In-Reply-To: <20100917023543.24997.48466.stgit@tt-desk>
References: <20100917023543.24997.48466.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a counter to show how many times a queue got stuck in the debugfs queue
file.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c  |    2 ++
 drivers/net/wireless/ath/ath5k/base.h  |    1 +
 drivers/net/wireless/ath/ath5k/debug.c |    2 ++
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index d13df7a..c4f0786 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -896,6 +896,7 @@ ath5k_txq_setup(struct ath5k_softc *sc,
 		txq->setup = true;
 		txq->txq_len = 0;
 		txq->txq_poll_mark = false;
+		txq->txq_stuck = 0;
 	}
 	return &sc->txqs[qnum];
 }
@@ -2197,6 +2198,7 @@ ath5k_tx_complete_poll_work(struct work_struct *work)
 						  "TX queue stuck %d\n",
 						  txq->qnum);
 					needreset = true;
+					txq->txq_stuck++;
 					spin_unlock_bh(&txq->lock);
 					break;
 				} else {
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index d8e2674..7f9d0d3 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -88,6 +88,7 @@ struct ath5k_txq {
 	bool			setup;
 	int			txq_len; /* number of queued buffers */
 	bool			txq_poll_mark;
+	unsigned int		txq_stuck;	/* informational counter */
 };
 
 #define ATH5K_LED_MAX_NAME_LEN 31
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index b2c610b..6583a82 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -785,6 +785,8 @@ static ssize_t read_file_queue(struct file *file, char __user *user_buf,
 
 		len += snprintf(buf+len, sizeof(buf)-len,
 				"  len: %d bufs: %d\n", txq->txq_len, n);
+		len += snprintf(buf+len, sizeof(buf)-len,
+				"  stuck: %d\n", txq->txq_stuck);
 	}
 
 	if (len > sizeof(buf))

