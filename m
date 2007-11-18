Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:46952 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751942AbXKRD6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2007 22:58:14 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Edgar Toernig <froese@gmx.de>
Subject: Re: [rtl8185] driver working but some probs
Date: Sat, 17 Nov 2007 22:57:11 -0500
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
References: <20071116232001.70a4ae77.froese@gmx.de>
In-Reply-To: <20071116232001.70a4ae77.froese@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1885278.s4M9j9CY00";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200711172257.15418.flamingice@sourmilk.net> (sfid-20071118_035825_057433_6E717363)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1885278.s4M9j9CY00
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 16 November 2007 17:20:01 Edgar Toernig wrote:
> I tried the rtl8180 driver Michael posted on 2007-10-14
> ( http://marc.info/?m=3D119238789630565 ).  As he didn't
> mentioned what kernel the patch was for I took a 2.6.24
> snapshot from about two days ago (v2.6.24-rc2-409-g9418d5d).
>
The driver has been merged in wireless-2.6 and will be picked up by -mm at=
=20
some point.

> There were two compile time problems: the MAC_ARG macro
> was missing=20
A patch was posted to fix that. The driver was against the wireless-2.6 tre=
e=20
at the time of posting.

> and the symbols from rtl8180_rtl8225.c clash=20
> with those from rtl8187_rtl8225.c.  One has to choose
> either the rtl8187 driver or the rtl8180 driver.
>
Are you compiling as modules or into the kernel? I have no problems buildin=
g=20
both as modules.

> After that, the driver works - mostly.
>
> First thing I noticed: the reported "Link Signal Level"
> from iwconfig was way off.  It showed values around
> -170 dBm when it was sitting directly beside the AP.
> It was easy to fix:
>
> -     rx_status.ssi =3D (flags2 >> 8) & 0x7F;
> +     rx_status.ssi =3D (flags2 >> 8) & 0xFF;
>
> According to the 8180 datasheet, this field is 8 bit.
>
Ugh. The diagram (in the 8185 datasheet) shows that the rssi field is 7 bit=
s=20
long while the table after it says 8 bits, and the two figures disagree on =
a=20
few other fields too. I'll fix that up..

> First, bit rate almost immediately drops to 1 Mb/s
> even if the card sits right beside the AP.  Only
> if I force both, card and AP, to a fixed bitrate do
> I get reasonable performance (up to about 22 Mb/s,
> giving ~1MByte/s payload rate - it seems the laptop
> isn't faster; even on wired 100Mb/s ethernet I get
> max 2 MByte/s throughput.).
>
The rate control algorithm starts at 1 mbit and goes up with successful TXe=
s.=20
Try ping flooding (-f) your AP or doing a large file transfer and see if th=
at=20
gives the rate control enough information to push the speed up. It generall=
y=20
makes things settle around 18/24 mbit. (yes, mac80211 rate control needs to=
=20
be improved)

> Then, suspend doesn't work.  The driver seems to
> work but it won't see its AP any more.  It *can*
> see other APs, but not the one he is associated
> with.  rmmod/insmod is necessary.
>
Reassociation won't work?

> With the last problem I'm not sure whether it's a
> driver or a wpa_supplicant problem.  I can't connect
> to the AP if the ssid is hidden.  wpa_supplicant stays
> in SCANNING mode even though he already has the AP in
> his scan list.  Playing around with ap_scan=3D2 etc
> doesn't seem to help.  Any idea?
>
This problem is related to mac80211 and wpa_supplicant. There have been som=
e=20
patches posted to address these.. I think wireless-2.6 has them. Try=20
wireless-2.6 out. See http://linuxwireless.org/en/developers/git-guide for=
=20
information on pulling this tree.

Thanks for testing,
=2DMichael Wu

--nextPart1885278.s4M9j9CY00
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHP7gbT3Oqt9AH4aERArN/AKCUtIR9DfCX16/cWh1iKTeGq6mqqQCgtUl3
upILKQmwKcGL7oLUCZgyYCo=
=fpBY
-----END PGP SIGNATURE-----

--nextPart1885278.s4M9j9CY00--
