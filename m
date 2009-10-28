Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35069 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbZJ1UPy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 16:15:54 -0400
Subject: Re: [PATCH] mac80211: make align adjustment code support paged SKB
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <1256760832-29063-1-git-send-email-reinette.chatre@intel.com>
References: <1256760832-29063-1-git-send-email-reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JqNi+n14dT4Ui+kDADg6"
Date: Wed, 28 Oct 2009 21:15:28 +0100
Message-ID: <1256760928.4237.250.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JqNi+n14dT4Ui+kDADg6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-10-28 at 13:13 -0700, Reinette Chatre wrote:
> From: Zhu Yi <yi.zhu@intel.com>
>=20
> This fixed a BUG_ON in __skb_trim() when paged rx is used in
> iwlwifi driver. Yes, the whole mac80211 stack doesn't support
> paged SKB yet. But let's start the work slowly from small
> code snippets.
>=20
> Reported-and-tested-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

we'll also be working on moving more paged RX awareness into the stack
so other drivers can benefit and things get more efficient.

johannes

> ---
>  net/mac80211/rx.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 5c385e3..a50d5f3 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1337,10 +1337,10 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *r=
x)
>  				skb =3D NULL;
>  			} else {
>  				u8 *data =3D skb->data;
> -				size_t len =3D skb->len;
> -				u8 *new =3D __skb_push(skb, align);
> -				memmove(new, data, len);
> -				__skb_trim(skb, len);
> +				size_t len =3D skb_headlen(skb);
> +				skb->data -=3D align;
> +				memmove(skb->data, data, len);
> +				skb_set_tail_pointer(skb, len);
>  			}
>  		}
>  #endif


--=-JqNi+n14dT4Ui+kDADg6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK6KZcAAoJEODzc/N7+Qma9eEP/2xxA2OwMhK+CZQtJEofLliE
3IKuqAf+fUDy5azXDfC37/s1BEiOxvNZmvJ4sl7BChLPA7QYK9xWKZqRkJr0Bxh4
erSg5Tr2usG3CHY1G/hcQq6DO39Et8P91e9f6JUq0F18vFlpTs/GnaH/qLG1onYI
r+f9LmIZTHAu1iDjsrFr9qcMTG5zqbcyQbfha2n1Ayr3yRg8CytCQGGudFTq0yNH
BwIlkir+ZfzR6aSKRoQ3S/mMB3S6s1VeY23l9om87T6X12uOWH4a+WCk8vikAlaZ
W8XTj3BugctX1brp581AZOoRxxRtWyNqnPw53pCqOxUak9yzlwLOhtQ62yQi9YPb
Fj5gKulUTSAg3UCgEL88KzxNZqEY1ILoTQX+RFrjwVgCHSm+ERRMiJRKzVKmxES4
Xy4QQOJyApy8FM7NpYOJZKtUjytKRS0jMf9Dlr5sbvw/Tyj9s3B6w98RddbLTumt
xE/u0HD2x7ZVVAourdun1N7SZNPcAnLXKG5YJO2/LFO5rzo8x70hvFi838emP/HM
e5QFJfcnl9YtAa/lbKrLNyJz7miT/PDhgml5hgC10yrahPAUAvccoyOR2Wi32/w2
yfzK1xVqy4roXqMXNyO6ySAGhMJsubXBg5HHmrbQvs40MU+MQ++9M0ZMFZ7T90jZ
8jruSs66MHLRG3Hs8vhU
=FSSi
-----END PGP SIGNATURE-----

--=-JqNi+n14dT4Ui+kDADg6--

