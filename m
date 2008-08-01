Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42148 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbYHAMJX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 08:09:23 -0400
Subject: Re: iwlwifi aggregation info
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Friedrich.Beckmann@infineon.com, linux-wireless@vger.kernel.org,
	j@w1.fi
In-Reply-To: <1ba2fa240807311216u1a45cf22j219046ab357b0910@mail.gmail.com> (sfid-20080731_211625_713551_7D0F0411)
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217423948.10489.121.camel@johannes.berg>
	 <1ba2fa240807300645j654a82b4rb813b71681dfab71@mail.gmail.com>
	 <1217425854.10489.125.camel@johannes.berg>
	 <1ba2fa240807300659p4d743f31se265f550a2da0dd1@mail.gmail.com>
	 <1217431179.10489.134.camel@johannes.berg>
	 <1ba2fa240807300908x5489e3f8g54ff83e7e5912c0b@mail.gmail.com>
	 <1217509511.10489.140.camel@johannes.berg>
	 <1ba2fa240807311114t3e1b4fb3oe6643fbe28f2c2ac@mail.gmail.com>
	 <1217528597.10489.150.camel@johannes.berg>
	 <1ba2fa240807311216u1a45cf22j219046ab357b0910@mail.gmail.com>
	 (sfid-20080731_211625_713551_7D0F0411)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-M+D4C8CFytMRV/Dnn2DH"
Date: Fri, 01 Aug 2008 14:09:14 +0200
Message-Id: <1217592554.8621.23.camel@johannes.berg> (sfid-20080801_140927_778420_FD9C94E6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-M+D4C8CFytMRV/Dnn2DH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Had to think about this for a bit...

> > Right. Which brings us back to the original point, why does the hw need
> > to make the scheduling decision between agg and non-agg?
>=20
> There is no scheduling between aag and legacy queue in the sense of
> qdisc .

Right. So why are you saying we should have a separate qdisc for it?

> The aggregation need to be taken from single stream as
> explained before,

I think we simply agree on that. Which brings me back to my original
point: to provide fairness within that stream we shouldn't have separate
qdiscs for agg/non-agg parts of the stream.

> Iwlwifi has HW support for it that that's the whole story we just need
> queueing support from the software buffering stopping and starting
> queue and last but not least there is a classification just an
> extension of the regular AC scheduling.  The fairness between legacy
> and agg queue must be provided by actually 'not scheduling'

I don't understand what you mean by "not scheduling". AIUI from the
specs, there is no scheduling between aggregation/non-aggregation
queues, or "within an AC" as I would say it.

Therefore, I think we should remove the extra software queues and split
up the single-AC stream into the different hardware queues in the
driver, to be reunited in the FIFOs.

> If you don't want to experiment but provide QoS by spec the scheduling
> is best to leave to HW.

I don't contend that only the hw is able to make QoS scheduling
decisions, as they depend on air access etc. after all.

johannes

--=-M+D4C8CFytMRV/Dnn2DH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIkvzmAAoJEKVg1VMiehFYT/kQALpHMZUdh0Wm/eUCr8wB/j9C
JTId/+ejQapT3Sg94ylE0Xp+LkzJ+Wwsr2/+B8HxViHPQD8/RhN9n6dLoWTFl6wT
vLRHRSVBoxTBoaC8z5FAHRGf4sFyoRRVf6vZ3lc1NXDMhadWSFjlnqdDOTOnv0Z2
KJtUpq5kuOKAMiTml3srXIrRFbXAVmdvBA1SMD/gYJk+uqZMcOvK0yWLvZIOLat9
JTG2084MNm4+Ii7UvZVlag2UJ1qWLEpivbiPpXph044YXuugbU391IyzuWQA1Yk6
7Z6W7q+XQB7sEObjbm/+3ZNhozBU6dJj8FE2f9piNE/1ObTX59ZOMeiRS1sB8BRH
CHTik5XYslbDij5v+EYmftymT2T6YGZEF0gjOwlHVY26fEgjQea94F63+kn2QHx0
aRmCvoESoOizRc0B+4LtJ0zatUlG2xHdZLdxI+FyngBTtiJzqMsbPmlSEIurI8LP
tIWcC+rtF+1776uYKBFxleSYhBvrurdIPlohA9+7Q6TiTchnxX0sCj768pYCCUDD
GsrEKyhlvlrVF1mCW8sr0Nx1nTJFEmbAIs510/OGPgWXzowkEHJxRY6NfyA1HRcB
/xqLhsjbfjgx10PQc4QCe02jxws7h7q/s6axAxijZkYsRvy6amslY8UQbhUyj+MU
SioVM6s76dSqwjPW7gCf
=M2WE
-----END PGP SIGNATURE-----

--=-M+D4C8CFytMRV/Dnn2DH--

