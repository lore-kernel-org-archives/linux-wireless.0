Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:8830 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751498Ab0IPJvG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 05:51:06 -0400
Received: from vs3003.wh2.ocn.ne.jp (125.206.180.231)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-090268664
	for <linux-wireless@vger.kernel.org>; Thu, 16 Sep 2010 18:51:04 +0900 (JST)
Subject: [PATCH 2/9] ath5k: Fix queue debug file
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Thu, 16 Sep 2010 18:51:23 +0900
Message-ID: <20100916095123.17637.43751.stgit@tt-desk>
In-Reply-To: <20100916095112.17637.17207.stgit@tt-desk>
References: <20100916095112.17637.17207.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Take txq lock in debug file and fix reporting of used buffers.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/debug.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 1b7c6d7..b2c610b 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -763,7 +763,7 @@ static ssize_t read_file_queue(struct file *file, char __user *user_buf,
 
 	struct ath5k_txq *txq;
 	struct ath5k_buf *bf, *bf0;
-	int i, n = 0;
+	int i, n;
 
 	len += snprintf(buf+len, sizeof(buf)-len,
 			"available txbuffers: %d\n", sc->txbuf_len);
@@ -777,9 +777,14 @@ static ssize_t read_file_queue(struct file *file, char __user *user_buf,
 		if (!txq->setup)
 			continue;
 
+		n = 0;
+		spin_lock_bh(&txq->lock);
 		list_for_each_entry_safe(bf, bf0, &txq->q, list)
 			n++;
-		len += snprintf(buf+len, sizeof(buf)-len, "  len: %d\n", n);
+		spin_unlock_bh(&txq->lock);
+
+		len += snprintf(buf+len, sizeof(buf)-len,
+				"  len: %d bufs: %d\n", txq->txq_len, n);
 	}
 
 	if (len > sizeof(buf))

