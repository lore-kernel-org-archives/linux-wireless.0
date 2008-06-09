Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39638 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbYFIRWg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 13:22:36 -0400
Subject: Re: [PATCH 1/7] mac80211: add helpers for frame control testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213029086.5974.21.camel@brick> (sfid-20080609_183129_796413_B211C17A)
References: <1212774671.6340.75.camel@brick>
	 (sfid-20080606_195944_782545_6A2B1449)  <1212997265.698.55.camel@johannes.berg>
	 <1213029086.5974.21.camel@brick> (sfid-20080609_183129_796413_B211C17A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BrOlBBzEk3TcMvwn/San"
Date: Mon, 09 Jun 2008 19:21:25 +0200
Message-Id: <1213032085.22220.1.camel@johannes.berg> (sfid-20080609_192239_543392_B1D3DB3C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BrOlBBzEk3TcMvwn/San
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-06-09 at 09:31 -0700, Harvey Harrison wrote:
> On Mon, 2008-06-09 at 09:41 +0200, Johannes Berg wrote:
> > > +static inline int ieee80211_data_has_qos(__le16 fc)
> > > +{
> > > +	/*
> > > +	 * mask with QOS_DATA rather than IEEE80211_FCTL_STYPE as we just n=
eed
> > > +	 * to check the one bit
> > > +	 */
> > > +	return (fc &
> > > +	       cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_STYPE_QOS_DATA)=
) =3D=3D
> > > +	       cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_QOS_DATA)=
;
> > > +}
> >=20
> > Shouldn't that rather be _is_qos_data?
> >=20
>=20
> I don't think so....I was trying to keep it so _is_ meant an exact compar=
ison and
> _has_ was checking the presence of particular bits.
>=20
> As this helper only checks for the one bit being set, I chose _has_.

Hmm. As far as I can tell, it checks that the frame is a QoS controlled
data frame. Hence, it explicitly checks that it _is_ a data frame and
_has_ the QoS bit, but in 802.11 lingo I think that means it _is_ a
"data+qos" frame.

johannes

--=-BrOlBBzEk3TcMvwn/San
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJITWaQAAoJEKVg1VMiehFYenUP+gIesvaZO/z5VqmLQH54zWdz
cgjqdUrrUerWstca25xQ7kiLRbVnCxGN3nAhNibXgHFkzLONIex3iS8QW/JM8V5s
1tjl/LyzOcxGfZAbnXsMbxFc++N0vt7YFTGsRHAlmH+TcMVlFg/OCLqvlfUTO9mS
04e3H6fD8lMKmFXMHkHPDzp7QfFehjqwqkSU6D3P+EATkYGOEKrPnC/D5F5sNCXJ
9xYurebPuwnfS4WvTskvylqD6ee1fw/TvlBC4p5yEQ9av5aGc8E/ugOxG9UjR2FH
XM8MF88HGmONHzY+dvhM6QdvxTRnE2WmhN6wqgpznfHqKHFSYzc1kK8aSbU98EDB
+Dbx7AmvflzoDOZAvGVogU2ChBqsMDSG8p3sNAT0qW376xW3nmhxgFVVpITXIRTA
JQPUXUrZCO7b7iaPSiLOUUs1xfwz/dy99PILEFaPbKZBXComljaaoMyAFe0dHyH+
+LWvQcQsgC338bKtYzwOICkB/1KHU79rSLOI1JwJQryevAjfZQj93HRJBvAqRVw+
tCRlYiPH319GpdhXVtIozW79YGbAgCKhyIWlhfZStxy6TeUsa2Ie7M+2++D1on+T
sqaDwmI9fslOBqrNbb3SlnuQqehDuRQX0nX86aDQnAvn5I7GgJGXiy/gEBcUCaBF
cdyNMfznSm0YOucH/F8j
=ppKF
-----END PGP SIGNATURE-----

--=-BrOlBBzEk3TcMvwn/San--

