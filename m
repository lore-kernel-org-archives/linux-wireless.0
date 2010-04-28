Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52375 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab0D1VBM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 17:01:12 -0400
From: cabtobma@tuxdriver.com
To: linux-wireless@vger.kernel.org
Cc: gwingerde@gmail.com, ivdoorn@gmail.com,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: remove now unused noise field from struct rxdone_entry_desc
Date: Wed, 28 Apr 2010 17:00:52 -0400
Message-Id: <1272488452-21288-1-git-send-email-cabtobma>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: John W. Linville <linville@tuxdriver.com>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c   |    4 ----
 drivers/net/wireless/rt2x00/rt2800usb.c   |    4 ----
 drivers/net/wireless/rt2x00/rt2x00queue.h |    2 --
 3 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 0e52f17..89281d7 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -895,10 +895,6 @@ static void rt2800pci_fill_rxdone(struct queue_entry *entry,
 	    (rt2x00_get_field32(rxwi2, RXWI_W2_RSSI0) +
 	     rt2x00_get_field32(rxwi2, RXWI_W2_RSSI1)) / 2;
 
-	rxdesc->noise =
-	    (rt2x00_get_field32(rxwi3, RXWI_W3_SNR0) +
-	     rt2x00_get_field32(rxwi3, RXWI_W3_SNR1)) / 2;
-
 	rxdesc->size = rt2x00_get_field32(rxwi0, RXWI_W0_MPDU_TOTAL_BYTE_COUNT);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index a716156..6f2a945 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -645,10 +645,6 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 	    (rt2x00_get_field32(rxwi2, RXWI_W2_RSSI0) +
 	     rt2x00_get_field32(rxwi2, RXWI_W2_RSSI1)) / 2;
 
-	rxdesc->noise =
-	    (rt2x00_get_field32(rxwi3, RXWI_W3_SNR0) +
-	     rt2x00_get_field32(rxwi3, RXWI_W3_SNR1)) / 2;
-
 	rxdesc->size = rt2x00_get_field32(rxwi0, RXWI_W0_MPDU_TOTAL_BYTE_COUNT);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index c1e482b..f519aba 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -183,7 +183,6 @@ enum rxdone_entry_desc_flags {
  * @timestamp: RX Timestamp
  * @signal: Signal of the received frame.
  * @rssi: RSSI of the received frame.
- * @noise: Measured noise during frame reception.
  * @size: Data size of the received frame.
  * @flags: MAC80211 receive flags (See &enum mac80211_rx_flags).
  * @dev_flags: Ralink receive flags (See &enum rxdone_entry_desc_flags).
@@ -197,7 +196,6 @@ struct rxdone_entry_desc {
 	u64 timestamp;
 	int signal;
 	int rssi;
-	int noise;
 	int size;
 	int flags;
 	int dev_flags;
-- 
1.6.6.1

