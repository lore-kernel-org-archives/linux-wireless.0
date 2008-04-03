Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60045 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbYDCMw1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 08:52:27 -0400
Subject: Re: mac80211 -- My log files are filling up with: "wlan0: RX
	non-WEP frame, but expected encryption"
From: Johannes Berg <johannes@sipsolutions.net>
To: Miles Lane <miles.lane@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <a44ae5cd0804021732s6ae5ed81ma5e229ae0faf4aaf@mail.gmail.com> (sfid-20080403_013238_466005_CF563BE7)
References: <a44ae5cd0804021732s6ae5ed81ma5e229ae0faf4aaf@mail.gmail.com>
	 (sfid-20080403_013238_466005_CF563BE7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-q3DZVVyiyOis7n8FjxMo"
Date: Thu, 03 Apr 2008 14:45:56 +0200
Message-Id: <1207226756.3636.66.camel@johannes.berg> (sfid-20080403_135257_509725_35FED48D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-q3DZVVyiyOis7n8FjxMo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Please copy the mailing list, I've done that now.

> My log files are filling up with these messages:
>=20
>        [ 8722.198929] wlan0: RX non-WEP frame, but expected encryption
>        [ 8726.506345] __ratelimit: 14 messages suppressed

> ./rx.c:			printk(KERN_DEBUG "%s: RX non-WEP frame, but expected "


> It seems that others who are using Netgear WPN824 access points are
> also seeing these messages in their logs.
> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=3D1614
> http://ubuntuforums.org/showthread.php?t=3D637084
>=20
> I am wondering whether this indicates a problem situation with the
> access point that really needs to be reported.  Is this being reported
> because it is a security risk?   Is this a condition that really needs
> to be reported by wireless drivers?

Hm. You shouldn't actually be getting this when your AP is configured to
use encryption. It either points to somebody trying to invade your
network (unlikely) or an AP bug.

Can you use 'iw' to add a new monitor interface and capture some of the
unencrypted packets with that? Use

$ git clone http://git.sipsolutions.net/iw.git/
$ cd iw
$ make

# ./iw dev wmaster0 interface add moni0 type monitor

and then wireshark/tcpdump on it, you can also send me the dump in
private mail if you cannot identify the problem. If you *disable* hw
crypto I won't even be able to read your actual traffic :)

johannes

--=-q3DZVVyiyOis7n8FjxMo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/TRg6Vg1VMiehFYAQJj3g/9G1ydGITc7qyKlLjt7iSus8LwK5e62JRu
1S3LG4GcBoYaCCsNjEliF3C0xSuDFw+WkFBPFZoyaYEi3hIJz8PHymSxUy9uEmmp
JTRu1yrODCZ6rZWHRBZ+VgHIDHUHuQsXMqmvUWi6TQoGAMqr1cztgVndoKSMrENo
53Gy6GNJHGTCusr26FKZmiDQbEwuJE/EuZniDgw49u5RQmcRFmgNp5mRouBg6Uk0
kFHTAs8EmJYurQH3JEIILVoHHnnc4mHlm8UstL+Pb08JdFnCA9BwniKoJPPh8f+W
1/Zwec66ejavs1sIn1fCStVujSutze55kr8v4tp4HG+UXwUcNtOV8oQHINYZs8Ti
W4J0zn/sPa0lYqFIOlojPC2JyBANjLUZrpOotbrusxwaWioLAmLV/Kfb6Mr5O/N/
NEw489smIyCJH/Nal+bnojIiUaN3eL9Q2/WQrl1yhBaBE/kaC/5DMvNYbh0i1oOq
klVjD9resXos8iB5MCfnn5Yv3mexdVYZ2jQvq4eSURjAf3VXs4oDY7e2wDvQ2Vee
L1mQaz7CU/fMjsRMcq3vO9n5h1E8S3PQdBGzAEIPcYp4C6WOts858XgXhDDpe4IR
mGewYWNRvWXc+Qsz2bvpKw4Tx+lNhuCl16Qxy0zlGluD2grxkgms4zSdZeqS75jI
NN7cblH7Bbw=
=NpaV
-----END PGP SIGNATURE-----

--=-q3DZVVyiyOis7n8FjxMo--

