Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:21084 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbYEJMKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 08:10:05 -0400
Received: by nf-out-0910.google.com with SMTP id d3so883147nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 05:10:04 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 08/16] rt2x00: Remove ieee80211_tx_control argument from write_tx_desc()
Date: Sat, 10 May 2008 13:42:31 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805101337.14536.IvDoorn@gmail.com>
In-Reply-To: <200805101337.14536.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805101342.31362.IvDoorn@gmail.com> (sfid-20080510_141022_103636_0798AF5A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the last remaining information details read from ieee80211_tx_control
in the drivers to the txentry_desc structure. After this we can
remove ieee80211_tx_control from the argument list for the callback function,
which makes it easier when the control information is moved into skb->cb

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |    6 ++----
 drivers/net/wireless/rt2x00/rt2500pci.c   |    7 ++-----
 drivers/net/wireless/rt2x00/rt2500usb.c   |    7 +++----
 drivers/net/wireless/rt2x00/rt2x00.h      |    3 +--
 drivers/net/wireless/rt2x00/rt2x00dev.c   |   19 ++++++++++++++-----
 drivers/net/wireless/rt2x00/rt2x00queue.h |   14 ++++++++++----
 drivers/net/wireless/rt2x00/rt61pci.c     |    6 ++----
 drivers/net/wireless/rt2x00/rt73usb.c     |    6 ++----
 8 files changed, 36 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 15cf224..a8aae9a 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1001,8 +1001,7 @@ static int rt2400pci_set_device_state(struct rt2x00_dev *rt2x00dev,
  */
 static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct sk_buff *skb,
-				    struct txentry_desc *txdesc,
-				    struct ieee80211_tx_control *control)
+				    struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
 	__le32 *txd = skbdesc->desc;
@@ -1046,8 +1045,7 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			   test_bit(ENTRY_TXD_RTS_FRAME, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
-			   !!(control->flags &
-			      IEEE80211_TXCTL_LONG_RETRY_LIMIT));
++			   test_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags));
 	rt2x00_desc_write(txd, 0, word);
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 234b5b7..1f99fad 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1155,8 +1155,7 @@ static int rt2500pci_set_device_state(struct rt2x00_dev *rt2x00dev,
  */
 static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct sk_buff *skb,
-				    struct txentry_desc *txdesc,
-				    struct ieee80211_tx_control *control)
+				    struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
 	__le32 *txd = skbdesc->desc;
@@ -1198,9 +1197,7 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_OWNER, 1);
 	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
-			   !!(control->flags &
-			      IEEE80211_TXCTL_LONG_RETRY_LIMIT));
-	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skbdesc->data_len);
+			   test_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, CIPHER_NONE);
 	rt2x00_desc_write(txd, 0, word);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 80b34d4..76ede93 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1033,8 +1033,7 @@ static int rt2500usb_set_device_state(struct rt2x00_dev *rt2x00dev,
  */
 static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct sk_buff *skb,
-				    struct txentry_desc *txdesc,
-				    struct ieee80211_tx_control *control)
+				    struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
 	__le32 *txd = skbdesc->desc;
@@ -1058,7 +1057,7 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_desc_write(txd, 2, word);
 
 	rt2x00_desc_read(txd, 0, &word);
-	rt2x00_set_field32(&word, TXD_W0_RETRY_LIMIT, control->retry_limit);
+	rt2x00_set_field32(&word, TXD_W0_RETRY_LIMIT, txdesc->retry_limit);
 	rt2x00_set_field32(&word, TXD_W0_MORE_FRAG,
 			   test_bit(ENTRY_TXD_MORE_FRAG, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_ACK,
@@ -1068,7 +1067,7 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_OFDM,
 			   test_bit(ENTRY_TXD_OFDM_RATE, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_NEW_SEQ,
-			   !!(control->flags & IEEE80211_TXCTL_FIRST_FRAGMENT));
+			   test_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
 	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skbdesc->data_len);
 	rt2x00_set_field32(&word, TXD_W0_CIPHER, CIPHER_NONE);
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 79bd9c9..6561484 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -540,8 +540,7 @@ struct rt2x00lib_ops {
 	 */
 	void (*write_tx_desc) (struct rt2x00_dev *rt2x00dev,
 			       struct sk_buff *skb,
-			       struct txentry_desc *txdesc,
-			       struct ieee80211_tx_control *control);
+			       struct txentry_desc *txdesc);
 	int (*write_tx_data) (struct rt2x00_dev *rt2x00dev,
 			      struct data_queue *queue, struct sk_buff *skb,
 			      struct ieee80211_tx_control *control);
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index acc22df..8ca464f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -664,7 +664,12 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			tx_rate = control->rts_cts_rate->hw_value;
 	}
 
-	rate = rt2x00_get_rate(tx_rate);
+	/*
+	 * Determine retry information.
+	 */
+	txdesc.retry_limit = control->retry_limit;
+	if (control->flags & IEEE80211_TXCTL_LONG_RETRY_LIMIT)
+		__set_bit(ENTRY_TXD_RETRY_MODE, &txdesc.flags);
 
 	/*
 	 * Check if more fragments are pending
@@ -686,16 +691,20 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 * Set ifs to IFS_SIFS when the this is not the first fragment,
 	 * or this fragment came after RTS/CTS.
 	 */
-	if ((seq_ctrl & IEEE80211_SCTL_FRAG) > 0 ||
-	    test_bit(ENTRY_TXD_RTS_FRAME, &txdesc.flags))
+	if (test_bit(ENTRY_TXD_RTS_FRAME, &txdesc.flags)) {
 		txdesc.ifs = IFS_SIFS;
-	else
+	} else if (control->flags & IEEE80211_TXCTL_FIRST_FRAGMENT) {
+		__set_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc.flags);
 		txdesc.ifs = IFS_BACKOFF;
+	} else {
+		txdesc.ifs = IFS_SIFS;
+	}
 
 	/*
 	 * PLCP setup
 	 * Length calculation depends on OFDM/CCK rate.
 	 */
+	rate = rt2x00_get_rate(tx_rate);
 	txdesc.signal = rate->plcp;
 	txdesc.service = 0x04;
 
@@ -733,7 +742,7 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			txdesc.signal |= 0x08;
 	}
 
-	rt2x00dev->ops->lib->write_tx_desc(rt2x00dev, skb, &txdesc, control);
+	rt2x00dev->ops->lib->write_tx_desc(rt2x00dev, skb, &txdesc);
 
 	/*
 	 * Update queue entry.
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index f361f78..3f7cfa9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -204,18 +204,22 @@ struct txdone_entry_desc {
  *
  * @ENTRY_TXD_RTS_FRAME: This frame is a RTS frame.
  * @ENTRY_TXD_OFDM_RATE: This frame is send out with an OFDM rate.
+ * @ENTRY_TXD_FIRST_FRAGMENT: This is the first frame.
  * @ENTRY_TXD_MORE_FRAG: This frame is followed by another fragment.
  * @ENTRY_TXD_REQ_TIMESTAMP: Require timestamp to be inserted.
  * @ENTRY_TXD_BURST: This frame belongs to the same burst event.
  * @ENTRY_TXD_ACK: An ACK is required for this frame.
+ * @ENTRY_TXD_RETRY_MODE: When set, the long retry count is used.
  */
 enum txentry_desc_flags {
 	ENTRY_TXD_RTS_FRAME,
 	ENTRY_TXD_OFDM_RATE,
+	ENTRY_TXD_FIRST_FRAGMENT,
 	ENTRY_TXD_MORE_FRAG,
 	ENTRY_TXD_REQ_TIMESTAMP,
 	ENTRY_TXD_BURST,
 	ENTRY_TXD_ACK,
+	ENTRY_TXD_RETRY_MODE,
 };
 
 /**
@@ -229,6 +233,7 @@ enum txentry_desc_flags {
  * @length_low: PLCP length low word.
  * @signal: PLCP signal.
  * @service: PLCP service.
+ * @retry_limit: Max number of retries.
  * @aifs: AIFS value.
  * @ifs: IFS value.
  * @cw_min: cwmin value.
@@ -244,10 +249,11 @@ struct txentry_desc {
 	u16 signal;
 	u16 service;
 
-	int aifs;
-	int ifs;
-	int cw_min;
-	int cw_max;
+	short retry_limit;
+	short aifs;
+	short ifs;
+	short cw_min;
+	short cw_max;
 };
 
 /**
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 907e67b..f42d1cc 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1526,8 +1526,7 @@ static int rt61pci_set_device_state(struct rt2x00_dev *rt2x00dev,
  */
 static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct sk_buff *skb,
-				    struct txentry_desc *txdesc,
-				    struct ieee80211_tx_control *control)
+				    struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
 	__le32 *txd = skbdesc->desc;
@@ -1577,8 +1576,7 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			   test_bit(ENTRY_TXD_OFDM_RATE, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
-			   !!(control->flags &
-			      IEEE80211_TXCTL_LONG_RETRY_LIMIT));
+			   test_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_TKIP_MIC, 0);
 	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skbdesc->data_len);
 	rt2x00_set_field32(&word, TXD_W0_BURST,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 351d95c..ceb3438 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1255,8 +1255,7 @@ static int rt73usb_set_device_state(struct rt2x00_dev *rt2x00dev,
  */
 static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct sk_buff *skb,
-				    struct txentry_desc *txdesc,
-				    struct ieee80211_tx_control *control)
+				    struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
 	__le32 *txd = skbdesc->desc;
@@ -1301,8 +1300,7 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			   test_bit(ENTRY_TXD_OFDM_RATE, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
-			   !!(control->flags &
-			      IEEE80211_TXCTL_LONG_RETRY_LIMIT));
+			   test_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_TKIP_MIC, 0);
 	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skbdesc->data_len);
 	rt2x00_set_field32(&word, TXD_W0_BURST2,
-- 
1.5.5.1

