Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57257 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbYBYTSy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 14:18:54 -0500
Subject: Re: [PATCH 04/13 v2] o11s: added mesh.h, mesh function and data
	structures definitions
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1203966978.6929.11.camel@localhost> (sfid-20080225_191446_935065_00D100D8)
References: <47be7732.20588c0a.0360.ffff8f1c@mx.google.com>
	 (sfid-20080222_071816_353396_9A4A9995)  <1203697425.7082.70.camel@johannes.berg>
	 <1203966978.6929.11.camel@localhost> (sfid-20080225_191446_935065_00D100D8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-L0aflKV/3MLJKazva3ov"
Date: Mon, 25 Feb 2008 20:18:44 +0100
Message-Id: <1203967124.13162.131.camel@johannes.berg> (sfid-20080225_191858_769138_D9250125)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-L0aflKV/3MLJKazva3ov
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-02-25 at 11:16 -0800, Luis Carlos Cobo wrote:
> On Fri, 2008-02-22 at 17:23 +0100, Johannes Berg wrote:
> > I don't think I fully understand that. The mesh path points to a sta
> > structure, so when that sta is removed, the corresponding mesh path mus=
t
> > also be deleted. I think I need to look closer at where that is done to
> > understand how it could be substituted.
>=20
> In sta_info_free() we call mesh_plink_deactivate(sta), which calls
> mesh_path_flush_by_nexthop(). There is where you could substitute the
> mesh path (copy it with next_hop pointing to NULL, substitute pointer,
> rcu_synchronize()). However there is not much to gain. Since mesh paths
> are freed if inactive sooner than mesh peer links are, this will
> actually only happen when mesh peer links are either deleted from user
> land or because a specific "peer link close" frame is received.

Yup. I think I understand it now, but I had to add a "force" parameter
there so that the path is actually completely removed when a STA info is
destroyed.

johannes

--=-L0aflKV/3MLJKazva3ov
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8MUk6Vg1VMiehFYAQLnvA//eViQlzfqY7hWW7AlzYNUD3UgIT0dW1Pc
jbCT4/Z8VquHQAjCzFxBh1Q+imVPJBlfjjVZs6fvYCl2TLACVQaiBbzLJhavfu77
nV68lUSDTHrP2Q/1uRbC64K9H5n5q1+ES4teSuODdRnZTNTURZZAgg0B9ElDu0BJ
k7cq4DoHjA+WNfLsLXi13bSL+wXXKs9l+BUZ3mFVckIrRqenEQYd039ffnNRiy21
l0qKSbk/xpz90IiYyLnnXoXGVrUul0LvFcqw3iUHBLW26enQ4IWH32vPVoBFK16A
yiigTcrdWCGS8IMjvbnuZngWoGrtWDmbsTp33402PFLEvttoi+7oUm23/oHLPGYX
mTnjPHsLegvK/GENAcnfaWjagIa5ub6HnIbtK7Y76MYtiSuQzGnT4NnglBgBB6dK
xPLt3W4+hTH06XCbQcKwXsOafZRYOfmdhAHD+RWLiCQ5dNoVea9Mr8E52mwENS9Q
hEf576VO0G9BMrdRHXLMKZIRJ2Z2LFWxDCv87zd3uq2CEfw8H03spy9jx5AL7L1o
zCAJt6rOyNsPGMkHTmeojLm2IyLZCkduRhDrv4RtazgTrkfPsCrLvKOcLXbF+SzX
ypd1+ue1ToI0BEukQJxi/j4tpMKMyDSmmOvycHzzqdCiDY0zf01IVIbiRKEiOYHO
WmNdWkz3t1E=
=VEPK
-----END PGP SIGNATURE-----

--=-L0aflKV/3MLJKazva3ov--

