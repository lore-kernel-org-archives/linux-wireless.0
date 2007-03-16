Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3939 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933040AbXCQMN6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 08:13:58 -0400
Date: Fri, 16 Mar 2007 17:38:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: jeff@garzik.org
Cc: linux-wireless@vger.kernel.org
Subject: Please pull 'libertas' branch of wireless-2.6
Message-ID: <20070316213820.GF3426@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm not sure why I still have libertas as a separate branch, but I do.
I don't think this should cause any trouble for you, but I figured
I'd say something in case you were wondering. :-)

Anyway, this is intended for the 'upstream' branch of netdev-2.6.
You already had pulled libertas there when last I checked.

BTW, Pavel's patch is here instead of in another branch because it
depends on changes from the original libertas driver patch.

Thanks,

John

---

The following changes since commit 971a89608a33ab591c85aa00777acd9ad05f9e82:
  John W. Linville (1):
        Merge branch 'from-linus' into libertas

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git libertas

Pavel Roskin (1):
      sparse-annotate radiotap header

Tony Breeds (1):
      libertas: use standard kernel macros

 drivers/net/wireless/libertas/debugfs.c |   41 ++--------------------
 include/net/ieee80211_radiotap.h        |   57 ++++++++++++++++---------------
 2 files changed, 33 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 3ad1e03..51dfd20 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -1772,8 +1772,8 @@ void libertas_debugfs_remove_one(wlan_private *priv)
 
 /* debug entry */
 
-#define item_size(n) (sizeof ((wlan_adapter *)0)->n)
-#define item_addr(n) ((u32) &((wlan_adapter *)0)->n)
+#define item_size(n)	(FIELD_SIZEOF(wlan_adapter, n))
+#define item_addr(n)	(offsetof(wlan_adapter, n))
 
 struct debug_data {
 	char name[32];
@@ -1789,40 +1789,7 @@ static struct debug_data items[] = {
 	{"psstate", item_size(psstate), item_addr(psstate)},
 };
 
-static int num_of_items = sizeof(items) / sizeof(items[0]);
-
-/**
- *  @brief convert string to number
- *
- *  @param s   	   pointer to numbered string
- *  @return 	   converted number from string s
- */
-static int string_to_number(char *s)
-{
-	int r = 0;
-	int base = 0;
-
-	if ((strncmp(s, "0x", 2) == 0) || (strncmp(s, "0X", 2) == 0))
-		base = 16;
-	else
-		base = 10;
-
-	if (base == 16)
-		s += 2;
-
-	for (s = s; *s != 0; s++) {
-		if ((*s >= 48) && (*s <= 57))
-			r = (r * base) + (*s - 48);
-		else if ((*s >= 65) && (*s <= 70))
-			r = (r * base) + (*s - 55);
-		else if ((*s >= 97) && (*s <= 102))
-			r = (r * base) + (*s - 87);
-		else
-			break;
-	}
-
-	return r;
-}
+static int num_of_items = ARRAY_SIZE(items);
 
 /**
  *  @brief proc read function
@@ -1912,7 +1879,7 @@ static int wlan_debugfs_write(struct file *f, const char __user *buf,
 			if (!p2)
 				break;
 			p2++;
-			r = string_to_number(p2);
+			r = simple_strtoul(p2, NULL, 0);
 			if (d[i].size == 1)
 				*((u8 *) d[i].addr) = (u8) r;
 			else if (d[i].size == 2)
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
-- 
John W. Linville
linville@tuxdriver.com
