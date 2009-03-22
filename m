Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56877 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbZCVI22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 04:28:28 -0400
Subject: Re: Japan regulations
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@atheros.com>
In-Reply-To: <43e72e890903211246r5e5aa2cev7ad3e790716966ed@mail.gmail.com> (sfid-20090321_204624_299605_151B529C)
References: <1237646363.5100.209.camel@johannes.local>
	 <43e72e890903211246r5e5aa2cev7ad3e790716966ed@mail.gmail.com>
	 (sfid-20090321_204624_299605_151B529C)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-o2a68+4O0DrOBBt823Px"
Date: Sun, 22 Mar 2009 09:28:23 +0100
Message-Id: <1237710503.5100.731.camel@johannes.local> (sfid-20090322_092850_201321_2AAFC901)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-o2a68+4O0DrOBBt823Px
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-21 at 12:46 -0700, Luis R. Rodriguez wrote:

> > country JP:
> >        (2402.000 - 2472.000 @ 40.000), (N/A, 20.00)
> >        (2457.000 - 2482.000 @ 20.000), (N/A, 20.00)
> >        (2474.000 - 2494.000 @ 20.000), (N/A, 20.00), NO-OFDM

> > Also, how
> > should the 2.4GHz part be interpreted?
>=20
> Channels 1-11 allow 40 width channels, so HT40 is allowed.
> Channels 12, 13 only allow 20 MHz width channels, so HT40 is disallowed.
> Channel 14 only allows OFDM.

s/OFDM/non-OFDM/

Ok, this is a bit of a problem. Let me break out of this thread and
propose new, slightly changed, interpretation rules.

> > Currently we are not interpreting overlapping ranges properly at all --
> > we really need to fix a set of interpretation rules.
>=20
> Sort of, we currently stick to the first reg rule which fits our
> desired bandwidth. Right now we iterate through 2 possible max
> bandwidths -- 40 and 20 and then set the channel max bandwidth based
> on which one fits. Note though that we do disregard the freq_range max
> bandwidth, which my patches correct.

True. I'm rather keen on removing that code though -- it is rather
confusing to hardcode 20/40 in there and try them.

> We also need to consider for future usage custom bandwidths, which I
> guess why we had the first JP rule for 4 GHz (but yeah the second rule
> seem to imply what the first one intends on allowing). First step
> might be to say allow drivers to use monitor mode with 10 MHz
> bandwidth or 5 MHz bandwidth. That of course would also need further
> work other than regulatory.

Indeed. The question is how we want to capture this. So far I was always
thinking that we would capture this as an extra channel type -- like
HT40+, but going the other direction -- "10MHZ"/"5MHZ".

johannes

--=-o2a68+4O0DrOBBt823Px
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxfahAAoJEKVg1VMiehFYHBkQAL6Tz/FhMWhSukRe1kYuJZi/
LFuSuENweX/Wrkr9YPkJqSyW3XxTW6VYvXiS2Lw6K5ZhNnDKoHclJPwX/xRh34ep
atw8q2anhZTICCPgUOZRnrZidySwTb7Sz2BiBzkcxj5vXUa0GoD0pZXPmQcW/Ix3
6cZRkB5/YsHT/9lWZDuVZHV1EgJv3MejMu6inW/QzQaoUlt+y+H2mWxfcDhSLzYd
ZyC0foOKOLH0KtIDH/qXdMAwrBPVrrdVwWlk3TFk1Wq5+6FD7ZgLSHBB8DFImbiN
SODkAT97PWkMrVjwHPdfmfQ1/gEnD6+bp5JTyZ1diH4KMD7ndaVGKLtaQC4smVR/
Ap+bjcAPATXtTBsmfwPez1rtVp/BfGnLImH9envhvR/h4L/2RUsLj6rx8Vq8eqzg
WEc2DcXFHOfbEvPZo5s3HBDJdZfsoSi31uftx8FdenNVFSw8N4C6/peMuEWVXafl
X+rwO6BKGXbMojOnaoEJcIQfmrppIYU5Ns2urdWf9n6gle/dAP8kGFLbTeH5WWEe
3LAukld9RvtiCy/9I3FYPqfGFiS0hozxLbDmId/ef5LF7SuYShNxSv8eETfewJh3
4KtoJWDYsGy9/ccjh+2jzd531mJA6V41noUk4AUgXOaLOMZjugkT1VEZB/uyhvw+
m4fe4/HqQv21zQtNk7mC
=PnUn
-----END PGP SIGNATURE-----

--=-o2a68+4O0DrOBBt823Px--

