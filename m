Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55505 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbYAJMRW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 07:17:22 -0500
Received: from [131.234.199.10]
	by sipsolutions.net with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.68)
	(envelope-from <johannes@sipsolutions.net>)
	id 1JCwLZ-0002tK-0z
	for linux-wireless@vger.kernel.org; Thu, 10 Jan 2008 12:17:21 +0000
Subject: [RFC v3] cfg80211 API for channels/bitrates, mac80211 and driver
	conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mKmLxlA49VWtDSGOKMKj"
Date: Thu, 10 Jan 2008 13:17:03 +0100
Message-Id: <1199967423.3861.51.camel@johannes.berg> (sfid-20080110_121725_060148_B022943A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mKmLxlA49VWtDSGOKMKj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This patch creates new cfg80211 wiphy API for channel and bitrate
registration and converts mac80211 and drivers to the new API. The
old mac80211 API is completely ripped out. All drivers (except ath5k)
are updated to the new API, in many cases I expect that optimisations
can be done.

Along with the regulatory code I've also ripped out the
IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED flag, I believe it to be
unnecessary if the hardware simply gives us whatever channels it wants
to support and we then enable/disable them as required, which is pretty
much required for travelling.

Additionally, the patch adds proper "basic" rate handling for STA
mode interface, AP mode interface will have to have new API added
to allow userspace to set the basic rate set, currently it'll be
empty... However, the basic rate handling will need to be moved to
the BSS conf stuff.

I do expect there to be bugs in this, especially wrt. transmit
power handling where I'm basically clueless about how it should work.

Patch is too large for this list (almost 310KiB)

http://johannes.sipsolutions.net/patches/kernel/all/2008-01-10-11%3a59/016-=
cfg80211-channel-and-bitrate-api.patch

johannes

--=-mKmLxlA49VWtDSGOKMKj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4YMvqVg1VMiehFYAQL59RAAs8afX6uvZ3tKN/ig8TevPxarqTEInKGe
AN1flNFWi8OBNWoaxhdhkNI9UaAgFj8sydh6MB6KnVKP9u8x9HD7/n1kGg6vV5nE
RI65ksIOgAZ+OAIfTtoZONaKZ6ftzGGDAypowIeFDT7I7cYqzeicc91wXkicb6fG
bydyx7sqd3rf0Dld6mwctjWLLckFP0OIu9tIV3QS3eTD7IUmjj51pFWk4PNhZsFd
W2vizqKluC300kVPPr9no7VIzCpJplB7vK2PkA6EzcrNimOlRA4aZ20eEgnHuEkY
osnSrIPB1I1d6EVxkGUakvoz2NgWShBxrxXwUxE1ZN4XsgXBw2ThffIdxmQ+5FD3
21TB6gu7ji9up558eCwGrNdRYEChSZ2Tp+vgHDINYKh31saOako06nnU8HtayFLn
HqgDm/MzD5u4nbe4jMYcJCJdxs68re5TWmbqWDDNip9szZeFQI2UXG7lR+SkSwod
8/XHRyNoMfXOvtBJflQ6TbKVx8Fl/AWojyp/GpuBraXt+D2Y4y57ivaZv2fxavRA
FqbfdxYTxeffv94w+blQYCrSLAUeG0+ma+uJ6Wih6LyPqX4jsFXPRPrD73PcV9vu
M58fXD4pC593Na2iFs0b2/t4gr0jQJSsTyh+hg9uBM9ZhnRkpVVq6Nl3oOcguc8G
MgU7M2kOB0Y=
=AyUk
-----END PGP SIGNATURE-----

--=-mKmLxlA49VWtDSGOKMKj--

