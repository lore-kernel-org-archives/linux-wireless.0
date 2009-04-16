Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44093 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbZDPJqk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 05:46:40 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1239837672.11795.46.camel@violet> (sfid-20090416_012123_293746_81110E23)
References: <1239837672.11795.46.camel@violet>
	 (sfid-20090416_012123_293746_81110E23)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tVqiulh6Qn+pYrrQrKXZ"
Date: Thu, 16 Apr 2009 11:46:08 +0200
Message-Id: <1239875168.9737.10.camel@johannes.local> (sfid-20090416_114643_572801_07873E40)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tVqiulh6Qn+pYrrQrKXZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-16 at 01:21 +0200, Marcel Holtmann wrote:

> After a long debugging session with Reinette we finally tracked down
> what is going on here. A full scan with this card takes 7-9 seconds and
> that seems to be too long and trigger IEEE80211_MONITORING_INTERVAL
> which then deauthenticates us with the AP (reason=3D6).

Note to everybody: _Please_ provide the exact output. This text above
makes it sound like we deauth from the AP, when in reality the AP has
deauth'ed us.

Maybe your AP is just buggy and can't handle you going away for more
than a couple of seconds? It _looks_ like it sends you a deauth frame
while you're scanning (please verify using wireshark or similar), we
miss that deauth because we're off the channel, and then when we get
back and start sending data again the AP complains that we're no longer
authenticated.

Sorry, but there's not enough information here to tell what really is
going wrong. The known bug shouldn't be able to cause this behaviour.

johannes

--=-tVqiulh6Qn+pYrrQrKXZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ5v5dAAoJEKVg1VMiehFYjGEP/2ECTpji3u3+9HbNhCljjdLz
i+nvfwSIjo4SrmqtpLq8WlkhMQ4oRfgBEQPke1RN3kMeQU5nKqh8iEqLPEa8RsJt
DDSZLE9rWtrHTCNWwMxsrga3Py2OrXoePj8FGCpI0QM61tUelb0izt4j9+i3M06D
Y8H79JhKuIH4Xl3rQFmc0oTkX+x0PbXvq/ePt4cmjQCd8HX5mm8gEhmqY12Hs1si
oB0vK2tRhzQXqLbqwoQPuUT94mPhCwRpc2N+y4s+vqkHBuy9ISdyn70hEwgSrSNX
7Md8iSLo3iMy8bhC2bIwlAEYIqqWI4HaLOrxzU7sC/gZgh6KONP4fj6wruPiipzB
B9kKki8NxdOZehGAxTXsP54zt4XAK27LwKAuh+kCiARr2qyN4woK2JVwKmHtclOo
5BJMoUaBTdEpV70jAyH73CuIBSgALmRoV5q1Bi75sYnlQCNvcAqSC7SPTLJVLd3W
JyLFtKNmZb7Uvw2HZDrMqRrJEw3q901zuayyBU60PvirN5cPGcjezQmmGRoeR9Zf
vdWm2htf6Gt1sSmn0kc6kVJLYCOISV2HxIstKWg3IeLnRydfCs/LWVAbXeCQ/ckT
o+K4ryFkBvS0qM3bd3W8O1SUIVhrtvmrcvasDzZKVnjVWnV498Rva+zAahCtYSTP
Yx5NV013J1mt4D3MD1JG
=JsyO
-----END PGP SIGNATURE-----

--=-tVqiulh6Qn+pYrrQrKXZ--

