Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44177 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbYJBJYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 05:24:08 -0400
Subject: Re: rate control vs. bands
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>, Tomas Winkler <tomas.winkler@intel.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <1221223890.11204.33.camel@johannes.berg> (sfid-20080912_145214_760432_1456136F)
References: <1221223890.11204.33.camel@johannes.berg>
	 (sfid-20080912_145214_760432_1456136F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-e6VkR/PHNw73tPOuh0oH"
Date: Thu, 02 Oct 2008 10:40:45 +0200
Message-Id: <1222936845.24551.34.camel@johannes.berg> (sfid-20081002_112412_267237_BBD009D3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-e6VkR/PHNw73tPOuh0oH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> During my rate control work I noticed that the band handling there is
> somewhat awkward, and I wanted to collect opinions.
>=20
> Currently, much of the code assumes that neither we nor station in our
> bSS change bands; the PID algorithm even says:
>=20
>         /* We can safely assume that sband won't change unless we get
>          * reinitialized. */
>=20
> which doesn't really seem true.

I haven't checked so far, but I think you can make it switch:
 * bring up two IBSS interfaces in 2.4 GHz, have them sync
 * switch the leader to a channel in 5 GHz
 * the follower will hopefully find the leader and switch there, but the
   sta_info for the follower will, on the leader, still have sband 2GHz

> For the rate control algorithms, I was just thinking about removing the
> rate_init() callback because this can just as well be done when
> allocating the station. However, currently we don't pass the band to the
> alloc_sta function, so that isn't possible right now.

So it seems that this sucks for rate control algorithms; we need to make
sure rate_init is always called during alloc_sta initially (so we don't
forget like mesh does right now! nbd, make sure to test mesh and
possibly fix it please.)

We also need to investigate calling rate_init again when the sta has
switched band for some reason.

johannes

--=-e6VkR/PHNw73tPOuh0oH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI5IkKAAoJEKVg1VMiehFYW6EP/3Cb30hNFZb78R6xx2reAxR6
CkmCI+W9Zwl7D21hqHBh5BeCzE/Wh6vtFniipG/Ji9ebmeZEavYcyPOofOBNNSt8
Goe55BEf/D2JkGuh47J7pjRWVxktkXuptaiIdkPPKq8mhE1ITCdMbb5Y3i0jIdkU
3tTIs7qT8ZaTv2SB4Y4ni4bez3RGTWjk6ofT760jStzVLQbytwLTrIuRVqTb5vlX
Zu/8fdknBGBaBAoikn8LNNuGPSLwjJ/myYvCm0N86770Tty8avFj45J1MTQAAmYJ
p/xNfo4zGZC0VQ2xA8wJ0aWPOVNotZpPwMcsjmZKSPXNuaUdF4eq6yXHa96Jhhas
pjz2C71bUk7NBL2IKGaGuvusxzI8lbQ8bC8TUDqpVqIKifzTth/3W5xbVdDQI0K9
3NMB8e6fP6pyJBrrHl+PdCI2BDnL68IWehJ4ia5YQhNEa1JA4tkqBnSoCaYgLSbg
/MaFFR7uA9ua2sikgTC9xdkstVoR02o+5HFkrMZqXyP5ic9+16s14fppppwffxU2
Av2lhMCO+28UOyLHMf254SL8hsFlmFOIynh6hBnSGoSqzheoRjmsRjSpThCFQwS0
lBt8131nj/X0wztjA6aTnfd83vhcbyhZT4st/uHBLx3qtSqk2MNFDsiedpamOFuT
M2iUFBDEbHUSphXhlHOJ
=uaYN
-----END PGP SIGNATURE-----

--=-e6VkR/PHNw73tPOuh0oH--

