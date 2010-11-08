Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:32786 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab0KHSuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 13:50:08 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath5k: Print stats as unsigned ints.
Date: Mon,  8 Nov 2010 10:50:03 -0800
Message-Id: <1289242203-3702-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The debugfs code for ath5k was printing some unsigned int
stats with %d instead of %u.  This meant that you could see
negative numbers instead of a clean wrap.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 acda56e... 54dcf77... M	drivers/net/wireless/ath/ath5k/debug.c
 drivers/net/wireless/ath/ath5k/debug.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index acda56e..54dcf77 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -554,63 +554,63 @@ static ssize_t read_file_frameerrors(struct file *file, char __user *user_buf,
 
 	len += snprintf(buf+len, sizeof(buf)-len,
 			"RX\n---------------------\n");
-	len += snprintf(buf+len, sizeof(buf)-len, "CRC\t%d\t(%d%%)\n",
+	len += snprintf(buf+len, sizeof(buf)-len, "CRC\t%u\t(%u%%)\n",
 			st->rxerr_crc,
 			st->rx_all_count > 0 ?
 				st->rxerr_crc*100/st->rx_all_count : 0);
-	len += snprintf(buf+len, sizeof(buf)-len, "PHY\t%d\t(%d%%)\n",
+	len += snprintf(buf+len, sizeof(buf)-len, "PHY\t%u\t(%u%%)\n",
 			st->rxerr_phy,
 			st->rx_all_count > 0 ?
 				st->rxerr_phy*100/st->rx_all_count : 0);
 	for (i = 0; i < 32; i++) {
 		if (st->rxerr_phy_code[i])
 			len += snprintf(buf+len, sizeof(buf)-len,
-				" phy_err[%d]\t%d\n",
+				" phy_err[%u]\t%u\n",
 				i, st->rxerr_phy_code[i]);
 	}
 
-	len += snprintf(buf+len, sizeof(buf)-len, "FIFO\t%d\t(%d%%)\n",
+	len += snprintf(buf+len, sizeof(buf)-len, "FIFO\t%u\t(%u%%)\n",
 			st->rxerr_fifo,
 			st->rx_all_count > 0 ?
 				st->rxerr_fifo*100/st->rx_all_count : 0);
-	len += snprintf(buf+len, sizeof(buf)-len, "decrypt\t%d\t(%d%%)\n",
+	len += snprintf(buf+len, sizeof(buf)-len, "decrypt\t%u\t(%u%%)\n",
 			st->rxerr_decrypt,
 			st->rx_all_count > 0 ?
 				st->rxerr_decrypt*100/st->rx_all_count : 0);
-	len += snprintf(buf+len, sizeof(buf)-len, "MIC\t%d\t(%d%%)\n",
+	len += snprintf(buf+len, sizeof(buf)-len, "MIC\t%u\t(%u%%)\n",
 			st->rxerr_mic,
 			st->rx_all_count > 0 ?
 				st->rxerr_mic*100/st->rx_all_count : 0);
-	len += snprintf(buf+len, sizeof(buf)-len, "process\t%d\t(%d%%)\n",
+	len += snprintf(buf+len, sizeof(buf)-len, "process\t%u\t(%u%%)\n",
 			st->rxerr_proc,
 			st->rx_all_count > 0 ?
 				st->rxerr_proc*100/st->rx_all_count : 0);
-	len += snprintf(buf+len, sizeof(buf)-len, "jumbo\t%d\t(%d%%)\n",
+	len += snprintf(buf+len, sizeof(buf)-len, "jumbo\t%u\t(%u%%)\n",
 			st->rxerr_jumbo,
 			st->rx_all_count > 0 ?
 				st->rxerr_jumbo*100/st->rx_all_count : 0);
-	len += snprintf(buf+len, sizeof(buf)-len, "[RX all\t%d]\n",
+	len += snprintf(buf+len, sizeof(buf)-len, "[RX all\t%u]\n",
 			st->rx_all_count);
-	len += snprintf(buf+len, sizeof(buf)-len, "RX-all-bytes\t%d\n",
+	len += snprintf(buf+len, sizeof(buf)-len, "RX-all-bytes\t%u\n",
 			st->rx_bytes_count);
 
 	len += snprintf(buf+len, sizeof(buf)-len,
 			"\nTX\n---------------------\n");
-	len += snprintf(buf+len, sizeof(buf)-len, "retry\t%d\t(%d%%)\n",
+	len += snprintf(buf+len, sizeof(buf)-len, "retry\t%u\t(%u%%)\n",
 			st->txerr_retry,
 			st->tx_all_count > 0 ?
 				st->txerr_retry*100/st->tx_all_count : 0);
-	len += snprintf(buf+len, sizeof(buf)-len, "FIFO\t%d\t(%d%%)\n",
+	len += snprintf(buf+len, sizeof(buf)-len, "FIFO\t%u\t(%u%%)\n",
 			st->txerr_fifo,
 			st->tx_all_count > 0 ?
 				st->txerr_fifo*100/st->tx_all_count : 0);
-	len += snprintf(buf+len, sizeof(buf)-len, "filter\t%d\t(%d%%)\n",
+	len += snprintf(buf+len, sizeof(buf)-len, "filter\t%u\t(%u%%)\n",
 			st->txerr_filt,
 			st->tx_all_count > 0 ?
 				st->txerr_filt*100/st->tx_all_count : 0);
-	len += snprintf(buf+len, sizeof(buf)-len, "[TX all\t%d]\n",
+	len += snprintf(buf+len, sizeof(buf)-len, "[TX all\t%u]\n",
 			st->tx_all_count);
-	len += snprintf(buf+len, sizeof(buf)-len, "TX-all-bytes\t%d\n",
+	len += snprintf(buf+len, sizeof(buf)-len, "TX-all-bytes\t%u\n",
 			st->tx_bytes_count);
 
 	if (len > sizeof(buf))
-- 
1.7.2.3

