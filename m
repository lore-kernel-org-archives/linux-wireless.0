Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58357 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758905AbZJPLjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 07:39:19 -0400
Subject: Re: SME warning on 2.6.32-rc<bleh>
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890909291224t26b7e6cbmc78976165bd1bb88@mail.gmail.com>
References: <43e72e890909291224t26b7e6cbmc78976165bd1bb88@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OKFKd7US9cT12E9oIWX/"
Date: Fri, 16 Oct 2009 19:09:11 +0900
Message-Id: <1255687751.4095.333.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OKFKd7US9cT12E9oIWX/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-29 at 12:24 -0700, Luis R. Rodriguez wrote:
> I believe the problem comes from the assumption from cfg80211 that
> previous deauthentications would have gone through before we run
> __cfg80211_disconnected() and are using wext or nl80211
> connec/disconnectt. Under certain conditions (clearly not known yet)
> this is not true and we'll end up asking mac80211 to deauthenticate us
> from a BSS we already deauthenticated to end end up with an -ENOLINK
> on our mac80211 cfg80211 deauth ops. It seems this race was expected
> all along on mac80211 ieee80211_mgd_deauth():
>=20
>         /*
>          * cfg80211 should catch this ... but it's racy since
>          * we can receive a deauth frame, process it, hand it
>          * to cfg80211 while that's in a locked section already
>          * trying to tell us that the user wants to disconnect.
>          */
>         if (!bssid) {
>                 mutex_unlock(&ifmgd->mtx);
>                 return -ENOLINK;
>         }
>=20
> So it seems we do need to address that race but I'm not yet sure how.

I don't think so. The race is definitely there in mac80211, but not in
cfg80211, since both processing the deauth frame and sending a deauth
frame in cfg80211 are both under the same lock.

OTOH, it could happen with lock contention, but that seems very unlikely
here?

I mean -- this race should only happen if the AP and you decide to
deauth at the /same/ time. Precisely the same time.

johannes

--=-OKFKd7US9cT12E9oIWX/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK2EZEAAoJEODzc/N7+QmaOloQAK1XCWgEPm8sO1hpnu+RgHfa
0UeQhNo7JUDYu91KCKt1YozrYyQbwW/dukLBoST5hd7jpyXY8ZgYU/BlWZXD570Z
KCSXeoqIiZDt9KyVUQ4sJ1qgFHB5PJL5NWGZvmx1KPOWyweuVFmzqwlLoQ3sZiCo
67QyMadBR+B3tueLZ7DAXhxZBRoxdVSACfttHFk3iq5xHg08GWPP/XpCyfJN7s4P
j1E3izc2C7X8AcmWp5MXSUyAEvr4wlhNuwxzaOp6PgOdc73E56Rrm0GyicAZz1uG
LH+G82APFXGZcCvnzWKISoLm0df0Opa4uenFom4dMB6hDBMQqQD/JbFFxRIQCOAo
m7UMS0DNTjwhhYH+uEMdyA3LywEI7js8Ogvk+vx3MVyQD/kRsiOtny+xpmUsvvFs
gnDYSIvfTshW2eGEYZM6AYj2cef9BVzPZT8tPVCoOX6OVcNh4d9s3bQxVWRprtsc
6SysSgB/fBdnQ7dPGt8iW2vweaQATNidbtzTVhDmlQkpkS2+n3EV9Pni9ykihLQ8
AqtmOn+Uf/SYF86N86yllYrYmEkqVGisISo7dSXyBT+vsCF0+zj3jNKPodAHpmWh
AXjRr/iKwg7y7ZFim+RUN2lYrsvwO3mbsAprllAHKSmOB477MOH6oxXYVpWFtMY3
c/Eo4WOyextwL9aq5Nrh
=EdhF
-----END PGP SIGNATURE-----

--=-OKFKd7US9cT12E9oIWX/--

