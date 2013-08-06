Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57808 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292Ab3HFMSY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 08:18:24 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, sujith@msujith.org
Subject: [PATCH v2 04/12] ath9k: add CAB queue info to debugfs
Date: Tue,  6 Aug 2013 14:18:05 +0200
Message-Id: <1375791493-83971-4-git-send-email-nbd@openwrt.org> (sfid-20130806_141847_601793_0FFCF099)
In-Reply-To: <1375791493-83971-1-git-send-email-nbd@openwrt.org>
References: <1375791493-83971-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/debug.c | 43 +++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index a155190..63b4d82 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -728,6 +728,28 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
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
@@ -745,24 +767,13 @@ static ssize_t read_file_queues(struct file *file, char __user *user_buf,
 
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

