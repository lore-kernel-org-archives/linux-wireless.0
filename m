Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.itconnect.no ([80.89.32.22]:32977 "EHLO mail.itconnect.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbYHXXiE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Aug 2008 19:38:04 -0400
Received: from enterprise.localnet.radiotube.org (80-89-52-37.network.itconnect.no [80.89.52.37])
	by mail.itconnect.no (8.13.1/8.13.1) with ESMTP id m7ONWCxv022023
	for <linux-wireless@vger.kernel.org>; Mon, 25 Aug 2008 01:32:12 +0200
Received: from [172.19.0.6] (sigsegv@[172.19.0.6])
	(authenticated bits=0)
	by enterprise.localnet.radiotube.org (8.14.2/8.14.2) with ESMTP id m7ONW58W062550
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 25 Aug 2008 01:32:08 +0200 (CEST)
	(envelope-from sigsegv@radiotube.org)
Message-ID: <48B1EF75.9060704@radiotube.org> (sfid-20080825_013822_339354_5E91653E)
Date: Mon, 25 Aug 2008 01:32:05 +0200
From: Jan-Espen Pettersen <sigsegv@radiotube.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: PROBLEM: mac80211 and 802.11a does not associate with ap [PATCH]
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig73F520B22924DF1E387D3A60"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig73F520B22924DF1E387D3A60
Content-Type: multipart/mixed;
 boundary="------------080601080300050507020001"

This is a multi-part message in MIME format.
--------------080601080300050507020001
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,

Short problem description:
mac80211 framework sends a possibly invalid assoc request (802.11a)

Patch url download (if the attachment is unusable or stripped):
http://www.radiotube.org/mac80211_emptyext.diff

PROBLEM DESCRIPTION
The association request includes a list of supported data rates.

802.11b: 4 supported rates.
802.11g: 12 (8 + 4) supported rates.
802.11a: 8 supported rates.

The rates tag of the assoc request has room for only 8 rates. In case of
802.11g an extended rate tag is appended. However in net/wireless/mlme.c
an extended (empty) rate tag is also appended if the number of rates is
exact 8.

Pseudo-code of current mlme.c implementation:

for (i =3D 0; i < num_rates && i < 8; i++)
    ... append_rate ...;
if (i =3D=3D 8) { /* <-- problem */
    length =3D num_rates - i;
    ... append ext rate ...;
}

The correct way to do this should be more like:

for (i =3D 0; i < num_rates && i < 8; i++)
    ... append_rate ...;
if (i < num_rates) { /* <--note this */
    length =3D num_rates - i;
    ... append ext rate ...
}

A ZyXEL G-570U access point does not accept this empty extended rates
tag. It responds with a 'association denied' with code 18 (unsupported
rates). I do not know if this is correct behaviour, but as far as I can
see it would be wise to not send an empty extended rates tag anyway.

Kernel version:
Linux version 2.6.27-rc4 (sigsegv@challenger) (gcc version 4.3.1 (Debian
4.3.1-9) ) #9 SMP Sun Aug 24 22:24:27 CEST 2008

Wireless card (dmesg):
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for
Linux, 1.2.26kds
iwl3945: Copyright(c) 2003-2008 Intel Corporation
iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwl3945 0000:03:00.0: setting latency timer to 64
iwl3945: Detected Intel Wireless WiFi Link 3945ABG
iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels

Debug output from mac80211 and iwl3945:
phy0: HW CONFIG: freq=3D5180
phy0: HW CONFIG: freq=3D5180
wlan0_rename: Initial auth_alg=3D0
wlan0_rename: authenticate with AP 00:19:cb:2f:4b:95
phy0: TX to low-level driver (len=3D30) FC=3D0x00b0 DUR=3D0x003c
A1=3D00:19:cb:2f:4b:95 A2=3D00:1b:77:40:82:46 A3=3D00:19:cb:2f:4b:95
phy0: HW CONFIG: freq=3D5180
wlan0_rename: Initial auth_alg=3D0
wlan0_rename: authenticate with AP 00:19:cb:2f:4b:95
phy0: TX to low-level driver (len=3D30) FC=3D0x00b0 DUR=3D0x003c
A1=3D00:19:cb:2f:4b:95 A2=3D00:1b:77:40:82:46 A3=3D00:19:cb:2f:4b:95
wlan0_rename: RX authentication from 00:19:cb:2f:4b:95 (alg=3D0
transaction=3D2 status=3D0)
wlan0_rename: authenticated
wlan0_rename: associate with AP 00:19:cb:2f:4b:95
phy0: TX to low-level driver (len=3D46) FC=3D0x0000 DUR=3D0x003c
A1=3D00:19:cb:2f:4b:95 A2=3D00:1b:77:40:82:46 A3=3D00:19:cb:2f:4b:95
wlan0_rename: authentication frame received from 00:19:cb:2f:4b:95, but
not in authenticate state - ignored
wlan0_rename: authentication frame received from 00:19:cb:2f:4b:95, but
not in authenticate state - ignored
wlan0_rename: RX AssocResp from 00:19:cb:2f:4b:95 (capab=3D0x421 status=3D=
18
aid=3D0)
wlan0_rename: AP denied association (code=3D18)
wlan0_rename: associate with AP 00:19:cb:2f:4b:95
phy0: TX to low-level driver (len=3D46) FC=3D0x0000 DUR=3D0x003c
A1=3D00:19:cb:2f:4b:95 A2=3D00:1b:77:40:82:46 A3=3D00:19:cb:2f:4b:95
wlan0_rename: RX AssocResp from 00:19:cb:2f:4b:95 (capab=3D0x421 status=3D=
18
aid=3D0)
wlan0_rename: AP denied association (code=3D18)
wlan0_rename: associate with AP 00:19:cb:2f:4b:95
phy0: TX to low-level driver (len=3D46) FC=3D0x0000 DUR=3D0x003c
A1=3D00:19:cb:2f:4b:95 A2=3D00:1b:77:40:82:46 A3=3D00:19:cb:2f:4b:95
wlan0_rename: RX AssocResp from 00:19:cb:2f:4b:95 (capab=3D0x421 status=3D=
18
aid=3D0)
wlan0_rename: AP denied association (code=3D18)
wlan0_rename: association with AP 00:19:cb:2f:4b:95 timed out

Regards
Jan-Espen Pettersen

Patch url download (if the attachment is unusable or stripped):
http://www.radiotube.org/mac80211_emptyext.diff


--------------080601080300050507020001
Content-Type: text/x-diff;
 name="mac80211_emptyext.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="mac80211_emptyext.diff"

--- net/mac80211/mlme.c.old	2008-08-25 00:19:30.000000000 +0200
+++ net/mac80211/mlme.c	2008-08-24 22:21:16.000000000 +0200
@@ -813,7 +813,7 @@
 		}
 	}
=20
-	if (count =3D=3D 8) {
+	if (count =3D=3D 8 && rates_len > count) {
 		pos =3D skb_put(skb, rates_len - count + 2);
 		*pos++ =3D WLAN_EID_EXT_SUPP_RATES;
 		*pos++ =3D rates_len - count;

--------------080601080300050507020001--

--------------enig73F520B22924DF1E387D3A60
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQEcBAEBAgAGBQJIse91AAoJEDk8S7U888kVDqkH/0Ix1ZqDT09EflXLoizdam7f
LlUsnrqnvWVs3ynWAZsvLxQmTPO33lR60jaL07FWGdN/XVtqebxzhzfMLaD4o2x/
OpjMPVzUZbACO2mez80qkPvvP2Nj5K89XUFHg6NwUNObliErKbV2B83znXju7md6
lbIHm9T6SYMG5PxbDgdBi/UQq3ida6Ut0iyUK/TImz3VIlDwMYGlmDuvDQ66YgVg
mXWU39ReNyOZ0uxR4QPMYbXVeiHoAH43ttUZmtp7vlq4WwegHhS5Ihd5UMuQvqvF
v13QyL/hEggWsETESCT3ov7Hk8mlSoP2VGdMeyR3qUFsH6HWiNlryHcNIFeGj4E=
=xOFE
-----END PGP SIGNATURE-----

--------------enig73F520B22924DF1E387D3A60--
