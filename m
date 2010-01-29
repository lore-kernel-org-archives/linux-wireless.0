Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:12141 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210Ab0A2WWg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 17:22:36 -0500
Subject: [PATCH 2/2] ath9k: allocate string buffer in read_file_dma() by
	kmalloc()
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Fri, 29 Jan 2010 17:22:26 -0500
Message-ID: <20100129222226.23641.63667.stgit@mj.roinet.com>
In-Reply-To: <20100129222212.23641.58699.stgit@mj.roinet.com>
References: <20100129222212.23641.58699.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using stack for that causes warnings with CONFIG_FRAME_WARN=1024

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath9k/debug.c |   43 +++++++++++++++++++-------------
 1 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 9489b6b..42d2a50 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -75,17 +75,24 @@ static const struct file_operations fops_debug = {
 
 #endif
 
+#define DMA_BUF_LEN 1024
+
 static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
 	struct ath_hw *ah = sc->sc_ah;
-	char buf[1024];
+	char *buf;
+	int retval;
 	unsigned int len = 0;
 	u32 val[ATH9K_NUM_DMA_DEBUG_REGS];
 	int i, qcuOffset = 0, dcuOffset = 0;
 	u32 *qcuBase = &val[0], *dcuBase = &val[4];
 
+	buf = kmalloc(DMA_BUF_LEN, GFP_KERNEL);
+	if (!buf)
+		return 0;
+
 	ath9k_ps_wakeup(sc);
 
 	REG_WRITE_D(ah, AR_MACMISC,
@@ -93,20 +100,20 @@ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 		   (AR_MACMISC_MISC_OBS_BUS_1 <<
 		    AR_MACMISC_MISC_OBS_BUS_MSB_S)));
 
-	len += snprintf(buf + len, sizeof(buf) - len,
+	len += snprintf(buf + len, DMA_BUF_LEN - len,
 			"Raw DMA Debug values:\n");
 
 	for (i = 0; i < ATH9K_NUM_DMA_DEBUG_REGS; i++) {
 		if (i % 4 == 0)
-			len += snprintf(buf + len, sizeof(buf) - len, "\n");
+			len += snprintf(buf + len, DMA_BUF_LEN - len, "\n");
 
 		val[i] = REG_READ_D(ah, AR_DMADBG_0 + (i * sizeof(u32)));
-		len += snprintf(buf + len, sizeof(buf) - len, "%d: %08x ",
+		len += snprintf(buf + len, DMA_BUF_LEN - len, "%d: %08x ",
 				i, val[i]);
 	}
 
-	len += snprintf(buf + len, sizeof(buf) - len, "\n\n");
-	len += snprintf(buf + len, sizeof(buf) - len,
+	len += snprintf(buf + len, DMA_BUF_LEN - len, "\n\n");
+	len += snprintf(buf + len, DMA_BUF_LEN - len,
 			"Num QCU: chain_st fsp_ok fsp_st DCU: chain_st\n");
 
 	for (i = 0; i < ATH9K_NUM_QUEUES; i++, qcuOffset += 4, dcuOffset += 5) {
@@ -120,7 +127,7 @@ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 			dcuBase++;
 		}
 
-		len += snprintf(buf + len, sizeof(buf) - len,
+		len += snprintf(buf + len, DMA_BUF_LEN - len,
 			"%2d          %2x      %1x     %2x           %2x\n",
 			i, (*qcuBase & (0x7 << qcuOffset)) >> qcuOffset,
 			(*qcuBase & (0x8 << qcuOffset)) >> (qcuOffset + 3),
@@ -128,35 +135,37 @@ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 			(*dcuBase & (0x1f << dcuOffset)) >> dcuOffset);
 	}
 
-	len += snprintf(buf + len, sizeof(buf) - len, "\n");
+	len += snprintf(buf + len, DMA_BUF_LEN - len, "\n");
 
-	len += snprintf(buf + len, sizeof(buf) - len,
+	len += snprintf(buf + len, DMA_BUF_LEN - len,
 		"qcu_stitch state:   %2x    qcu_fetch state:        %2x\n",
 		(val[3] & 0x003c0000) >> 18, (val[3] & 0x03c00000) >> 22);
-	len += snprintf(buf + len, sizeof(buf) - len,
+	len += snprintf(buf + len, DMA_BUF_LEN - len,
 		"qcu_complete state: %2x    dcu_complete state:     %2x\n",
 		(val[3] & 0x1c000000) >> 26, (val[6] & 0x3));
-	len += snprintf(buf + len, sizeof(buf) - len,
+	len += snprintf(buf + len, DMA_BUF_LEN - len,
 		"dcu_arb state:      %2x    dcu_fp state:           %2x\n",
 		(val[5] & 0x06000000) >> 25, (val[5] & 0x38000000) >> 27);
-	len += snprintf(buf + len, sizeof(buf) - len,
+	len += snprintf(buf + len, DMA_BUF_LEN - len,
 		"chan_idle_dur:     %3d    chan_idle_dur_valid:     %1d\n",
 		(val[6] & 0x000003fc) >> 2, (val[6] & 0x00000400) >> 10);
-	len += snprintf(buf + len, sizeof(buf) - len,
+	len += snprintf(buf + len, DMA_BUF_LEN - len,
 		"txfifo_valid_0:      %1d    txfifo_valid_1:          %1d\n",
 		(val[6] & 0x00000800) >> 11, (val[6] & 0x00001000) >> 12);
-	len += snprintf(buf + len, sizeof(buf) - len,
+	len += snprintf(buf + len, DMA_BUF_LEN - len,
 		"txfifo_dcu_num_0:   %2d    txfifo_dcu_num_1:       %2d\n",
 		(val[6] & 0x0001e000) >> 13, (val[6] & 0x001e0000) >> 17);
 
-	len += snprintf(buf + len, sizeof(buf) - len, "pcu observe: 0x%x \n",
+	len += snprintf(buf + len, DMA_BUF_LEN - len, "pcu observe: 0x%x \n",
 			REG_READ_D(ah, AR_OBS_BUS_1));
-	len += snprintf(buf + len, sizeof(buf) - len,
+	len += snprintf(buf + len, DMA_BUF_LEN - len,
 			"AR_CR: 0x%x \n", REG_READ_D(ah, AR_CR));
 
 	ath9k_ps_restore(sc);
 
-	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+	return retval;
 }
 
 static const struct file_operations fops_dma = {
