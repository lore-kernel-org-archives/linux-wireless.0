Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38004 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbYKNV7E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 16:59:04 -0500
Subject: Re: [RFC] mac80211: don't assume driver has been attached on
	registration
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1226697147-27997-1-git-send-email-lrodriguez@atheros.com>
References: <1226697147-27997-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-l7+AK7NVQMqa2nKHmEgL"
Date: Fri, 14 Nov 2008 22:58:58 +0100
Message-Id: <1226699938.4120.26.camel@johannes.berg> (sfid-20081114_225910_435743_4D164C76)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-l7+AK7NVQMqa2nKHmEgL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-14 at 13:12 -0800, Luis R. Rodriguez wrote:
> mac80211's ieee80211_register_hw() is often called within the
> probe path so it cannot assume the device's driver structure
> has been attached yet so to create a workqueue instead of
> using driver->name use the wiphy's phy%d name.
>=20
> This should fix sporadic oopses found when we race to beat the
> driver pointer setting. Not even sure how this was working properly.
>=20
> http://www.kerneloops.org/search.php?search=3Dieee80211_register_hw

Ok, umm, very odd. Why is it sometimes working? It should always fail...

Patch looks ok though, the name of the thing doesn't really matter
anyway...

> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
> Tested with iwlagn. If you are running into this oops please test.
>=20
>  net/mac80211/main.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index d631dc9..cec9b6d 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -722,7 +722,6 @@ EXPORT_SYMBOL(ieee80211_alloc_hw);
>  int ieee80211_register_hw(struct ieee80211_hw *hw)
>  {
>  	struct ieee80211_local *local =3D hw_to_local(hw);
> -	const char *name;
>  	int result;
>  	enum ieee80211_band band;
>  	struct net_device *mdev;
> @@ -787,8 +786,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  	mdev->header_ops =3D &ieee80211_header_ops;
>  	mdev->set_multicast_list =3D ieee80211_master_set_multicast_list;
> =20
> -	name =3D wiphy_dev(local->hw.wiphy)->driver->name;
> -	local->hw.workqueue =3D create_freezeable_workqueue(name);
> +	local->hw.workqueue =3D
> +		create_freezeable_workqueue(wiphy_name(local->hw.wiphy));
>  	if (!local->hw.workqueue) {
>  		result =3D -ENOMEM;
>  		goto fail_workqueue;

--=-l7+AK7NVQMqa2nKHmEgL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJHfSfAAoJEKVg1VMiehFYJdUP/3XCs9qMp9z7+f78w/4mldiH
VkdAdAM/hBDMKQ6pV8nX0L/ZAYKXBRTtNSEOeYz/HLcDoBwc0GC24pRuITSppkxe
oILOW8x/gSRNkANAT9iWWkQUDwfM1/eK6AJKzlJkkHUdJYryFYtMsYevhWILsB/q
0zZCIzmo9Hhufj+D6nQOP6qBaSePUsY5485CY6CfSI7rb9ebHK+bYC3jg3eWnuTY
PXlkYdg1cYE+PpuIbb3iD4aP5w1LpAmvPj1KU3GxtCfHT2JLyu5lh+9v8wafjNpS
YA4/kiBGhmj0L+iF5Ej9v47Wp9pvxGp9rX3+xAJ1+QOfXbiaMs7QHfOYc2YHGREO
QItLviAA+SZLIij/BNuCBX68JurSjhVVTrKuSx699d+j9v6TNWajnjkzWlc8hAh8
3CR+csGXbEwjtM55WsNOYjJ/HVFxj6m9FEyJS/HHIATPY7/Z3ejW4fA92VqtZswY
EdaEUAzWVUrguXDRZB418/j3KMR2NNwTQIgtvWdfI4CQyNacGBcBHMtnE4RY2ILW
wbuoBVlLTtVO+X5bhkQ9BVz8TS9zaEgJDZj5VAT3U2DQZ+cectgwoYvGGpbKMsl6
hjHRFids6eOBDcHbv2nwX2zk8M2utzb34zXodzVhosJ82PZmBFLbHDndtP3cnDTD
8oeVGINKY1GHAOp7phiX
=h3Rd
-----END PGP SIGNATURE-----

--=-l7+AK7NVQMqa2nKHmEgL--

