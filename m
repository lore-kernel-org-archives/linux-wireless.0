Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51963 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759747Ab3GaTZo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 15:25:44 -0400
Message-ID: <1375298735.8289.25.camel@jlt4.sipsolutions.net> (sfid-20130731_212557_264097_5CACBE65)
Subject: pull-request: mac80211 2013-07-31
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 31 Jul 2013 21:25:35 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-cNK/biyHxVSOYaOfRUTV"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cNK/biyHxVSOYaOfRUTV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Another pull request for mac80211 - this time with a bunch of important
fixes.

I have a fix from Chris for an infinite loop along with fixes from
myself to prevent it entering the loop to start with (continue using
disabled channels, many thanks to Chris for his debug/test help) and a
workaround for broken APs that advertise a bad HT primary channel in
their beacons. Additionally, a fix for another attrbuf race in mac80211
and a fix to clean up properly while P2P GO interfaces go down.

Let me know if there's any problem.

johannes

The following changes since commit 23df0b731954502a9391e739b92927cee4360343=
:

  regulatory: use correct regulatory initiator on wiphy register (2013-07-2=
5 09:52:46 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to ddfe49b42d8ad4bfdf92d63d4a74f162660d878d:

  mac80211: continue using disabled channels while connected (2013-07-31 21=
:18:17 +0200)

----------------------------------------------------------------
Chris Wright (1):
      mac80211: fix infinite loop in ieee80211_determine_chantype

Johannes Berg (5):
      nl80211: fix another nl80211_fam.attrbuf race
      mac80211: don't wait for TX status forever
      mac80211: ignore HT primary channel while connected
      cfg80211: fix P2P GO interface teardown
      mac80211: continue using disabled channels while connected

 net/mac80211/mlme.c    | 54 +++++++++++++++++++++++++++++++++-------------=
----
 net/wireless/core.c    |  1 +
 net/wireless/nl80211.c |  6 ++++--
 3 files changed, 41 insertions(+), 20 deletions(-)


--=-cNK/biyHxVSOYaOfRUTV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJR+WSvAAoJEDBSmw7B7bqrpgQP/A6XoGOvaVcW8h+De9DgJlLC
ghjf906dubZp2bUQDh2zI/wu4VKdB5xX54LOQhqeghwWeZqyTHY043wUCgtgk2dK
1yj6R1BzbPKyfU9+rPNgTS1fbTdWpJy8VvyGFbgP9zNmUBbVlWqNMiUNc6nEVRrk
rSPG12L6cRp23TTv+FuLiIqrkypyAXbqNdJju2QmadpJSG38AH4sTzb+AOxMQlWz
mihJPGUm51jE5wew/ykb5GGdKK48FZ591GeKH5c5MuCEh7gabC3G/E4f4SG8H3Oj
Ry5dm/ERewddEiVds9wM26/qqTTvGQNL5Ig5xdJcDtYiy/LrROay0EM9XUk4r3w1
nXNSFsCCzdoY/gIc4Evi/l5i+EW9dZ6GtlGy20SdZLWsFpJ2KZ295itEFqspnHtP
DjUgjX31/rwauQvyYrBuQvbd1SyT9aYTFhUI6e4oUdI1xP0q+SK3CmIT+tlVuUs8
POSfXXHsFOkbGJW4mDydHx1n4ZbLvMmO5PY9LbFmpezIegFv+gbCttLzHMLpPxzC
UqRX8RElHy1UnnXiUw7ycP89ot70hnkZE4rzKwiYU8MW+USqbz5CRLBoK1eWlLMO
olVDsqFmeQvRiPW6gIik9umgC4e+8FwMqtakBe6R5UFPhWn7Sg/CNvVSQ7SyjXWv
MFUV+F54GWL3FH5cQU3w
=3cgC
-----END PGP SIGNATURE-----

--=-cNK/biyHxVSOYaOfRUTV--

