Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45532 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbYEPPaw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 11:30:52 -0400
Subject: Re: iwlwifi injection bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <69e28c910805160812g1c88d796m6133cb36586cc8e8@mail.gmail.com> (sfid-20080516_171249_316046_CADCB33A)
References: <1210945631.6381.11.camel@johannes.berg>
	 <69e28c910805160812g1c88d796m6133cb36586cc8e8@mail.gmail.com>
	 (sfid-20080516_171249_316046_CADCB33A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-afQcDAsazVth53PlgwbI"
Date: Fri, 16 May 2008 17:30:36 +0200
Message-Id: <1210951836.6381.38.camel@johannes.berg> (sfid-20080516_173059_783149_E4F0DD1D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-afQcDAsazVth53PlgwbI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-05-16 at 17:12 +0200, Stefanik G=C3=A1bor wrote:
> On Fri, May 16, 2008 at 3:47 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > I don't know why you want to disallow sending frames when in monitor
> > mode (especially since reportedly it works), but this is not a good way
> > to go about it:
> >
> > static int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
> > {
> >        struct iwl_priv *priv =3D hw->priv;
> >
> >        IWL_DEBUG_MAC80211("enter\n");
> >
> >        if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
> >                IWL_DEBUG_MAC80211("leave - monitor\n");
> >                return -1;
> >        }
> >
> > You see, this will cause mac80211 to resubmit the frame and most likely
> > will totally mess up queue handling and various other things.
> >
> > johannes
> >
>=20
> Hmm... thanks for the hint! I was chasing a weird Radiotap bug that
> shown up when I tried to use packetspammer or aireplay on a monitor
> interface with the latest iwlwifi git. The symptoms ranged from just
> not transmitting to hangs and kernel panics. It appears to mess up
> more than just TX/RX queues.

Doesn't surprise me, but I'd be interested in the panics nonetheless.

johannes

--=-afQcDAsazVth53PlgwbI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASC2om6Vg1VMiehFYAQJ3hA/7Bkxa4FhM6qrbrEnnwfshGSmYrdjzIL31
H7S0y9nZXLxbXpLoAkN75kU+dpIDdo8XvLccLjNIzd00a/0Un1BgsztpoauD3JcZ
iDzv1UiaIrLnhdwrfEEKts7VdVCipq85MQb5GRbZFmDnxU/C58Epb8reIHeUaIBx
208sUXgHHnGNaX8ROJLceEwN8354D/kvqNnJW5a8/ft9pCElRW2D9LBwv3RAvUpX
ClA7sobQcxpzR4816SpgDCF+KQvlekaGm1BhIxgx9WbywzyMHKrfIghni02gjjvR
OH0MNsWhhYHhkhXWBwtG0i5W9zAi5E4j9jTI8V/3CleR9Gr+5iWjvt7NP/RG/htJ
/YkYSnB8kkLtHKrGZf2cpGAsLpZkSx5xOEbNZbCalV1tM/BEc+/B+lj35R74Pyir
FEZqS8OtxLAYcjkuPtp7Rp8dcCCuVe+URMmI966DB47TRZwI8Pv5Uz8Cm2jxGgPq
HPUwoz5ChyavL6APf3uWMi3SVIXqXrayPnH8OhvexL7r195XqZymPdxDSqWLB8l8
XpPx2aL2LKndrFCDDpH8ZyMB4p6b1jmcRfqt4o2Fl11HTPxRSOqbK343UFObCtj3
GL0d9DR8i52GKIenpfCRHQ1g8O9dfc6NeLcwfS9j3QrWmHwjC+NpF+oNGqvCogBb
QjlOqI/bzbY=
=LbdS
-----END PGP SIGNATURE-----

--=-afQcDAsazVth53PlgwbI--

