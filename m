Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33907 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbZAMWuv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 17:50:51 -0500
Subject: Re: [PATCH 11/12] mac80211: allow mac80211 drivers to get to
	driver priv from wiphy
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1231876675-20518-12-git-send-email-lrodriguez@atheros.com>
References: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-2-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-3-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-4-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-5-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-6-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-7-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-8-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-9-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-10-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-11-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-12-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Avk2DNg5UhG2tfFkh7lJ"
Date: Tue, 13 Jan 2009 23:50:23 +0100
Message-Id: <1231887023.3728.4.camel@johannes> (sfid-20090113_235055_195638_EEA2866C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Avk2DNg5UhG2tfFkh7lJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-13 at 11:57 -0800, Luis R. Rodriguez wrote:
> If a driver is given a wiphy and it wants to get to its private
> mac80211 driver area it can use mac80211_wiphy_driver_priv(). The
> wiphy_priv() is already being used internally by mac80211 and drivers
> should not use this. This can be helpful a drivers reg_notifier().

> + * mac80211_wiphy_driver_priv - return a mac80211 driver's priv from a w=
iphy
> + *
> + * @wiphy: the &struct wiphy which we want to query
> + *
> + * mac80211 drivers can use this instead of wiphy_priv() to get to their
> + * driver's private area. wiphy_priv() is used internally by mac80211 fo=
r
> + * its own private area and should not be used by mac80211 drivers.
> + */
> +void *mac80211_wiphy_driver_priv(struct wiphy *wiphy);

I think I'd prefer to have this return the hw struct, and the drivers
can dereference to priv themselves.

johannes

--=-Avk2DNg5UhG2tfFkh7lJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJbRqsAAoJEKVg1VMiehFYAM0P/j0XC5OMBItVw86u9UzVGDQs
+rPChXlgzhIIDDZ7+acFd30QerdZMluCItkRZF1jvnf1s9aac1fQk4Vkc0UbXpMk
eE2WcpanmpiEv2sjXpnMv1mewbS5nsGdKerUb2BhrThI53jTw5oOzJ092utdB6nQ
Ez9SYenKl7S33GkgOQBW4RCLN/snbhMIAdZOcR0cU6uQUQhLZ21Kz5WOrBPeWTK4
4UIocMmT8Y6fzkWvCLe71d0cVSUuBKR6MdrmoOjpklYtBqVWy0YscXBdXsvMiumf
GJ4ZuwOwAf56iX6s02oupj6cxstEa4gUiejvo/ADcsg92bNEdf0ZwuFIjQmT+BGn
kkvm8LOQgguJWTBawIsQR0WqxURJcXZg/jsuIemMhkyjSj3T1uW33aJ76SCZ3bfK
kSGLWVoLp7+dc/uUN817KE70VrTEAyyLNe/MDc+CYMhl9lz2a5sDhcF5uFfR9GbQ
lDeUo8ZvavuR6Bc3TilL2cATPGK6f4NI5BQ4FzBnc5UbyRyEw93gDkeI/lCKwUuc
IUs18YiszCqtvMJyWuHTVNZuXVs5B1c7cr6x7Isz/Rkxjf9VR8YMIKJH8ZM5H+7l
SrQhlEhMEe0KrSqjl0IL1Ko8HG0vnf9ySZ1N8ExRZUOdbyJWvuFyhROFxoEkHzd7
C5uZxbPETvOIfuBXrD/H
=jyeQ
-----END PGP SIGNATURE-----

--=-Avk2DNg5UhG2tfFkh7lJ--

