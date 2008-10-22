Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58377 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbYJVIRm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 04:17:42 -0400
Subject: Re: [PATCH ] mac80211: check return value of dev_alloc_skb() in
	ieee80211_sta_join_ibss().
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Rami Rosen <ramirose@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081022081149.GE16005@jm.kir.nu>
References: <eb3ff54b0810220000p71a54f53ped88651b62c6d35c@mail.gmail.com>
	 <1224660978.28639.27.camel@johannes.berg>
	 <eb3ff54b0810220042y43ea248qba1064a3eedf85b1@mail.gmail.com>
	 <20081022081149.GE16005@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-j3pjoPeU7RGxYuNAhQsQ"
Date: Wed, 22 Oct 2008 10:17:33 +0200
Message-Id: <1224663453.28639.37.camel@johannes.berg> (sfid-20081022_101746_624392_9984D006)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-j3pjoPeU7RGxYuNAhQsQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-22 at 11:11 +0300, Jouni Malinen wrote:
> On Wed, Oct 22, 2008 at 09:42:37AM +0200, Rami Rosen wrote:
>=20
> > Do we want to continue as usual if dev_alloc_skb() in theis method fail=
s?
>=20
> I think we should continue and as such, I would rather not see the patch
> that proposes to abort here go in. The allocated skb is not used at this
> point anyway; it is only used as an optimization to prepare a ProbeRsp
> frame for possible future use. This could be done at the time when
> ProbeReq is received (and we sent the last Beacon), i.e., only when
> needed. Or if the optimization of generating this only once is
> considered desirable, that place could try to allocate a new skb if the
> one here failed (or do it on first need and cache the result).

Good point. We currently don't try again, but we could put this into a
new function and call it from when we need it. Then again, we'll need it
right away, the driver will probably call _get_beacon from
ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);

johannes

--=-j3pjoPeU7RGxYuNAhQsQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/uGXAAoJEKVg1VMiehFYlywQALL1UI3zFEJatWMqzFH/vPw3
PbHiHu+zysUWsisIP6BokG+0VcqDbraUiC9PXmoNI/32e0wJs+d5qwBCNEtq2Qqk
3zlul0PA7vT7TzKbXyfCYcYv30zpLGFauVo+mj+a1xx+wGRPUc2E22KIPL25dtkA
WTRXoJ75ZiWKy4se83z05GnNOOHwHrJdb2U02DwvlgWXFP/tyD64Bj9ivtYyI2IS
rWdO2IJL3DP9NYyIzkF/CNsn6dHghs/n86XoL2w3QpMKS6UrJm+SHp4+8h4i89HL
UJgBnlmcohaJJcMzOyI1ErKmRnCJYOGtefp1ILwL5fAXz9Htr/3uaglhK/V0+VzG
iJYT2snS7Jhhexsag0AHd8xLQeS8Ps90a8AUk19YzZrNsX1lxbvQVFYaLNNVugvg
L2g8ek7LyaOxs5Wx4Wor7en46thWb7/FpqzHa6rex0Xk3SkMA/XZ2TEAXv204mX6
1+ZZ3nTiUxgdRoo6mtf1TGXqV2F4unE+jtLZWR4hKek5cgHJA3njE9sKz+vEz/Fj
msdLMzonYDnXpE40cIKAYQTi6H7aUBWBTTmhL9q7iSahvH6Hg47EW+2pGvWFI/Ap
SzcYqqLKS7jP5dmKGLT3S9G8oYAH+KU06oQYMUGq+FtzpxNokcI2fscfV2EpTsD9
aCdbtX6dQny18dwT7dL1
=MeZg
-----END PGP SIGNATURE-----

--=-j3pjoPeU7RGxYuNAhQsQ--

