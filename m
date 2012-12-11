Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.allnet.de ([212.18.29.59]:22488 "EHLO mail.allnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab2LKKKB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 05:10:01 -0500
Date: Tue, 11 Dec 2012 12:04:22 +0200
From: Daniel Golle <dgolle@allnet.de>
To: <linux-wireless@vger.kernel.org>
CC: <users@rt2x00.serialmonkey.com>, <juhosg@openwrt.org>,
	<sgruszka@redhat.com>, <helmut.schaa@googlemail.com>,
	<gwingerde@gmail.com>, <john@phrozen.org>
Subject: [PATCH 3/3] rt2x00: add platform_data mac address
Message-ID: <20121211100419.GA7822@earthship.arig> (sfid-20121211_111008_824122_AD3D8760)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Signed-off-by: Daniel Golle <dgolle@allnet.de>

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt=
2x00/rt2x00.h
index c67e769..8b82e77 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1294,6 +1294,7 @@ static inline void rt2x00debug_dump_frame(struct rt2x=
00_dev *rt2x00dev,
  */
 u32 rt2x00lib_get_bssidx(struct rt2x00_dev *rt2x00dev,
 			 struct ieee80211_vif *vif);
+const u8 *rt2x00lib_get_mac_address(struct rt2x00_dev *rt2x00dev);
=20
 /*
  * Interrupt context handlers.
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless=
/rt2x00/rt2x00dev.c
index b7856bf..f9868d1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -826,6 +826,18 @@ static void rt2x00lib_rate(struct ieee80211_rate *entr=
y,
 		entry->flags |=3D IEEE80211_RATE_SHORT_PREAMBLE;
 }
=20
+const u8 *rt2x00lib_get_mac_address(struct rt2x00_dev *rt2x00dev)
+{
+	struct rt2x00_platform_data *pdata;
+
+	pdata =3D rt2x00dev->dev->platform_data;
+	if (!pdata)
+		return NULL;
+
+	return pdata->mac_address;
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_get_mac_address);
+
 static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 				    struct hw_mode_spec *spec)
 {
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/r=
t2x00/rt61pci.c
index f95792c..7dbc0ba 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2392,6 +2392,7 @@ static int rt61pci_validate_eeprom(struct rt2x00_dev =
*rt2x00dev)
 	u32 reg;
 	u16 word;
 	u8 *mac;
+	const u8 *pdata_mac;
 	s8 value;
=20
 	rt2x00pci_register_read(rt2x00dev, E2PROM_CSR, &reg);
@@ -2412,7 +2413,11 @@ static int rt61pci_validate_eeprom(struct rt2x00_dev=
 *rt2x00dev)
 	/*
 	 * Start validation of the data that has been read.
 	 */
+	pdata_mac =3D rt2x00lib_get_mac_address(rt2x00dev);
 	mac =3D rt2x00_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0);
+	if (pdata_mac)
+		memcpy(mac, pdata_mac, 6);
+
 	if (!is_valid_ether_addr(mac)) {
 		eth_random_addr(mac);
 		EEPROM(rt2x00dev, "MAC: %pM\n", mac);
diff --git a/include/linux/rt2x00_platform.h b/include/linux/rt2x00_platfor=
m.h
index b4c7768..e10377e 100644
--- a/include/linux/rt2x00_platform.h
+++ b/include/linux/rt2x00_platform.h
@@ -14,6 +14,7 @@
=20
 struct rt2x00_platform_data {
 	char *eeprom_file_name;
+	const u8 *mac_address;
=20
 	int disable_2ghz;
 	int disable_5ghz;
--=20
1.8.0.1


--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQxwUjAAoJEDy9cKN/1Et0iqMQAJvps47XqXHKdqeJDAXKGJd9
+j+VUrU8q3SmOYoj3vTQRo1k/hD7Qn9QBZG9S2RF3lhyiRXL1yF92ggR/C0qcnsF
LjVVx/6eKm40+ws0/Jv7E7HLjC1yt1qkgIiVAfKP8gIZwM4NIMIg46ZFLGEkb49L
jP1XeZXrifhEr76I/2CSyRGrWuFla20IcNzgDxTNfERwgPzpZj14D3WYBWNwSFZo
/9lmVIGJtETDJ12RTdnOUJx4L3IhhGNNtLX9Vypu56o28b+R8h+npb73Csm1C4gJ
XCL1x/A4ltoIKfDnTxGBfO1WR8t2eejBXsMzERSjwFedKVbyiI3HxLQAfknAENhG
y5a7+NWeC5SZety18+lP5OQwdag6lCRrjbTb2gPcmDWGKMrWF8M+pXWS0JduR4kd
ISE6wXPQaCSA5GjKB3DbHLZUPYD/+Zix0R3RNsVemr/8h8SJD28NWY41ueIUnCyc
mPdQeVmORzLmtSEqjOqy0vwQ6W4UImb88cwNn7Z7qO89943JyqGf02ciDdA2biwX
JFxUHq0j9Psch98qJ7eoddgEALyFFsa6+IBwxLYR5yQTzMM7SzlbGo92Jm32dvn4
IN3hc42iMObYWUhWKl7HdOVFuLixgontmAfIjqHhGmIoJJBnREPuqmRDdI7RThi+
OfkNgNAtUlbCIMeRQcvT
=F6cV
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
