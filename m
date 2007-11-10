Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33031 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbXKJJdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Nov 2007 04:33:13 -0500
Subject: Re: [PATCH 2/4] o80211s: (nl80211) support for mesh interfaces and
	set_mesh_cfg command
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <473516df.18bb720a.41e8.5fdc@mx.google.com> (sfid-20071110_022645_005653_498DB7A6)
References: <473516df.18bb720a.41e8.5fdc@mx.google.com>
	 (sfid-20071110_022645_005653_498DB7A6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Y33dC8XcJayl4yrU864x"
Date: Sat, 10 Nov 2007 10:34:35 +0100
Message-Id: <1194687275.7258.36.camel@johannes.berg> (sfid-20071110_093316_192833_53CD4ECB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Y33dC8XcJayl4yrU864x
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> @@ -36,6 +36,7 @@
>   *	%NL80211_ATTR_IFINDEX and %NL80211_ATTR_WIPHY. Can also be sent from
>   *	userspace to request deletion of a virtual interface, then requires
>   *	attribute %NL80211_ATTR_IFINDEX.
> + * @NL80211_CMD_SET_MESH_CFG: start mesh operation

So if I bring up a mesh interface and don't use SET_MESH_CFG, it won't
operate at all?

I think I'd prefer if the MESH_ID attribute would be given as part of
SET_INTERFACE/NEW_INTERFACE instead of a new command. I'm attempting to
keep nl80211 as object oriented as possible and this single command
doesn't really fit the picture.

In fact, you could deny creating a MESH type interface when no mesh ID
is given, that would be more obvious to the user imho than to deny
bringing it up later.

johannes

--=-Y33dC8XcJayl4yrU864x
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzV7KqVg1VMiehFYAQJ8sQ/9EZWWzt2gLMtRMUCbZdGHzYV7rjCuNx77
c1uf2o1WovEF85u4wxnjLaNR25l2h6i0ilh5c/2GxT/lWISiouKEp79Wlo4VG+Iw
hNvQWEh/j5qTyKABmugTT20Qf5Ogd+REbBURSGt+2ZmSCf/MMwEWuaAm5HqgQGd1
tu2lbJdKyjy/5P6gPt4RRozZqGNKXCk3iQeWjCIu7BdkSsd7JlXr46ny+1L7BM+g
3dZOpyQUle0plbJgKovnlJBCa46pi/oCx9VMzsDyovFDuwe5Iz3N4eiHln07COlX
E0WhwgiIlPCXOu7++SMoFTReLd3sCPk1MLYaaXZNLg6TriRB8hOnU9kdH5pUIPNU
FGf+rCxv+AAvkdjuoafWviaHrJKz2x6u3ogsNL5lZUfcWCXstSqB/Q2If2Sx9ZYM
odxstIelsajprLGK4AXQssXPRC6J32eeqzyqIIffGE0fdx+jNNahY+mHymB99wv4
/TYHZgJij8xEUxSCVsz3FfOwuqfgdQklxILyplqDdrtiHxhZr+hAiknFUiQoHC+f
ms6kn7x/m/gycTIW4HRHJn4JvCTxaW5p4LS3jnie9DpMzhlIQfb6nIbhjm+LZ3w7
QErKcorqHfQNF8S+YQoxCPOX8SoRwpIX+0cfajecXDqlbS1ZYanjD8bSmR2COtx3
DlBHDm+BUiA=
=6wnJ
-----END PGP SIGNATURE-----

--=-Y33dC8XcJayl4yrU864x--

