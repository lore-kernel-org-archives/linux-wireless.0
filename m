Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:43317 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbYLTKCQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 05:02:16 -0500
Received: by mail-ew0-f17.google.com with SMTP id 10so1457082ewy.13
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2008 02:02:15 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 11/15] rt2x00: Remove ENTRY_TXD_OFDM_RATE
Date: Sat, 20 Dec 2008 10:59:02 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200812201052.00655.IvDoorn@gmail.com> <200812201057.47712.IvDoorn@gmail.com> <200812201058.33821.IvDoorn@gmail.com>
In-Reply-To: <200812201058.33821.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812201059.02959.IvDoorn@gmail.com> (sfid-20081220_110900_878006_8BE55E2C)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The flag ENTRY_TXD_OFDM_RATE isn't flexible enough
to indicate which rate modulation should be used for
a frame. This will become a problem when 11n support
is added.

Remove the flag and replace it with an enum value which
can better indicate the exact rate modulation.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500pci.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c |    6 +++++-
 drivers/net/wireless/rt2x00/rt2x00queue.h |    5 +++--
 drivers/net/wireless/rt2x00/rt2x00reg.h   |   10 ++++++++++
 drivers/net/wireless/rt2x00/rt61pci.c     |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c     |    2 +-
 7 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 90333ee..76f016d 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1233,7 +1233,7 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
 			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_OFDM,
-			   test_bit(ENTRY_TXD_OFDM_RATE, &txdesc->flags));
+			   (txdesc->rate_mode == RATE_MODE_OFDM));
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_OWNER, 1);
 	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 8a53f9b..81400ea 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1217,7 +1217,7 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
 			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_OFDM,
-			   test_bit(ENTRY_TXD_OFDM_RATE, &txdesc->flags));
+			   (txdesc->rate_mode == RATE_MODE_OFDM));
 	rt2x00_set_field32(&word, TXD_W0_NEW_SEQ,
 			   test_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index efb2875..fc28e23 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -313,9 +313,13 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	} else
 		txdesc->ifs = IFS_SIFS;
 
+	/*
+	 * Determine rate modulation.
+	 */
 	hwrate = rt2x00_get_rate(rate->hw_value);
+	txdesc->rate_mode = RATE_MODE_CCK;
 	if (hwrate->flags & DEV_RATE_OFDM)
-		__set_bit(ENTRY_TXD_OFDM_RATE, &txdesc->flags);
+		txdesc->rate_mode = RATE_MODE_OFDM;
 
 	/*
 	 * Apply TX descriptor handling by components
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 2829371..5a9d2c3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -222,7 +222,6 @@ struct txdone_entry_desc {
  *
  * @ENTRY_TXD_RTS_FRAME: This frame is a RTS frame.
  * @ENTRY_TXD_CTS_FRAME: This frame is a CTS-to-self frame.
- * @ENTRY_TXD_OFDM_RATE: This frame is send out with an OFDM rate.
  * @ENTRY_TXD_GENERATE_SEQ: This frame requires sequence counter.
  * @ENTRY_TXD_FIRST_FRAGMENT: This is the first frame.
  * @ENTRY_TXD_MORE_FRAG: This frame is followed by another fragment.
@@ -238,7 +237,6 @@ struct txdone_entry_desc {
 enum txentry_desc_flags {
 	ENTRY_TXD_RTS_FRAME,
 	ENTRY_TXD_CTS_FRAME,
-	ENTRY_TXD_OFDM_RATE,
 	ENTRY_TXD_GENERATE_SEQ,
 	ENTRY_TXD_FIRST_FRAGMENT,
 	ENTRY_TXD_MORE_FRAG,
@@ -263,6 +261,7 @@ enum txentry_desc_flags {
  * @length_low: PLCP length low word.
  * @signal: PLCP signal.
  * @service: PLCP service.
+ * @rate_mode: Rate mode (See @enum rate_modulation).
  * @retry_limit: Max number of retries.
  * @aifs: AIFS value.
  * @ifs: IFS value.
@@ -282,6 +281,8 @@ struct txentry_desc {
 	u16 signal;
 	u16 service;
 
+	u16 rate_mode;
+
 	short retry_limit;
 	short aifs;
 	short ifs;
diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index c2fba7c..93f8427 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -125,6 +125,16 @@ enum cipher {
 };
 
 /*
+ * Rate modulations
+ */
+enum rate_modulation {
+	RATE_MODE_CCK = 0,
+	RATE_MODE_OFDM = 1,
+	RATE_MODE_HT_MIX = 2,
+	RATE_MODE_HT_GREENFIELD = 3,
+};
+
+/*
  * Register handlers.
  * We store the position of a register field inside a field structure,
  * This will simplify the process of setting and reading a certain field
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 875acb3..f1150a7 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1847,7 +1847,7 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
 			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_OFDM,
-			   test_bit(ENTRY_TXD_OFDM_RATE, &txdesc->flags));
+			   (txdesc->rate_mode == RATE_MODE_OFDM));
 	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
 			   test_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags));
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 2268d5c..891554e 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1498,7 +1498,7 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
 			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_OFDM,
-			   test_bit(ENTRY_TXD_OFDM_RATE, &txdesc->flags));
+			   (txdesc->rate_mode == RATE_MODE_OFDM));
 	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
 			   test_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags));
-- 
1.5.6.1

