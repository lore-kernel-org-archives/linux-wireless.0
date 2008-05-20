Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55111 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027AbYETPTV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 11:19:21 -0400
Subject: Re: iwlwifi injection bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: Tomas Winkler <tomasw@gmail.com>, Zhu Yi <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andy Green <andy@warmcat.com>
In-Reply-To: <69e28c910805200758j72281d34kfaa244e9bbdd8451@mail.gmail.com> (sfid-20080520_165905_398872_E5346CEF)
References: <1210945631.6381.11.camel@johannes.berg>
	 <1211249729.2532.59.camel@debian.sh.intel.com>
	 <69e28c910805200432lbd3790vb925dacaea3aca83@mail.gmail.com>
	 <1211287111.6252.84.camel@johannes.berg>
	 <69e28c910805200614q2232b21ame8ff03fe4156fb3b@mail.gmail.com>
	 <1ba2fa240805200641j4ccc1de4r5572e1321394a526@mail.gmail.com>
	 <69e28c910805200716i3fd16c33x274983ab8e7591e6@mail.gmail.com>
	 <1211293631.6252.98.camel@johannes.berg>
	 <69e28c910805200758j72281d34kfaa244e9bbdd8451@mail.gmail.com>
	 (sfid-20080520_165905_398872_E5346CEF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pn/EUkZJYUWNL2IajVOy"
Date: Tue, 20 May 2008 17:18:30 +0200
Message-Id: <1211296710.6252.99.camel@johannes.berg> (sfid-20080520_171925_686713_1B8902F4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pn/EUkZJYUWNL2IajVOy
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-05-20 at 10:58 -0400, Stefanik G=C3=A1bor wrote:
> On Tue, May 20, 2008 at 10:27 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> >> -     /* drop all data frame if we are not associated */
> >> -     if ((!iwl3945_is_associated(priv) ||
> >> +     /* drop all data frame if we are not associated and not monitori=
ng */
> >> +     if (((!iwl3945_is_associated(priv) && priv->iw_mode !=3D
> >> IEEE80211_IF_TYPE_MNTR) ||
> >>            ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA) && !priv->ass=
oc_id)) &&
> >>           ((fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA)) {
> >> -             IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated\n");
> >> +             IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated outsid=
e monitor mode\n");
> >>               goto drop_unlock;
> >>       }
> >
> > This makes injection not work when you're not exclusively in monitor
> > mode. Yes, it may break the spec to be sending frames to an arbitrary
> > station, but it's useful for all kinds of things including testing to
> > have a monitor and a regular interface working at the same time.
> >
> > johannes
> >
>=20
> What do you think is a better way to check if we have a monitor
> interface? && priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA? Or should this
> be removed altogether?

I tend to think it should be removed, in regular operation mac80211
would never create such a data frame, and when injecting you actually
want it.

johannes

--=-pn/EUkZJYUWNL2IajVOy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDLrxaVg1VMiehFYAQKFWw/9EaX0tn1O8o4RAO2Mde/3ML7lXRRdZUCH
OkbJkUYh+iUXd9svsC0LV8oJ9jXiDb4KfvGqkZ3rA1R2+cXaSyLRbqPMH4moUNdt
fNRqKn4+ZdhPLnhu3tEVN6w6hd0yNE++/3uiMVvGhIbIIJ5/1MscGDSIBf5z0QIG
ba5YXOcFdqXYzdQ0FQbbi3+3PpfZ+Wxnfeja/5qjNGJEQs5ADc8bkDc4jU89oEJm
rxDEyepJS1Yz+vtsw4huxu2q0bC+uPsAD61PmgXHrcxwcsYZITrDIseRQJCS6kGo
Dg6O1ShpATpO649PJj4Xjs4ZQLTlRbGAnzaXRa+Btoi83+wDbU27fICkiycrvW6h
cIQGKH2j3On7nwHnuLRT/dj/Q2nYSXomivKo3btAfqTqAQN4f7ilk9YreMBQAxa6
9iFtYeht5rXyl+EG152qi1yTLQ+yHandTij9/LSTJbeGenWGmbDNGRvMxB1s2IUf
oYaiPPnVSA6E8kl0rrsTXsuaqd0DtV1teB3Eg1WOpxb/YW9m6S6Sro5Gt+a8TVYT
FMZyT+GTC0q1qrp/PUu28A7CqR4jgJNiez/Ux2odaDYlzjFzbZe1qFkvF4jIs0KW
WnGEz4YVkKZN+ncavLToxMpUVQLb1Nkpo7tjqPVQx9XmI+rbeDqiD1ayfRLYjdb2
3vezoUJD4x0=
=kq5J
-----END PGP SIGNATURE-----

--=-pn/EUkZJYUWNL2IajVOy--

