Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.239]:45456 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762441AbXIUU7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 16:59:19 -0400
Received: by wx-out-0506.google.com with SMTP id h31so761327wxd
        for <linux-wireless@vger.kernel.org>; Fri, 21 Sep 2007 13:59:18 -0700 (PDT)
Date: Fri, 21 Sep 2007 17:00:15 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Daniel Drake <dsd@gentoo.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 1/5] Move standard wireless defintions out of mac80211
Message-ID: <20070921210014.GE31768@pogo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="96YOpH+ONegL0A3E"
In-Reply-To: <20070921204606.GD31768@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--96YOpH+ONegL0A3E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I tried moving the common stuff to a few already existing files and in=20
all of them I had dependency issues. Adding a wireless_common hoping
we can later clean out net/ieee80211.h and linux/ieee80211.h

* Move standard wireless structs and definitions out of mac80211 and into
  a wireless_common.h.
* Move IEEE80211_CHAN_W_* flags, struct ieee80211_channel, IEEE80211_RATE_*
  flags, struct ieee80211_rate, and enum ieee80211_phymode out to
  wireless_common.h
* Move IEEE80211_CHAN_W_* defines to enum channel_flags, add documenation
* Move IEEE80211_RATE_* defines to enum rate_flags, add documenation
* Add documenation for ieee80211_channel
* Add documenation for ieee80211_rate
* Remove unused min_rssi_ack, and min_rssi_ack_delta from struct
  ieee80211_rate as its unused
* Remove usage of min_rssi_ack and min_rssi_ack_delta from Ralink driver
  (rt2x00dev.c), it just initialized it unnesariily to 0 (as the struct was
  kzalloc'd anyway). But mac80211 never used this.

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 -
 include/net/mac80211.h                  |   63 +------------
 include/net/wireless_common.h           |  154 +++++++++++++++++++++++++++=
++++
 3 files changed, 155 insertions(+), 64 deletions(-)
 create mode 100644 include/net/wireless_common.h

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless=
/rt2x00/rt2x00dev.c
index cd82eef..68aee89 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -559,8 +559,6 @@ static void rt2x00lib_rate(struct ieee80211_rate *entry,
 	entry->val2 =3D entry->val;
 	if (entry->flags & IEEE80211_RATE_PREAMBLE2)
 		entry->val2 |=3D DEVICE_SET_RATE_FIELD(1, PREAMBLE);
-	entry->min_rssi_ack =3D 0;
-	entry->min_rssi_ack_delta =3D 0;
 }
=20
 static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9b4b4a2..4832e6a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -19,6 +19,7 @@
 #include <linux/wireless.h>
 #include <linux/device.h>
 #include <linux/ieee80211.h>
+#include <net/wireless_common.h>
 #include <net/wireless.h>
 #include <net/cfg80211.h>
=20
@@ -47,68 +48,6 @@
  * copying of the data.
  */
=20
-#define IEEE80211_CHAN_W_SCAN 0x00000001
-#define IEEE80211_CHAN_W_ACTIVE_SCAN 0x00000002
-#define IEEE80211_CHAN_W_IBSS 0x00000004
-
-/* Channel information structure. Low-level driver is expected to fill in =
chan,
- * freq, and val fields. Other fields will be filled in by 80211.o based on
- * hostapd information and low-level driver does not need to use them. The
- * limits for each channel will be provided in 'struct ieee80211_conf' when
- * configuring the low-level driver with hw->config callback. If a device =
has
- * a default regulatory domain, IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED
- * can be set to let the driver configure all fields */
-struct ieee80211_channel {
-	short chan; /* channel number (IEEE 802.11) */
-	short freq; /* frequency in MHz */
-	int val; /* hw specific value for the channel */
-	int flag; /* flag for hostapd use (IEEE80211_CHAN_*) */
-	unsigned char power_level;
-	unsigned char antenna_max;
-};
-
-#define IEEE80211_RATE_ERP 0x00000001
-#define IEEE80211_RATE_BASIC 0x00000002
-#define IEEE80211_RATE_PREAMBLE2 0x00000004
-#define IEEE80211_RATE_SUPPORTED 0x00000010
-#define IEEE80211_RATE_OFDM 0x00000020
-#define IEEE80211_RATE_CCK 0x00000040
-#define IEEE80211_RATE_MANDATORY 0x00000100
-
-#define IEEE80211_RATE_CCK_2 (IEEE80211_RATE_CCK | IEEE80211_RATE_PREAMBLE=
2)
-#define IEEE80211_RATE_MODULATION(f) \
-	(f & (IEEE80211_RATE_CCK | IEEE80211_RATE_OFDM))
-
-/* Low-level driver should set PREAMBLE2, OFDM and CCK flags.
- * BASIC, SUPPORTED, ERP, and MANDATORY flags are set in 80211.o based on =
the
- * configuration. */
-struct ieee80211_rate {
-	int rate; /* rate in 100 kbps */
-	int val; /* hw specific value for the rate */
-	int flags; /* IEEE80211_RATE_ flags */
-	int val2; /* hw specific value for the rate when using short preamble
-		   * (only when IEEE80211_RATE_PREAMBLE2 flag is set, i.e., for
-		   * 2, 5.5, and 11 Mbps) */
-	signed char min_rssi_ack;
-	unsigned char min_rssi_ack_delta;
-
-	/* following fields are set by 80211.o and need not be filled by the
-	 * low-level driver */
-	int rate_inv; /* inverse of the rate (LCM(all rates) / rate) for
-		       * optimizing channel utilization estimates */
-};
-
-/* 802.11g is backwards-compatible with 802.11b, so a wlan card can
- * actually be both in 11b and 11g modes at the same time. */
-enum ieee80211_phymode {
-	MODE_IEEE80211A, /* IEEE 802.11a */
-	MODE_IEEE80211B, /* IEEE 802.11b only */
-	MODE_IEEE80211G, /* IEEE 802.11g (and 802.11b compatibility) */
-
-	/* keep last */
-	NUM_IEEE80211_MODES
-};
-
 struct ieee80211_hw_mode {
 	int mode; /* MODE_IEEE80211... */
 	int num_channels; /* Number of channels (below) */
diff --git a/include/net/wireless_common.h b/include/net/wireless_common.h
new file mode 100644
index 0000000..1e88d6e
--- /dev/null
+++ b/include/net/wireless_common.h
@@ -0,0 +1,154 @@
+#ifndef __NET_WIRELESS_COMMON_H
+#define __NET_WIRELESS_COMMON_H
+/*
+ * Copyright 2002-2005, Devicescape Software, Inc.
+ * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
+ * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/* Standard wireless common structs and definitions. */
+
+/**
+ * enum channel_flags - internal &ieee80211_channel flags
+ *
+ * Use these flags to indicate to the lower layers details about an
+ * &ieee80211_channel.
+ *
+ * @IEEE80211_CHAN_W_SCAN: if this flag is set it informs the lower layer =
that
+ *   this channel can be passively scanned for.
+ * @IEEE80211_CHAN_W_ACTIVE_SCAN: if this flag is set it informs the lower=
 layers
+ *   which channels can be scanned actively. Active scanning is done by se=
nding a=20
+ *   probe. Specifically, mac80211 sends this probe via the host MLME kern=
el's
+ *   MLME ieee80211_send_probe_req()
+ * @IEEE80211_CHAN_W_IBSS: if this flag is found in &ieee80211_channel's @=
flag
+ *   it indicates to that channel can be used in an IBSS.
+ */
+enum channel_flags {
+	IEEE80211_CHAN_W_SCAN =3D		(1<<0),
+	IEEE80211_CHAN_W_ACTIVE_SCAN =3D	(1<<1),
+	IEEE80211_CHAN_W_IBSS =3D		(1<<2),
+};
+
+/**
+ * ieee80211_channel - internal structure definiton for an IEEE-802.11 cha=
nnel
+ *
+ * This defines an ieee80211_channel. The IEEE-802.11 regulatory domain ag=
ent
+ * is in charge of filling most of these fields out. The low-level driver=
=20
+ * is expected to fill in, if needed, the val field. Note that val is alre=
ady=20
+ * set by the regulatory agent to the same channel as in chan.
+ *
+ * @chan: channel number (IEEE 802.11)
+ * @freq: center of frequency in MHz
+ * @val: hw specific value for the channel
+ * @flag: flag for hostapd use (IEEE80211_CHAN_*)
+ * @power_level: max allowed eirp in dBm
+ * @antenna_max: max allowed antenna gain in dBi
+ * @modulation_cap: could be IEEE80211_RATE_*
+ * @list: lets you make this structure part of a linked list
+ */
+struct ieee80211_channel {
+	/* XXX change to u8 */
+	short chan;
+	/* change to u16 */
+	short freq;
+	int val;
+	int flag;
+	unsigned char power_level;
+	unsigned char antenna_max;
+	u32 modulation_cap;
+	struct list_head list;
+};
+
+/* XXX consider removing the holes bellow */
+
+/**
+ * enum rate_flags - internal &ieee80211_rate flags
+ *
+ * Use these flags to indicate to the lower layers details about an
+ * &ieee80211_rate.
+ *
+ * @IEEE80211_RATE_ERP: indicates if the rate is an  Extended Rate PHY (ER=
P)
+ * @IEEE80211_RATE_BASIC: indicates the rate is a basic rate for the=20
+ *   currently used mode
+ * @IEEE80211_RATE_PREAMBLE2: used to indicates that the rate for short
+ *   preamble is to be used. This is set in &ieee80211_rate's @val2.
+ * @IEEE80211_RATE_SUPPORTED: indicates if rate is supported by the given =
mode
+ * @IEEE80211_RATE_OFDM: indicates support for ODFM modulation
+ * @IEEE80211_RATE_CCK: indicates support for CCK modulation
+ * @IEEE80211_RATE_MANDATORY: indicates if this rate is mandatory for the
+ *   currently used mode
+ */
+enum rate_flags {
+	IEEE80211_RATE_ERP		=3D (1<<0),
+	IEEE80211_RATE_BASIC		=3D (1<<1),
+	IEEE80211_RATE_PREAMBLE2	=3D (1<<2),
+	/* Hole at 0x08 */
+	IEEE80211_RATE_SUPPORTED	=3D (1<<4),
+	IEEE80211_RATE_OFDM		=3D (1<<5),
+	IEEE80211_RATE_CCK		=3D (1<<6),
+	/* Hole at 0x80 */
+	IEEE80211_RATE_MANDATORY	=3D (1<<7),
+};
+
+/* XXX move to inline and add documenation, kernel-doc can't doc defines */
+#define IEEE80211_RATE_CCK_2 (IEEE80211_RATE_CCK | IEEE80211_RATE_PREAMBLE=
2)
+#define IEEE80211_RATE_MODULATION(f) \
+	(f & (IEEE80211_RATE_CCK | IEEE80211_RATE_OFDM))
+
+/**
+ * ieee80211_rate - defines a standard ieee8011_rate
+ *
+ * Low-level driver should set PREAMBLE2, OFDM and CCK flags.
+ * BASIC, SUPPORTED, ERP, and MANDATORY flags are set in 80211.o based on =
the
+ * configuration.
+ *
+ * @rate: rate in 100 kbps
+ * @val: hw specific value for the rate
+ * @flags: IEEE80211_RATE_* flags
+ * @val2: hw specific value for the rate when using short preamble
+ *   (only when IEEE80211_RATE_PREAMBLE2 flag is set, i.e., for
+ *   2, 5.5, and 11 Mbps)
+ * @min_rssi_ack: Minimum required RSSI of packet to generate an ACK ??
+ * @min_rssi_ack_delta: ??
+ *
+ */
+struct ieee80211_rate {
+	int rate;
+	int val;
+	int flags;
+	int val2;=20
+	signed char min_rssi_ack;
+	unsigned char min_rssi_ack_delta;
+
+	/* private */
+
+	/* the following fields are set by 80211.o and need not be filled by the
+	 * low-level driver */
+
+	/* inverse of the rate (LCM(all rates) / rate) for optimizing channel=20
+	 * utilization estimates */
+	int rate_inv;=20
+};
+
+/**
+ * enum ieee80211_phymode - modes for a physical 802.11 device
+ *
+ * @MODE_IEEE80211A: IEEE 802.11a
+ * @MODE_IEEE80211B: IEEE 802.11b only
+ * @MODE_IEEE80211G: IEEE 802.11g (and 802.11b compatibility)
+ * @NUM_IEEE80211_MODES: number of standard IEEE-802.11 modes currently su=
pported
+ */
+enum ieee80211_phymode {
+	MODE_IEEE80211A,
+	MODE_IEEE80211B,
+	MODE_IEEE80211G,
+
+	/* keep last */
+	NUM_IEEE80211_MODES
+};
+
+#endif /* __NET_WIRELESS_COMMON_H */
--=20
1.5.2.4


--96YOpH+ONegL0A3E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG9DDeat1JN+IKUl4RApe0AJ9/ZVjyLlYMS4ATfxIln6JSabWhvwCdFogs
lVLAw4KFRCn25WqeLx5veuE=
=kckr
-----END PGP SIGNATURE-----

--96YOpH+ONegL0A3E--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
