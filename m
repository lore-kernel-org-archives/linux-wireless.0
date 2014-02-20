Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:32823 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804AbaBTOa6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 09:30:58 -0500
Message-ID: <1392906648.5073.31.camel@jlt4.sipsolutions.net> (sfid-20140220_153103_239073_374D6E8D)
Subject: Re: pull-request: mac80211 2014-02-20
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 20 Feb 2014 15:30:48 +0100
In-Reply-To: <1392887140.5073.10.camel@jlt4.sipsolutions.net> (sfid-20140220_100613_323680_C04BED1E)
References: <1392887140.5073.10.camel@jlt4.sipsolutions.net>
	 (sfid-20140220_100613_323680_C04BED1E)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-85Zna94B9/dl6pTjp++E"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-85Zna94B9/dl6pTjp++E
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

I've got a few more fixes for some issues here now.

This time, I have a fix from Arik for scheduled scan recovery (something
that only recently went into the tree), a memory leak fix from Eytan and
a small regulatory bugfix from Inbal. The EAPOL change from Felix makes
rekeying more stable while lots of traffic is flowing, and there's
Emmanuel's and my fixes for a race in the code handling powersaving
clients.

Please pull.

Thanks,
johannes


The following changes since commit fab57a6cc227468ca9e6a4c7ff8d3b10727785ee=
:

  mac80211: fix virtual monitor interface iteration (2014-02-06 09:55:22 +0=
100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to e3685e03b40f5ec7926d9a75bf63467fc4071df9:

  mac80211: fix station wakeup powersave race (2014-02-20 11:54:09 +0100)

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

Johannes Berg (2):
      mac80211: insert stations before adding to driver
      mac80211: fix station wakeup powersave race

 net/mac80211/ieee80211_i.h | 10 ++-----
 net/mac80211/mlme.c        |  1 +
 net/mac80211/rx.c          |  7 +++++
 net/mac80211/sta_info.c    | 66 +++++++++++++++++++++++++++++-------------=
----
 net/mac80211/sta_info.h    |  7 +++--
 net/mac80211/tx.c          | 15 +++++++++++
 net/mac80211/util.c        | 48 ++++++++++++++++-----------------
 net/mac80211/wme.c         |  5 ++++
 net/wireless/reg.c         |  2 +-
 9 files changed, 98 insertions(+), 63 deletions(-)


--=-85Zna94B9/dl6pTjp++E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJTBhGYAAoJEDBSmw7B7bqrUOsP/2AwzScubPkatIVUnmW9kKLn
4Ua6VrflGgHADiproviaVqmQ0WZcciOHD+EESblTbv9nnpezIifgHvPPvxCRUM9y
KEr67c2hbvU2GjCOLgp588l90tdPzcEUZjcFpgDMjxJ6k0vYxolgnL10kV6DgJNY
QFiZmbc8eHRFmBaulHYeJO9xsBEmmadFNYroZnQPa40+DIunDEBleJZOfWabxAyl
WvbCmoqVrxyVm0NSgdk3Hp1EHjNp1vLaSQiD7W5uxzarmST/r72wHGel1Edg9Cgd
unZaxL/s47XNzsCRg+pu0W6jt41ou1leiY7m+Gmv+fee/AQSn3j/y292YPypB32y
BssnOm1jpb+6r8NjnweTCyuE2TBngWNW5+uvcqwyUcvmYLU2putScshV7+nK594Z
Ah8lVZ8Smd1I3AdxcgT3LylVmVQf+W/is4FxUAzI1yVVphS0oYVZXZbK4LZAQJmv
ayHxw+C93GukBS3Evf2U8dpJogk4Z5vrF0x8QQewX0N+XhNIHZ2jgmkFZXBfHBIm
iELOZjl10K7qxCJFPe7tVsTB64oW5ESyTFlQCVXMgWJNlTWlJvm8FEFi/6/tdyTT
QV3PqiBawBlFsjyoIoShB+4rQv31UiYkFsr4bhEkWjIUt0hBQH1QtXlnTVwLBOir
wsXAi/fcHQIGkXOItr4s
=cE3u
-----END PGP SIGNATURE-----

--=-85Zna94B9/dl6pTjp++E--

