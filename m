Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35666 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbYBVPV5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 10:21:57 -0500
Subject: Re: [PATCH 00/13 v2] o11s: mesh interface support for mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <47be76f9.03b48c0a.025f.54f4@mx.google.com> (sfid-20080222_071727_691746_9DC8AC76)
References: <47be76f9.03b48c0a.025f.54f4@mx.google.com>
	 (sfid-20080222_071727_691746_9DC8AC76)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tBUJc8mwzp68ioXoFv0I"
Date: Fri, 22 Feb 2008 16:21:49 +0100
Message-Id: <1203693709.7082.35.camel@johannes.berg> (sfid-20080222_152202_419952_859BF240)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tBUJc8mwzp68ioXoFv0I
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> This is the second round of patches incorporating the comments from Johan=
nes
> Berg and others. The main changes with the first set of patches are:

:)

>  - We are now using airtime link metric, instead of hop count.

Cool.

>  - Mesh peer link table has been discarded, integrating the necessary att=
ributes
>    directly on struct sta_info.

Neat. I'll have to respin either my recent sta_info reorg patches or
these. I can do the work either way, sorry for messing with mac80211 all
the time.

>  - We no longer use directly rtnetlink for mesh peer link and mesh paths
>    operation, and use nl80211 instead.

Nice too. What does libertas currently do btw?

>  - We now support mesh network in scan. The part interacting with wext is=
 a bit
>    ugly but works well. I just read the mail from Johannes with a differe=
nt
>    approach and will consider it.

I'll take a look here too.

> The pid rate control algorithm has been modified to provide an estimated
> transmission error, probability, necessary for the airtime link metric, a=
nd a to
> call mesh_peer_link_broken() if it detects a sta is no longer reachable.

Interesting. Would like to get Stefano's input on that.

> I would like to point out that it looks like we can get duplicate sta_ent=
ries,
> or more entries than the maximum allowed, if stas are added at the same t=
ime
> through normal network behavior and manual operation through nl80211. Ple=
ase
> correct me if I am wrong or if it is just that no interface type is suppo=
sed to
> allow both kinds of additions.

I think I CC'ed you on the patch fixing that, no?

> The code has been tested in a 12-node testbed and has proved to be stable=
 and
> functional. The only supported driver right now is zd1211rw, but changes =
in the
> driver for mesh functionality are minimal (for the zd1211rw driver most c=
hanges
> were just to provide missing functionality such as beaconing support), so=
 we
> expect a wide array of devices to be supported soon.

I think b43 should be fine since it supports AP (so clearly beacons),
the only thing to figure out is whether to turn on or off INFRA mode
(ie. use AP or IBSS beaconing)

> The patches are to be applied on top of wireless-2.6/everything HEAD. Eve=
n
> though I am sure there will be some issues, it would be great if we could
> integrate this as soon as possible to make it easier for other people to
> collaborate and to make my life a bit easier :-)

Hm. I think you'd have to rebase on top of wireless-testing/master but
I'm not sure how they currently differ. See John Linville's mail on the
new tree structure.

johannes

--=-tBUJc8mwzp68ioXoFv0I
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR77ojKVg1VMiehFYAQKd8Q//QyORXEpLwZOI8BAGaHPQxfMkzfV7FOqA
7Pjd2Y7YpKYoOTbRHNdlvRini2JAd/ghleyeky+J10AE509PIDdOV/7cej2ZwGuM
NAOMuosdG75pX2NiIbdX/NmvsARVXO9nh1KDg/Tth337q+zcWoeXk3pQ/b3cR4zX
yEcvrJd84kpusK/L/iL6nj/MvNWbEVAsG4Rj/KV6R857B5gfwhbCJyyULEFUQrAd
lWq7E6OLOdLRiea9y8QYkLL/aw1q11Ytc9+7zDIs3UlgUUsfcrISlnk8boEbf6Ot
FhjSxFrZb6YVXF9idDYRRjhO8UBZqlU5uByRp76jEFwpD4Bmji5bCD31ovOOPqn1
GLS8hSh0G0yWUr7FKTeQd4UFT9OAbMr3Hz3lPRD840X7Ndwi7BlSMdohWa5X2BjG
gGS0ovRmwWREDE3GbNw6vpnm1YW4USwJSjfzuCBGNy/MynaKyxnQIwVwTWomvgHj
lmYUqDNFpreplvxyZ1Tl+tRmw7ow8vnfG9N+fhcLenSENoY9bJ7McjNUU/2FtXly
CXew1zwSOgpXSIMbaxSfiIo8d3Q7lDNpjxyHMDYRoEdOmo6wVb1SImtoY4ThwlFp
TAI6K0k1hTJl0+72QAZopfDGF41ZY1PdqNKV9iAbcGeDAE0Dt25XrmXmZcG4FJ0J
DDZabsmG+is=
=Xy30
-----END PGP SIGNATURE-----

--=-tBUJc8mwzp68ioXoFv0I--

