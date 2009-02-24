Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46780 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbZBXHO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 02:14:29 -0500
Subject: Re: Signal quality strange since commit 708c57cf1709fb95
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kalle.valo@iki.fi>, Dan Williams <dcbw@redhat.com>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <49A39C9C.7040002@lwfinger.net>
References: <49A01922.1090106@lwfinger.net>
	 <1235241867.3284.44.camel@localhost> <49A05E35.70904@lwfinger.net>
	 <8763j33rgq.fsf@litku.valot.fi>
	 (sfid-20090222_074023_562332_D346678B) <1235441441.4455.58.camel@johannes.local>
	 <49A37531.70907@lwfinger.net> <1235452576.4455.81.camel@johannes.local>
	 <49A39C9C.7040002@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rlOx2F+0FsvVUyDTb91B"
Date: Mon, 23 Feb 2009 23:13:46 -0800
Message-Id: <1235459626.4320.3.camel@johannes.local> (sfid-20090224_081432_459157_E571CC87)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rlOx2F+0FsvVUyDTb91B
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-02-24 at 01:07 -0600, Larry Finger wrote:
> Johannes Berg wrote:
> > On Mon, 2009-02-23 at 22:18 -0600, Larry Finger wrote:
> >=20
> >> No, I just wondered if it was intentional that it was changed to /70. =
It appears
> >> that it was, therefore, at least 3 drivers must be changed as they are
> >> calculating on the basis of /100. For example, my b43 is showing an iw=
config
> >> Link Quality of 93/70 while the KNM applet is showing 50%.
> >=20
> > Well that _is_ a bug, since this shouldn't have required driver changes=
!
> > I'll take a look into why that might be happening.
>=20
> Drivers b43, b43legacy, rtl8187, and p54usb all assume a Link Quality sca=
led to
> 100, which was the behavior before the commit in the subject. I don't qui=
te
> understand why as the old code had this fragment:

Ahh. I see now, you're talking wireless_stats and I'm thinking scan
results. Yeah, I see what's going on, I'll fix it tomorrow.

johannes

--=-rlOx2F+0FsvVUyDTb91B
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo54nAAoJEKVg1VMiehFYyT4QAJ46rPPmVAZuPXeayUEnRy/H
wDP0s2IN95/9dLjm2/A+K6tMVBJgijaaCyWBZ+g0+rkSAjWMGKED4sQEt8aRe8Fz
qR4ZsbgOP8MRWkUrEfkrbDAuhccOcE62HPm9iC/Dmg02DimtYCC66jvZuM24LMcO
qow5dWXZVNHmMVUQdldFbwnFi+geTAapK9E0i+nNLM/ZMY1qzpakKxYiF5Qy9Ovp
KhLAj3JRs393Akh6um7+B46rLC3mtruimc8GmkVGFl7U9jBEugYqpK/1M8jhTjL5
4y95CPulJ30tLEHKz+hg2Jl8ZnRVysg96qJBNmnLTGSVm4536c7EB1F1n0n/G2JU
nYXAytKGLnUaNJG/TbMvSfS2c7FE9SBbPQla7cKYfCeRIzMynJ0/xR6v7Pl5v2M3
PD0FgITtE2pDr7p9AvFfE7qB62szuidQKSGsLQ63Pa6lWDn9Lm63WFUtsxsa1nzJ
0/wfS3ndrlFGJAB5/wWbjihnykjMgCr7g5OLFUhBVv3f+0LDO8e9GZTq82HMhI+Q
3LIdvnronA6ss6mKRvyZ2df71nNdn0tT8fdFJIDJdphS/5AUYS8s6zk5moRzpsV5
U7SE/6506lIPbxSAjj+FYsAqJZr0TI1Fjr7gg8kDbUl80mxkYccHuJcM5PCdRg3T
sYsIRJtU0cHhTxKssveK
=GWfq
-----END PGP SIGNATURE-----

--=-rlOx2F+0FsvVUyDTb91B--

