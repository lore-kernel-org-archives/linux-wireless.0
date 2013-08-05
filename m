Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36204 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712Ab3HET4b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 15:56:31 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 04/12] ath9k: add CAB queue info to debugfs
Date: Mon,  5 Aug 2013 21:56:15 +0200
Message-Id: <1375732583-39001-4-git-send-email-nbd@openwrt.org> (sfid-20130805_215639_171773_6F1C9C4A)
In-Reply-To: <1375732583-39001-1-git-send-email-nbd@openwrt.org>
References: <1375732583-39001-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/debug.c | 43 +++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index e744d97..d94facc 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -726,6 +726,28 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	return retval;
 }
 
+static ssize_t print_queue(struct ath_softc *sc, struct ath_txq *txq,
+			   char *buf, ssize_t size)
+{
+	ssize_t len = 0;
+
+	ath_txq_lock(sc, txq);
+
+	len += snprintf(buf + len, size - len, "%s: %d ",
+			"qnum", txq->axq_qnum);
+	len += snprintf(buf + len, size - len, "%s: %2d ",
+			"qdepth", txq->axq_depth);
+	len += snprintf(buf + len, size - len, "%s: %2d ",
+			"ampdu-depth", txq->axq_ampdu_depth);
+	len += snprintf(buf + len, size - len, "%s: %3d ",
+			"pending", txq->pending_frames);
+	len += snprintf(buf + len, size - len, "%s: %d\n",
+			"stopped", txq->stopped);
+
+	ath_txq_unlock(sc, txq);
+	return len;
+}
+
 static ssize_t read_file_queues(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
 {
@@ -743,24 +765,13 @@ static ssize_t read_file_queues(struct file *file, char __user *user_buf,
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		txq = sc->tx.txq_map[i];
-		len += snprintf(buf + len, size - len, "(%s): ", qname[i]);
-
-		ath_txq_lock(sc, txq);
-
-		len += snprintf(buf + len, size - len, "%s: %d ",
-				"qnum", txq->axq_qnum);
-		len += snprintf(buf + len, size - len, "%s: %2d ",
-				"qdepth", txq->axq_depth);
-		len += snprintf(buf + len, size - len, "%s: %2d ",
-				"ampdu-depth", txq->axq_ampdu_depth);
-		len += snprintf(buf + len, size - len, "%s: %3d ",
-				"pending", txq->pending_frames);
-		len += snprintf(buf + len, size - len, "%s: %d\n",
-				"stopped", txq->stopped);
-
-		ath_txq_unlock(sc, txq);
+		len += snprintf(buf + len, size - len, "(%s):  ", qname[i]);
+		len += print_queue(sc, txq, buf + len, size - len);
 	}
 
+	len += snprintf(buf + len, size - len, "(CAB): ");
+	len += print_queue(sc, sc->beacon.cabq, buf + len, size - len);
+
 	if (len > size)
 		len = size;
 
-- 
1.8.0.2

