Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45133 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbYFYU1M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 16:27:12 -0400
Subject: Re: BUG(?): dev->wl->if_type is 0 for monitor interfaces (should
	be 5); b43_is_mode(dev->wl; IEEE80211_IF_TYPE_MNTR) is always false
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <69e28c910806251323j3a80b31etde8683d573dcf2fa@mail.gmail.com> (sfid-20080625_222356_890423_579F588A)
References: <69e28c910806251322i31a8cb4flc7b6c85e8884a5ca@mail.gmail.com>
	 <69e28c910806251323j3a80b31etde8683d573dcf2fa@mail.gmail.com>
	 (sfid-20080625_222356_890423_579F588A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lY+3zF6ikuegqqUAlcbw"
Date: Wed, 25 Jun 2008 22:26:30 +0200
Message-Id: <1214425590.21847.61.camel@johannes.berg> (sfid-20080625_222715_875958_74FDF878)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lY+3zF6ikuegqqUAlcbw
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-06-25 at 22:23 +0200, Stefanik G=C3=A1bor wrote:
> On Wed, Jun 25, 2008 at 10:22 PM, Stefanik G=C3=A1bor
> <netrolller.3d@gmail.com> wrote:
> > In both b43 and b43legacy, dev->wl->if_type is 0
> > (IEEE80211_IF_TYPE_INVALID) when injecting/transmitting packets on a
> > monitor interface (not sure about receiving), while the logical result
> > would be  5 (IEEE80211_IF_TYPE_MNTR).

I should answer on the list too then:

No, 5 wouldn't be the logical result. Try to understand how monitor mode
and virtual interfaces in mac80211 work.

b43 only sees what mode it is operating in, but pure monitor mode isn't
"operating" at all.

johannes

--=-lY+3zF6ikuegqqUAlcbw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYqnyAAoJEKVg1VMiehFYCgkP/15JVNmhEyVtqWYEq9ykzdRA
l1QHGEfu3bd99J4yLkqTxXSEircfbiqebL0hwiUnB8goDowk/IDqrV2efWXT4tBM
E2rseZbDuve6bVlGhvY97qbeiZZzw8xSrWC4WOsqaZAvrDl40zTO7uWZ5ywXxHO8
lj2hXN/i7Q7KJgTLnb8CywXvqHpnjZ0c34lOJRtJpottOmtbUzAyj91qZ66ZbaxL
P5uY0D0W7QspKYUx92MorzdL+myCRp8vFaH+ZXWQnsRPEKXtLq+YCkhJawIgYWPv
RdB9TUQy1NsPTm4B8Qk6NBpXJiPv+ghDOtbkbTDhtC+BwEhAS8l9ToHUsiTcWLqL
iirKJJOfzy1ks7MedrV94T3GcUOAUmPwOnYtDEBIqG0sSM06QfUaWB9qs5y7dDns
FdHQv/LBzbnsxdH/3ZU0KImoCFeVSURTzHxOMPbzD8W7vq8UTkzKbjcJThKkWoCJ
K80aEeKI+wPlPjNZFufP5FFbgu9i21NV1wtvhC/hEL4dHfWOOwCgX0O6lEjg+SGc
X0Nz60saXBarIImkbdtQQdom3Tcgcy6N2iAS568k4W+9VNuDurxxLzBu28pqIHXn
JJb8cFJh5PUK2cbGVjQsdmvd2GCwamTBM3q2uOzkWgZlmPAf0Klr1olW/XPFtFHo
Qld7AvhV3+VNJWmonNhJ
=ba2d
-----END PGP SIGNATURE-----

--=-lY+3zF6ikuegqqUAlcbw--

