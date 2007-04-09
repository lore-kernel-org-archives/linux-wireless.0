Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:45538 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965912AbXDIPxh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2007 11:53:37 -0400
Message-Id: <20070409155334.453915725@warmcat.com>
References: <20070409154802.470925215@warmcat.com>
Date: Mon, 09 Apr 2007 16:48:03 +0100
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Cc: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 1/7] sync wireless-dev with radiotap header in wireless-2.6
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

Update the radiotap header with what's in wireless-2.6. Also remove the
comment about IEEE80211_RADIOTAP_FCS.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 include/net/ieee80211_radiotap.h |   77 ++++++++++++++++++++++++++------------
 1 files changed, 52 insertions(+), 25 deletions(-)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index 429b738..a0c2b41 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -66,7 +66,9 @@
  */
 #define IEEE80211_RADIOTAP_HDRLEN	64
 
-/* The radio capture header precedes the 802.11 header. */
+/* The radio capture header precedes the 802.11 header.
+ * All data in the header is little endian on all platforms.
+ */
 struct ieee80211_radiotap_header {
 	u8 it_version;		/* Version 0. Only increases
 				 * for drastic changes,
@@ -74,12 +76,12 @@ struct ieee80211_radiotap_header {
 				 * new fields does not count.
 				 */
 	u8 it_pad;
-	u16 it_len;		/* length of the whole
+	__le16 it_len;		/* length of the whole
 				 * header in bytes, including
 				 * it_version, it_pad,
 				 * it_len, and data fields.
 				 */
-	u32 it_present;		/* A bitmap telling which
+	__le32 it_present;	/* A bitmap telling which
 				 * fields are present. Set bit 31
 				 * (0x80000000) to extend the
 				 * bitmap by another 32 bits.
@@ -88,89 +90,102 @@ struct ieee80211_radiotap_header {
 				 */
 };
 
-/* Name                                 Data type       Units
- * ----                                 ---------       -----
+/* Name                                 Data type    Units
+ * ----                                 ---------    -----
  *
- * IEEE80211_RADIOTAP_TSFT              u64       microseconds
+ * IEEE80211_RADIOTAP_TSFT              __le64       microseconds
  *
  *      Value in microseconds of the MAC's 64-bit 802.11 Time
  *      Synchronization Function timer when the first bit of the
  *      MPDU arrived at the MAC. For received frames, only.
  *
- * IEEE80211_RADIOTAP_CHANNEL           2 x u16   MHz, bitmap
+ * IEEE80211_RADIOTAP_CHANNEL           2 x __le16   MHz, bitmap
  *
  *      Tx/Rx frequency in MHz, followed by flags (see below).
  *
- * IEEE80211_RADIOTAP_FHSS              u16       see below
+ * IEEE80211_RADIOTAP_FHSS              __le16       see below
  *
  *      For frequency-hopping radios, the hop set (first byte)
  *      and pattern (second byte).
  *
- * IEEE80211_RADIOTAP_RATE              u8        500kb/s
+ * IEEE80211_RADIOTAP_RATE              u8           500kb/s
  *
  *      Tx/Rx data rate
  *
- * IEEE80211_RADIOTAP_DBM_ANTSIGNAL     int8_t          decibels from
- *                                                      one milliwatt (dBm)
+ * IEEE80211_RADIOTAP_DBM_ANTSIGNAL     s8           decibels from
+ *                                                   one milliwatt (dBm)
  *
  *      RF signal power at the antenna, decibel difference from
  *      one milliwatt.
  *
- * IEEE80211_RADIOTAP_DBM_ANTNOISE      int8_t          decibels from
- *                                                      one milliwatt (dBm)
+ * IEEE80211_RADIOTAP_DBM_ANTNOISE      s8           decibels from
+ *                                                   one milliwatt (dBm)
  *
  *      RF noise power at the antenna, decibel difference from one
  *      milliwatt.
  *
- * IEEE80211_RADIOTAP_DB_ANTSIGNAL      u8        decibel (dB)
+ * IEEE80211_RADIOTAP_DB_ANTSIGNAL      u8           decibel (dB)
  *
  *      RF signal power at the antenna, decibel difference from an
  *      arbitrary, fixed reference.
  *
- * IEEE80211_RADIOTAP_DB_ANTNOISE       u8        decibel (dB)
+ * IEEE80211_RADIOTAP_DB_ANTNOISE       u8           decibel (dB)
  *
  *      RF noise power at the antenna, decibel difference from an
  *      arbitrary, fixed reference point.
  *
- * IEEE80211_RADIOTAP_LOCK_QUALITY      u16       unitless
+ * IEEE80211_RADIOTAP_LOCK_QUALITY      __le16       unitless
  *
  *      Quality of Barker code lock. Unitless. Monotonically
  *      nondecreasing with "better" lock strength. Called "Signal
  *      Quality" in datasheets.  (Is there a standard way to measure
  *      this?)
  *
- * IEEE80211_RADIOTAP_TX_ATTENUATION    u16       unitless
+ * IEEE80211_RADIOTAP_TX_ATTENUATION    __le16       unitless
  *
  *      Transmit power expressed as unitless distance from max
  *      power set at factory calibration.  0 is max power.
  *      Monotonically nondecreasing with lower power levels.
  *
- * IEEE80211_RADIOTAP_DB_TX_ATTENUATION u16       decibels (dB)
+ * IEEE80211_RADIOTAP_DB_TX_ATTENUATION __le16       decibels (dB)
  *
  *      Transmit power expressed as decibel distance from max power
  *      set at factory calibration.  0 is max power.  Monotonically
  *      nondecreasing with lower power levels.
  *
- * IEEE80211_RADIOTAP_DBM_TX_POWER      int8_t          decibels from
- *                                                      one milliwatt (dBm)
+ * IEEE80211_RADIOTAP_DBM_TX_POWER      s8           decibels from
+ *                                                   one milliwatt (dBm)
  *
  *      Transmit power expressed as dBm (decibels from a 1 milliwatt
  *      reference). This is the absolute power level measured at
  *      the antenna port.
  *
- * IEEE80211_RADIOTAP_FLAGS             u8        bitmap
+ * IEEE80211_RADIOTAP_FLAGS             u8           bitmap
  *
  *      Properties of transmitted and received frames. See flags
  *      defined below.
  *
- * IEEE80211_RADIOTAP_ANTENNA           u8        antenna index
+ * IEEE80211_RADIOTAP_ANTENNA           u8           antenna index
  *
  *      Unitless indication of the Rx/Tx antenna for this packet.
  *      The first antenna is antenna 0.
  *
- * IEEE80211_RADIOTAP_FCS           	u32       data
+ * IEEE80211_RADIOTAP_RX_FLAGS          __le16       bitmap
+ *
+ *     Properties of received frames. See flags defined below.
+ *
+ * IEEE80211_RADIOTAP_TX_FLAGS          __le16       bitmap
+ *
+ *     Properties of transmitted frames. See flags defined below.
+ *
+ * IEEE80211_RADIOTAP_RTS_RETRIES       u8           data
+ *
+ *     Number of rts retries a transmitted frame used.
+ *
+ * IEEE80211_RADIOTAP_DATA_RETRIES      u8           data
+ *
+ *     Number of unicast retries a transmitted frame used.
  *
- *	FCS from frame in network byte order.
  */
 enum ieee80211_radiotap_type {
 	IEEE80211_RADIOTAP_TSFT = 0,
@@ -187,7 +202,11 @@ enum ieee80211_radiotap_type {
 	IEEE80211_RADIOTAP_ANTENNA = 11,
 	IEEE80211_RADIOTAP_DB_ANTSIGNAL = 12,
 	IEEE80211_RADIOTAP_DB_ANTNOISE = 13,
-	IEEE80211_RADIOTAP_EXT = 31,
+	IEEE80211_RADIOTAP_RX_FLAGS = 14,
+	IEEE80211_RADIOTAP_TX_FLAGS = 15,
+	IEEE80211_RADIOTAP_RTS_RETRIES = 16,
+	IEEE80211_RADIOTAP_DATA_RETRIES = 17,
+	IEEE80211_RADIOTAP_EXT = 31
 };
 
 /* Channel flags. */
@@ -219,6 +238,14 @@ enum ieee80211_radiotap_type {
 						 * 802.11 header and payload
 						 * (to 32-bit boundary)
 						 */
+/* For IEEE80211_RADIOTAP_RX_FLAGS */
+#define IEEE80211_RADIOTAP_F_RX_BADFCS	0x0001	/* frame failed crc check */
+
+/* For IEEE80211_RADIOTAP_TX_FLAGS */
+#define IEEE80211_RADIOTAP_F_TX_FAIL	0x0001	/* failed due to excessive
+						 * retries */
+#define IEEE80211_RADIOTAP_F_TX_CTS	0x0002	/* used cts 'protection' */
+#define IEEE80211_RADIOTAP_F_TX_RTS	0x0004	/* used rts/cts handshake */
 
 /* Ugly macro to convert literal channel numbers into their mhz equivalents
  * There are certianly some conditions that will break this (like feeding it '30')

-- 
