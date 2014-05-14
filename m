Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42663 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaENOiu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 10:38:50 -0400
Message-ID: <1400078307.4759.11.camel@jlt4.sipsolutions.net> (sfid-20140514_163853_817720_20CFE14D)
Subject: pull-request: mac80211: 2014-05-14
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 14 May 2014 16:38:27 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-IXqWHUIec0hnAMLYHEAk"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IXqWHUIec0hnAMLYHEAk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

I know I sent a pull request two days ago, but now I have more fixes ...
if it's too much let me know and I'll limit myself to once a week or so,
but it seemed that we should get at least Emmanuel's fix in soon.

This has a fix from Emmanuel for a problem I failed to fix - when
association is in progress then it needs to be cancelled while
suspending (I had fixed the same for authentication). Also included a
fix from myself for a userspace API problem that hit the iw tool and a
fix to the remain-on-channel framework.

Let me know if there's any problem.

johannes

The following changes since commit f9ac71bfcc5c937ff02765dc316cf5bc01d21d97=
:

  mac80211: fix vif name tracing (2014-05-09 14:35:40 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git HEAD

for you to fetch changes up to b4b177a5556a686909e643f1e9b6434c10de079f:

  mac80211: fix on-channel remain-on-channel (2014-05-14 15:48:38 +0200)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      mac80211: fix suspend vs. association race

Johannes Berg (2):
      nl80211: fix NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL API
      mac80211: fix on-channel remain-on-channel

 include/uapi/linux/nl80211.h |  4 +++-
 net/mac80211/ieee80211_i.h   |  1 +
 net/mac80211/mlme.c          | 20 +++++++++++++-------
 net/mac80211/offchannel.c    | 27 ++++++++++++++++++++-------
 4 files changed, 37 insertions(+), 15 deletions(-)


--=-IXqWHUIec0hnAMLYHEAk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJTc3/nAAoJEDBSmw7B7bqrtLIP/1YnsHSa4m8Ud6zRKRtBEW/I
oHxfFTEEEVkWizQrNrOktadTOG8Vfiqbjmp3iUzgLYsEQ/Li715cMvMDpuVmeQU7
Ba5VNBUZDxqoh23bEeVtB/1k75ddL8O043g8GLc9ipSTyMsQJIExhuqtfCsQ5KuX
wq8MivFzpoEWq8joqmzsIE4Qkm1pTJHmF9et7hCj7O08opPmu71CMjEHhfD1kdaN
nsFFrK14noK/hM9IqeEw7b0OCatmyo0l0ZteYXpsKtkKCQEyO0Mdolhzetm5QM3k
KSphafELHwvA62Et+MsWukmZxYXa5qq6I661joJ9Hm2ckyevfQ9QQ9BGRz5j0v2u
mWDIIbs6a/wiiSNMxSzd01Fxl1zcFLKtLh51n1SyvSRSM8C8bmsRsb3V+alzVFfl
q8UjiIf2xN7STfRVHAGrbsNkUsDDvzZAMAQ7P0TM6BBJ0qo+tCO4ZIJL1D2RJDc5
hLdmCd9dHLAl1Vf/n+9ug95uXZ7Wyxq2LhHBWWEZ2ALPwh2Kzz4TLuhx1cTBRcXs
EP9xf91mD6Ohs1z9akxG9qXq15i0dpUFMvDyVsCKwOPoEN0vwYGLZzcOr/GsEE2n
EAe9MqqfaPWxQlV7QcLdRs5TtRWRGvaFLggjHF2LxOib0daqAnoMX5EAretP5MV5
a978xEYsqWhG7EKCSGF5
=yoyl
-----END PGP SIGNATURE-----

--=-IXqWHUIec0hnAMLYHEAk--

