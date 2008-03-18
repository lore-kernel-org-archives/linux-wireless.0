Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42515 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbYCRNVg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2008 09:21:36 -0400
Subject: Re: [PATCH] mac80211: configure default wmm params correctly
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Koutny <vlado@work.ksp.sk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <47DFBA13.3060508@work.ksp.sk>
References: <47DFBA13.3060508@work.ksp.sk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vPrWCQRR0d91v5P7B4Z1"
Date: Tue, 18 Mar 2008 14:21:12 +0100
Message-Id: <1205846472.16475.46.camel@johannes.berg> (sfid-20080318_132140_620469_42FDE5EC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vPrWCQRR0d91v5P7B4Z1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2008-03-18 at 13:48 +0100, Vladimir Koutny wrote:
> Default WMM params have to be set according to beacon/probe response
> information prior to authentication (or IBSS start/join). This does
> not affect the use of 'real' WMM params as reported by AP.
>=20
> Signed-off-by: Vladimir Koutny <vlado@ksp.sk>

Looks ok, but

> +	=09

There is lots of trailing whitespace (use scripts/checkpatch.pl)

> +	if (local->hw.conf.channel->band =3D=3D IEEE80211_BAND_2GHZ &&
> +    	have_higher_than_11mbit)

and that really needs to be indented differently.

> +		/* IBSS uses different parameters for Beacon sending */
> +		qparam.cw_min++;
> +		qparam.cw_min *=3D 2;
> +		qparam.cw_min--;
> +		local->ops->conf_tx(local_to_hw(local),
> +				   IEEE80211_TX_QUEUE_BEACON, &qparam);

And shouldn't we do that only for IBSS? I'm in favour of removing it
completely, however, since the beacon queue is a way to construct
hardware, not do things in software...

johannes

--=-vPrWCQRR0d91v5P7B4Z1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9/BxqVg1VMiehFYAQKrWhAAwWaeLCN47jYTteceIsPBj4IlAxWifGA7
dOLvd1vcQ3yDLAyPlwvbfvm8+wlQ2uS3x+UoGPjEg3sQ7WTK6fJCxY1+f2i1zrIp
TZOvC6Z+9fsZ7r7tsAow3brLx12rWrHqL0prhBKQGljN3GRXS7ptd5TY5LGm2lWa
SC1+/mAhgBm8Ok5ayCGgKI8rasv7hI4Aos4SWggn3EwrQQubLogGM4LKoH7eCH38
KOpoqIOV8I4Li3Wl5KNa4XYu4lFo4K9TspnZrEgjG91Xf1pquhJttFGYTY2b5BbX
GXEVAv4fFCxmzrBGVNsccxkMCO+LXjiBVu08iiMmiM1lmZlJmeS0jltaxirclH3S
QX4qaqRreOg/Zun9cKAROyBMo/ScM/siBrep3Fx/Z3f/YMq9EzlYV5+or/QuONN0
IyoMAe2RsRFbHwq62VxLOBYQx3VVlRS11HRgycFKZATLcH+enD8UIIfS7v0TZU2W
BMKHvzZyWihVPNigl16o+n5wBNEKcKuppL629WlSEfg1ohNaiph7mwyyQYSbsotB
YbF4Cmzu9tpPSesw77z5pRJ5BRj3et+TGNkuE2y/vBc7pYCjNSlwTjeX656DAIQR
q4r6okinxsL8kawzkNOf4ArxgeEvqzQBDls5BZ2v4fnZi1kL6DAswvMymdg+uy07
XIU0THM2Y50=
=S3oe
-----END PGP SIGNATURE-----

--=-vPrWCQRR0d91v5P7B4Z1--

