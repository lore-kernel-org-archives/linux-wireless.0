Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50460 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbXFTLQc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 07:16:32 -0400
Subject: Re: [PATCH Try#lucky13 3/3] mac80211: Monitor mode radiotap-based  packet injection
From: Johannes Berg <johannes@sipsolutions.net>
To: andy@warmcat.com
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>
In-Reply-To: <20070614123704.801683087@warmcat.com>
References: <20070614123316.868155662@warmcat.com>
	 <20070614123704.801683087@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BoxwivUrgYqEKcRHSX33"
Date: Tue, 19 Jun 2007 22:45:15 +0200
Message-Id: <1182285915.3714.5.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BoxwivUrgYqEKcRHSX33
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Nothing about this patch, I'm fine with it, but a comment for future use
cases of this where we'll need some changes.

> @@ -1284,15 +1442,26 @@ static int ieee80211_tx(struct net_devic
>  		return 0;
>  	}
> =20
> -	__ieee80211_tx_prepare(&tx, skb, dev, control);
> +	res_prepare =3D __ieee80211_tx_prepare(&tx, skb, dev, control);
> +
> +	if (res_prepare =3D=3D TXRX_DROP) {
> +		dev_kfree_skb(skb);
> +		return 0;
> +	}
> +
>  	sta =3D tx.sta;
>  	tx.u.tx.mgmt_interface =3D mgmt;
>  	tx.u.tx.mode =3D local->hw.conf.mode;
> =20
> -	for (handler =3D local->tx_handlers; *handler !=3D NULL; handler++) {
> -		res =3D (*handler)(&tx);
> -		if (res !=3D TXRX_CONTINUE)
> -			break;
> +	if (res_prepare =3D=3D TXRX_QUEUED) { /* if it was an injected packet *=
/
> +		res =3D TXRX_CONTINUE;
> +	} else {
> +		for (handler =3D local->tx_handlers; *handler !=3D NULL;
> +		     handler++) {
> +			res =3D (*handler)(&tx);
> +			if (res !=3D TXRX_CONTINUE)
> +				break;
> +		}

I think I mentioned it before; we'll have to split up TX handlers here
to get proper sequence numbering for devices that do it in software,
otherwise we won't be able to send packets with the right sequence
number on such devices.

johannes

--=-BoxwivUrgYqEKcRHSX33
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGeEBb/ETPhpq3jKURAmUZAKCryAWyvZoGvg295h7R94DUB0STcwCgja97
b49oAYHuh8M7VSzm+xK46Fo=
=aBnk
-----END PGP SIGNATURE-----

--=-BoxwivUrgYqEKcRHSX33--

