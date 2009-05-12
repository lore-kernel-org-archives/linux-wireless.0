Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59008 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458AbZELHL5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 03:11:57 -0400
Subject: Re: Re: [ath9k-devel] ath9k module-Unable to set channel-since ath
  comes
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: alexander.bartha@drz-wien.at,
	Alexander Bartha <alex.xy.privat@gmx.at>,
	ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Pavel Roskin <proski@gnu.org>
In-Reply-To: <43e72e890905112355t53537ca9w2797cfc8694302@mail.gmail.com>
References: <43e72e890905101141r6fe3b655ta158acabf4c87ec3@mail.gmail.com>
	 <OF24E7AF48.E39EC671-ONC12575B4.00236C72-C12575B4.0024C49C@drz-wien.at>
	 <43e72e890905112355t53537ca9w2797cfc8694302@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-TmDtzB37Gsfuu/Jv/h6V"
Date: Tue, 12 May 2009 09:11:50 +0200
Message-Id: <1242112310.3873.55.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TmDtzB37Gsfuu/Jv/h6V
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-11 at 23:55 -0700, Luis R. Rodriguez wrote:

> I've tested this and its not the "ath" module which introduces an
> issue its a patch which enables PS by default. You can disable that by
> recompiling with:
>=20
> CONFIG_MAC80211_DEFAULT_PS_VALUE=3D0
>=20
> If using compat-wireless just stuff it into config.mk.

I object to that assertion, or at least this way of putting it.

If powersave by default causes issues then it's not my patch that's
causing the problem, it's the fact that ath9k can't properly deal with
powersave in this case. Had the user enabled powersave manually they
would have run into the same issue. As such, I think ath9k should
probably simply stop claiming it can support PS.

johannes

--=-TmDtzB37Gsfuu/Jv/h6V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCSExAAoJEODzc/N7+QmaPJIQAInZZH1FcZVWCijstz0Z/nge
ENwuSTRYvjvGn/iVV2lNJGB9/ptb9GxAjkHtvxjbASbots97byD749O9ggcxjDPq
kg3/bl9+h1CrQB4PHdfu5TZXUZL9re31bA5ModvLiFLgUKrqU0qvE5sLdpMpyRCt
kkfdaTWgmdFWSrR7RyGaKXoI9+lurFc73/ubN1QpCa95oJcKvFVPYP1mJKuxczUx
5jZKcMEAspe/csY6nOi1la+7bziUXvrVlACBo0LIa8pcL6jvlNBODOrvftMBhfe6
USnGlyEM4FXNOTHj75Nq/FWxj2d+05z02ng5y5E1GKjo4utQtHdQ8bpa3s5MLSf/
O9HhhaY+QMA6TotWY8Ffuby0Qu3baGsnzW7f49CCL78WCcVH8kQa3nfj55GYuU9a
74zRvfg/Dfy43YJjxDjI/N8prNnM4Oz1vffNHuywReRuMNwusB4P2yNaCPqiK8uA
cfeFdMXCPe1VKQiuz945mumEXhRokUH9ux3+dqvfnL7R+mkss/1iEv6GSwTbqn90
BH+UZVbmPXm8nYNGnDaVMUDRnGfFRb89Gh5sZ3uNLRe+BNV19xq+YrN0NfXmMlFf
xz2O3EwSqzm7YGK9GuMX4g8TMLDw406KJljSx6PwN1IUv8PlC0MdHAhQ/YfWPaS/
arpcJ+49cz9h/GUYLv0j
=TLNW
-----END PGP SIGNATURE-----

--=-TmDtzB37Gsfuu/Jv/h6V--

