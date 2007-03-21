Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54230 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030342AbXCVKFF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2007 06:05:05 -0400
Subject: Re: [PATCH 1/4] mac80211: Coding style cleanups
From: Johannes Berg <johannes@sipsolutions.net>
To: andy@warmcat.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070320104104.112865979@warmcat.com>
References: <20070320103955.600509703@warmcat.com>
	 <20070320104104.112865979@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NUhPxIb5q+tWW2XfJ0P9"
Date: Wed, 21 Mar 2007 19:58:23 +0100
Message-Id: <1174503503.3944.50.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NUhPxIb5q+tWW2XfJ0P9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-03-20 at 10:39 +0000, andy@warmcat.com wrote:

I don't really see why this is necessary at all, but anyway.

> -			     (tx->fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA)) {
> +			     (tx->fc & IEEE80211_FCTL_FTYPE)
> +=3D=3D			      IEEE80211_FTYPE_DATA)) {

That's totally borked.

> -		if (unlikely((tx->fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DA=
TA &&
> +		if (unlikely((tx->fc & IEEE80211_FCTL_FTYPE) =3D=3D
> +		             IEEE80211_FTYPE_DATA &&

Indent that a bit more so it's clear it belongs to the line above and
isn't a condition itself.
=20
>  	if (unlikely(!sta ||
>  		     ((tx->fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_MGMT &&
> -		      (tx->fc & IEEE80211_FCTL_STYPE) =3D=3D IEEE80211_STYPE_PROBE_RES=
P)))
> +		      (tx->fc & IEEE80211_FCTL_STYPE) =3D=3D
> +		       IEEE80211_STYPE_PROBE_RESP)))

ditto.

> @@ -1170,7 +1178,8 @@ static int __ieee80211_tx(struct ieee80211_local *l=
ocal, struct sk_buff *skb,
>  						IEEE80211_TXCTL_RATE_CTRL_PROBE;
>  				else
>  					control->flags &=3D
> -						~IEEE80211_TXCTL_RATE_CTRL_PROBE;
> +						~IEEE80211_TXCTL_RATE_CTRL_PROBE
> +					;

ahem.

> -				printk(KERN_DEBUG "%s: ieee80211_beacon_get: no rate "
> +				printk(KERN_DEBUG
> +				       "%s: ieee80211_beacon_get: no rate "
>  				       "found\n", local->mdev->name);

Please change that to
	... no "
	"rate found\n", ...

instead.
=20
>  __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
>  				    size_t frame_len,
> -				    const struct ieee80211_tx_control *frame_txctl)
> +				    const struct ieee80211_tx_control
> +					*frame_txctl)

That's not how the kernel looks like in that case. I'd prefer this as

__le16 ieee80211_ctstoself_duration(
	struct ieee80211_hw *hw,
	size_t frame_len,
	const struct ieee80211_tx_control *frame_txctl)


>  			if (rx->sdata->bss)
> -				bss_tim_clear(rx->local, rx->sdata->bss, rx->sta->aid);
> +				bss_tim_clear(rx->local, rx->sdata->bss,
> +					rx->sta->aid);

You have lots of space to indent it to the parenthesis.
=20
> -		if ((fc & IEEE80211_FCTL_FTYPE) !=3D (f_fc & IEEE80211_FCTL_FTYPE) ||
> +		if ((fc & IEEE80211_FCTL_FTYPE) !=3D
> +		    (f_fc & IEEE80211_FCTL_FTYPE) ||

same as above.

> -		       (rx->fc & IEEE80211_FCTL_STYPE) =3D=3D IEEE80211_STYPE_PSPOLL))=
 &&
> +		       (rx->fc & IEEE80211_FCTL_STYPE) =3D=3D
> +		        IEEE80211_STYPE_PSPOLL)) &&

ditto.

>  		     (rx->fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA &&
> -		     (rx->fc & IEEE80211_FCTL_STYPE) !=3D IEEE80211_STYPE_NULLFUNC &&
> +		     (rx->fc & IEEE80211_FCTL_STYPE) !=3D
> +		      IEEE80211_STYPE_NULLFUNC &&

ditto.

> -		     (rx->fc & IEEE80211_FCTL_STYPE) !=3D IEEE80211_STYPE_NULLFUNC &&
> +		     (rx->fc & IEEE80211_FCTL_STYPE) !=3D
> +		      IEEE80211_STYPE_NULLFUNC &&

ditto.
=20
> @@ -3800,8 +3820,9 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct=
 sk_buff *skb,
>  						continue;
>  					rx.u.rx.ra_match =3D 0;
>  				} else if (!multicast &&
> -					   compare_ether_addr(sdata->dev->dev_addr,
> -							      hdr->addr1) !=3D 0) {
> +					   compare_ether_addr(
> +						sdata->dev->dev_addr,
> +						hdr->addr1) !=3D 0) {
>  					if (!sdata->promisc)
>  						continue;


Ugh. Somebody really needs to take this code and delete some indent by
moving stuff into new functions.

>  					if (net_ratelimit())
> -						printk(KERN_DEBUG "%s: failed to copy "
> +						printk(KERN_DEBUG
> +						       "%s: failed to copy "
>  						       "multicast frame for %s",
> -						       local->mdev->name, prev->dev->name);
> +						       local->mdev->name,
> +						       prev->dev->name);

Same as I said for that other message.

johannes

--=-NUhPxIb5q+tWW2XfJ0P9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGAYBP/ETPhpq3jKURAvMJAJ9NW2YoaOBvK8qK0jxKB9z2YZQxIACgmnxP
8x1rAX1QfsYrz3vQOgWH5EU=
=/Sb2
-----END PGP SIGNATURE-----

--=-NUhPxIb5q+tWW2XfJ0P9--

