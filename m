Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45314 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab0EGJDW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 May 2010 05:03:22 -0400
Received: by fxm10 with SMTP id 10so600144fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 May 2010 02:03:20 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCHv2] rt2x00: rt2800: use correct txop value in tx descriptor
Date: Fri, 7 May 2010 11:03:08 +0200
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201005071103.08186.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2800 devices use a different enumeration to specify what IFS values should
be used on frame transmission compared to the other rt2x00 devices. Hence,
create a new enum called txop that contains the valid values.

Furthermore use the appropriate txop values as found in the ralink drivers:
- TXOP_BACKOFF for management frames
- TXOP_SIFS for subsequent fragments in a burst
- TXOP_HTTXOP for all data frames

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00ht.c    |   17 +++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00queue.h |    2 ++
 drivers/net/wireless/rt2x00/rt2x00reg.h   |   10 ++++++++++
 5 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index f08b6a3..df2c3fb 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -643,7 +643,7 @@ static int rt2800pci_write_tx_data(struct queue_entry* entry,
 	rt2x00_set_field32(&word, TXWI_W0_AMPDU,
 			   test_bit(ENTRY_TXD_HT_AMPDU, &txdesc->flags));
 	rt2x00_set_field32(&word, TXWI_W0_MPDU_DENSITY, txdesc->mpdu_density);
-	rt2x00_set_field32(&word, TXWI_W0_TX_OP, txdesc->ifs);
+	rt2x00_set_field32(&word, TXWI_W0_TX_OP, txdesc->txop);
 	rt2x00_set_field32(&word, TXWI_W0_MCS, txdesc->mcs);
 	rt2x00_set_field32(&word, TXWI_W0_BW,
 			   test_bit(ENTRY_TXD_HT_BW_40, &txdesc->flags));
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index e3f3a97..c9e1320 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -417,7 +417,7 @@ static void rt2800usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXWI_W0_AMPDU,
 			   test_bit(ENTRY_TXD_HT_AMPDU, &txdesc->flags));
 	rt2x00_set_field32(&word, TXWI_W0_MPDU_DENSITY, txdesc->mpdu_density);
-	rt2x00_set_field32(&word, TXWI_W0_TX_OP, txdesc->ifs);
+	rt2x00_set_field32(&word, TXWI_W0_TX_OP, txdesc->txop);
 	rt2x00_set_field32(&word, TXWI_W0_MCS, txdesc->mcs);
 	rt2x00_set_field32(&word, TXWI_W0_BW,
 			   test_bit(ENTRY_TXD_HT_BW_40, &txdesc->flags));
diff --git a/drivers/net/wireless/rt2x00/rt2x00ht.c b/drivers/net/wireless/rt2x00/rt2x00ht.c
index 1056c92..5a40760 100644
--- a/drivers/net/wireless/rt2x00/rt2x00ht.c
+++ b/drivers/net/wireless/rt2x00/rt2x00ht.c
@@ -35,6 +35,7 @@ void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
 	struct ieee80211_tx_rate *txrate = &tx_info->control.rates[0];
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)entry->skb->data;
 
 	if (tx_info->control.sta)
 		txdesc->mpdu_density =
@@ -66,4 +67,20 @@ void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
 		__set_bit(ENTRY_TXD_HT_BW_40, &txdesc->flags);
 	if (txrate->flags & IEEE80211_TX_RC_SHORT_GI)
 		__set_bit(ENTRY_TXD_HT_SHORT_GI, &txdesc->flags);
+
+	/*
+	 * Determine IFS values
+	 * - Use TXOP_BACKOFF for management frames
+	 * - Use TXOP_SIFS for fragment bursts
+	 * - Use TXOP_HTTXOP for everything else
+	 *
+	 * Note: rt2800 devices won't use CTS protection (if used)
+	 * for frames not transmitted with TXOP_HTTXOP
+	 */
+	if (ieee80211_is_mgmt(hdr->frame_control))
+		txdesc->txop = TXOP_BACKOFF;
+	else if (!(tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT))
+		txdesc->txop = TXOP_SIFS;
+	else
+		txdesc->txop = TXOP_HTTXOP;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 94a48c1..36a957a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -299,6 +299,7 @@ enum txentry_desc_flags {
  * @retry_limit: Max number of retries.
  * @aifs: AIFS value.
  * @ifs: IFS value.
+ * @txop: IFS value for 11n capable chips.
  * @cw_min: cwmin value.
  * @cw_max: cwmax value.
  * @cipher: Cipher type used for encryption.
@@ -328,6 +329,7 @@ struct txentry_desc {
 	short retry_limit;
 	short aifs;
 	short ifs;
+	short txop;
 	short cw_min;
 	short cw_max;
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index 603bfc0..b9fe948 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -101,6 +101,16 @@ enum ifs {
 };
 
 /*
+ * IFS backoff values for HT devices
+ */
+enum txop {
+	TXOP_HTTXOP = 0,
+	TXOP_PIFS = 1,
+	TXOP_SIFS = 2,
+	TXOP_BACKOFF = 3,
+};
+
+/*
  * Cipher types for hardware encryption
  */
 enum cipher {
-- 
1.6.4.2

