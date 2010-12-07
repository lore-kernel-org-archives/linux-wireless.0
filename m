Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46574 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab0LGRzz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 12:55:55 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k: Show some live tx-queue values in debugfs.
Date: Tue,  7 Dec 2010 09:55:49 -0800
Message-Id: <1291744549-7646-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

I thought this might help track down stuck queues, etc.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 3586c43... 5075faa... M	drivers/net/wireless/ath/ath9k/debug.c
 drivers/net/wireless/ath/ath9k/debug.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 3586c43..5075faa 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -589,6 +589,16 @@ static const struct file_operations fops_wiphy = {
 		sc->debug.stats.txstats[WME_AC_VO].elem); \
 } while(0)
 
+#define PRX(str, elem)							\
+do {									\
+	len += snprintf(buf + len, size - len,				\
+			"%s%13u%11u%10u%10u\n", str,			\
+			(unsigned int)(sc->tx.txq[WME_AC_BE].elem),	\
+			(unsigned int)(sc->tx.txq[WME_AC_BK].elem),	\
+			(unsigned int)(sc->tx.txq[WME_AC_VI].elem),	\
+			(unsigned int)(sc->tx.txq[WME_AC_VO].elem));	\
+} while(0)
+
 static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 			      size_t count, loff_t *ppos)
 {
@@ -619,6 +629,12 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	PR("TX-Pkts-All:     ", tx_pkts_all);
 	PR("TX-Bytes-All:    ", tx_bytes_all);
 
+	PRX("axq-qnum:        ", axq_qnum);
+	PRX("axq-depth:       ", axq_depth);
+	PRX("axq-stopped      ", stopped);
+	PRX("tx-in-progress   ", axq_tx_inprogress);
+	PRX("pending-frames   ", pending_frames);
+
 	if (len > size)
 		len = size;
 
-- 
1.7.2.3

