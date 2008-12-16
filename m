Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38159 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbYLPUoS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 15:44:18 -0500
Subject: Re: ath5k + AP mode?
From: Johannes Berg <johannes@sipsolutions.net>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Bob Copeland <bcopeland@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <m3skon27cz.fsf@maximus.localdomain> (sfid-20081216_213014_549365_D8A76083)
References: <m3skopuq6t.fsf@maximus.localdomain>
	 <b6c5339f0812160933q1670f646iab25dff161450ef9@mail.gmail.com>
	 <m3skon27cz.fsf@maximus.localdomain> (sfid-20081216_213014_549365_D8A76083)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VCxgMZTTWlvnNlbQcCU0"
Date: Tue, 16 Dec 2008 21:44:17 +0100
Message-Id: <1229460257.4471.52.camel@johannes.berg> (sfid-20081216_214421_962589_91176D1C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VCxgMZTTWlvnNlbQcCU0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-16 at 21:27 +0100, Krzysztof Halasa wrote:
> "Bob Copeland" <bcopeland@gmail.com> writes:
>=20
> > It's probably worth taking a look at hostapd to see what exactly is fai=
ling.
> > We should be able to create an IFTYPE_AP interface with your above patc=
h
> > applied.  No telling whether the rest works.
>=20
> So the problem is:
> - hostapd requests master mode on "wlan0" using netlink,
> - it gets to nl80211_set_interface(), drv->ops->change_virtual_intf(),
>   ieee80211_change_iface() and then to ieee80211_if_change_type().
>=20
> Then it fails with -EOPNOTSUPP.
>=20
> int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
> 			     enum nl80211_iftype type)
> {
> 	ASSERT_RTNL();
>=20
> 	if (type =3D=3D sdata->vif.type)
> 		return 0;
>=20
> 	/* Setting ad-hoc mode on non-IBSS channel is not supported. */
> 	if (sdata->local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS)
> 		return -EOPNOTSUPP;
>                 ^^^^^^^^^^^^^^^^^^^
>=20
> The flags are set to 6 =3D IEEE80211_CHAN_NO_IBSS |
>                          IEEE80211_CHAN_PASSIVE_SCAN
>=20
> Unfortunately I don't know what does the above mean, except that
> I don't want ad-hoc mode, I want AP instead.
>=20
> Ideas?

It's a bug. I accidentally introduced it in 00176c7f.

johannes

--=-VCxgMZTTWlvnNlbQcCU0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJSBMdAAoJEKVg1VMiehFYxjwP/0BUsxGdPZ8J5vtGtyvS3L99
gCgSlJPvXAXUZbzPuJ1mIc2GlHq92/4bg4ZZwtU0H1W6+QuT+tjvLr+QCo3te1ZA
ij/R4dhZXXmPVLu5QdNuUD+fPxD7OhzR25svY4FEvKAOWYVC8GlgvQParC1Hdylj
O89vw2GdLo1UnND2N32h1NnAMWhkqKDVUAYCAwe8VMEfvoDdAe7Y04SNw7MT02uO
lpK9aULKpOGv1dYCLUtq7alveTWUMuIst3+lllpOBOGx/KFpOGDahN7YlNSs77qk
gsoa90ltX7Vub3vcHE7yDEKXymGnpx0DoDGP9AYY3bstMSRWi1brF/ej0Unshqxg
vMW5lThtYXa5GQ7sl8A9zroXm8rWfbRjKD+X9ReLY9WBXU1N5Ryn4x7WHSgbbmu6
dW5koqIxvghSrveSeD77VTVqSmGjt8Do4Fp3/JkaaI7OWnuoO62F0vgZ8fHanzH/
lIThIc1JxnzHWkotlPE8g7NMeKns+X0NqYcPoRu00YHC+gp6QNYOQvBz/G23zER1
gjthGg5i8v11hDOqZFpYobxU3+7cG8Hei8p6I9WDCvvDHAtwYVbUfdijmHH7G7zR
Yo4t6Z7rnkMCoIdo23vX2/kCr7IDKmIM6C6tI7qyYCQMgymHTSvzyxbBdjs8PgSj
JCb5oFsl7McPFbmleMuv
=QIct
-----END PGP SIGNATURE-----

--=-VCxgMZTTWlvnNlbQcCU0--

