Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57223 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbZDPKTJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 06:19:09 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <878wm0ap2u.fsf@litku.valot.fi> (sfid-20090416_120845_607079_60A37B4E)
References: <1239837672.11795.46.camel@violet>
	 <1239841291.25334.18.camel@johannes.local> <87ocuxf7kv.fsf@litku.valot.fi>
	 <1239873166.9737.4.camel@johannes.local> <87fxg8apgo.fsf@litku.valot.fi>
	 <1239876253.9737.12.camel@johannes.local>  <878wm0ap2u.fsf@litku.valot.fi>
	 (sfid-20090416_120845_607079_60A37B4E)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hX8kP6XZdpNR7F57XD2x"
Date: Thu, 16 Apr 2009 12:18:35 +0200
Message-Id: <1239877115.9737.16.camel@johannes.local> (sfid-20090416_121913_430210_55EDD87D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hX8kP6XZdpNR7F57XD2x
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-16 at 13:08 +0300, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>=20
> >> ifmgd->timer is run every two seconds, even then scanning and it calls
> >> like this:
> >>=20
> >> ieee80211_sta_timer() -> ieee80211_sta_work() -> ieee80211_associated(=
)
> >>=20
> >> And to my knowledge the timer is run even when scanning. Or am I missi=
ng
> >> something?
> >
> > But ieee80211_sta_work() checks if we're scanning and aborts if we are.
>=20
> Oh, I missed that one. Yes, you are right.

Maybe we should just set last_beacon =3D jiffies on scan finished as an
easy workaround :)

johannes

--=-hX8kP6XZdpNR7F57XD2x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ5wX5AAoJEKVg1VMiehFYmHsP/0xAUDa4+5dwQhycjfVwIEuO
T02MpVASc+2LE6xUZTYTzLr6ZXi88cSiW2i6KYohCfBg1vcsp6MPKmuizhn/nOYq
9wJ4zuNJb5oK0i5feVyUwa5P3xrpKUglQ7PnejNOhpxMr4HKVU0ytbNEPddbFoAL
I9f639K5PjV1J4HO1UJLIWfuytRk9LpsEjxziBh8vW9X+DlgL+VFnFnQDTUaIfJX
bfMK3+m1EZq2CTEFbR8fcyAT4Ku0xVeWuGaWcg4sj4J2//Zoh2bDytFowqOPWH7+
DCqZR0I3scScQ0B//k/zgSx3IdqWcCpd+SxxHll4kMxyQ04RLXx+7sjjvGdowDGq
Gs1+PzkMUT9rhTcRfYd7EaR8aVwH67SpqKFc2aHFAHQFC8nsF28DcxRsOzbGxBla
7SWOPWuKH9FFrbWVUmStp39YjOBY2xuHdmNoSQGkp2vxUOnvS4tPoTCvWdQCEOAD
2CzOyqdZxw6wW5BFyX+Eaju8OfTA1IOZ10WMfa5Wt2CQOL2ym8gvUzrIbbyFjesX
auc2kNT7X4mX44TT3/XHLWuYzozt+Vj64hUQ48uGfkpBubsIolX+9XnpT93F7qET
OJg54av3Ie/jsNZ6r0WDPjiaOPH8sriAvzCxVQrNkHXCBnYODxUVc47tjSSN5IiG
MjKnpnKO9ZTEwOdJk6Vf
=OYep
-----END PGP SIGNATURE-----

--=-hX8kP6XZdpNR7F57XD2x--

