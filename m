Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37083 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2DCQRG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 12:17:06 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/3] ath9k: Add tx-failed counter.
Date: Tue,  3 Apr 2012 09:16:55 -0700
Message-Id: <1333469815-26146-1-git-send-email-greearb@candelatech.com> (sfid-20120403_181711_164301_0B173FA5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This counts any failure during getting packets into
the DMA buffers, including out-of-memory, etc.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 35d1c8e... 9078279... M	drivers/net/wireless/ath/ath9k/debug.c
:100644 100644 64fcfad... d1c132f... M	drivers/net/wireless/ath/ath9k/debug.h
:100644 100644 215eb25... 2e49a43... M	drivers/net/wireless/ath/ath9k/main.c
 drivers/net/wireless/ath/ath9k/debug.c |    1 +
 drivers/net/wireless/ath/ath9k/debug.h |    2 ++
 drivers/net/wireless/ath/ath9k/main.c  |    1 +
 3 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 35d1c8e..9078279 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -529,6 +529,7 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	PR("hw-put-tx-buf:   ", puttxbuf);
 	PR("hw-tx-start:     ", txstart);
 	PR("hw-tx-proc-desc: ", txprocdesc);
+	PR("TX-Failed:       ", txfailed);
 	len += snprintf(buf + len, size - len,
 			"%s%11p%11p%10p%10p\n", "txq-memory-address:",
 			sc->tx.txq_map[WME_AC_BE],
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 64fcfad..d1c132f 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -113,6 +113,7 @@ struct ath_interrupt_stats {
  * @puttxbuf: Number of times hardware was given txbuf to write.
  * @txstart:  Number of times hardware was told to start tx.
  * @txprocdesc:  Number of times tx descriptor was processed
+ * @txfailed:  Out-of-memory or other errors in xmit path.
  */
 struct ath_tx_stats {
 	u32 tx_pkts_all;
@@ -135,6 +136,7 @@ struct ath_tx_stats {
 	u32 puttxbuf;
 	u32 txstart;
 	u32 txprocdesc;
+	u32 txfailed;
 };
 
 /**
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 215eb25..2e49a43 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1135,6 +1135,7 @@ static void ath9k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	if (ath_tx_start(hw, skb, &txctl) != 0) {
 		ath_dbg(common, XMIT, "TX failed\n");
+		TX_STAT_INC(txctl.txq->axq_qnum, txfailed);
 		goto exit;
 	}
 
-- 
1.7.3.4

