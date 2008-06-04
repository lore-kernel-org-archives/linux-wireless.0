Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54579 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbYFDJAr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 05:00:47 -0400
Subject: Re: mac80211 ad-hoc mode problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <1212543664.4237.14.camel@localhost.localdomain> (sfid-20080604_034126_005983_906C2124)
References: <1212543664.4237.14.camel@localhost.localdomain>
	 (sfid-20080604_034126_005983_906C2124)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fVWnNXMUz0gFn9OvhiaW"
Date: Wed, 04 Jun 2008 11:00:00 +0200
Message-Id: <1212570001.14371.16.camel@johannes.berg> (sfid-20080604_110109_008283_3EE9C20E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fVWnNXMUz0gFn9OvhiaW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-06-03 at 21:41 -0400, Dan Williams wrote:
> Hi,
>=20
> While adding adhoc shared network support to NM, I ran into a few
> mac80211 problems.
>=20
> 1) doesn't send SIOCGIWAP event on successful adhoc activation (patch
> forthcoming)

Thanks.

> 2) takes a _really_ long time to create an adhoc network.  This is
> controlled by IEEE80211_IBSS_JOIN_TIMEOUT.  Why is that 20 seconds?  The
> problem here is that wpa_supplicant has an association timer shorter
> than =EF=BB=BFIEEE80211_IBSS_JOIN_TIMEOUT and will re-try the connection,
> causing mac80211 to reset ifsta->ibss_join_req.  FullMAC drivers will
> simply look in their scan list (and optionally perform one scan) and if
> the IBSS isn't found, create it.  I'd really like to
> take =EF=BB=BFIEEE80211_IBSS_JOIN_TIMEOUT down to 5 or 7 seconds.  This i=
s only
> the initial IBSS creation, IBSS merging will still be in effect.  I
> simply thing 20 seconds is really too long here.

Yeah, I don't know why it is that long. Jouni, do you remember maybe?
I'm ok with reducing it.

> 3) doesn't send NULL SIOCGIWAP disassoc events when the device goes down
> or the module is removed.  Where's the best place to put the event on
> module remove?

Huh? Why does that matter, the network interface is going away so...?

> 4) Is the association expected to survive a up->down->up sequence?  If
> not, then we should be sending NULL SIOCGIWAP event whenever dev_close()
> gets called.

No, it's not, yes, we probably should send that event somewhere. Is it
ok to send the event while not associated?

> 5) mac80211 requires the device to be down when changing modes.  That's
> fine; but requires a patch to wpa_supplicant to handle this.  This would
> cause failures when switching AP that were different modes from NM.
> See:
>=20
> http://lists.shmoo.com/pipermail/hostap/2008-June/017894.html

Don't understand. How can you switch to an IBSS AP? :)

It's probably fairly easy to remove this restriction because they all
use ieee80211_if_sta internally (sta, ibss, mesh) but since I don't care
too much about IBSS and see mesh as being quite different, I have no
motivation to try (and test) this.

johannes

johannes

--=-fVWnNXMUz0gFn9OvhiaW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEZZj6Vg1VMiehFYAQJ07g/6A5XQV45Ds3k6SoFR8RpAVewQjl7n9O4b
6zBRwx6CjcoFGZQiJ4D5lNO/BngJyRgVLFU6O21hTK4QBIzw1CEbRfTseG4nDa9q
rQCqRnUreziNWh8VRPM93J+G1JSEam+l3ELlwvVGd+mrG6jPKOoKq+wyXkFVD+xJ
xVNgxn/svw0ul4FkaQGNlVGsdZzOG/hySlepDRbNN1YGQoxxJsmcfEpxncV9ZTIg
rYOYUI8zzPLil6/SNaQuWnXqxUQWP8idgz+UPNtErQiSGUyu/dKeZlT3M8e4/Q2e
QD0mAb4LnSI0Tky3c31Oq4pWGzV6nZjMi5mOcda4a97GrduBbkqRGl7C56EIuUUY
e1uPK4S8k00jvaJxAlHP7RgrUvC7yOVnMley6NOEeIAKHXTD5U0Qf5t3cY0hsLiy
lOfWznrLri7BhjqfDbJzqowJduwkFIxd2n9BGarNDbDPkFD2wZS43ovx7UwQDGXa
OQl18Du3mzz4ve7JZoBFYkS/kaTkjwSMrL8Ouzfxv4bQ34dq/QAE8R6xWjK70IZ0
ayyKkI8bH4gWvF44BA0Y0yd+qqaONQ6ZGcEIbEJhAOx/f1gm+MjZQZJBCkldrhUI
bY1QCjZJsttXg1fVeS/bb2D5hkOwa2SyiiMJdoINVDTSryQgr9z2BYYMFJDE0VbH
e+sZfizz8iw=
=Fit5
-----END PGP SIGNATURE-----

--=-fVWnNXMUz0gFn9OvhiaW--

