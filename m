Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40956 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab0AQVF4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 16:05:56 -0500
Subject: Re: [PATCH 1/2] cfg80211: add a callback for querying the
 operating frequency and export it through nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4B537A94.9070807@openwrt.org>
References: <4B536B05.6070301@openwrt.org>
	 <1263758236.28067.11.camel@johannes.local>
	 <1263758423.28067.12.camel@johannes.local>  <4B536F21.1090509@openwrt.org>
	 <1263759278.28067.13.camel@johannes.local>  <4B5371C3.6060504@openwrt.org>
	 <1263761294.28067.14.camel@johannes.local>  <4B537A94.9070807@openwrt.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-l0eG4zeAme1zH1gZOygu"
Date: Sun, 17 Jan 2010 22:05:51 +0100
Message-ID: <1263762351.28067.21.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-l0eG4zeAme1zH1gZOygu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-01-17 at 22:01 +0100, Felix Fietkau wrote:

> > But like I said, you already have that information in the relevant
> > cases. hostapd you can just look in the config file for it...

> Nope, hostapd can deviate from the config, e.g. in the HT40 case.
> It'll
> switch primary and secondary channel, if necessary, or switch from
> HT40
> to HT20 entirely if there are overlapping BSSs. And what about STA
> mode?
> The channel won't be in the config in that case.

In STA and IBSS modes you already have the information from the BSS
info.

The channel type might be more interesting, but even then

> > The problem with this is that not all drivers will be able to
> support
> > it, and that you will be exporting stale information say in the case
> > where we're not connected at all.
> If we document the exported channel for the netdev as 'last configured
> channel', it should be fine, IMHO.

I really don't think we should do that. And it will not be possible to
ever have iwm/rndis/orinoco etc. export such information.

In any case I have a feeling you're trying to use the kernel as a
database for something you already know, just don't have quite as
readily available as you'd like.

johannes

--=-l0eG4zeAme1zH1gZOygu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLU3urAAoJEODzc/N7+QmaF8gP/Apo3RMSxxY8UOGysbOqjmGx
7IDCe9yLYzc2IwW6NYMRea+eJLCfnZSZH2STC837w7jcG2ZbbbRLzTImvDCV97Xh
XGgdQh7moEfxVvEwJgM9ClFgrZC62YLH7p0//14t3iRxTzfqvKF0wstkRT/dYFeW
VOZvCG/OKAPxDMRAWIzwSW+rZKFeiajfXmGcjUi0RFHF1157+fErUpArfvPxUTCr
wqg4Ly6Qqye5mn8ctx4fCI4yJoXGJ3/5WrMkgo09O0VwZ3HbaeWugjl0gFsjWbzl
6h5KtE95RUZdNdv/wlTkJYE0FlvHXKcm+PalvRdFmfz/AULbyKtWnq46nSSF65l5
UXPBHrjy6T/7klYru0VrDfY0NXtcQJK6w0HDVSsX+5z2LPG62bZfHPcG0PJr/pIj
pgtRo1qHGfmzpK4zSgK6Oblj1G3qFGFU8S/KdWpMLFEBdO9QBY48FS1tZB41ZelW
BMVDLBUyxjNB3cPufctjiYzytXRes4M+A+oqm/WHveIH85r31GE4r6D76sPO4Y+T
PiLreBuyZyTH8bYJHVlIAWZWpy7FAt2kej2LDZmXhS8odf0k50gUkGqnFTrTiU4W
Wrlg3Hz8b+ngWSm5/4Ux8sTjsU+VzGBGdCmFwEz2OXwssxWGcDaA+xLimLjfOW6s
w0pZVDWfzvW+ldQA1hly
=5jbG
-----END PGP SIGNATURE-----

--=-l0eG4zeAme1zH1gZOygu--

