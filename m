Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41899 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYJTIHr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 04:07:47 -0400
Subject: Re: [PATCH v3] mac80211/drivers: rewrite the rate control API
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <1224489844.24677.225.camel@debian.sh.intel.com>
References: <1223996147.10113.33.camel@johannes.berg>
	 (sfid-20081014_165703_092655_BE6BA58D) <1224052607.3027.20.camel@johannes.berg>
	 <1224484940.24677.169.camel@debian.sh.intel.com>
	 <1224485319.18024.9.camel@johannes.berg>
	 <1224486368.24677.184.camel@debian.sh.intel.com>
	 <1224486587.18024.25.camel@johannes.berg>
	 <1224489844.24677.225.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YztsR1U4FQ/gMRwuw8y7"
Date: Mon, 20 Oct 2008 10:07:40 +0200
Message-Id: <1224490060.18024.28.camel@johannes.berg> (sfid-20081020_100757_757770_1AE22354)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YztsR1U4FQ/gMRwuw8y7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 16:04 +0800, Zhu Yi wrote:
> On Mon, 2008-10-20 at 01:09 -0600, Johannes Berg wrote:
> > Yes, I know that much, but can you tell us how exactly?
>=20
> I don't know the details either. Will follow up on this.

Thanks.

> > It would be good to actually report as accurate as possible (up to
> > MAX_RATES) the retries the firmware will have done. We're going to
> > export that information to userland in radiotap too.
>=20
> Sounds like a good idea. The actual number of retried rates should
> depend on hardware/firmware. But '5' doesn't look like the possible MAX.

Yeah, we don't have more space than for five entries. The question is
whether the firmware will really go lower for each try, that would seem
harmful for throughput in most cases. And if it doesn't ever use more
than five different rates we can obviously add the count... If it does
use more than five rates then we'll just have to live with imperfect
reporting I guess.

johannes

--=-YztsR1U4FQ/gMRwuw8y7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/DxJAAoJEKVg1VMiehFYqdcP/ivKJ1ntztEbX+0q5J4B7VE5
DIlcc5Df01jqPkqIevPOMrm7BDRtx3ir4oUlTXCl9VthxigqFq9lnl5vBWXjN5xI
X2K/PSg2PreRlGeldPLDrg0vLfFwSVzApnhrWWLMYx/NZdFZu4bQzkrH8FBh9Dxd
vHPfIP7HHClMgjIvGq/s8RIvWh+eQ3L+XFpjMAPiCoUbz0FTDnDqjU0FEEx5VCMy
pRXU/pljqacepSZqtWdJKpfmWMHX0KlAvH+lYvjicNcyAZY3XPkZXwp6VwXhXD+Y
5a/hgOIsOh0t2a2KwKsLds4r8aGq8xDbeU7npACYC5S4lJbb9Y1KGTbg4FGwAQFP
+d7GaomHpO3vBnwKkJQd7U62oPjZ+PJoI+9eyixD0ggICM34/KyjhrgT7TAzVRSr
mzBkov5LbcCfhz4OBl1TTImua3YXph6I63rrnK8owFVOeVEnycg1SpOzvh4TbSAf
+58SAgN4UhERmuKOr3MX5xktbhW4CUYiIBna51Bp1ILrnhD5cjgSmM4cFNrfYgC9
KgkjSGyPxQR+zguAhSLUiffEfzDCx/np71Pkjfu9PghW6coQW5iSi+xxhPQOBjE5
IWjazL0FXMhFbiLjWmCET6Smonr7NmK4J5AngTA355YXLkXIQ3ziSm+DMOVyKMXy
qsnQtPibUpW61HKtZVNP
=TWcf
-----END PGP SIGNATURE-----

--=-YztsR1U4FQ/gMRwuw8y7--

