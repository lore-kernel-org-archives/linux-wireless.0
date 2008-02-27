Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49241 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbYB0Q2k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 11:28:40 -0500
Subject: Re: Roaming issues.
From: Johannes Berg <johannes@sipsolutions.net>
To: Lars Ericsson <Lars_Ericsson@telia.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <004501c87946$e5f1f490$0b3ca8c0@gotws1589>
References: <004501c87946$e5f1f490$0b3ca8c0@gotws1589>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rxb3VGUUbqwhOkX/32Uq"
Date: Wed, 27 Feb 2008 17:28:25 +0100
Message-Id: <1204129706.6309.19.camel@johannes.berg> (sfid-20080227_162855_974710_28A9773A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rxb3VGUUbqwhOkX/32Uq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Lars,

> AP deauthentication.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> When any of the ieee80211_rx_mgmt_deauth() or ieee80211_rx_mgmt_disassoc(=
)
> are executed, the mac layer takes two actions.
> 1) Tells wpa_supplicant what had happened.
> 2) Start reestabliching the connaction again.
>=20
> The later action will stop or significantly delay the decisions/action ta=
ken
> by wpa_supplicant as a result of action 1. Normally the supplicant will
> start an AP scan.=20
> But the mac layer is busy with reestablishing the link and will not start
> any scan action.

Does associating actually block scanning?

> My patches simply put the mac layer in IEEE80211_DISABLED state and wait =
for
> the supplicant to decide.

That would break supplicant-less operation which we can't do.

> The ieee80211_rx_h_sta_process() and  ieee80211_associated() are involved=
 in
> monitors for dead AP connection. A last_rx value is set to indicate a
> working connection.
>=20
> The porblem is the following lines.
> 	if (!is_multicast_ether_addr(hdr->addr1) ||
> 	    rx->sdata->vif.type =3D=3D IEEE80211_IF_TYPE_STA) {
>=20
> Any package that arrives to an STA will update the last_rx value and
> prohibit a link lost action.
>=20
> I have noticed in my system that this function receives the following typ=
e
> of frames:
> 1) Broad cast frames from my BSS (beacons).
> 2) Data frames addressed to me ;)
> 3) Data frames from other STA addressed to other MAC addresses but using =
the
> same BSS.
>=20
> It is the case 3 that creates the problem. Another STA, closer to my BSS
> will update my last_rx value even I do not receive the BSS.

I'm pretty sure case 3 can't create a problem there since rx->sta
wouldn't be set to the AP. Can you please print out "rx->sta->addr"
after the !sta check in ieee80211_rx_h_sta_process and send me the log
indicating that we can actually get into there with sta !=3D our own AP?
If we can that's a bug elsewhere but I doubt it.

> Timeout handling
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> When any of the ieee80211_authenticate() or ieee80211_associate() functio=
n
> are executed.=20
> The mac silently set its state to IEEE80211_DISABLED and waits for the
> wpa_supplicant to timeout its current action.
>=20
> I think it would be a good idea to signal to the supplicant that the
> operation has timeout, and no further action will be taken.
> To speed up the timeout response I had squeezed the supplicant timeout.

How do you signal that? Make a wext event with the BSSID all-zeroes or
something? Sounds ok.

johannes

--=-rxb3VGUUbqwhOkX/32Uq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8WPqKVg1VMiehFYAQL1tBAAm4kU/V4gzboev6qFj9O0rnmPg2zoC8MT
oQ53eG6CPx50MzEp2pGkp6QkdElCNcGD0h40NZjZM7h5dOrguJB6UNngsNuBS9Vw
zKlhP3X6z1m86ufDxhWez8SWVjXy5sXF34I7NbVOgk1PCFGmDQVKxjXnh7UiMoiU
2s2DPHGUceIfHKvRmmYsBmIZZ/hCyx70ivDwoczV++63BFaFTRiMCSISkcK0nHtq
29sgq1GDenZUF64L7KVC7qcQiClXQ3x5MWE6zZe3Oawxd+Fn7XWgxuUtmNs+wrRQ
c3CeCR6CU1X60NZ/+xkw0kr8QdopuZJWM28oRkthaMtWA1GO4SB2SJUt6JIklrOD
UUOQRAeKrFUyUj5BI2LG23+IOLO99KDoJE/O00munOIdOvPjfo5cdrF8mexq+Rt/
2Wu29jlMatOmmw2mCTkmNBxj9aHXSrnictQRO5veIUSxqEqWGlO839ssiRaLXqIX
7AKm76oTnGCZXI1yOCz9x3KpnvhyED3EjkeijZT1s/aG58/uF10U/OHV6txRPWkn
WrRXpceJgAhCZE7q/KdNYs2GISb/wCfn9zP+nC65nvvjRj+z5pKv82v+yLgXRi6d
c3wEfN9g3p9rW9yWJp4KdIuyzknrqznURtPjErtuD4ObCJTCMaOBQVHM+luHzerh
CWfjRyzAf38=
=lTHr
-----END PGP SIGNATURE-----

--=-rxb3VGUUbqwhOkX/32Uq--

