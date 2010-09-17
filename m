Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:35298 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753285Ab0IQCgT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 22:36:19 -0400
Received: from vs3008.wh2.ocn.ne.jp (125.206.180.171)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-029102978
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 11:36:18 +0900 (JST)
Subject: [PATCH 04/11] ath5k: Fix queue debug file
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Fri, 17 Sep 2010 11:36:40 +0900
Message-ID: <20100917023640.24997.1987.stgit@tt-desk>
In-Reply-To: <20100917023543.24997.48466.stgit@tt-desk>
References: <20100917023543.24997.48466.stgit@tt-desk>
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

