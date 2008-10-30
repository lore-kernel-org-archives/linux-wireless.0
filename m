Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49574 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbYJ3Od0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 10:33:26 -0400
Subject: Re: [PATCH 08/10] ath9k: add block braces to match indentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: Ilpo J??rvinen <ilpo.jarvinen@helsinki.fi>, linville@tuxdriver.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org
In-Reply-To: <18697.50365.638598.302055@localhost.localdomain> (sfid-20081030_153208_498429_4A6C57C6)
References: <Pine.LNX.4.64.0810301307160.7072@wrl-59.cs.helsinki.fi>
	 <Pine.LNX.4.64.0810301339550.7072@wrl-59.cs.helsinki.fi>
	 <1225367129.3690.40.camel@johannes.berg>
	 <18697.50365.638598.302055@localhost.localdomain>
	 (sfid-20081030_153208_498429_4A6C57C6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-M353oz57B6bldmq02yVb"
Date: Thu, 30 Oct 2008 15:33:19 +0100
Message-Id: <1225377199.3690.50.camel@johannes.berg> (sfid-20081030_153337_725744_7A372D83)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-M353oz57B6bldmq02yVb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-30 at 19:59 +0530, Sujith wrote:
> Johannes Berg wrote:
> > > diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless=
/ath9k/main.c
> > > index f05f584..0f67b1b 100644
> > > --- a/drivers/net/wireless/ath9k/main.c
> > > +++ b/drivers/net/wireless/ath9k/main.c
> > > @@ -467,9 +467,10 @@ void ath_tx_complete(struct ath_softc *sc, struc=
t sk_buff *skb,
> > >  	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK ||
> > >  		tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
> > >  		/* free driver's private data area of tx_info */
> > > -		if (tx_info->driver_data[0] !=3D NULL)
> > > +		if (tx_info->driver_data[0] !=3D NULL) {
> > >  			kfree(tx_info->driver_data[0]);
> > >  			tx_info->driver_data[0] =3D NULL;
> > > +		}
> >=20
> > Since kfree(NULL) is fine, how about just removing the if? Also, this
> > code has been removed in a recent change in the wireless tree, I think
> > (the rate control revamp)
> >=20
>=20
> Rate control hasn't been revamped yet. :)

Well, Felix's and my patch touched this code but did actually leave the
indentation strange like that. Anyway, since it will be rewritten
eventually and the strange indentation doesn't hurt right now, I think
not touching it will be simpler to avoid merge conflicts all around.

johannes

--=-M353oz57B6bldmq02yVb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCcWrAAoJEKVg1VMiehFYQLwP/iM8oq4VBor/2JDypYwSc1Xs
aL6bTTuZ4OnEnlmMLRSTYKlAEMh46JbfjAqzKPrziVcjgOzx2HjeuUCzGRxTRm1u
e8kBgGZj4/n9EHmM/DDcrzvBl0c5UJ6Ki37e/Aa1mtVWaRBk94mrhOPioSiLSO5e
BSJ/Quum6Un2hHekaSXoT2dZiToUVsZDv23QGy2ixyD+Zn/m7bH4RTvuayZjnDyt
Btkc6ZJzVNLnnpOGQaFf58T2S43a/ivGkNMR+PsZxOK3u3JbKbvyf22mUrW329T5
pnQxa89vYvTOPwoXgc5E9MQMm/lDtBWv488DxuXvpDiV3epW1m5vSGQ5ofSylSfa
52Nu+X5bxXc0ytuS6jfEe6HRTW9ePFIsadOS6j0M62DdIvVu5UzxD9trNtJMOTOP
RUdHYwmcRLrYeAIA1zDNBG7/eGeQUz6t/PXoQGI0lVKDbf0xNVV4472+ZjYl12MW
vXJWtZpHWDXWDA6uIJPHmNn+uOy5eEcPpmKHg0iLalFn4SIGtPpL27e/HZW3//OX
B3vPjaJe9n1LKb2RQ0i8ZPkX3gV9EN/gaSFG+1z5br0ebh+ze75fOo4/9Ed+E0Ez
YaA0TnBJlR8nWBIExFQILR1Kphco4tWihSbjaHzESmEdR3l4WnpkpOdGwzOv9b0d
EKhjIf0aqLIL7WsRLUUX
=IlQV
-----END PGP SIGNATURE-----

--=-M353oz57B6bldmq02yVb--

