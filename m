Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40853 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab3FLHPC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 03:15:02 -0400
Message-ID: <1371021295.8601.8.camel@jlt4.sipsolutions.net> (sfid-20130612_091527_537692_57BE4962)
Subject: Re: pull-request: mac80211 2013-06-12
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 12 Jun 2013 09:14:55 +0200
In-Reply-To: <1371019363.8601.6.camel@jlt4.sipsolutions.net> (sfid-20130612_084307_095664_EEF5FB16)
References: <1371019363.8601.6.camel@jlt4.sipsolutions.net>
	 (sfid-20130612_084307_095664_EEF5FB16)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-5zNV2ZMz4CjaxYv/n4RB"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5zNV2ZMz4CjaxYv/n4RB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Let's try that again :-)

Following davem's complaint about my patch, here's a new pull request
w/o the patch he was complaining about, but instead with the const fix
rolled into the fix.

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

for you to fetch changes up to 795d855d56c6d172f50a974f603ba923ac93ee76:

  mac80211: Fix rate control mask matching call (2013-06-12 09:12:43 +0200)

----------------------------------------------------------------
Johannes Berg (1):
      mac80211: work around broken APs not including HT info

Simon Wunderlich (2):
      mac80211: abort CAC in stop_ap()
      mac80211: Fix rate control mask matching call

 net/mac80211/cfg.c         |  6 ++++
 net/mac80211/ieee80211_i.h |  5 +--
 net/mac80211/mlme.c        | 87 ++++++++++++++++++++++++++++++++++++++++++=
----
 net/mac80211/rate.c        |  2 +-
 net/mac80211/util.c        |  4 +--
 5 files changed, 92 insertions(+), 12 deletions(-)


--=-5zNV2ZMz4CjaxYv/n4RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRuB/vAAoJEDBSmw7B7bqrDzsP/2c4BQopDENZlcsYVNWVdP3c
r0cWSjdDm1+tOB8/2LhDcarlS2xgW8AtVn2pvJ0XnZBQotAD8smRmzgxDlZ9dKHw
nRyKwDtYl9VU1xg+OksrIxSmKQ0ApWBz6YuV/ru+eGLXbbv7dReqvsLGbWyl1N9t
3N4uB0yCEwW00Dh7DcUM+mafAbf8+HIkGc9KuTP1Nf4U/NN0As4n3Sefzl/gTWrT
+sI6PqpvrJdHLQa1fdYyNxDGAw0mSuXdvdzKVb2jtOd6JjqLvf2DTKIIv6ANGORF
Qj4T+DydOGT43BGtx4crJaxB86cd0wB+Jb7ZB5CXiNpPpSQKnopzEW2bKwqYBtAh
G4Hpfu2H/gOWBEFj40bwyXyt/5WvWNc1GcI+/Y1QZ2CKafhuRTn48V9q8qmoIPqf
Vl8jADbNiBXTKnyrAHwwIBmySI5ByRMq0Nj+lYU178qompIUycgPFv09cXzrmnGa
iDSgrSOTucABG+CfHcbN+8oXiuaPGIBcZzdbo1p2LkdV2rJwjb5dRg0fkEDz2q6m
FZlFApkk23e2KP1pbp9bBNQEtJ5KM0n4fV32yMzPPNW6qcDpdZvE7yKpEemlHpmI
fhZMlwRpgT2duNlIE5AZxuhp77eEYOzZtqiPryVBdGV4RXNtKQE+6HuVusEz/zV5
SfB4MA1lz/GSClFZqwk9
=BEVq
-----END PGP SIGNATURE-----

--=-5zNV2ZMz4CjaxYv/n4RB--

