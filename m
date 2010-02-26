Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp101.plus.mail.re1.yahoo.com ([69.147.102.64]:39335 "HELO
	smtp101.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964839Ab0BZO0S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 09:26:18 -0500
Message-ID: <4B87D9FF.5080105@yahoo.com>
Date: Fri, 26 Feb 2010 15:26:07 +0100
From: Alban Browaeys <prahal@yahoo.com>
Reply-To: prahal@yahoo.com
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: Josef Bacik <josef@redhat.com>, Ivo van Doorn <ivdoorn@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] rt2x00: Fix TX status reporting for rt2800pci.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After testing, we found that TX_STA_FIFO_MCS is the last MCS value
tried. If the transmission failed, 8 frames have been transmitted. If the
transmission succeed, we can easily compute the number of retry.  This patch fix
the way status is reported to mac80211 rate control. It has 2 bugs :

1. mcs can contain the short preamble flag and it will lead to wrong
computations.

2. minstrel nearly always say that 54 Mbits is the best rate, even if we are
very far from the AP

TX_DONE_FALLBACK flag meaning has been changed : it means that a
fallback rate table is used by the hardware.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
  drivers/net/wireless/rt2x00/rt2800pci.c   |   40 +++++++++++++--------
  drivers/net/wireless/rt2x00/rt2x00dev.c   |   53 ++++++++++++++++++++++++----
  drivers/net/wireless/rt2x00/rt2x00queue.h |    6 ++-
  3 files changed, 74 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 841f973..587c25d 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -974,26 +974,36 @@ static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
  		 * Obtain the status about this packet.
  		 */
  		txdesc.flags = 0;
-		if (rt2x00_get_field32(reg, TX_STA_FIFO_TX_SUCCESS))
-			__set_bit(TXDONE_SUCCESS, &txdesc.flags);
-		else
-			__set_bit(TXDONE_FAILURE, &txdesc.flags);
+		rt2x00_desc_read(txwi, 0, &word);
+		mcs = rt2x00_get_field32(word, TXWI_W0_MCS);
+		real_mcs = rt2x00_get_field32(reg, TX_STA_FIFO_MCS);
  
  		/*
  		 * Ralink has a retry mechanism using a global fallback
-		 * table. We setup this fallback table to try immediate
-		 * lower rate for all rates. In the TX_STA_FIFO,
-		 * the MCS field contains the MCS used for the successfull
-		 * transmission. If the first transmission succeed,
-		 * we have mcs == tx_mcs. On the second transmission,
-		 * we have mcs = tx_mcs - 1. So the number of
-		 * retry is (tx_mcs - mcs).
+		 * table. We setup this fallback table to try the immediate
+		 * lower rate for all rates. In the TX_STA_FIFO, the MCS field
+		 * always contains the MCS used for the last transmission, be
+		 * it successful or not.
  		 */
-		rt2x00_desc_read(txwi, 0, &word);
-		mcs = rt2x00_get_field32(word, TXWI_W0_MCS);
-		real_mcs = rt2x00_get_field32(reg, TX_STA_FIFO_MCS);
+		if (rt2x00_get_field32(reg, TX_STA_FIFO_TX_SUCCESS)) {
+			/*
+			 * Transmission succeeded. The number of retries is
+			 * mcs - real_mcs
+			 */
+			__set_bit(TXDONE_SUCCESS, &txdesc.flags);
+			txdesc.retry = ((mcs > real_mcs) ? mcs - real_mcs : 0);
+		} else {
+			/*
+			 * Transmission failed. The number of retries is
+			 * always 7 in this case (for a total number of 8
+			 * frames sent).
+			 */
+			__set_bit(TXDONE_FAILURE, &txdesc.flags);
+			txdesc.retry = 7;
+		}
+
  		__set_bit(TXDONE_FALLBACK, &txdesc.flags);
-		txdesc.retry = mcs - min(mcs, real_mcs);
+
  
  		rt2x00lib_txdone(entry, &txdesc);
  	}
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index b93731b..65259c6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -251,8 +251,7 @@ void rt2x00lib_txdone(struct queue_entry *entry,
  
  	rate_idx = skbdesc->tx_rate_idx;
  	rate_flags = skbdesc->tx_rate_flags;
-	retry_rates = test_bit(TXDONE_FALLBACK, &txdesc->flags) ?
-	    (txdesc->retry + 1) : 1;
+	retry_rates = txdesc->retry + 1;
  
  	/*
  	 * Initialize TX status
@@ -265,13 +264,51 @@ void rt2x00lib_txdone(struct queue_entry *entry,
  	 * different rates to send out the frame, at each
  	 * retry it lowered the rate 1 step.
  	 */
-	for (i = 0; i < retry_rates && i < IEEE80211_TX_MAX_RATES; i++) {
-		tx_info->status.rates[i].idx = rate_idx - i;
-		tx_info->status.rates[i].flags = rate_flags;
-		tx_info->status.rates[i].count = 1;
+	if (test_bit(TXDONE_FALLBACK, &txdesc->flags)) {
+		/*
+		 * Fill in a multiple rate entries, ie frame was sent once at
+		 * each rates. We use rate_idx as an index into
+		 * rt2x00_supported_rates array. Since we can have up to 8
+		 * transmissions at different rates and since
+		 * IEEE80211_TX_MAX_RATES is only 5, the array can be
+		 * truncated.
+		 */
+		for (i = 0; (i < retry_rates) &&
+			    (i < IEEE80211_TX_MAX_RATES); i++) {
+			/*
+			 * check if we reach the lowest rates for this
+			 * modulation ie 1 Mbits for CCK and 6 Mbits for
+			 * OFDM.
+			 *
+			 * FIXME : This code needs to be checked for MCS
+			 */
+
+			int idx = rate_idx - i;
+			if ((idx == 0) /* 1 Mbits CCK rate index */ ||
+			(idx == 4) /* 6 Mbits OFDM rate index */) {
+				tx_info->status.rates[i].idx = idx;
+				tx_info->status.rates[i].flags = rate_flags;
+				tx_info->status.rates[i].count =
+							    retry_rates - i;
+				/* move to the next entry */
+				i++;
+				break;
+			} else {
+				tx_info->status.rates[i].idx = idx;
+				tx_info->status.rates[i].flags = rate_flags;
+				tx_info->status.rates[i].count = 1;
+			}
+		}
+		if (i < IEEE80211_TX_MAX_RATES)
+			tx_info->status.rates[i].idx = -1; /* terminate */
+	} else {
+		/* Fill in a single rate entry, ie frame was sent
+		 * (txdesc->retry+1) times at the same rate */
+		tx_info->status.rates[0].idx = rate_idx;
+		tx_info->status.rates[0].flags = rate_flags;
+		tx_info->status.rates[0].count = retry_rates;
+		tx_info->status.rates[1].idx = -1; /* terminate */
  	}
-	if (i < (IEEE80211_TX_MAX_RATES - 1))
-		tx_info->status.rates[i].idx = -1; /* terminate */
  
  	if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK)) {
  		if (success)
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index c1e482b..4e801c3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -214,7 +214,7 @@ struct rxdone_entry_desc {
   *
   * @TXDONE_UNKNOWN: Hardware could not determine success of transmission.
   * @TXDONE_SUCCESS: Frame was successfully send
- * @TXDONE_FALLBACK: Frame was successfully send using a fallback rate.
+ * @TXDONE_FALLBACK: Frame was sent using a fallback rate table.
   * @TXDONE_FAILURE: Frame was not successfully send
   * @TXDONE_EXCESSIVE_RETRY: In addition to &TXDONE_FAILURE, the
   *	frame transmission failed due to excessive retries.
@@ -234,7 +234,9 @@ enum txdone_entry_desc_flags {
   * after the device is done with transmission.
   *
   * @flags: TX done flags (See &enum txdone_entry_desc_flags).
- * @retry: Retry count.
+ * @retry: Retry count. If TXDONE_FALLBACK is not set, the frame was sent
+ * (retry+1) times at the same rate. If TXDONE_FALLBACK is set, the frame was
+ * sent once for each lower rates, up to (retry+1) times in total.
   */
  struct txdone_entry_desc {
  	unsigned long flags;
-- 
1.7.0

