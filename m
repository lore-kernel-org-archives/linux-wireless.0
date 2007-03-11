Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:33520 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932857AbXCKDyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2007 22:54:25 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HQF6p-0001AL-FN
	for linux-wireless@vger.kernel.org; Sat, 10 Mar 2007 22:52:35 -0500
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] sparse-annotate radiotap header
To: linux-wireless@vger.kernel.org,
	Mike Kershaw <dragorn@kismetwireless.net>
Date: Sat, 10 Mar 2007 22:54:22 -0500
Message-ID: <20070311035422.1103.77734.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Document that all fields must be little endian.  Use annotated types
even in the comments.  Consistently use shorter type names (u8, s8). 
Realign the comments.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 include/net/ieee80211_radiotap.h |   57 +++++++++++++++++++-------------------
 1 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index c6e0d81..f3bc00e 100644
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
@@ -88,104 +90,103 @@ struct ieee80211_radiotap_header {
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
- * IEEE80211_RADIOTAP_RX_FLAGS          u_int16_t       bitmap
+ * IEEE80211_RADIOTAP_RX_FLAGS          __le16       bitmap
  *
  *     Properties of received frames. See flags defined below.
  *
- * IEEE80211_RADIOTAP_TX_FLAGS          u_int16_t       bitmap
+ * IEEE80211_RADIOTAP_TX_FLAGS          __le16       bitmap
  *
  *     Properties of transmitted frames. See flags defined below.
  *
- * IEEE80211_RADIOTAP_RTS_RETRIES       u_int8_t        data
+ * IEEE80211_RADIOTAP_RTS_RETRIES       u8           data
  *
  *     Number of rts retries a transmitted frame used.
  *
- * IEEE80211_RADIOTAP_DATA_RETRIES      u_int8_t        data
+ * IEEE80211_RADIOTAP_DATA_RETRIES      u8           data
  *
  *     Number of unicast retries a transmitted frame used.
  *
- *
- * IEEE80211_RADIOTAP_FCS           	u32       data
+ * IEEE80211_RADIOTAP_FCS           	__le32       data
  *
  *	FCS from frame in network byte order.
  */


