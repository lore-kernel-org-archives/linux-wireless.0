Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48523 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbYA3Pwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2008 10:52:41 -0500
Subject: should we revert the cfg80211 API patches?
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Michael Buesch <mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mbd02Bgcih0XHDo6ZdxG"
Date: Wed, 30 Jan 2008 16:52:31 +0100
Message-Id: <1201708352.4149.21.camel@johannes.berg> (sfid-20080130_155245_303200_605C2E05)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mbd02Bgcih0XHDo6ZdxG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

John,

It appears that there's more trouble caused by my cfg80211 band API
patch than people are willing to put up with. Tomas has already asked
for it to be reverted, and neither Michael (Buesch) nor Stefano want to
maintain two driver branches (one "stable" 2.6.25 branch and one
"development" "for the future" branch).

FWIW, I support your decision to not push this particular patch for
2.6.25, it really doesn't fall into the "tested well enough to merge
during merge window" category.

Additionally, since Michael Wu has (privately) announced to stop working
on wireless, a number of drivers are effectively unmaintained now and
I'm not sure I can quickly fix the breakage that my patch probably
caused in those drivers, especially since Michael Wu is the only
developer with access to all that hardware.

To ease the short term pain, we can remove/revert the commits in
question (those being 51c4c94e89a2042e8b20d640b49b6b605d71420d,
6854a5291cce341751a7e2e195cc3e97d95afeec and
d0776155b288c20cc936bfd87d9a76255f244ed8).

Maybe I should have waited longer or posted the patches earlier. I
didn't post them earlier because I had not wanted to disrupt Intel's
iwlwifi work too much knowing that there were patches, and then those
patches caused bad breakage with my patch so I had to wait for another
Intel patchset fixing a number of bugs they introduced... I'll admit
that timing was horrible.

But, I'll be frank, if the patches are removed/revert I probably won't
continue maintaining them. I can't do much with these patches but
continually forward port them on top of new driver changes which is
boring and useless work. Experience has shown that hardly anybody but me
[1] actually tests my patches until I push them into your tree, so
continuing to forward port these patches won't actually help them become
better but can only make sure they don't completely bitrot into
oblivion.

The only way forward I see if these patches are reverted is that we
announce with the reversion that we'll merge them again in N weeks (with
N being a reasonably small number, say 4-6) and until then people can
test the patches and send me driver updates that I'll incorporate. But I
don't see how useful that is vs. just leaving the patches in place and
you managing the required driver updates.

johannes

[1] the only other people who test it seem to be mostly clueless people
who want to get AP mode working and then ask me stupid questions in
private... there are exceptions of course

--=-mbd02Bgcih0XHDo6ZdxG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6CdPqVg1VMiehFYAQIt4w/9HZeDZvONJUvTCpPuXDprilqh1ZTSC9T/
ymtxwuQ1JEvP7L0S0u/09SvToW8YINurVSxHhN4Jo7DOZWwlS46mPXywGvRdqNEc
yqpKQSxywPe2ocYXU0w4l0bPNB1rJgx2ABw9eGKyFKxodLpfRcCzENBX9SFU+sJV
Q/1GqKFQmDeqElQ7cuvWM23l8+0rJOVuchU3kmh+d4sfiv1LICTtFCytsC+ZRBZL
LgNGcGJ4fgAf085dy/f9/pq4s8goMkE3UZ3l/F+BcmO4eUs5QL4GIAiDuDn4LIsM
AmgloKQoGIl0kijZ4SesEf294JnkCi0zSE4obzXvShaQEm8xGJIr7LwaAmxIUxjx
O6tCEWeAE7kwVeDUcBB5o0mxa5V4MMS5VZekdvTLPyJZT/zBadIs/JDK0+YUrmtl
A/ESNGNHIrdmTRDhLGPf7baLxRkAccHsxF9p2QrXjPpYQL0VwpbqIe169Pv3BdEF
gXqHLemAHHXU5GMiDWj4mkMLsNwt9GdFnP3OllGFzfOyFhOeY0p8rpxiHaGhlzmZ
Us282weFcS3cxLFxAVzTqd34t8TopFWmMKD2w8UxLnaIiPjueLX6gb9h4+fz7cSm
Mm2wJkYcyRAgf53nTtp+05znuq9SCNH2pcAAcR776lxetHakisuBCYzjE0vBPwHd
EbhQUU0he6Y=
=OGI5
-----END PGP SIGNATURE-----

--=-mbd02Bgcih0XHDo6ZdxG--

