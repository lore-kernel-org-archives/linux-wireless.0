Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60026 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbaBTJF5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 04:05:57 -0500
Message-ID: <1392887140.5073.10.camel@jlt4.sipsolutions.net> (sfid-20140220_100613_323680_C04BED1E)
Subject: pull-request: mac80211 2014-02-20
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 20 Feb 2014 10:05:40 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-0shdzrvx2TaNOzWtY8/B"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0shdzrvx2TaNOzWtY8/B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

I've got a few more fixes for some issues here now.

This time, I have a fix from Arik for scheduled scan recovery (something
that only recently went into the tree), a memory leak fix from Eytan and
a small regulatory bugfix from Inbal. The EAPOL change from Felix makes
rekeying stable while lots of traffic is flowing, and there's
Emmanuel/my fix for a race in the code handling powersaving clients.

Please pull.

Thanks,
johannes



The following changes since commit fab57a6cc227468ca9e6a4c7ff8d3b10727785ee=
:

  mac80211: fix virtual monitor interface iteration (2014-02-06 09:55:22 +0=
100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 51f94933f1bcea26a0c309702d1ec51f02864ca5:

  mac80211: fix AP powersave TX vs. wakeup race (2014-02-20 09:52:53 +0100)

----------------------------------------------------------------
Arik Nemtsov (1):
      mac80211: fix sched_scan restart on recovery

Emmanuel Grumbach (1):
      mac80211: fix AP powersave TX vs. wakeup race

Eytan Lifshitz (1):
      mac80211: fix memory leak

Felix Fietkau (1):
      mac80211: send control port protocol frames to the VO queue

Inbal Hacohen (1):
      cfg80211: bugfix in regulatory user hint process

 net/mac80211/mlme.c     |  1 +
 net/mac80211/sta_info.c |  4 ++++
 net/mac80211/sta_info.h |  7 +++----
 net/mac80211/tx.c       | 14 ++++++++++++++
 net/mac80211/util.c     | 40 ++++++++++++++++++++--------------------
 net/mac80211/wme.c      |  5 +++++
 net/wireless/reg.c      |  2 +-
 7 files changed, 48 insertions(+), 25 deletions(-)


--=-0shdzrvx2TaNOzWtY8/B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJTBcVkAAoJEDBSmw7B7bqrlswP/jxKRPwADNAHsP76g7Zjdr3v
DHrtTe+MgvvBpSGKDAxfn/mIsRaHemeXGS0aI0CGMDuRtK91XBEegU568JF/g9WG
TI+Yuw3eLWO5CuskM9mkClRYekhyINDPzwS3dxoktHAxAskOoS1fQsUb/D+JJh2p
LngG7dGmnnkqQPEx8IgVBo9V7tYjworSnVRTNXaFsgUYCBD5eFPCjZL0+kqSQ8vY
TnXJXXhp9K5Ec9WBD+uBC15XHtzPOG+BFkPa++Ln2vgCH/Ndc1rfKeop9ZY8aU2L
e2t550SqydpRemRdUDzFk0obQ978Md8+e+v3DjJ1gkcnxADYcoFK2xyeF9gMgcBp
RWnj5G42ydQ9dg8ISGc122u5kyNK+nNf42ge2j9kw5ndqDj+faOOEjiAg7uK1JJH
vswJBoh+08h6P7xAVjB3yrtYDqg3t5HACXpKfr6bDVmX8LKK3JTJ6eOqGcbQQ6Io
Y7k7vC7gHayJ1QM/brhOnppXl32u7ArILBnWh+pQkk7U54VRzcjibk1TcNLD5vu4
nIbbmMJR4CIs9YQElqARcocp+ae/rhyhL3cXAxEUvwL75o8d7UbgWk4STkzDrKCF
vV3pE3t790fBj4rJPDbB8ineBmX3u9umkA/e7XpLIcPti+iDKrV1jLBeZMjEvRDV
99K9rhUTEtypr4Fn2OcH
=ckEo
-----END PGP SIGNATURE-----

--=-0shdzrvx2TaNOzWtY8/B--

