Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:20429 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932941AbXBLDXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 22:23:12 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: [PATCH] rt2x00: update to new statistics reporting API
Date: Sun, 11 Feb 2007 22:22:43 -0500
Cc: linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1229495.vAfDBKXfsp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702112222.43503.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1229495.vAfDBKXfsp
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

rt2x00: update to new statistics reporting API

This patch updates rt2x00 to the new statistics reporting API.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 drivers/net/wireless/d80211/rt2x00/rt2400pci.c |   12 +-----------
 drivers/net/wireless/d80211/rt2x00/rt2500pci.c |   16 ++++------------
 drivers/net/wireless/d80211/rt2x00/rt2500usb.c |   16 ++++------------
 drivers/net/wireless/d80211/rt2x00/rt61pci.c   |   12 ++----------
 drivers/net/wireless/d80211/rt2x00/rt73usb.c   |   12 ++----------
 5 files changed, 13 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/d80211/rt2x00/rt2400pci.c=20
b/drivers/net/wireless/d80211/rt2x00/rt2400pci.c
index 3be2aa8..8853876 100644
=2D-- a/drivers/net/wireless/d80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/d80211/rt2x00/rt2400pci.c
@@ -1571,16 +1571,6 @@ static void rt2400pci_rxdone(struct work
 			rt2x00dev->rx_params.ssi =3D
 				rt2x00_get_field32(word2, RXD_W2_RSSI);
=20
=2D			/*
=2D			 * The following set of assignments supply
=2D			 * additional data for wireless statistics. The
=2D			 * necessary quantities are (1) the "noise" value
=2D			 * in dBm, and (2) the "signal" value in dBm.
=2D			 */
=2D			rt2x00dev->rx_params.noise =3D 0;
=2D			rt2x00dev->rx_params.signal =3D rt2x00dev->rx_params.ssi
=2D				- rt2x00dev->hw->maxssi;
=2D
 			__ieee80211_rx(rt2x00dev->hw,
 				skb, &rt2x00dev->rx_params);
 		}
@@ -2655,7 +2645,7 @@ static int rt2400pci_init_hw(struct rt2x
 		IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 		IEEE80211_HW_MONITOR_DURING_OPER;
 	rt2x00dev->hw->extra_tx_headroom =3D 0;
=2D	rt2x00dev->hw->maxssi =3D MAX_RX_SSI;
+	rt2x00dev->hw->max_rssi =3D MAX_RX_SSI;
 	rt2x00dev->hw->queues =3D RING_NUM_TX;
=20
 	status =3D rt2400pci_init_hw_modes(rt2x00dev);
diff --git a/drivers/net/wireless/d80211/rt2x00/rt2500pci.c=20
b/drivers/net/wireless/d80211/rt2x00/rt2500pci.c
index 7e69825..2c4e729 100644
=2D-- a/drivers/net/wireless/d80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/d80211/rt2x00/rt2500pci.c
@@ -1728,17 +1728,8 @@ static void rt2500pci_rxdone(struct work
=20
 			rt2x00dev->rx_params.ssi =3D
 				rt2x00_get_field32(word2, RXD_W2_RSSI);
=2D
=2D			/*
=2D			 * The following set of assignments supply
=2D			 * additional data for wireless statistics. The
=2D			 * necessary quantities are (1) the "noise" value
=2D			 * in dBm, and (2) the "signal" value in dBm.
=2D			 */
 			rt2x00dev->rx_params.noise =3D
 				rt2x00_get_link_noise(&rt2x00dev->link);
=2D			rt2x00dev->rx_params.signal =3D rt2x00dev->rx_params.ssi
=2D				- rt2x00dev->hw->maxssi;
=20
 			__ieee80211_rx(rt2x00dev->hw,
 				skb, &rt2x00dev->rx_params);
@@ -2649,10 +2640,11 @@ static int rt2500pci_init_eeprom(struct
 	 * Read the RSSI <-> dBm offset information.
 	 */
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_CALIBRATE_OFFSET, &eeprom);
=2D	rt2x00dev->hw->maxssi =3D
+	rt2x00dev->hw->max_rssi =3D
 		rt2x00_get_field16(eeprom, EEPROM_CALIBRATE_OFFSET_RSSI);
=2D	if (rt2x00dev->hw->maxssi =3D=3D 0x00 || rt2x00dev->hw->maxssi =3D=3D 0=
xff)
=2D		rt2x00dev->hw->maxssi =3D MAX_RX_SSI;
+	if (rt2x00dev->hw->max_rssi =3D=3D 0x00 || rt2x00dev->hw->max_rssi =3D=3D=
 0xff)
+		rt2x00dev->hw->max_rssi =3D MAX_RX_SSI;
+	rt2x00dev->hw->max_noise =3D -110;
=20
 	return 0;
 }
diff --git a/drivers/net/wireless/d80211/rt2x00/rt2500usb.c=20
b/drivers/net/wireless/d80211/rt2x00/rt2500usb.c
index cb8f7e6..eade5ff 100644
=2D-- a/drivers/net/wireless/d80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/d80211/rt2x00/rt2500usb.c
@@ -1709,17 +1709,8 @@ static void rt2500usb_rxdone(struct work
=20
 			rt2x00dev->rx_params.ssi =3D
 				rt2x00_get_field32(word1, RXD_W1_RSSI);
=2D
=2D			/*
=2D			 * The following set of assignments supply
=2D			 * additional data for wireless statistics. The
=2D			 * necessary quantities are (1) the "noise" value
=2D			 * in dBm, and (2) the "signal" value in dBm.
=2D			 */
 			rt2x00dev->rx_params.noise =3D
 				rt2x00_get_link_noise(&rt2x00dev->link);
=2D			rt2x00dev->rx_params.signal =3D rt2x00dev->rx_params.ssi
=2D				- rt2x00dev->hw->maxssi;
=20
 			__ieee80211_rx(rt2x00dev->hw,
 				skb, &rt2x00dev->rx_params);
@@ -2493,10 +2484,11 @@ static int rt2500usb_init_eeprom(struct
 	 * Read the RSSI <-> dBm offset information.
 	 */
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_CALIBRATE_OFFSET, &eeprom);
=2D	rt2x00dev->hw->maxssi =3D
+	rt2x00dev->hw->max_rssi =3D
 		rt2x00_get_field16(eeprom, EEPROM_CALIBRATE_OFFSET_RSSI);
=2D	if (rt2x00dev->hw->maxssi =3D=3D 0x00 || rt2x00dev->hw->maxssi =3D=3D 0=
xff)
=2D		rt2x00dev->hw->maxssi =3D MAX_RX_SSI;
+	if (rt2x00dev->hw->max_rssi =3D=3D 0x00 || rt2x00dev->hw->max_rssi =3D=3D=
 0xff)
+		rt2x00dev->hw->max_rssi =3D MAX_RX_SSI;
+	rt2x00dev->hw->max_noise =3D -110;
=20
 	return 0;
 }
diff --git a/drivers/net/wireless/d80211/rt2x00/rt61pci.c=20
b/drivers/net/wireless/d80211/rt2x00/rt61pci.c
index 7f2d4c0..5899d2c 100644
=2D-- a/drivers/net/wireless/d80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/d80211/rt2x00/rt61pci.c
@@ -2198,17 +2198,8 @@ static void rt61pci_rxdone(struct work_s
=20
 			rt2x00dev->rx_params.ssi =3D
 				rt2x00_get_field32(word1, RXD_W1_RSSI);
=2D
=2D			/*
=2D			 * The following set of assignments supply
=2D			 * additional data for wireless statistics. The
=2D			 * necessary quantities are (1) the "noise" value
=2D			 * in dBm, and (2) the "signal" value in dBm.
=2D			 */
 			rt2x00dev->rx_params.noise =3D
 				rt2x00_get_link_noise(&rt2x00dev->link);
=2D			rt2x00dev->rx_params.signal =3D rt2x00dev->rx_params.ssi
=2D				- rt2x00dev->hw->maxssi;
=20
 			__ieee80211_rx(rt2x00dev->hw,
 				skb, &rt2x00dev->rx_params);
@@ -3490,7 +3481,8 @@ static int rt61pci_init_hw(struct rt2x00
 		IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 		IEEE80211_HW_MONITOR_DURING_OPER;
 	rt2x00dev->hw->extra_tx_headroom =3D 0;
=2D	rt2x00dev->hw->maxssi =3D MAX_RX_SSI;
+	rt2x00dev->hw->max_rssi =3D MAX_RX_SSI;
+	rt2x00dev->hw->max_noise =3D -110;
 	rt2x00dev->hw->queues =3D RING_NUM_TX;
=20
 	num_modes =3D rt61pci_init_hw_modes(rt2x00dev);
diff --git a/drivers/net/wireless/d80211/rt2x00/rt73usb.c=20
b/drivers/net/wireless/d80211/rt2x00/rt73usb.c
index 0915636..6116d44 100644
=2D-- a/drivers/net/wireless/d80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/d80211/rt2x00/rt73usb.c
@@ -1986,17 +1986,8 @@ static void rt73usb_rxdone(struct work_s
=20
 			rt2x00dev->rx_params.ssi =3D
 				rt2x00_get_field32(word1, RXD_W1_RSSI);
=2D
=2D			/*
=2D			 * The following set of assignments supply
=2D			 * additional data for wireless statistics. The
=2D			 * necessary quantities are (1) the "noise" value
=2D			 * in dBm, and (2) the "signal" value in dBm.
=2D			 */
 			rt2x00dev->rx_params.noise =3D
 				rt2x00_get_link_noise(&rt2x00dev->link);
=2D			rt2x00dev->rx_params.signal =3D rt2x00dev->rx_params.ssi
=2D				- rt2x00dev->hw->maxssi;
=20
 			__ieee80211_rx(rt2x00dev->hw,
 				skb, &rt2x00dev->rx_params);
@@ -3146,7 +3137,8 @@ static int rt73usb_init_hw(struct rt2x00
 		IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 		IEEE80211_HW_MONITOR_DURING_OPER;
 	rt2x00dev->hw->extra_tx_headroom =3D 0;
=2D	rt2x00dev->hw->maxssi =3D MAX_RX_SSI;
+	rt2x00dev->hw->max_rssi =3D MAX_RX_SSI;
+	rt2x00dev->hw->max_noise =3D -110;
 	rt2x00dev->hw->queues =3D RING_NUM_TX;
=20
 	num_modes =3D rt73usb_init_hw_modes(rt2x00dev);

--nextPart1229495.vAfDBKXfsp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFz92DT3Oqt9AH4aERAgT0AJ9pKXuWKoyVnEdVS9TEhG0VpagcvQCfegOn
r6k/VfHFz5NhlRfJkw3Injc=
=gqCO
-----END PGP SIGNATURE-----

--nextPart1229495.vAfDBKXfsp--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
