Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52455 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbYJWGl6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 02:41:58 -0400
Subject: Re: [PATCH] mac80211: correct warnings in minstrel rate control
	algorithm
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1224718894-25861-1-git-send-email-linville@tuxdriver.com> (sfid-20081023_014146_340361_0F53A941)
References: <1224718894-25861-1-git-send-email-linville@tuxdriver.com>
	 (sfid-20081023_014146_340361_0F53A941)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Eg0jkvXBz9puaxNjWo9o"
Date: Thu, 23 Oct 2008 08:41:52 +0200
Message-Id: <1224744112.5865.13.camel@johannes.berg> (sfid-20081023_084205_736189_33466BF1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Eg0jkvXBz9puaxNjWo9o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Thanks, somehow I thought Felix had already posted that. Must've been
wishful thinking ;)

On Wed, 2008-10-22 at 19:41 -0400, John W. Linville wrote:
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  net/mac80211/rc80211_minstrel_debugfs.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc802=
11_minstrel_debugfs.c
> index 0b024cd..98f4807 100644
> --- a/net/mac80211/rc80211_minstrel_debugfs.c
> +++ b/net/mac80211/rc80211_minstrel_debugfs.c
> @@ -94,8 +94,8 @@ minstrel_stats_open(struct inode *inode, struct file *f=
ile)
>  				prob / 10, prob % 10,
>  				mr->last_success,
>  				mr->last_attempts,
> -				mr->succ_hist,
> -				mr->att_hist);
> +				(unsigned long long)mr->succ_hist,
> +				(unsigned long long)mr->att_hist);
>  	}
>  	p +=3D sprintf(p, "\nTotal packet count::    ideal %d      "
>  			"lookaround %d\n\n",
> @@ -106,7 +106,7 @@ minstrel_stats_open(struct inode *inode, struct file =
*file)
>  	return 0;
>  }
> =20
> -static int
> +static ssize_t
>  minstrel_stats_read(struct file *file, char __user *buf, size_t len, lof=
f_t *o)
>  {
>  	struct minstrel_stats_info *ms;

--=-Eg0jkvXBz9puaxNjWo9o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJABysAAoJEKVg1VMiehFYWTgP/3WnAQ6VXP9D/o9UQW0lViah
NBvp0H4istdRrpSOnK4gtYH0r//b4h1dZvPw5le+hGfRqQGF80TLE47sTyv+7DES
stcn5goulhqF0Zyu4bsS69EHIX0PT31VDbAW+4mjTRgD8mo3DbDgRswctAV7NySx
95eOrHxHziY0mtDlcZcIRHRdz3VukwM5ujDTMILRHxh4T2pZj/+bruXb6JSLFgXY
YGYshkQuB9mS+OSfMrNlF7gdC96EgK3jpLqpXMGn/Ec8PzWvc8zhqckyrq6wgAgl
N6QGPQxL1CdckBYV1bkmBJS5XTavcm9sfQgLHwro9AO+3HTRKk9J80tn1maFe7aR
G/0hfnpVoJJAaM21/N9dpvkJk9A0x3fR+GwDpBoZBdg3SxDmsTJXmhgA5qZLm9xo
PE6kkB+P+Ynh1w0hB2UuJccNq/1deNkIwdAwcqX7/fboZgqKs+wHk2vNNU/VHwuQ
K9qb999j27qxVxri4kvltPWjR5gHrIMR2WmtY/tszqDJNN2fBsNFTSpUMpW/X+Fe
X09s/EV2WPJcEg2UTFzRKsJPag8C9FAex5L1w8Mi08SOWIubHnNw1+XvSOkRfDOO
AoGHvLgb/h4CXGljclI+p5+9WjJYk3LxlVZwUQsaAesoFM35EAVv1bI0pFVHJH2T
ecrYxFWWS3Q4j4aZ5NHj
=g+q7
-----END PGP SIGNATURE-----

--=-Eg0jkvXBz9puaxNjWo9o--

