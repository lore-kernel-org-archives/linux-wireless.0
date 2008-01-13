Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50771 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbYAMNIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 08:08:18 -0500
Subject: Re: [PATCH] mac80211: Initialize vif pointer
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200801131402.26165.IvDoorn@gmail.com> (sfid-20080113_130244_390201_5373C434)
References: <200801131402.26165.IvDoorn@gmail.com>
	 (sfid-20080113_130244_390201_5373C434)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-H+oqcdb6P+pwEX1+2AEk"
Date: Sun, 13 Jan 2008 14:07:58 +0100
Message-Id: <1200229679.5887.3.camel@johannes.berg> (sfid-20080113_130827_300116_78D628A4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-H+oqcdb6P+pwEX1+2AEk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sun, 2008-01-13 at 14:02 +0100, Ivo van Doorn wrote:
> Before calling update_beacon() mac80211 must
> initialize the control.vif pointer so it can
> be used by the driver to determine which
> interface is trying to send the beacon.

Good catch, thanks Ivo. I'd prefer if it was set a few lines lower
though where all the other control members are initialised. Mind
respinning? Feel free to add

Acked-by: Johannes Berg <johannes@sipsolutions.net>


> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>


> ---
>=20
> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index 4f5d5c6..8a35fed 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -2536,6 +2536,7 @@ static int ieee80211_sta_join_ibss(struct net_devic=
e *dev,
>  		}
> =20
>  		memset(&control, 0, sizeof(control));
> +		control.vif =3D &sdata->vif;
>  		rate_control_get_rate(dev, local->oper_hw_mode, skb, &ratesel);
>  		if (!ratesel.rate) {
>  			printk(KERN_DEBUG "%s: Failed to determine TX rate "
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-H+oqcdb6P+pwEX1+2AEk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4oNLaVg1VMiehFYAQI5WhAAqvi+hAuVmYs+JtYw+2f6R2J1f602K88p
vjl3JCDLh4ouZG3ldXIeCyssAIZBFqjue4354U274YLj3QjBhh+2ohR5vMg3uffN
Hw7SH0u9MlhIBmt/Nc1I5tiKAaHNSG5Z9ADmTEPCJrvTdtb8LcSVII/PWD/qCF/f
9WJbKZKJTsHn9eVa0G7HyVbAuiuu59fsivZHyInNsbnPRslpgl+Otd/yUQfeSMw0
aX8xD9ewLWabvyfXW/QwpN/qT+vr/+syWur839HxaNdXEApNYP0rfI+cyfdxtIzI
Wcz/NF4XQ7K0X/faRco9dPE1NbxtAxHtBnyZyjwa5nO4yxtSU0IQK/V519+Azc1S
E2QDgJYL/Ze4jLS70jhgQGeoCoVaTP9Ghern2vKhEQg5DaV3zmai9ZsUzL+95VAT
WoW3EayC9TLqK/vg9H3ZawVC/PcczMZKISquRXixTURsBxeA6uuTm4eZg795ys0S
y6nNZZdfr24QoRPjMCwPy1TqRyOAxBkfTzRSPEanzYWTC48dBPclWZInSRS3lwD/
ISZOTuVlkou8i9RY5Dl1r5SlFJi4XD/n4y5mBRpDzp9+eEltddWUF0mRhzR1Xiz0
3ZzXn6fntg5wiJdloQr/tzox3bq67wlJeVokS5bPTRHjO1FJ8sdztslCr4Oyc15A
+r3VtJFg1qw=
=yvXW
-----END PGP SIGNATURE-----

--=-H+oqcdb6P+pwEX1+2AEk--

