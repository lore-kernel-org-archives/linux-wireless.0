Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44997 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbYJTGtO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 02:49:14 -0400
Subject: Re: [PATCH v3] mac80211/drivers: rewrite the rate control API
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <1224484940.24677.169.camel@debian.sh.intel.com>
References: <1223996147.10113.33.camel@johannes.berg>
	 (sfid-20081014_165703_092655_BE6BA58D)  <1224052607.3027.20.camel@johannes.berg>
	 <1224484940.24677.169.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JrTmBf2MVwoSj+WoTXNd"
Date: Mon, 20 Oct 2008 08:48:38 +0200
Message-Id: <1224485319.18024.9.camel@johannes.berg> (sfid-20081020_084916_841164_C0CBE5DA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JrTmBf2MVwoSj+WoTXNd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 14:42 +0800, Zhu Yi wrote:

> > @@ -318,9 +348,33 @@ static void iwl3945_rx_reply_tx(struct i
> >         }
> >=20
> >         info =3D IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb[0]);
> > -       memset(&info->status, 0, sizeof(info->status));
> > +       ieee80211_tx_info_clear_status(info);
> > +
> > +       /* Fill the MRR chain with some info about on-chip retransmissi=
ons */
> > +       rate_idx =3D iwl3945_hwrate_to_plcp_idx(tx_resp->rate);
> > +       if (info->band =3D=3D IEEE80211_BAND_5GHZ)
> > +               rate_idx -=3D IWL_FIRST_OFDM_RATE;
> > +
> > +       info->status.rates[0].count =3D tx_resp->failure_frame + 1;
>=20
> This is useless. And it is even confusable with the later count++.

In what way useless? We've changed the semantics and made "count" be the
"transmit count" rather than the "# of retries", so it has to be one
more. Or was there a bug in the previous understanding? Wouldn't
surprise me, and we can fix the bug here.

> > +       fail =3D tx_resp->failure_frame;
> > +       for(i =3D 0; i < 4; i++) {
>=20
> Where does the '4' come from? Why not IEEE80211_TX_MAX_RATES?
>=20
> > +               int next =3D iwl3945_rs_next_rate(priv, rate_idx);
> > +
> > +               info->status.rates[i].idx =3D rate_idx;
> > +
> > +               if ((rate_idx =3D=3D next) || (i =3D=3D 3)) {
>=20
> ditto

Probably should be MAX_RATES, but I'm not sure, can you explain how the
hardware will behave for retries?

> [...]
>=20
> Other iwlwifi changes looks fine to me.

Thanks for looking.

johannes

--=-JrTmBf2MVwoSj+WoTXNd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/CnBAAoJEKVg1VMiehFYciUP/1KaYEwwbuMyAhZOks3902t+
ClPdoYEEReqy6U/fOijJiCv88x2+H2AbZyBL6EsX3bIzn/Zslk1RICZqpIxaLUEL
UNWahkzDNTX23F/QDQ9VQ7dklsvJOhwUOeATxGUiVKkn8WZjTycCNfRD5hiMkTpL
80i8sy+qcK44qZ7ejh1CIzipJWO1dP0RzfdLimB+jD/vLszmIRZ9kjj6qKCXlZFF
S/276z49J/Hj+ukEwFXL2Jko5xPKRmliqZIm36I0YLu//OxN48j9A7IhN85TpAaA
1XTRZz1jhEvz6BS9VPrg5F5JCAMtpjbUIMk1RhFP6DPuU4/hdCbWkGUjql7HDPYT
zV7EWk7XjBamhlwkO3paiN3JB4f0g6J+fVPRMrdFVjHg+jCsDaorvlhFGHfdvD68
5tAkPo+cpZBzS6UTlOkQ6d7loo02QVDQN7cHCBOgZiqIYvVueKN31GGLzzev4LYU
JD40Tq6o+VQDGzAJdGmH/0MjUCi4SxdmbsX6n5uhn8cCaj1gRZ58MafCNkXk7aQ9
lY5z1aPskZtb3M19q5ZjMb14/hj9xYnfljRk5d4r6tlGYBu1U6spRA6hZG1aU/g3
vTuOw8UXyee51lYLwV6mxFBtoWSEVKNCX7u772/VxVfZoypU5xCY8k4evu3qDOxP
Sdc1pFS2gMLW1hAHV6Jh
=jjUB
-----END PGP SIGNATURE-----

--=-JrTmBf2MVwoSj+WoTXNd--

