Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33928 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbYJ3RyO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 13:54:14 -0400
Subject: Re: [PATCH] mac80211: Allow AP mode to be enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081030175030.GD3923@jm.kir.nu>
References: <20081030175030.GD3923@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oUa7IjgdBd171X32+ru2"
Date: Thu, 30 Oct 2008 18:54:09 +0100
Message-Id: <1225389249.3690.78.camel@johannes.berg> (sfid-20081030_185418_955759_E4CF7365)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oUa7IjgdBd171X32+ru2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-30 at 19:50 +0200, Jouni Malinen wrote:
> With the addition of basic rate set and TX queue parameter
> configuration and confirmation that power save buffering is
> working again, mac80211 is now in state that allows AP mode to be
> used without major problems. Consequently, it is time to allow this
> mode to be enabled without having to patch the kernel.
>=20
> AP mode requires hostapd for management frame processing and as such,
> configuring this mode is only allowed through cfg80211 (not with
> iwconfig and WEXT).

Good stuff. Finally :) Now we just need all drivers to support it too ;)

> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Index: wireless-testing/net/mac80211/cfg.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/net/mac80211/cfg.c	2008-10-28 10:32:35.00000000=
0 +0200
> +++ wireless-testing/net/mac80211/cfg.c	2008-10-28 10:32:40.000000000 +02=
00
> @@ -26,6 +26,8 @@
>  #ifdef CONFIG_MAC80211_MESH
>  	case NL80211_IFTYPE_MESH_POINT:
>  #endif
> +	case NL80211_IFTYPE_AP:
> +	case NL80211_IFTYPE_AP_VLAN:
>  	case NL80211_IFTYPE_WDS:
>  		return true;
>  	default:
>=20

--=-oUa7IjgdBd171X32+ru2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCfS9AAoJEKVg1VMiehFYXJUP/i4ox9WJe8I2X0AXM/0QS+hY
Nd7A2fjmDp9CEqMumTP2Y36GtGsQSWokRxRjYuNrcIiNLhwS8KWWpVbuZh5xDx2G
yZOT1Kkt16G4guGSxKxaIGI+WSA/9MDGW9ksMEZqP+VPh6E81nbBI4l9XCJ0zCUo
LbNQ/MbxYa5fSQtGF2D5huPybl0SQut//YhOSoe/Krb7WccBvlHEKUKOJ/hY7uDg
oBsLBGuH83hdt90+RoljQ2xk80evZI6OU/EA5SxY7MHDmXt1+9liII0dad+B5V5v
NONCheABLz6L1m1kHcv+8/z8zvXRJalng0xesKq35geXTYMWo284aUphIjHNDJ3H
Qmng81nl1t+F+3mZM2Dw+1NGVnt2Ugz1vQK4o0eePbSpzo3wWbK5PrifA/+3GlDP
0NM6QqJY5uERKeOo+/Yd+kQ01momOP2u054/HeYQ/pY5Au9SmhtI+VSx1AhVMJ7M
omN4882+CJiaje0gSqXMjIVi3aWbnvJ6+bHPiDf0dQCVCna41eUGFXgHVFTkHVGX
DdhBSVm9AoT874SJCkqVV2El4meOK4OVwTwJQIwtKVMwWKxGDgI8RjQ5vktqeHXO
7lnKF9ZdEESDy/Nwqn1TIDIjVW7EwQM3XH8+ZjZH0y/LZg7/0QTA57KkVDHfovuB
IrhiOLy8a/ByELKBIgbp
=NE7u
-----END PGP SIGNATURE-----

--=-oUa7IjgdBd171X32+ru2--

