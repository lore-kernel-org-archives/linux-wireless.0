Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:43051 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab1KPKv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 05:51:27 -0500
Date: Wed, 16 Nov 2011 11:51:20 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [PATCH] mac80211: Add NoAck per WMM Queue Support
Message-ID: <20111116105120.GA6139@pandem0nium> (sfid-20111116_115131_539496_1D301BE8)
References: <1321399276-3585-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1321429935.4773.10.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
In-Reply-To: <1321429935.4773.10.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Johannes,

thanks for the review!

On Wed, Nov 16, 2011 at 08:52:15AM +0100, Johannes Berg wrote:
> On Wed, 2011-11-16 at 00:21 +0100, Simon Wunderlich wrote:
> > This patch adds support for NoAck per WMM Queue. The Unicast QoS
> > Header is adapted accordingly for each outgoing frame.
> > The support is turned on and off through nl80211 by extending
> > the WMM TX Queue Parameters, but can be triggered separately.
>=20
> Can you explain what for? :-)

We want to set NoAck for special traffic classes like video or voice where
"old" packets are not useful, but keep it for background and best effort tr=
affic.
This can be applied on devices supporting both traffic classes (e.g.=20
laptops, smartphones with VoIP software) as well as for backhaul links.

Something similar has been done previously on madwifi, what we used:

http://madwifi-project.org/wiki/UserDocs/UsersGuide#noackpolicy-WMMNoAckPol=
icyBitValue

>=20
> I'm not sure this API is really the best way to handle it either, like I
> just said it might be nicer per connection or so to get reset properly.
>=20

I'm not sure what you mean by "per connection" - do you mean per AP/Sta
connection? We need definitely need it per queue as explained above.

> > I have tested this feature on ath9k as well as ath5k devices. There is
> > an iw patch as well to make use of this feature.
>=20
> Since you're adding 'real API' (unlike the debugfs file which you should
> probably remove now!) you also should think about drivers like mwifiex
> that don't support this and don't use mac80211.

mwifiex neither supports set_txq_params nor the new function, nl80211 should
just return "-EOPNOTSUPP". A short grep revealed that no driver in wireless=
-testing
implements set_txq_params so far, so at least for the drivers within the ke=
rnel
this should be safe. I forgot to explicitly check for rdev->ops->set_txq_no=
ack
and will add this check in v2 ...

I will also remove the debugfs entry.

>=20
> Also, given real API, this impacts the duration calculation etc.

I'm no expert in duration calculation, but will give it a try.

best regards,
	Simon

>=20
> johannes
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7DlagACgkQrzg/fFk7axblsACgqXYyUdvYrV8Akd6Lp/MEHsIb
HuMAn1y3KPhSg0A5ndTTzht5aMM+VQ56
=DiAL
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
