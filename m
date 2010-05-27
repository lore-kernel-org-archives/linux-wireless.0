Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.108.102.1]:43156 "EHLO parez.praha12.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228Ab0E0QTW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 12:19:22 -0400
Received: from 8an.javor.praha12.czf (8an.javor.praha12.czf [10.27.67.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by parez.praha12.net (Postfix) with ESMTPS id 55801C2248
	for <linux-wireless@vger.kernel.org>; Thu, 27 May 2010 18:10:55 +0200 (CEST)
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: linux-wireless@vger.kernel.org
Subject: Regulatory problem with multiple wireless interfaces
Date: Thu, 27 May 2010 18:10:41 +0200
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart18752801.UbissgIjxi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201005271810.55211.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart18752801.UbissgIjxi
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

I reported this first in ath5k-devel, but now I'm convinced the problem lie=
s=20
in the cfg80211 regulatory framework.

When there is more than one wireless card installed, sometimes the CRDA rep=
ly=20
for first detected card's request gets into the kernel before next card is=
=20
requested and everything is fine. But sometimes CRDA replies too late and=20
kernel sends multiple request, one for each card. The behavior is completely
random, different every boot.

This is dmesg output from a system with three AR5414 PCI cards, all with=20
regdomain 0x36 (Czech Republic) exhibiting this problem:

ath5k 0000:02:01.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
ath5k 0000:02:01.0: registered as 'phy0'
ath: EEPROM regdomain: 0x36
ath: EEPROM indicates we should expect a direct regpair map
ath: Country alpha2 being used: CZ
ath: Regpair used: 0x36
udev: renamed network interface eth0 to eth2
udev: renamed network interface eth1_rename to eth0
phy0: Selected rate control algorithm 'minstrel'
ath5k phy0: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
ath5k 0000:02:02.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ath5k 0000:02:02.0: registered as 'phy1'
ath: EEPROM regdomain: 0x36
ath: EEPROM indicates we should expect a direct regpair map
ath: Country alpha2 being used: CZ
ath: Regpair used: 0x36
cfg80211: Calling CRDA for country: CZ
phy1: Selected rate control algorithm 'minstrel'
ath5k phy1: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
ath5k 0000:02:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ath5k 0000:02:03.0: registered as 'phy2'
ath: EEPROM regdomain: 0x36
ath: EEPROM indicates we should expect a direct regpair map
ath: Country alpha2 being used: CZ
ath: Regpair used: 0x36
cfg80211: Calling CRDA for country: CZ
udev: renamed network interface wlan1 to wlan3
phy2: Selected rate control algorithm 'minstrel'
ath5k phy2: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
cfg80211: Calling CRDA for country: CZ
udev: renamed network interface wlan1 to wlan2
cfg80211: Current regulatory domain intersected:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
(2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm)
(2457000 KHz - 2482000 KHz @ 20000 KHz), (N/A, 2000 mBm)
(2474000 KHz - 2483500 KHz @ 9500 KHz), (N/A, 2000 mBm)
(5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211: Current regulatory domain intersected:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
(2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm)
(2457000 KHz - 2482000 KHz @ 20000 KHz), (N/A, 2000 mBm)
(2474000 KHz - 2483500 KHz @ 9500 KHz), (N/A, 2000 mBm)
(5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211: Current regulatory domain intersected:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
(2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm)
(2457000 KHz - 2482000 KHz @ 20000 KHz), (N/A, 2000 mBm)
(2474000 KHz - 2483500 KHz @ 9500 KHz), (N/A, 2000 mBm)
(5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)

The result is that all but the last card stay in world regdomain with chann=
els=20
100-140 unavailable. Only the last card has correct channels enabled. I had=
=20
to disable some code at 4 places to get it working, so there might be mutip=
le=20
bugs, or they all have some common cause, but I couldn't find any. The ugly=
=20
patch I used is attached, hopefully it will provide some pointers to find o=
ut=20
what's wrong.

My guess is that the main problem is the use of the global variable
last_request, which is incompatible with asynchronous replies from CRDA.

Unfortunately it's quite hard for me to debug this problem because of the
random behavior and especially because I don't understand the purpose of so=
me
parts of the regulatory code - for example why do you calculate the
intersection at all, and don't just set on each card whatever regdomain is =
in
its EEPROM? What should happen if all cards have different regdomains?

Lukas Turek


diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 422da20..52536ae 100644
=2D-- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1156,6 +1156,8 @@ static int freq_reg_info_regd(struct wiphy *wiphy,
 	    wiphy->regd)
 		regd =3D wiphy->regd;
=20
+	regd =3D cfg80211_regdomain; //HACK
+
 	if (!regd)
 		return -EINVAL;
=20
@@ -1286,7 +1288,7 @@ static void handle_channel(struct wiphy *wiphy, enum =
ieee80211_band band,
 		bw_flags =3D IEEE80211_CHAN_NO_HT40;
=20
 	if (last_request->initiator =3D=3D NL80211_REGDOM_SET_BY_DRIVER &&
=2D	    request_wiphy && request_wiphy =3D=3D wiphy &&
+	    request_wiphy && /* request_wiphy =3D=3D wiphy && */ //HACK
 	    request_wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY) {
 		/*
 		 * This gaurantees the driver's requested regulatory domain
@@ -1327,6 +1329,8 @@ static void handle_band(struct wiphy *wiphy, enum iee=
e80211_band band)
 static bool ignore_reg_update(struct wiphy *wiphy,
 			      enum nl80211_reg_initiator initiator)
 {
+	return false; //HACK
+=09
 	if (!last_request)
 		return true;
 	if (initiator =3D=3D NL80211_REGDOM_SET_BY_CORE &&
@@ -2499,7 +2503,7 @@ static int __set_regdom(const struct ieee80211_regdom=
ain *rd)
=20
 	if (last_request->initiator !=3D NL80211_REGDOM_SET_BY_COUNTRY_IE) {
=20
=2D		intersected_rd =3D regdom_intersect(rd, cfg80211_regdomain);
+		intersected_rd =3D regdom_intersect(rd, rd); //HACK
 		if (!intersected_rd)
 			return -EINVAL;
=20

--nextPart18752801.UbissgIjxi
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iQIcBAABAgAGBQJL/pmPAAoJEEBjvk/UOfYw4cQP/0HxTP7uecAhsaFQLAEHqAX9
qPI2vMJwnmuYyMuq7Yi8X6tsi+c0xr0gikTadQ5Q7vzyKGbxXBE8YFvFOLzCBqDS
9vHVwZbNXwDleRv01lCLsuWfaijqSRPH7Sv944Gt+nfddHAS3nIx8KUGeDCExArb
YhtdFxu4kkm4GTftV6z3ROOE2NvBvmU5/WZVGkfRGshuCaVK8f8C9xWzhCV6Qt3X
5oeY4Tm2w7R9aUaQbr0JdHgBLgX5E0rwfwUbFEL40/idHfoEuK2Ss5ByiEJ5MK6l
lWOjgn4UYf3AmR9wHC+KRoUMh54Gg2gWUfdUu8jzm5p9sD1NOe1vK62/K5BSRpF3
SIQBIziPZ4Lo5SoaUrvfrF7LZT5erZM8ErUuIWxjH8OiCb4Od6gtUGfF8/4lMehe
UxlYyVR1tnnPSXeIQ1GrbhUbT1rUj+zJaZ23vg0Rf52TlUPbrsAd59maqvFInO2O
hDUXkmAB1DHQqWsVkduji3+QIDLyiNKqardCHZuk0xwz4hZwsroOATwClrgXN94T
aUQ9FZmrkOHpWNYn66XOlSranuElELKu2N44+61OHVoThDwr5EFKjpw7CEy3JD1r
gwBHQtZuANSbAQsVdeiKUQxHypovUc1gBYDR5v4YdQCCpKAIH7m5N4Wl66WztHBh
cOufkdDDC9qaImr2BCrV
=K4zI
-----END PGP SIGNATURE-----

--nextPart18752801.UbissgIjxi--
