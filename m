Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60555 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbYLGRjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 12:39:44 -0500
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@googlemail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Henning Rogge <rogge@fgan.de>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
In-Reply-To: <200812071832.20533.hrogge@googlemail.com> (sfid-20081207_183226_187045_51440084)
References: <200811252131.30161.hrogge@googlemail.com>
	 <1228579172.16752.21.camel@johannes.berg>
	 <43e72e890812061246n1d63c306x942759674cf0b26a@mail.gmail.com>
	 <200812071832.20533.hrogge@googlemail.com>
	 (sfid-20081207_183226_187045_51440084)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RBVcUt1Elbtb2jvL+Y1a"
Date: Sun, 07 Dec 2008 18:39:38 +0100
Message-Id: <1228671578.22164.48.camel@johannes.berg> (sfid-20081207_183947_863695_4738E921)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RBVcUt1Elbtb2jvL+Y1a
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-12-07 at 18:32 +0100, Henning Rogge wrote:

> I think the suggestion is to remove the total/legacy bitrate for 802.11n=20
> completely from the nl80211 station_info. Which I still think is not a go=
od=20
> idea. This way we force any  application displaying the bitrate to check =
for=20
> several cases, know about the 802.11n table, ...
> I think it's funny that we have the "total bitrate" information available=
 on=20
> driver level but translate it into the mcs index with the help of tables.=
..=20
> and assume that userspace knows about the tables.

Alright, whatever, put it in, but please do the calculation in cfg80211
(nl80211.c). Should rename it to _TOTAL again then, though, I guess.

>  /**
> + * enum nl80211_sta_info_rate - station information about bitrate
> + *
> + * These attribute types are used with %NL80211_STA_INFO_TXRATE
> + * when getting information about the bitrate of a station.
> + *
> + * @__NL80211_STA_INFO_RATE_INVALID: attribute number 0 is reserved
> + * @NL80211_STA_INFO_RATE_LEGACY: bitrate for 802.11abg (u16, 100kbit/s)
> + * @NL80211_STA_INFO_RATE_MCS: mcs index for 802.11n (u8)
> + * @NL80211_STA_INFO_RATE_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
> + * @NL80211_STA_INFO_RATE_SHORT_GI: 400ns guard interval
> + */
> +enum nl80211_sta_info_rate {
> +	__NL80211_STA_INFO_RATE_INVALID,
> +	NL80211_STA_INFO_RATE_LEGACY,
> +	NL80211_STA_INFO_RATE_MCS,
> +	NL80211_STA_INFO_RATE_40_MHZ_WIDTH,
> +	NL80211_STA_INFO_RATE_SHORT_GI,
> +
> +	/* keep last */
> +	__NL80211_STA_INFO_RATE_AFTER_LAST,
> +	NL80211_STA_INFO_RATE_MAX =3D __NL80211_STA_INFO_RATE_AFTER_LAST - 1
> +};

Can you rename those too to NL80211_RATE_INFO_*? That way we can use
them for other things later.

But this looks good to me now.

johannes

--=-RBVcUt1Elbtb2jvL+Y1a
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPApWAAoJEKVg1VMiehFYwqoP/3uAFp9o8RQUWv3nGT6+oLbV
ZVimu0PBvq0GiOjSs4FEmlCnKNFgtPjI9BshJgW4aObLXretHETdDQSMwEyOLnfx
biyquYeGvVSm7Wg8YYHpVuTxm790R06lt0+aUH6r1lXi4GkAq7ncscHY/U2qaLTf
imew6GP1ZK6OWMLRFBYfGq85u9fxSSZh9MWGFL2oia11bj12+Su1BV0SLdng3ExA
FMQlWaOGowGSu9N3dKkyziRjXSTYkgdtdHl9VxMzamkH1SGaQLDcOk0hGTrGv6oB
SF6QQxcVxT882Rg0KAKpio4b38SNENjKC83Qi0l6VNKxgIzxBhqw5oZWHI5D24wv
SSGXiVzvFK5Cir2NT4L/LpnOJ+xPYAwsRna4UkPI8ZQ7oNrxi1m+/4DtDjzdHBKn
q2hbxMaGRdFkMbf2K3hGoDD3evNPC25l/ia5REYFB+4V3izT2E4ro2OeJ0Z/2Ke8
eF9Vk/j8NBhVHQoeIKBpgFayyFvaXcNcug5z9L7vrRfRl63GjVYW4MgGb8r2uJwD
Euoibikld7J1S1xtV56SqHs3uoCanYFYTWc3/jqBdsaBeO/m41qgTqv2wVXyuW30
DomOcR4JDymT7VirfyQtnOi1x7FJv4uVeYSrPMSefdjHlrNkS/9cmo1ylQypfu0/
dkp1bwUL3v0bzr1ebFXf
=19EW
-----END PGP SIGNATURE-----

--=-RBVcUt1Elbtb2jvL+Y1a--

