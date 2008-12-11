Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47332 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbYLKSPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 13:15:25 -0500
Subject: Re: [Patch] nl80211: Add signal strength and bandwith to
	nl80211station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@googlemail.com>
Cc: Henning Rogge <rogge@fgan.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
In-Reply-To: <200812111902.24289.hrogge@googlemail.com> (sfid-20081211_190616_777198_C22FC159)
References: <200811252131.30161.hrogge@googlemail.com>
	 <200812111807.24168.hrogge@googlemail.com>
	 <1229016248.8081.44.camel@johannes.berg>
	 <200812111902.24289.hrogge@googlemail.com>
	 (sfid-20081211_190616_777198_C22FC159)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-u8bb17tF9yYS94yK4p5H"
Date: Thu, 11 Dec 2008 19:14:47 +0100
Message-Id: <1229019287.8081.49.camel@johannes.berg> (sfid-20081211_191529_398601_57E03141)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-u8bb17tF9yYS94yK4p5H
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-11 at 19:02 +0100, Henning Rogge wrote:

> Okay... I have included a casting to s8 into cfg.c so everyone is warned.=
..=20
> the original signal field in the sta_info struct is an int, but this stru=
cture=20
> is used by the drivers so I don't want to touch it.

Right, not sure what happens when it's not in dBm anyway.

> > Can you also send me the corresponding iw patch?
> Have to write a modified one, I will post it later this evening I think.

Ok. I noticed a few more things, sorry:

> + * enum nl80211_rate_info - bitrate information
> + *
> + * These attribute types are used with %NL80211_STA_INFO_TXRATE
> + * when getting information about the bitrate of a station.
> + *
> + * @__NL80211_RATE_INFO_INVALID: attribute number 0 is reserved
> + * @NL80211_RATE_INFO_BITRATE: total bitrate (u16, 100kbit/s)
> + * @NL80211_RATE_INFO_MCS: mcs index for 802.11n (u8)
> + * @NL80211_RATE_INFO_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
> + * @NL80211_RATE_INFO_SHORT_GI: 400ns guard interval

This needs documentation for __...after_last and ..._max too, I think,
or kernel-doc will complain, and then I get email on the next daily git
update and complain ;)

Other than that,

Acked-by: Johannes Berg <johannes@sipsolutions.net>

so feel free to add that into the patch when you resend.

johannes

--=-u8bb17tF9yYS94yK4p5H
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQViRAAoJEKVg1VMiehFYqRgP/1Ol4corZrHnDBeM3c+R+6PQ
WC0OzZRmHIlMlqqkzs1wXOejYBQEiSxBzraK/FSXB0hu5vAVA6Op2+H/8vFG4enW
tsSig47KW6E+BlbnHbVfGyEZBTorjuwx+kKRYUe5Rt5od4PVz1c/JCJ+fbNDeVWZ
58tTf4VBN2vxltneb/de2TDTRzI7BZOzWysgtAaXsSKZiveSriPwkTwzVAoOMxdr
4XkIIDqaMJocTMwI/7VYxcQ+I544XQbWfIqyl/zbmp37V8Hfdlrqg9Y0M4bJvYOL
YSjKOMYGM0cRQd0jENfWCynF27vHmSfe+9n0jOW3OcsoeWprSvwqH97UjkHSE1e+
ipzcbhml2BH0CLWsk3usWQjpJFCRjMo8aQLHxtRloB64D6IBxQywFlOPQlhT70CS
7nObw7Ay7xGWVmEww33121IcXB/SUOvSpLDQrY1FzLrfuCFPrUKFEyNoHt6ADcVL
AXazyG7iPuUcwU5Qe36csCifMZ+F5hrzQTlkNOELAgEwJ1cP0rrgMY4/FOVJAXPx
2sBEWN1GdcFOE+hqnhA6/jpBhQNky19tH5+nFEar3ArbppZipHuT947G2g1l2ro8
siQnCNu5dQgq8syVIHjMyuTdYmL26s5w3HpdWfvBJeUKPpi0wNJNfPShV8rpGPg0
wFjk/81BjKr7oZaqgNbz
=v94u
-----END PGP SIGNATURE-----

--=-u8bb17tF9yYS94yK4p5H--

