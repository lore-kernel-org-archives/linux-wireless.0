Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60155 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbZG1QcL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 12:32:11 -0400
Subject: Re: [PATCH] orinoco: enable cfg80211 "set_channel" operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave <kilroyd@googlemail.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>,
	orinoco-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1248798599.13742.2.camel@johannes.local>
References: <200907281634.26104.hs4233@mail.mn-solutions.de>
	 <4A6F270A.7030002@gmail.com>  <1248798599.13742.2.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/oSqc0advicgpyeFzJLd"
Date: Tue, 28 Jul 2009 18:31:39 +0200
Message-Id: <1248798699.13742.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/oSqc0advicgpyeFzJLd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-28 at 18:29 +0200, Johannes Berg wrote:
> On Tue, 2009-07-28 at 17:27 +0100, Dave wrote:
>=20
> > Looks right for monitor mode (as you tested), but for ad-hoc the channe=
l
> > change would be delayed until the next SIOCSIWCOMMIT. Which for cfg8021=
1
> > is currently only on change_vif.
>=20
> You won't be getting this call for ad-hoc mode, because then the channel
> is contained in the ibss_join() parameters.


> > You can also eliminate orinoco_ioctl_setfreq from wext.c with this
> > change.

That also means you can't eliminate that, of course, since for connect()
the channels is also contained in the parameters, and the set_freq isn't
invoked.

johannes

--=-/oSqc0advicgpyeFzJLd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbyfoAAoJEODzc/N7+QmarwsP/jmObLXdDeOtynkkjqe1Y6Hz
Sujo9dI4H1vdPmksU7CE6VAomxDb0u10849+VgfH5aSbOd9mr3NJQ5gNQj16tl89
+O5vOympRMYPhudTotidlObVw2AIpkcNNlbrMvGvL6MMEGqQMslni0P2zm9PGGdl
w+nGTnto+aQV89HvnpEbjnassmsJj1M4Y2J7ttqVUEJdWj9v6rmWRimpGQxsaGaw
O2jG/9qnF+3Y/7bTWhUdqKIDgJariIYJ8hLLBd3jaOM7JGrNXPfBX5K9rMc2uYEd
6kwvR7/NEtqtwIZnaFb4cmrpn1zYvHr3NE0Bif22MWgzI5wQenhoudZsWvvtiICf
8xstUMmwHP5F9QmZCCVRqjfRB1RZ9B7E8wpva5viMFg3IeGZ4k6nTbzVE0Wl3gCB
nXNdKEZPPn7JtWHDYF3N95XLckoHN9uTCIkbx71b5B9yJtJ0JQw1tt3V7pjcDaDP
w1hCf0mIBjag9nfiq451U75lNBKnDl3F/6LkEsX7E6PmgCyuFSLp5Lfg7WBc8pnB
LVNihr0ZogMBf+TUriAXSOChFcQSAuCHlS0S9HJfO+L4CfQIWmqmKCAO0nsHy6JD
Zn6ntjgbj39ySKnrRSeWqZ0ThS2ZoTZ/nX0kY1NhjH/GChM9mU0Ar8/XXVwwTZx+
ejqhfZTpKc2xutrf8a/Y
=wnjg
-----END PGP SIGNATURE-----

--=-/oSqc0advicgpyeFzJLd--

