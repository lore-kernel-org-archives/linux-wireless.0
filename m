Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp101.plus.mail.re1.yahoo.com ([69.147.102.64]:35014 "HELO
	smtp101.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030223Ab0B1QOo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 11:14:44 -0500
Message-ID: <4B8A9670.1080906@yahoo.com>
Date: Sun, 28 Feb 2010 17:14:40 +0100
From: Alban Browaeys <prahal@yahoo.com>
Reply-To: prahal@yahoo.com
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: Gertjan van Wingerde <gwingerde@gmail.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	Josef Bacik <josef@redhat.com>
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

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
Signed-off-by: Alban Browaeys <prahal@yahoo.com>
---

This patch applies above : "rt2x00: txdone implementation supporting hw encryption."
This is  trimmed down compared to the previous version. It removes anything not specific to rt2800pci
as the why notes were lost I kept only the fix and not the more in depth rewrite.

  drivers/net/wireless/rt2x00/rt2800pci.c |   40 +++++++++++++++++++-----------
  1 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 7049c74..316beb0 100644
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
-- 
1.7.0

