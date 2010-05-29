Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jack.hrz.tu-chemnitz.de ([134.109.132.46]:41613 "EHLO
	jack.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab0E2WIH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 May 2010 18:08:07 -0400
From: Tobias Doerffel <tobias.doerffel@gmail.com>
To: ath5k-devel@lists.ath5k.org
Subject: Commit 6b5d11 breaks association with WPA enabled APs
Date: Sat, 29 May 2010 23:36:20 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2346918.EW6y1LvLup";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201005292336.37765.tobias.doerffel@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2346918.EW6y1LvLup
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

using the latest kernel (Linus master branch) breaks my wireless connection=
=20
(ath5k/AR5001), i.e. I'm not able to connect to my WPA-secured AP anymore.=
=20
It's been working fine up to (and including) 2.6.34.

Verbose output of wpa_supplicant:

Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:XX:XX:XX:XX:c6 ssid=3D'myAP' wpa_ie_len=3D0 rsn_ie_len=3D20 caps=3D0x=
11
   skip - SSID mismatch
   selected based on RSN IE
   selected WPA AP 00:XX:11:XX:XX:c6 ssid=3D'myAP'
Trying to associate with 00:XX:XX:XX:XX:c6 (SSID=3D'myAP' freq=3D2462 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: clearing AP WPA IE
WPA: set AP RSN IE - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 01 00 00 0f=
 ac=20
04 01 00 00 0f ac 02 00 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 01=
 00=20
00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
wpa_driver_wext_set_drop_unencrypted
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=3D-1, operstate=3D5
wpa_driver_wext_associate
wpa_driver_wext_set_psk
Setting authentication timeout: 10 sec 0 usec
EAPOL: External notification - EAP success=3D0
EAPOL: External notification - EAP fail=3D0
EAPOL: External notification - portControl=3DAuto
RSN: Ignored PMKID candidate without preauth flag
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=3D0x8b06 len=3D8
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=3D0x8b04 len=3D12
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=3D0x8b1a len=3D15

[delay of some seconds]

Authentication with 00:XX:X:XX:XX:c6 timed out.
Added BSSID 00:XX:XX:XX:XX:c6 into blacklist
No keys have been configured - skip key clearing
State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=3D-1, operstate=3D5
EAPOL: External notification - portEnabled=3D0
EAPOL: External notification - portValid=3D0
EAPOL: External notification - EAP success=3D0
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Starting AP scan (broadcast SSID)
Scan requested (ret=3D0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=3D0x8b19 len=3D8
Received 3379 bytes of scan results (10 BSSes)
New scan results available
Selecting BSS from priority group 2
Try to find WPA-enabled AP
=2E..

and the whole procedure starts over and over again. I therefore started to=
=20
bisect the issue and finally was able to blame commit=20
6b5d117eddc09cd976ad8030d715f4350f598a22 ("ath5k: clean up queue=20
manipulation"). After reverting the commit on-top of my branch, everything=
=20
works fine again! So please have a look at it and/or revert the commit.

Regards

Toby

--nextPart2346918.EW6y1LvLup
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkwBiNQACgkQHsjdpw2OaafqwQCfQlHCqNyK9/FBzJwK76pnsjhC
piQAoKHrQQa2bPyIyH6VzA/7VF8EFPP+
=f+6o
-----END PGP SIGNATURE-----

--nextPart2346918.EW6y1LvLup--
