Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55728 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab0JARyJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 13:54:09 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath5k:  Print rx/tx bytes in debugfs
Date: Fri,  1 Oct 2010 10:54:04 -0700
Message-Id: <1285955644-31046-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This adds counters for tx and rx bytes, including any
errored packets as well as all wireless headers.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 2ed327a... d914a31... M	drivers/net/wireless/ath/ath5k/base.c
:100644 100644 b9f6d13... 9a79773... M	drivers/net/wireless/ath/ath5k/base.h
:100644 100644 0f06e84... c2d549f... M	drivers/net/wireless/ath/ath5k/debug.c
 drivers/net/wireless/ath/ath5k/base.c  |    2 ++
 drivers/net/wireless/ath/ath5k/base.h  |    7 +++++++
 drivers/net/wireless/ath/ath5k/debug.c |    4 ++++
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 2ed327a..d914a31 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1433,6 +1433,7 @@ static bool
 ath5k_receive_frame_ok(struct ath5k_softc *sc, struct ath5k_rx_status *rs)
 {
 	sc->stats.rx_all_count++;
+	sc->stats.rx_bytes_count += rs->rs_datalen;
 
 	if (unlikely(rs->rs_status)) {
 		if (rs->rs_status & AR5K_RXERR_CRC)
@@ -1611,6 +1612,7 @@ ath5k_tx_frame_completed(struct ath5k_softc *sc, struct sk_buff *skb,
 	int i;
 
 	sc->stats.tx_all_count++;
+	sc->stats.tx_bytes_count += skb->len;
 	info = IEEE80211_SKB_CB(skb);
 
 	ieee80211_tx_info_clear_status(info);
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index b9f6d13..9a79773 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -121,6 +121,13 @@ struct ath5k_statistics {
 	/* frame errors */
 	unsigned int rx_all_count;	/* all RX frames, including errors */
 	unsigned int tx_all_count;	/* all TX frames, including errors */
+	unsigned int rx_bytes_count;	/* all RX bytes, including errored pks
+					 * and the MAC headers for each packet
+					 */
+	unsigned int tx_bytes_count;	/* all TX bytes, including errored pkts
+					 * and the MAC headers and padding for
+					 * each packet.
+					 */
 	unsigned int rxerr_crc;
 	unsigned int rxerr_phy;
 	unsigned int rxerr_phy_code[32];
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 0f06e84..c2d549f 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -587,6 +587,8 @@ static ssize_t read_file_frameerrors(struct file *file, char __user *user_buf,
 				st->rxerr_jumbo*100/st->rx_all_count : 0);
 	len += snprintf(buf+len, sizeof(buf)-len, "[RX all\t%d]\n",
 			st->rx_all_count);
+	len += snprintf(buf+len, sizeof(buf)-len, "RX-all-bytes\t%d\n",
+			st->rx_bytes_count);
 
 	len += snprintf(buf+len, sizeof(buf)-len,
 			"\nTX\n---------------------\n");
@@ -604,6 +606,8 @@ static ssize_t read_file_frameerrors(struct file *file, char __user *user_buf,
 				st->txerr_filt*100/st->tx_all_count : 0);
 	len += snprintf(buf+len, sizeof(buf)-len, "[TX all\t%d]\n",
 			st->tx_all_count);
+	len += snprintf(buf+len, sizeof(buf)-len, "TX-all-bytes\t%d\n",
+			st->tx_bytes_count);
 
 	if (len > sizeof(buf))
 		len = sizeof(buf);
-- 
1.7.2.2

