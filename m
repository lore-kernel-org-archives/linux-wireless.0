Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45353 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436AbXJRS4A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2007 14:56:00 -0400
Subject: Re: [PATCH 1/1] mac80211: adding bss_config to low driver ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240710181146t111bd63ek97cf0c102d17369@mail.gmail.com> (sfid-20071018_194612_884567_BC7A460B)
References: <11926651061687-git-send-email-tomas.winkler@intel.com>
	 <1192726084.15285.31.camel@johannes.berg>
	 <1ba2fa240710181146t111bd63ek97cf0c102d17369@mail.gmail.com>
	 (sfid-20071018_194612_884567_BC7A460B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TAZ9vpiHkOmim8NjcB6P"
Date: Thu, 18 Oct 2007 20:57:07 +0200
Message-Id: <1192733827.15285.39.camel@johannes.berg> (sfid-20071018_195605_274405_484C1032)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TAZ9vpiHkOmim8NjcB6P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-10-18 at 20:46 +0200, Tomas Winkler wrote:

> > /**
> >  * DOC: BSS Status changes
> >  *
> >  * Describe what is expected of driver here
> >  */
> >
>=20
> We'll do

Thanks. One of these days I'll get all the kernel-doc stuff sorted out
and actually post the mac80211 book for inclusion.

> > This seems pretty ad-hoc to me. I think it'd be better to have them all
> > in one structure and use just a single 'changed' parameter instead of
> > having an extra one in the erp info. I would also use a 'flags'
> > parameter instead of 'assoc' and then roll CTS protect and short
> > preamble into those flags.
> >
> The bits in flags are possible just sometimes you need to pass a value
> such as assoc id
> or queue num so it will be a little mess.

Oh right. I guess we need good docs as to which "changed" flag implies
which fields have actually changed since things like "assocation status
changed" implies that the AID is new *and* the "associated" flag is
changed too. On the other hand, maybe we should aim for some redundancy
and have a changed flag for each struct member and each flag?

Hmm. Thinking about this a bit more, the AID can actually change when
the association status didn't change, in the case where we associated to
another AP. Though we actually tell the driver that we disassociated
first, right? That makes me think we should maybe also make the BSSID
part of this call structure instead of having it in if_conf. Hmm.

> Yes we can have both valid and change bitmap to lower that burden from
> form driver.

Note that embedding the info might be a lot of work. Then again it might
just be some code shuffling and simplification. I haven't looked at it,
from the stuff I see here I just think it'd be worth it. Your tradeoffs
are probably different than mine though and in either case such a
callback is an improvement over current behaviour.

johannes

--=-TAZ9vpiHkOmim8NjcB6P
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARxesgqVg1VMiehFYAQIQKg/+Oan7GYG4evJ3ctVDsB2GI5bAQ6FFyeP1
O2C3g3OiB+P6irhpOuP96PEKHydA6cI/cLoS7nCXuN8aNi15Y03HvDGT1YkvTp2e
Of7v5Sz5FYCgvYXBmmFbau2DT9iulV3/w+26itL5FcdCyAylF48LkKCUYkG3bwzm
MHjmfTnM/cnXyMY/x8D/gQr1wtNw3AvXeArEQ+JlcAR+S9RPPrUVV0W6+3eSJkAB
6WRPmrEX3wy7l+0RYgybiHCS+CpOTtf1Cnw3nzMAOeZ61Gg50YAWrR1tPqc+G1sl
ADPqGtpgrlknWIEwdl+MA2FSug9dylDQeohaPP3eUnlXDW0sJimUxIjfwQwgMw6w
ZC97rn3uhQgpIGkY4qj/Yt9UcuCLnaSrgj0Kcnx/aOy6foTGaTOsSkP8QvFg+c0s
kxXuBt8X0Ojs96Rv2fDehKYPs1dvR+dYP5IrZKWeEyogSLEBu6BsJf/BEJCvuN8k
94HhWhjbTJ1Gqb1OnNXBCUm38us+f8ntPMv0BCo16MWwOhNtJCXuIb5rcqe9YUnF
kV/D8nhTRPecgEDU2n6M4nSD6xgxkr9XCkL3HTZ56pNbVdvPE0NTAhRJB8Fg+Lsm
m8m+EfDPFG9rsnqGwe+NtSCbt+GIQaBUlvjAH0qAVOPt/2erwIZN+3CuecxdiE2o
m+AkDqeTikQ=
=zOmI
-----END PGP SIGNATURE-----

--=-TAZ9vpiHkOmim8NjcB6P--

