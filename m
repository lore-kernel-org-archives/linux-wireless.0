Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59581 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbYIKRrm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 13:47:42 -0400
Subject: Re: [PATCH 00/18] mac80211 cleanups and fixes
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1221154941.6986.46.camel@johannes.berg> (sfid-20080911_194301_979620_DD1EC47A)
References: <20080910220145.707263000@sipsolutions.net>
	 <18632.55008.411078.289830@gargle.gargle.HOWL>
	 <1221139351.6986.26.camel@johannes.berg> <20080911165011.GA6049@tesla>
	 <1221151995.6986.33.camel@johannes.berg>  <20080911173335.GD6049@tesla>
	 <1221154777.6986.43.camel@johannes.berg>
	 (sfid-20080911_194024_972872_166E0270)  <1221154941.6986.46.camel@johannes.berg>
	 (sfid-20080911_194301_979620_DD1EC47A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mRxxy1Cs89y/GbPe+6w3"
Date: Thu, 11 Sep 2008 19:47:05 +0200
Message-Id: <1221155225.6986.49.camel@johannes.berg> (sfid-20080911_194745_607518_23F5C2CC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mRxxy1Cs89y/GbPe+6w3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-11 at 19:42 +0200, Johannes Berg wrote:
> On Thu, 2008-09-11 at 19:39 +0200, Johannes Berg wrote:
>=20
> > Well take the larger bit of code:
> >=20
> > 	struct something *an =3D NULL;
> >=20
> > ...
> >=20
> > 	rcu_read_lock();
> > 	sta =3D ieee80211_find_sta(hw, hdr->addr2);
> > 	if (sta)
> > 		an =3D (void *) sta->drv_priv;
> > =20
> >  	if (an) {
> >  		ath_rx_input(sc, an,
> >  			     hw->conf.ht_conf.ht_supported,
> >  			     skb, status, &st);
> >  	}
> > 	rcu_read_unlock();
> >=20
> > 	/* the "!an" here is fine even outside RCU lock */
> >  	if (!an || (st !=3D ATH_RX_CONSUMED))
> >  		__ieee80211_rx(hw, skb, &rx_status);
> >=20
> >=20
> > So at this point it's only checking whether above it had a pointer, it'=
s
> > not accessing it. Think of the "an" variable, after rcu_read_unlock(),
> > as a bool indicating whether or not the code that just happened had
> > access to the node or not.
>=20
> That said, here it's probably smarter to just initialise "st" to
> something other than _RX_CONSUMED and remove that !an condition
> entirely.

And why is that not the return value of ath_rx_input? Anyway, I'm
getting off-topic here :)

johannes

--=-mRxxy1Cs89y/GbPe+6w3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyVmVAAoJEKVg1VMiehFY9xcQAKF9CLZYvI2kp793SJo3EeSF
Uxb1+Vgt7GyMorGlg+FdKSyg7vlyRjriZEUa42WYDTfwGEKjEOh0v7zrMwNDunGd
SRj5cqG0/sgMeIoTXN7nyUSCXWQZGeRXnQWTeG6qV6yq38ZASeoxNwcWU+5q5Fde
1zPZuWAMPU7Q58iXOY2aCRfXvzLwbjIXmKamqbqeHAfNOKq8KcA+lTSc+IuE8JDe
KIiXKgnQL+b96IqiHZ2dXeITsKwhrJ1dHtfRhnrhsxEjVV9zVsdqzk5FvbFWGCtL
Za9qZcgQGuRdkWbFe/bTRaFXBTpv+fm0IoZZomrdQL5/BW2x/zWbx1SbAkcHLj7U
t9ShKGCyh2NUsCp8vkPeO9DHlD3uBj/QLErhjEwYnx6v1Wo4WlASMOufrKVgeh3Y
qoxfZ7lDVdYYPKtbPRShkwcDuy7i/Jy3x1G/EzZuYlgc+B6mHaW8ZthNFEQOxLti
ShfJDOO7n3PrFoLa7V1A37R/FKQ61sHDC2wHPnz9bC9IfTAoqoKJyV2UJ/vZ3Xqz
WAoVo92Iha5KvtPjzmC6dW4v79VWPHmeHth7qcPOCuwlJlycfyh2iHAMMmzvWEkA
lmGNLiSToHtrWIYQ5GW+wup6rX9Bd1bzFLp5neOdvVqza6AtlJYNrJdV/GI0ngw0
TpCFn2Jt0epdCil9+hJh
=jqP9
-----END PGP SIGNATURE-----

--=-mRxxy1Cs89y/GbPe+6w3--

