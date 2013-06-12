Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40726 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab3FLGnC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 02:43:02 -0400
Message-ID: <1371019363.8601.6.camel@jlt4.sipsolutions.net> (sfid-20130612_084307_095664_EEF5FB16)
Subject: pull-request: mac80211 2013-06-12
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 12 Jun 2013 08:42:43 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-r7TYLuV3+2fXxx3AgfFP"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-r7TYLuV3+2fXxx3AgfFP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Following davem's complaint about my patch, here's a new pull request
w/o the patch he was complaining about, but instead with an ugly void*
cast to suppress the compiler warning.

I have a fix for radar detection, one for rate control and a workaround
for broken HT APs which is a regression fix because we didn't rely on
them to be correct before.

johannes


The following changes since commit ac20976dcaeea3e77e40e9aac8f3799d2a22ea2b=
:

  mac80211: Allow single vif mac address change with addr_mask (2013-05-27 =
11:26:48 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to be0d678f67ce75ad7099d067e0de6c72f61db27f:

  mac80211: Fix rate control mask matching call (2013-06-12 08:37:36 +0200)

----------------------------------------------------------------
Johannes Berg (1):
      mac80211: work around broken APs not including HT info

Simon Wunderlich (2):
      mac80211: abort CAC in stop_ap()
      mac80211: Fix rate control mask matching call

 net/mac80211/cfg.c  |  6 ++++
 net/mac80211/mlme.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++-=
----
 net/mac80211/rate.c |  2 +-
 3 files changed, 87 insertions(+), 8 deletions(-)


--=-r7TYLuV3+2fXxx3AgfFP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRuBhjAAoJEDBSmw7B7bqr/3AP/AhPOPrSkcjBGQmLdsiF879D
TFFp05DnT1sLWBW+7U6TSmNACgDeyp1/AFEAJGc0YenEM4dSer+oplLcnz6xHM46
GE0TV0KHyXp93RLWCk0Diq+UDyWuo0IEMKBb9wAuTmMsQ6qEue0zCwvChR4JucvT
i8mRahYUpinckiDDX8NzjK/oGsJntgeCGopBrph2JwCUly5UttrmV1m6ATETibOi
pRQE16qLIl6GUBjA9+OZcZJ9/pVUTAnu7EwdgF7xpGf3N9Xql7xD0fvwLI0cVnCW
h0ShhMWWLbrtW0EJGJkOmkeScw0YwCLOKogcaEnKalti3spzQur5WFdwUs7yd3sd
RuIIes5ha06uHnAKH+B9Bvhet+kU6C/wEVlK3U3Arj0+3X2SiuezYcgQQRlarSRs
t8ig8eYfGUAJIA/HArnKYjPcg5zI/N9h8ciKxb4daoZb0RtzfBZspfMrM7FR+4Dw
aafHy3nyHvIceQcSmVYTbl5g4/WlcGUd/BeCFtdqqWA3zdRg9gKuHMqPArWYfIml
SWvn2fv7vk8iIfViB1jBrJ5SGcQGl5rKANDNONf97SrHRODA/PgAWDv+cbH+EvC4
Jdhh5O8FwiMdr7l1vgWzdTG21ahDjDrhYzT5kKxTjkzFdNDctPyEyiTLyMVgUSFt
aXrOtJzTw6riDq96O7j9
=E+LA
-----END PGP SIGNATURE-----

--=-r7TYLuV3+2fXxx3AgfFP--

