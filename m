Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:32799 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbYALKPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2008 05:15:17 -0500
Subject: Re: channel utilisation short/long hdr?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <20080112024400.GC12245@jm.kir.nu>
References: <1199922658.3861.40.camel@johannes.berg>
	 <20080112024400.GC12245@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3eBLVJbIIV5jWaWCWLh9"
Date: Sat, 12 Jan 2008 11:15:00 +0100
Message-Id: <1200132900.3528.22.camel@johannes.berg> (sfid-20080112_101527_157595_21B1F386)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3eBLVJbIIV5jWaWCWLh9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Hmm.. I thought I had filtered out the channel use estimation code from
> the original release since I did not see much use for this and the
> values were not exactly valid in many cases.. ;-).=20

Heh.

> This code is almost five years old and maybe not so surprisingly, I
> don't remember the exact details anymore.. Since these are use as
> "hdrtime", I would assume they were derived using following calculation:

Right. Thanks for the values, I guess that if we really wanted to keep
that stuff maintainable we should rewrite it and take into account
preamble length too etc. I'm not too keen on that though, would anybody
object if we'd just kill it?

> That would be any rate using Extended Rate PHY (ERP; 802.11 Clause 19).
> This is not necessarily OFDM (it could also be using PBCC modulation).
> In practice, I would expect the kernel side implementation to use this
> in anything PHY related as ERP-OFDM (i.e., it may not support optional
> PBCC rates). The association and beacon/probe processing may be more
> generic to any ERP rate. I don't think ERP-PBCC is very commonly used,
> so this may be more on the theoretical side..

Oh, right, I keep forgetting about the optional rates.

Thanks,
johannes

--=-3eBLVJbIIV5jWaWCWLh9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4iTI6Vg1VMiehFYAQIZkxAAgK9qBrFFARvNzXS6a15XxUALGZohfeWm
UiZxVEzjNQNPLPx7OM1DjzdUSMyWHOOTJ+4fMqdWMlrjGojHS0Js7IElHY3ORfqk
kJ95P2BmseUMVhMrSPI03/FpJz4l39U+ea3N+CG3I8HLstxTrUee2Fneb0zkqiWP
1MxUVyHSoWs03T23/aOMpcC9vYMhiRpiN0vxMY1mNddGET3oLG8aLHu6M1My/C+W
wZZl2pvdO0nrQN13sjKJJH1I55o3LnMHw5nG+IX3diHoUfv2mIxve/KnsDd8ncrF
oK3Z7zzWTqIRq9KdXFE0wz/2tTBpbm59TQKVqSyHjPQrBw07PvaO1sq3sqUt11hz
8a5tZ7UMViYw5T/eaKT1uJgQXoa5jn61g2VSz6ECBNQY30hqmCO+80Tm/FAomKFw
9nCPXqa0oQgLPFa78HM6ADaWWctznkuUoYZWxsgbLltYur8i1h9QxuDCCQ9K2vET
7N1zmMDJ+2+81HGM8Z4Ml2QTJYyaYq+Zt2gkO2z3r8flt5VRLvN/9B4EqTvladxy
1J/M1d1jhMk8/tSQVaaQ10N9JO4iLdv+137zIAIm5ZUPrnPM/aecDvLbgZ1hm1Qb
l6x7BRopBVwWP2plh83m64iWifunhD/KpCsAaSW1wI6LBIBWdW197GmEulNcLnvh
s2V6U/BJ8yw=
=RG8K
-----END PGP SIGNATURE-----

--=-3eBLVJbIIV5jWaWCWLh9--

