Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48841 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbZHZOfW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 10:35:22 -0400
Subject: Re: [RFC/RFT] rtl8187: Implement rfkill support
From: Johannes Berg <johannes@sipsolutions.net>
To: htl10@users.sourceforge.net
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <850984.89698.qm@web23108.mail.ird.yahoo.com>
References: <850984.89698.qm@web23108.mail.ird.yahoo.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oce+4jvtuf2mvgKQLj5D"
Date: Wed, 26 Aug 2009 16:34:33 +0200
Message-Id: <1251297273.15619.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oce+4jvtuf2mvgKQLj5D
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-26 at 13:33 +0000, Hin-Tak Leung wrote:

> > Or wait ... are you using compat-wireless?
>=20
> Yes, I am. I mentioned this and did wonder if the _backport/ part
> in /sys/class is important.

Sorry, didn't see.

Anyway, that's pretty clearly the reason -- Luis added NETDEV_PRE_UP to
some compat*.h but obviously the kernel won't ever call that notifier,
so cfg80211 doesn't get a chance to reject the IFUP. No idea how to
handle that -- it'll be working fine in a regular tree.

Luis, the only way to handle that would be to manually call the PRE_UP
notifier from mac80211's subif_open() and if that returns an error
(warning: the calling convention is weird) return the error... that's
weird but would work.

johannes

--=-oce+4jvtuf2mvgKQLj5D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKlUf1AAoJEODzc/N7+QmaLb8P/RsWg5eruL+TITLkUEbUpUqW
wAjvNpjtc+eHtZk9CkI3M8LIhAkvOm1LX+ligGZ3IpC1an1VAQnQzKIOksSoeLWP
RA84Y7sy+Y9pdi2rWMvjmdw6Lv5+vrd9RKyznkHvtdROTtlSTL6L5chG7jb05DIG
9UX+UqcC4HpVUjJvQmJJfnfjDH5CFwDB3L3rY0CUG/NSH8oyIrtkpEbKsKYmHcIx
Wzl03RKlICQL5ygFIcwxn3IYuManhFb16W+xDUYnY2xkpXP8F17QHWaoZTT+lJcT
53ARZOBl4O+ftu9TxXdMMNdgWAMmVQygkFWRpwoxuKjf5K8Bugq1WzzWXiODJonQ
FLBdELNElXhZuR0ncNL8HaFjp2cGufQsioI02s7q59eHcGUve7EVux6jEW2qYUai
yrTcDoVi9KgiiWEFxNyr60xq8zZ77OqjSC+cApwAaxAlNTpq7roc5r74be5d7sF1
uhRF6bbvDKGgrEsxuZhe3LIM11jxuqe/NCDPcUNPiYF6Hkuynode9WDWTpRcLk4U
xP/58uWuIjkjRM2mF0QxxRClsohanx6+3yoVaxOhd34H+IZcDD40Bkc0U0ePnAVf
VqBo+0eXs+Mt+++TwiIn+mCFge4kjPyCC52oR3BrS9Qv8NxoIaFjNF9nYjR4PN5m
nABM2RnP15jxcTTWS0f+
=sKpr
-----END PGP SIGNATURE-----

--=-oce+4jvtuf2mvgKQLj5D--

