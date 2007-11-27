Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:23631 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbXK0Tjl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 14:39:41 -0500
Received: by ug-out-1314.google.com with SMTP id z38so1321058ugc
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 11:39:40 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/11] rt2x00: Extend PLCP descriptor definition for rt2400pci
Date: Tue, 27 Nov 2007 21:47:56 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200711272146.53518.IvDoorn@gmail.com>
In-Reply-To: <200711272146.53518.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711272147.57024.IvDoorn@gmail.com> (sfid-20071127_194249_301923_3634E0DA)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extend word field definitions for the PLCP words
in the TX descriptor to contain the BBP fields as well.
This will remove rt2400pci_write_tx_desc() from the
checkstack script.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |   40 +++++++++---------------------
 drivers/net/wireless/rt2x00/rt2400pci.h |   20 +++++++++++----
 2 files changed, 27 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 6d3cdaf..c9a234f 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1019,30 +1019,6 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct ieee80211_tx_control *control)
 {
 	u32 word;
-	u32 signal = 0;
-	u32 service = 0;
-	u32 length_high = 0;
-	u32 length_low = 0;
-
-	/*
-	 * The PLCP values should be treated as if they
-	 * were BBP values.
-	 */
-	rt2x00_set_field32(&signal, BBPCSR_VALUE, desc->signal);
-	rt2x00_set_field32(&signal, BBPCSR_REGNUM, 5);
-	rt2x00_set_field32(&signal, BBPCSR_BUSY, 1);
-
-	rt2x00_set_field32(&service, BBPCSR_VALUE, desc->service);
-	rt2x00_set_field32(&service, BBPCSR_REGNUM, 6);
-	rt2x00_set_field32(&service, BBPCSR_BUSY, 1);
-
-	rt2x00_set_field32(&length_high, BBPCSR_VALUE, desc->length_high);
-	rt2x00_set_field32(&length_high, BBPCSR_REGNUM, 7);
-	rt2x00_set_field32(&length_high, BBPCSR_BUSY, 1);
-
-	rt2x00_set_field32(&length_low, BBPCSR_VALUE, desc->length_low);
-	rt2x00_set_field32(&length_low, BBPCSR_REGNUM, 8);
-	rt2x00_set_field32(&length_low, BBPCSR_BUSY, 1);
 
 	/*
 	 * Start writing the descriptor words.
@@ -1052,13 +1028,21 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_desc_write(txd, 2, word);
 
 	rt2x00_desc_read(txd, 3, &word);
-	rt2x00_set_field32(&word, TXD_W3_PLCP_SIGNAL, signal);
-	rt2x00_set_field32(&word, TXD_W3_PLCP_SERVICE, service);
+	rt2x00_set_field32(&word, TXD_W3_PLCP_SIGNAL, desc->signal);
+	rt2x00_set_field32(&word, TXD_W3_PLCP_SIGNAL_REGNUM, 5);
+	rt2x00_set_field32(&word, TXD_W3_PLCP_SIGNAL_BUSY, 1);
+	rt2x00_set_field32(&word, TXD_W3_PLCP_SERVICE, desc->service);
+	rt2x00_set_field32(&word, TXD_W3_PLCP_SERVICE_REGNUM, 6);
+	rt2x00_set_field32(&word, TXD_W3_PLCP_SERVICE_BUSY, 1);
 	rt2x00_desc_write(txd, 3, word);
 
 	rt2x00_desc_read(txd, 4, &word);
-	rt2x00_set_field32(&word, TXD_W4_PLCP_LENGTH_LOW, length_low);
-	rt2x00_set_field32(&word, TXD_W4_PLCP_LENGTH_HIGH, length_high);
+	rt2x00_set_field32(&word, TXD_W4_PLCP_LENGTH_LOW, desc->length_low);
+	rt2x00_set_field32(&word, TXD_W3_PLCP_LENGTH_LOW_REGNUM, 8);
+	rt2x00_set_field32(&word, TXD_W3_PLCP_LENGTH_LOW_BUSY, 1);
+	rt2x00_set_field32(&word, TXD_W4_PLCP_LENGTH_HIGH, desc->length_high);
+	rt2x00_set_field32(&word, TXD_W3_PLCP_LENGTH_HIGH_REGNUM, 7);
+	rt2x00_set_field32(&word, TXD_W3_PLCP_LENGTH_HIGH_BUSY, 1);
 	rt2x00_desc_write(txd, 4, word);
 
 	rt2x00_desc_read(txd, 0, &word);
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
index f5dbde7..369aac6 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -839,11 +839,21 @@
 
 /*
  * Word3 & 4: PLCP information
- */
-#define TXD_W3_PLCP_SIGNAL		FIELD32(0x0000ffff)
-#define TXD_W3_PLCP_SERVICE		FIELD32(0xffff0000)
-#define TXD_W4_PLCP_LENGTH_LOW		FIELD32(0x0000ffff)
-#define TXD_W4_PLCP_LENGTH_HIGH		FIELD32(0xffff0000)
+ * The PLCP values should be treated as if they were BBP values.
+ */
+#define TXD_W3_PLCP_SIGNAL		FIELD32(0x000000ff)
+#define TXD_W3_PLCP_SIGNAL_REGNUM	FIELD32(0x00007f00)
+#define TXD_W3_PLCP_SIGNAL_BUSY		FIELD32(0x00008000)
+#define TXD_W3_PLCP_SERVICE		FIELD32(0x00ff0000)
+#define TXD_W3_PLCP_SERVICE_REGNUM	FIELD32(0x7f000000)
+#define TXD_W3_PLCP_SERVICE_BUSY	FIELD32(0x80000000)
+
+#define TXD_W4_PLCP_LENGTH_LOW		FIELD32(0x000000ff)
+#define TXD_W3_PLCP_LENGTH_LOW_REGNUM	FIELD32(0x00007f00)
+#define TXD_W3_PLCP_LENGTH_LOW_BUSY	FIELD32(0x00008000)
+#define TXD_W4_PLCP_LENGTH_HIGH		FIELD32(0x00ff0000)
+#define TXD_W3_PLCP_LENGTH_HIGH_REGNUM	FIELD32(0x7f000000)
+#define TXD_W3_PLCP_LENGTH_HIGH_BUSY	FIELD32(0x80000000)
 
 /*
  * Word5
-- 
1.5.3.6

