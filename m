Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:30801 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460AbYAFWmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 17:42:52 -0500
Received: by ug-out-1314.google.com with SMTP id z38so3071365ugc.16
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jan 2008 14:42:51 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/12] rt2x00: Cleanup write_tx_desc() arguments
Date: Sun, 6 Jan 2008 23:41:10 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200801062337.35904.IvDoorn@gmail.com>
In-Reply-To: <200801062337.35904.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801062341.10719.IvDoorn@gmail.com> (sfid-20080106_224256_377946_608335DB)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Send the skb structure with write_tx_desc() and use
the skbdesc structure to read all information about
the frame. This saves several arguments in the function
definition and it is easier to send more information
later as well.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    8 ++++----
 drivers/net/wireless/rt2x00/rt2500pci.c |    8 ++++----
 drivers/net/wireless/rt2x00/rt2500usb.c |    8 ++++----
 drivers/net/wireless/rt2x00/rt2x00.h    |    4 +---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    4 +---
 drivers/net/wireless/rt2x00/rt61pci.c   |   14 +++++++-------
 drivers/net/wireless/rt2x00/rt73usb.c   |   12 ++++++------
 7 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index b042eb5..ffc7e20 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1012,19 +1012,19 @@ static int rt2400pci_set_device_state(struct rt2x00_dev *rt2x00dev,
  * TX descriptor initialization
  */
 static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				    __le32 *txd,
+				    struct sk_buff *skb,
 				    struct txdata_entry_desc *desc,
-				    struct ieee80211_hdr *ieee80211hdr,
-				    unsigned int length,
 				    struct ieee80211_tx_control *control)
 {
+	struct skb_desc *skbdesc = get_skb_desc(skb);
+	__le32 *txd = skbdesc->desc;
 	u32 word;
 
 	/*
 	 * Start writing the descriptor words.
 	 */
 	rt2x00_desc_read(txd, 2, &word);
-	rt2x00_set_field32(&word, TXD_W2_DATABYTE_COUNT, length);
+	rt2x00_set_field32(&word, TXD_W2_DATABYTE_COUNT, skbdesc->data_len);
 	rt2x00_desc_write(txd, 2, word);
 
 	rt2x00_desc_read(txd, 3, &word);
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index c92163d..81a48e8 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1162,12 +1162,12 @@ static int rt2500pci_set_device_state(struct rt2x00_dev *rt2x00dev,
  * TX descriptor initialization
  */
 static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				    __le32 *txd,
+				    struct sk_buff *skb,
 				    struct txdata_entry_desc *desc,
-				    struct ieee80211_hdr *ieee80211hdr,
-				    unsigned int length,
 				    struct ieee80211_tx_control *control)
 {
+	struct skb_desc *skbdesc = get_skb_desc(skb);
+	__le32 *txd = skbdesc->desc;
 	u32 word;
 
 	/*
@@ -1208,7 +1208,7 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
 			   !!(control->flags &
 			      IEEE80211_TXCTL_LONG_RETRY_LIMIT));
-	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, length);
+	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skbdesc->data_len);
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, CIPHER_NONE);
 	rt2x00_desc_write(txd, 0, word);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 576f0f8..f136703 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1024,12 +1024,12 @@ static int rt2500usb_set_device_state(struct rt2x00_dev *rt2x00dev,
  * TX descriptor initialization
  */
 static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				    __le32 *txd,
+				    struct sk_buff *skb,
 				    struct txdata_entry_desc *desc,
-				    struct ieee80211_hdr *ieee80211hdr,
-				    unsigned int length,
 				    struct ieee80211_tx_control *control)
 {
+	struct skb_desc *skbdesc = get_skb_desc(skb);
+	__le32 *txd = skbdesc->desc;
 	u32 word;
 
 	/*
@@ -1062,7 +1062,7 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_NEW_SEQ,
 			   !!(control->flags & IEEE80211_TXCTL_FIRST_FRAGMENT));
 	rt2x00_set_field32(&word, TXD_W0_IFS, desc->ifs);
-	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, length);
+	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skbdesc->data_len);
 	rt2x00_set_field32(&word, TXD_W0_CIPHER, CIPHER_NONE);
 	rt2x00_desc_write(txd, 0, word);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 0dc880c..0795332 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -488,10 +488,8 @@ struct rt2x00lib_ops {
 	 * TX control handlers
 	 */
 	void (*write_tx_desc) (struct rt2x00_dev *rt2x00dev,
-			       __le32 *txd,
+			       struct sk_buff *skb,
 			       struct txdata_entry_desc *desc,
-			       struct ieee80211_hdr *ieee80211hdr,
-			       unsigned int length,
 			       struct ieee80211_tx_control *control);
 	int (*write_tx_data) (struct rt2x00_dev *rt2x00dev,
 			      struct data_ring *ring, struct sk_buff *skb,
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 911060d..a95cf53 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -601,7 +601,6 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	struct txdata_entry_desc desc;
 	struct skb_desc *skbdesc = get_skb_desc(skb);
 	struct ieee80211_hdr *ieee80211hdr = skbdesc->data;
-	__le32 *txd = skbdesc->desc;
 	int tx_rate;
 	int bitrate;
 	int length;
@@ -729,8 +728,7 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			desc.signal |= 0x08;
 	}
 
-	rt2x00dev->ops->lib->write_tx_desc(rt2x00dev, txd, &desc, ieee80211hdr,
-					   skbdesc->data_len, control);
+	rt2x00dev->ops->lib->write_tx_desc(rt2x00dev, skb, &desc, control);
 
 	/*
 	 * Update ring entry.
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 34bd90b..3080984 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1533,12 +1533,12 @@ static int rt61pci_set_device_state(struct rt2x00_dev *rt2x00dev,
  * TX descriptor initialization
  */
 static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				  __le32 *txd,
-				  struct txdata_entry_desc *desc,
-				  struct ieee80211_hdr *ieee80211hdr,
-				  unsigned int length,
-				  struct ieee80211_tx_control *control)
+				    struct sk_buff *skb,
+				    struct txdata_entry_desc *desc,
+				    struct ieee80211_tx_control *control)
 {
+	struct skb_desc *skbdesc = get_skb_desc(skb);
+	__le32 *txd = skbdesc->desc;
 	u32 word;
 
 	/*
@@ -1567,7 +1567,7 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_desc_write(txd, 5, word);
 
 	rt2x00_desc_read(txd, 11, &word);
-	rt2x00_set_field32(&word, TXD_W11_BUFFER_LENGTH0, length);
+	rt2x00_set_field32(&word, TXD_W11_BUFFER_LENGTH0, skbdesc->data_len);
 	rt2x00_desc_write(txd, 11, word);
 
 	rt2x00_desc_read(txd, 0, &word);
@@ -1586,7 +1586,7 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			   !!(control->flags &
 			      IEEE80211_TXCTL_LONG_RETRY_LIMIT));
 	rt2x00_set_field32(&word, TXD_W0_TKIP_MIC, 0);
-	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, length);
+	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skbdesc->data_len);
 	rt2x00_set_field32(&word, TXD_W0_BURST,
 			   test_bit(ENTRY_TXD_BURST, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, CIPHER_NONE);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index f2d1810..2982470 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1231,12 +1231,12 @@ static int rt73usb_set_device_state(struct rt2x00_dev *rt2x00dev,
  * TX descriptor initialization
  */
 static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				  __le32 *txd,
-				  struct txdata_entry_desc *desc,
-				  struct ieee80211_hdr *ieee80211hdr,
-				  unsigned int length,
-				  struct ieee80211_tx_control *control)
+				    struct sk_buff *skb,
+				    struct txdata_entry_desc *desc,
+				    struct ieee80211_tx_control *control)
 {
+	struct skb_desc *skbdesc = get_skb_desc(skb);
+	__le32 *txd = skbdesc->desc;
 	u32 word;
 
 	/*
@@ -1281,7 +1281,7 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			   !!(control->flags &
 			      IEEE80211_TXCTL_LONG_RETRY_LIMIT));
 	rt2x00_set_field32(&word, TXD_W0_TKIP_MIC, 0);
-	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, length);
+	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skbdesc->data_len);
 	rt2x00_set_field32(&word, TXD_W0_BURST2,
 			   test_bit(ENTRY_TXD_BURST, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, CIPHER_NONE);
-- 
1.5.3.7

