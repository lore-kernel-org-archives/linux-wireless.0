Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46078 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbYD0LYj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Apr 2008 07:24:39 -0400
Subject: Re: [PATCH] mac80211: incorrect shift direction
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1209293320.14173.63.camel@brick> (sfid-20080427_124905_831819_B50E5C6D)
References: <1209293320.14173.63.camel@brick>
	 (sfid-20080427_124905_831819_B50E5C6D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KAGzhwQzCVpNumCfeXKt"
Date: Sun, 27 Apr 2008 13:24:30 +0200
Message-Id: <1209295470.10943.65.camel@johannes.berg> (sfid-20080427_132452_091763_2C23545A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KAGzhwQzCVpNumCfeXKt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-04-27 at 03:48 -0700, Harvey Harrison wrote:
> Looks like  5d2cdcd4e85c5187db30a6b29f79fbbe59f39f78 got the
> shifts wrong.

Aha! Thanks for tracking this down. We had a patch to fix this but were
confused why the bug hadn't been noticed before. So it looks like it
wasn't *present* before :)

johannes


> =EF=BB=BF
> Noticed by sparse:
> net/mac80211/tkip.c:234:25: warning: right shift by bigger than source va=
lue
> net/mac80211/tkip.c:235:25: warning: right shift by bigger than source va=
lue
> net/mac80211/tkip.c:236:25: warning: right shift by bigger than source va=
lue
>=20
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  net/mac80211/tkip.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
> index dddbfd6..09093da 100644
> --- a/net/mac80211/tkip.c
> +++ b/net/mac80211/tkip.c
> @@ -230,10 +230,8 @@ void ieee80211_get_tkip_key(struct ieee80211_key_con=
f *keyconf,
> =20
>         iv16 =3D data[hdr_len] << 8;
>         iv16 +=3D data[hdr_len + 2];
> -       iv32 =3D data[hdr_len + 4] +
> -               (data[hdr_len + 5] >> 8) +
> -               (data[hdr_len + 6] >> 16) +
> -               (data[hdr_len + 7] >> 24);
> +       iv32 =3D data[hdr_len + 4] | (data[hdr_len + 5] << 8) |
> +              (data[hdr_len + 6] << 16) | (data[hdr_len + 7] << 24);
> =20
>  #ifdef CONFIG_TKIP_DEBUG
>         printk(KERN_DEBUG "TKIP encrypt: iv16 =3D 0x%04x, iv32 =3D 0x%08x=
\n",

--=-KAGzhwQzCVpNumCfeXKt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBRibaVg1VMiehFYAQJgrg//fa6Nvs+wanvE2eClzqyOfWUifYn7hUuR
tw7cHdusXqrZFTpAtoqZGonfOsuWJWrDPFLQWu3PiwPPvthC5cdIZW5RyFuQiHGW
G3rNse1Ujp5qu8zI9Sj74OFrYHlmDzqDYS4BgrPOepRQFiLkRdolYTeiUtgvLjQA
TdWDUbs9ccxCcxSuUs5px95RYLWPZyf3tlbxPeAEZPfR8kXS/TGFg/z5IxXwUFxY
SCxNel7O8AOljKDQuIRa9xJ/b360xVaes9WJmTBVKO+utOu5VVPGsGqsz0OfOoaP
04iDtXPKKwIg5pCQAJnfozrNkVxX9dRiJ8BBRKrcN2suQHuJWnbTMUqHpXauIS6T
t3R2iFWAHm5r7zftoeG6lwaOrMrw/BePZtSrLceTPKN/iVKf9RgEbSWALr4P49Ur
j442gh5etUgs6UO62fgBoq2yoAoSbhQmyQrek3xmE/O2p9PGtwVzNLqYBIiwyEai
JgxdPgDcFRvb6+4QQyfOeeDcqdLHffHDTmbbrsPqcbNrSFiJo9chRQsFQ8ibg5WT
muV8mEaE+173Sc2VB2+lzO5H/HiEPutY8uwUBrDMEgtn/xjyZLcs4RYPbZZ7pjEJ
v51Jz8vkxJ/zCXRUUlamoNcUo9kPVkB2y6X1+9KgecBFo+bAl0fkx7kZgxsSxRad
v34QrIZhxBc=
=DqMW
-----END PGP SIGNATURE-----

--=-KAGzhwQzCVpNumCfeXKt--

