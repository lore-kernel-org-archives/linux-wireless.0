Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:55730 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbXGYUsl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 16:48:41 -0400
Received: by ug-out-1314.google.com with SMTP id j3so420021ugf
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2007 13:48:40 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/11] rt2x00: Check for all errors on RXdone
Date: Wed, 25 Jul 2007 22:50:24 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707252250.24979.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 8f5bae2d78ddbd758762db4bf4910f58a722c067 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Tue, 24 Jul 2007 21:45:27 +0200
Subject: [PATCH 09/11] rt2x00: Check for all errors on RXdone

Make sure the CIPHER_ERRORS are also checked
when rxdone statistics are being read.
Rename CRC -> CRC_ERROR because that sounds more logical.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/mac80211/rt2x00/rt2400pci.c |    2 +-
 drivers/net/wireless/mac80211/rt2x00/rt2400pci.h |    2 +-
 drivers/net/wireless/mac80211/rt2x00/rt2500pci.c |    5 +++--
 drivers/net/wireless/mac80211/rt2x00/rt2500pci.h |    2 +-
 drivers/net/wireless/mac80211/rt2x00/rt2500usb.c |    5 +++--
 drivers/net/wireless/mac80211/rt2x00/rt2500usb.h |    4 ++--
 drivers/net/wireless/mac80211/rt2x00/rt61pci.c   |    2 +-
 drivers/net/wireless/mac80211/rt2x00/rt61pci.h   |    2 +-
 drivers/net/wireless/mac80211/rt2x00/rt73usb.c   |    2 +-
 drivers/net/wireless/mac80211/rt2x00/rt73usb.h   |    2 +-
 10 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index 62d742c..a69e0f6 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -1163,7 +1163,7 @@ static int rt2400pci_fill_rxdone(struct data_entry *entry,
 	 * TODO: Don't we need to keep statistics
 	 * updated about these errors?
 	 */
-	if (rt2x00_get_field32(word0, RXD_W0_CRC) ||
+	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR) ||
 	    rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR))
 		return -EINVAL;
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
index 7fac8ba..f3382c1 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
@@ -875,7 +875,7 @@
 #define RXD_W0_MULTICAST		FIELD32(0x00000004)
 #define RXD_W0_BROADCAST		FIELD32(0x00000008)
 #define RXD_W0_MY_BSS			FIELD32(0x00000010)
-#define RXD_W0_CRC			FIELD32(0x00000020)
+#define RXD_W0_CRC_ERROR		FIELD32(0x00000020)
 #define RXD_W0_PHYSICAL_ERROR		FIELD32(0x00000080)
 #define RXD_W0_DATABYTE_COUNT		FIELD32(0xffff0000)
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 3aa4e5f..7649d69 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -1313,8 +1313,9 @@ static int rt2500pci_fill_rxdone(struct data_entry *entry,
 	 * TODO: Don't we need to keep statistics
 	 * updated about these errors?
 	 */
-	if (rt2x00_get_field32(word0, RXD_W0_CRC) ||
-	    rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR))
+	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR) ||
+	    rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR) ||
+	    rt2x00_get_field32(word0, RXD_W0_ICV_ERROR))
 		return -EINVAL;
 
 	*signal = rt2x00_get_field32(word2, RXD_W2_SIGNAL);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
index 80abf95..556f896 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
@@ -1143,7 +1143,7 @@
 #define RXD_W0_MULTICAST		FIELD32(0x00000004)
 #define RXD_W0_BROADCAST		FIELD32(0x00000008)
 #define RXD_W0_MY_BSS			FIELD32(0x00000010)
-#define RXD_W0_CRC			FIELD32(0x00000020)
+#define RXD_W0_CRC_ERROR		FIELD32(0x00000020)
 #define RXD_W0_OFDM			FIELD32(0x00000040)
 #define RXD_W0_PHYSICAL_ERROR		FIELD32(0x00000080)
 #define RXD_W0_CIPHER_OWNER		FIELD32(0x00000100)
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index aa63b6d..2ac3ec3 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -1093,8 +1093,9 @@ static int rt2500usb_fill_rxdone(struct data_entry *entry,
 	 * TODO: Don't we need to keep statistics
 	 * updated about these errors?
 	 */
-	if (rt2x00_get_field32(word0, RXD_W0_CRC) ||
-	    rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR))
+	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR) ||
+	    rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR) ||
+	    rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR))
 		return -EINVAL;
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
index fba7674..88a20aa 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
@@ -701,11 +701,11 @@
 #define RXD_W0_MULTICAST		FIELD32(0x00000004)
 #define RXD_W0_BROADCAST		FIELD32(0x00000008)
 #define RXD_W0_MY_BSS			FIELD32(0x00000010)
-#define RXD_W0_CRC			FIELD32(0x00000020)
+#define RXD_W0_CRC_ERROR		FIELD32(0x00000020)
 #define RXD_W0_OFDM			FIELD32(0x00000040)
 #define RXD_W0_PHYSICAL_ERROR		FIELD32(0x00000080)
 #define RXD_W0_CIPHER			FIELD32(0x00000100)
-#define RXD_W0_CI_ERROR			FIELD32(0x00000200)
+#define RXD_W0_CIPHER_ERROR		FIELD32(0x00000200)
 #define RXD_W0_DATABYTE_COUNT		FIELD32(0x0fff0000)
 
 /*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 937b120..4d50f95 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -1745,7 +1745,7 @@ static int rt61pci_fill_rxdone(struct data_entry *entry,
 	 * TODO: Don't we need to keep statistics
 	 * updated about these errors?
 	 */
-	if (rt2x00_get_field32(word0, RXD_W0_CRC) ||
+	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR) ||
 	    rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR))
 		return -EINVAL;
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.h b/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
index 2c23911..1286391 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
@@ -1298,7 +1298,7 @@ struct hw_pairwise_ta_entry {
 #define RXD_W0_MULTICAST		FIELD32(0x00000008)
 #define RXD_W0_BROADCAST		FIELD32(0x00000010)
 #define RXD_W0_MY_BSS			FIELD32(0x00000020)
-#define RXD_W0_CRC			FIELD32(0x00000040)
+#define RXD_W0_CRC_ERROR		FIELD32(0x00000040)
 #define RXD_W0_OFDM			FIELD32(0x00000080)
 #define RXD_W0_CIPHER_ERROR		FIELD32(0x00000300)
 #define RXD_W0_KEY_INDEX		FIELD32(0x0000fc00)
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 3505bf6..60166b2 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -1344,7 +1344,7 @@ static int rt73usb_fill_rxdone(struct data_entry *entry,
 	 * TODO: Don't we need to keep statistics
 	 * updated about these errors?
 	 */
-	if (rt2x00_get_field32(word0, RXD_W0_CRC) ||
+	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR) ||
 	    rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR))
 		return -EINVAL;
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.h b/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
index 4808fca..09dd708 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
@@ -896,7 +896,7 @@ struct hw_pairwise_ta_entry {
 #define RXD_W0_MULTICAST		FIELD32(0x00000008)
 #define RXD_W0_BROADCAST		FIELD32(0x00000010)
 #define RXD_W0_MY_BSS			FIELD32(0x00000020)
-#define RXD_W0_CRC			FIELD32(0x00000040)
+#define RXD_W0_CRC_ERROR		FIELD32(0x00000040)
 #define RXD_W0_OFDM			FIELD32(0x00000080)
 #define RXD_W0_CIPHER_ERROR		FIELD32(0x00000300)
 #define RXD_W0_KEY_INDEX		FIELD32(0x0000fc00)
-- 
1.5.2.2

