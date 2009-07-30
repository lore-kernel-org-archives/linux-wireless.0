Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60451 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbZG3PdQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 11:33:16 -0400
Subject: Re: [PATCH 2/2] cfg80211: decouple regulatory variables from
 cfg80211_mutex
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890907300754v7ed8cb66w9b1bdbfe9917486c@mail.gmail.com>
References: <1248914792-6010-1-git-send-email-lrodriguez@atheros.com>
	 <1248914792-6010-3-git-send-email-lrodriguez@atheros.com>
	 <1248939781.8925.2.camel@johannes.local>
	 <43e72e890907300754v7ed8cb66w9b1bdbfe9917486c@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-bsLgqkbtcSdamyA1RMhJ"
Date: Thu, 30 Jul 2009 17:32:44 +0200
Message-Id: <1248967964.16129.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bsLgqkbtcSdamyA1RMhJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-30 at 07:54 -0700, Luis R. Rodriguez wrote:
> On Thu, Jul 30, 2009 at 12:43 AM, Johannes
> Berg<johannes@sipsolutions.net> wrote:
> > On Wed, 2009-07-29 at 17:46 -0700, Luis R. Rodriguez wrote:
> >> We change regulatory code to be protected by its own regulatory
> >> spinlock and alleviate cfg80211_mutex to only be used to protect
> >> cfg80211_rdev_list, the registered device list.
> >>
> >> By doing this we will be able to work on regulatory core components
> >> without having to have hog up the cfg80211_mutex. An example here is
> >> we no longer need to use the cfg80211_mutex during the country IE
> >> regulatory hint; by doing so we end up curing this new lockdep warning=
:
> >
> > This is ok with me, but be sure that it changes the API between drivers
> > and cfg80211 -- the reg notifier can no longer sleep now.
>=20
> We could use a mutex as well.

Right. I don't care, just wanted you to be aware of the change. I don't
expect many drivers to really use the reg notifier stuff so if it
doesn't matter for ath.ko it probably just doesn't matter.

johannes

--=-bsLgqkbtcSdamyA1RMhJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcb0ZAAoJEODzc/N7+Qma7nMP/iYBaF34WZcWTjOPHw6eJZ3t
wB7uAkxSP8wh+eG1IS0Itl2B5wcMcHYN1YWWTHzIdgdHUI7s7iRz2yO7B49iGNUD
cIqaybrnRDRjhKxxHd/DcbsrEuPGz6mT+OuNReoIZGW21Ir/+iMe6z/VajuVrHK1
O/PCC7Vu5GlsCUIA7CYfsFNoBV/AAjOg7TQ+rs8w9e4Lsf57wBWM9fr69biJZQDy
hBBcW3Z0f7D1ODN1GtlfGja1+JFOHXym5nf8gEyOFNfDjHT4eDUNyII6KlMqjFWz
uCIXzEb/1Ic6alQUOEoLEq6FaU4W7Bb2ZnK/ucwLvkrfkcnrCOjzrPWcz30aJTf5
7a1dqbRJiADNLsXGRCTSeUmzWj+S/XjDgn03izUI71lqAw/nmKOijAdf4NEl1YG1
b/FCa8aOyQYfxT2+ZlBc/IHT3O6tLF8EagX4jhM9bSYJENc8LouYE+bYh04CPLmu
3dL7qpguvXswQIO7FHjhtBwEIG/ni5fTl6mmH2S+380OaFCpdw9aMKMzrtWfNNq6
WScYXbt306F6CeYJL9UZiYqJrGrgo3IjEZyYuax5M3l5Di8swuyEu2IpEt3fh4Jj
5vcVyBVmUHSob89L2kFFlXd6wXiHjm3OKBqHsugiHo6f+W6Jlw4yUsPlfwKO0wOv
y0/anLebsDFbF5JYSYL0
=GgoE
-----END PGP SIGNATURE-----

--=-bsLgqkbtcSdamyA1RMhJ--

