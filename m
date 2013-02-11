Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42837 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab3BKLEq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 06:04:46 -0500
Message-ID: <1360580674.8738.14.camel@jlt4.sipsolutions.net> (sfid-20130211_120451_892838_B8937FF9)
Subject: pull-request: mac80211 2013-02-11
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 11 Feb 2013 12:04:34 +0100
In-Reply-To: <1360267300.8038.13.camel@jlt4.sipsolutions.net> (sfid-20130207_210125_019256_B62FB536)
References: <1360168561.7910.24.camel@jlt4.sipsolutions.net>
	 (sfid-20130206_173555_899354_0EC3DE1D) <1360267300.8038.13.camel@jlt4.sipsolutions.net>
	 (sfid-20130207_210125_019256_B62FB536)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-jeqQmg1zjoce9e1kL/bV"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jeqQmg1zjoce9e1kL/bV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I feel stupid now, I was testing corner cases and found *another*
bug ... :( So here's a new pull request.

Here are three fixes still for the 3.8 stream, the fix from Cong Ding
for the bad sizeof (Stephen Hemminger had pointed it out before but I'd
promptly forgotten), a mac80211 managed-mode channel context usage fix
where a downgrade would never stop until reaching non-HT and a bug in
the channel determination that could cause invalid channels like HT40+
on channel 11 to be used.

Please pull or let me know of any problems.

johannes

The following changes since commit c49dc9008b1c641a86837297df7c90cef070571b=
:

  cfg80211: off by one in ieee80211_bss() (2013-01-24 15:47:22 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 3d9646d0abd02c552f6f15c302b31aa321c2fa8b:

  mac80211: fix channel selection bug (2013-02-11 11:12:26 +0100)

----------------------------------------------------------------
Cong Ding (1):
      mac80211: fix error in sizeof() usage

Johannes Berg (2):
      mac80211: fix managed mode channel context use
      mac80211: fix channel selection bug

 net/mac80211/cfg.c  |  3 ++-
 net/mac80211/mlme.c | 11 +++++++----
 2 files changed, 9 insertions(+), 5 deletions(-)


--=-jeqQmg1zjoce9e1kL/bV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRGNBCAAoJEDBSmw7B7bqrZu0QAIgwOfX7wh2+Yo17xYyf7Fcm
UYZCBCLYSqaYSrHThOgYXToWNnzof8NFGmIHAr6l03Lepgu8K8uKBRRbyExdvrT8
o/doZcFajPwA7Dog0Xrs1UAGp8exdjedUVT1IbS+lDiGzLs3d5oeozMvkfVV5ecx
hcRa05MCKtym+O9n5ZGl2STc51dhscXmBxRQzUUic1DZjYUofMpKs2VCqPbyktEU
iVY7HGZOjsi4ykLS+9zx/qtMCeghqxq+1grOUhmrf4A3ruNt7l5ALZUzm927wJLg
AECRIKteMEd3p3qwus3uF4IxA/ru+fhr72+rRbpNdjnDAlSvOVyPSGtsqGCvhniy
ALX/R9mKIEmRNGC+36TJueT1gcEpPhQgQSOvKFIDSFfFOWcDywrIm1JgWQGCwTo9
Od6KFFbYM/qQyEvgXnUFnAB/5CXKzkTGS3bhyPF3vnnh8piXdIGFVs6Ayq4Rttan
RW+/oQbjK9MibIYm4ULHesnPXGL/FvUdn3+aT2XOphWT6bZrjmpDOGwrCEtxwYdq
QUyIul0FKtCQ+FPNvSNsNVQgnowqLmOiyqk2qLOz/d0OjEuHxtoophc4zYIuexUq
LIJKW2Xvpnt28DMzdO2WxIC9wB+S1itiNEy+Cr67/mOBvGaFAznAlxKvqosnSIZq
/gO/i3o7/euzqBOymJo/
=Pcr5
-----END PGP SIGNATURE-----

--=-jeqQmg1zjoce9e1kL/bV--

