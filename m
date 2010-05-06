Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:52386 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab0EFKaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 06:30:10 -0400
Received: by mail-bw0-f219.google.com with SMTP id 19so400457bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 06 May 2010 03:30:10 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 3/3] rt2x00: rt2800: use correct txop value in tx descriptor
Date: Thu, 6 May 2010 12:29:58 +0200
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201005061229.58509.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2800 devices use a different enumeration to specify what IFS values should
be used on frame transmission compared to the other rt2x00 devices. Hence,
create a new enum called txop that contains the valid values.

Furthermore use TXOP_HTTXOP as default on HT devices which means that the
hardware should select the correct IFS value on its own.

I'm not sure if we have the need to specify one of the other txop values
in the future but as far as I could see TXOP_HTTXOP is used by the Ralink
drivers for all normal data frames and should be a reasonable default.

This patch doesn't really fix anything as until now the IFS_BACKOFF(=0)
value was used as txop which luckily mapped to TXOP_HTTXOP(=0).

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00ht.c    |    2 ++
 drivers/net/wireless/rt2x00/rt2x00queue.h |    2 ++
 drivers/net/wireless/rt2x00/rt2x00reg.h   |   10 ++++++++++
 5 files changed, 16 insertions(+), 2 deletions(-)

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
index 1056c92..5483fec 100644
--- a/drivers/net/wireless/rt2x00/rt2x00ht.c
+++ b/drivers/net/wireless/rt2x00/rt2x00ht.c
@@ -66,4 +66,6 @@ void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
 		__set_bit(ENTRY_TXD_HT_BW_40, &txdesc->flags);
 	if (txrate->flags & IEEE80211_TX_RC_SHORT_GI)
 		__set_bit(ENTRY_TXD_HT_SHORT_GI, &txdesc->flags);
+
+	txdesc->txop = TXOP_HTTXOP;
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
index 603bfc0..894ff78 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -101,6 +101,16 @@ enum ifs {
 };
 
 /*
+ * IFS values for HT devices
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

