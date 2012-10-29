Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37338 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab2J2Jc7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 05:32:59 -0400
Message-ID: <1351503210.10925.23.camel@jlt4.sipsolutions.net> (sfid-20121029_103303_251955_9F9F497D)
Subject: pull-request: mac80211 2012-10-29
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 29 Oct 2012 10:33:30 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-xZgUV6j1UMSNc6ASG8th"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xZgUV6j1UMSNc6ASG8th
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please pull my mac80211.git tree per below to get a number of fixes. I
have included a patch from Antonio to fix a memcpy overrun, Felix's
patches for the antenna gain/tx power issues, a few mesh-related fixes
from Javier for mac80211 and my own patches to not access data that
might not be present in an skb at all as well as a patch (the duplicate
IE check one) to make mac80211 forward-compatible with potential future
spec extensions that use the same IE multiple times.

It's a bit bigger than I'd like maybe, but I think all of these are
worthwhile fixes at this point.

Thanks,
johannes


The following changes since commit 3a40414f826a8f1096d9b94c4a53ef91b25ba28d=
:

  mac80211: connect with HT20 if HT40 is not permitted (2012-10-17 13:46:38=
 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 6dbda2d00d466225f9db1dc695ff852443f28832:

  mac80211: make sure data is accessible in EAPOL check (2012-10-26 22:52:4=
2 +0200)

----------------------------------------------------------------
Antonio Quartulli (1):
      mac80211: fix SSID copy on IBSS JOIN

Felix Fietkau (2):
      cfg80211: fix antenna gain handling
      cfg80211: fix initialization of chan->max_reg_power

Javier Cardona (3):
      mac80211: Only process mesh config header on frames that RA_MATCH
      mac80211: Don't drop frames received with mesh ttl =3D=3D 1
      mac80211: don't inspect Sequence Control field on control frames

Johannes Berg (5):
      mac80211: use blacklist for duplicate IE check
      wireless: drop invalid mesh address extension frames
      mac80211: check management frame header length
      mac80211: verify that skb data is present
      mac80211: make sure data is accessible in EAPOL check

 include/net/cfg80211.h |    9 ++++++
 net/mac80211/ibss.c    |    2 +-
 net/mac80211/rx.c      |   74 ++++++++++++++++++++++++++++++++++++--------=
----
 net/mac80211/util.c    |   42 ++++++++++++++++++++++-----
 net/wireless/core.c    |    3 +-
 net/wireless/reg.c     |    5 ++--
 net/wireless/util.c    |   14 +++++----
 7 files changed, 113 insertions(+), 36 deletions(-)


--=-xZgUV6j1UMSNc6ASG8th
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQjk1qAAoJEDBSmw7B7bqrBDYP/iw0QN+SERwBd1NZyJgYVsK9
4H8ETcKfLu0KOeE/ZZYZZ8TogFgogtl73aoFCxbA2hjUVgvhtZCSPGw2caLJ71EH
ZevVBf/FqbG1ath9nbVVD17ag08Ts8JuTH4vTkgdEFbGITbme1XsthInIB+4U3UT
vNgvHUJ531/hkXK0b6J7kZiu6LDKxi92BEt4UoqCOTJpCZXmPuPnz6uvoSZWGtHA
ZajWPKgZl3wChTUxrYC4T1XSROs77rD/rHqDVAmDdZ4KKikQB9FfpSU41r+CKM/Y
PTpn9e8BRjd70K4nbPhbQI8aNnKpNEZkB1/hhGM3CFGR7fckB3zbvy/GFv7V+cUY
mmxQsw0RZSz6nnyRkH05eyA10JvgQeVar8U6UpUMyog9nft8iqe4ZHc9HoiuDQ6K
WxCsm9nQs7R+YgbwS9ayT/ktO/HjlaOz3h7XLGzQnyYIQon7aHTn1VYXAAJ/hafe
X3kp7c76R5hch30i6c66fhnicF61egxA/0TemVzUaLddwPLmeQ6TxCnZQGoUZGyk
qdiEHKKSBGr3FxQ2JJbOxKYSGluw9gyWxEk8ldlc2BkGqhvYsc5eCHoXRtGBCrND
op0A+cHrrSRXTQEJfb9oMjbTs/Hhh7ns0/3DBE61YslNql9+IDzr5p05hKY8NziA
zW3VsyydoN4jiwFP9+eP
=u1rE
-----END PGP SIGNATURE-----

--=-xZgUV6j1UMSNc6ASG8th--

