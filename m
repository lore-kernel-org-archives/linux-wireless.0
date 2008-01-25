Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42289 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbYAYM3t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 07:29:49 -0500
Subject: Re: Linux 2.6.24-rc7
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
In-Reply-To: <alpine.LFD.1.00.0801241334010.7482@hp.linux-foundation.org> (sfid-20080124_213551_947160_3434D67B)
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
	 <200801071830.51895.mb@bu3sch.de> <20080107212344.1372cc47@Varda>
	 <200801081630.31110.mb@bu3sch.de>
	 <alpine.LFD.1.00.0801241224050.2803@woody.linux-foundation.org>
	 <20080124210728.GD3200@tuxdriver.com>
	 <alpine.LFD.1.00.0801241334010.7482@hp.linux-foundation.org>
	 (sfid-20080124_213551_947160_3434D67B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+fOKFHJPpAlNmH6mD0pw"
Date: Fri, 25 Jan 2008 13:29:26 +0100
Message-Id: <1201264166.12870.16.camel@johannes.berg> (sfid-20080125_122953_456056_0DE198A7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+fOKFHJPpAlNmH6mD0pw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-01-24 at 13:34 -0800, Linus Torvalds wrote:
>=20
> On Thu, 24 Jan 2008, John W. Linville wrote:
> >=20
> > There is no great harm in reverting
> > 81100eb80add328c4d2a377326f15aa0e7236398 if you would like to go ahead
> > and push the 2.6.24 release.  I suspect, however, that the mac80211
> > guys would like to keep it (or put it back for 2.6.25) to continue
> > to shame driver developers in the future.
>=20
> I'd be happy to have it back in the development tree, I just don't want t=
o=20
> have the noise for a release tree.

I guess I should speak up, having added that warning :)

We had a huge discussion a while ago concerning alignment of packets
when somebody noticed that on sparc64 the zd1211rw driver was causing
alignment faults in the IP stack.

During the discussion, I noticed that hardly anybody of the wireless
driver developers knew about the alignment constraints and so I added
this warning to make people aware of when they would run into problems
on platforms like sparc and arm that can't do unaligned loads (or only
with extreme penalties).

I had myself been considering to revert this patch for the .24 release
as you've done now, so I definitely don't have a problem with that. All
drivers except the Intel ones have been fixed, and they are in the
luxurious position to be able to fix their firmware. I can see that
might take a while longer than posting a quick fix and honestly I had
hoped they'd post a quick fix so their hardware is usable on platforms
like arm/sparc that can't do unaligned loads, no such luck, however.

Please revert the revert after .24 though, there are quite a few
alignment constraints and we'd like to check them automatically. Also,
with 11n there is yet another constraint and John has just merged a
patch from me that checks for those constraints as well.

Since the only problematic driver is Intel's, they really should be able
to get their act together for .25 and fix their firmware, if not then
we'll have to think of something else like making their drivers
memmove() the packets to the right place.

johannes

--=-+fOKFHJPpAlNmH6mD0pw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR5nWJaVg1VMiehFYAQJXKhAAvAutB46Nc7YPSsCqKT1oU5cMLpQZQ8Th
vkNVsSEoBdSC6tR/6WGGkSWEqWIPQLLJv8VNUsAeAb6xssrB50Zei4ljhtw3XBke
99ZuUa+QfrMVuZduitm030AT7v/fzNPizuSdGitJL1x86OgWGVIYpuFhPKpa6W0L
3T8uX46COIUIgNbV/IPBG08UclOSfU8CfaVd43/q5GqPHhdnfVZt1lojAcF3Wx6U
JSmuxYhI9nnilq+MHWNdwiZ/7/PaVHsWlDOql0lt6Cagf7+dvJvsTWWuuoLIUE9f
sX9CGFvez1slXZkK/E7WYZYRqRadE+/BXhP4ncbUg80b+dGcfRFcrIcUFxxSFZvN
LQmC7lLfyKnJQkhT3mqxBBP0dXPuge5Yx67e9SzZShKyS+KiNl8atvW/dsfffLMk
yBZZBFEI6fYWnU/U9qsEuVej+HqnuVXNQBTUIj2C4ZcJXX2oB23RxC4hkZXC9wXn
8avAJoJrec1DDr3FmYNNS053uuq8JN9ZxdteUw3abubzRujauUgRl4NU86RHGyCY
TBdZj3LkFZMQ75U7tjV6KGw398FKuLS349R7lAzeMDm14G8Jwj2t/LCi69jXwFuD
kCW5rWAqJYBd7sJpk3LbT5x0ie0IWjyyRMFdCiCv3YiUc73lAVsAhHovBPzydOU7
HzWeynpjGhs=
=v/QI
-----END PGP SIGNATURE-----

--=-+fOKFHJPpAlNmH6mD0pw--

