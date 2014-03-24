Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:42002 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751959AbaCXIiF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 04:38:05 -0400
Message-ID: <1395650268.4515.21.camel@dubbel> (sfid-20140324_093811_248677_572097B9)
From: Luca Coelho <luca@coelho.fi>
To: "Berg, Johannes" <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 24 Mar 2014 10:37:48 +0200
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-sDS4tPg/YP4klQzWtpjr"
Mime-Version: 1.0
Subject: pull request: mac80211-next-csa 2014-03-24
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sDS4tPg/YP4klQzWtpjr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Johannes,

As we agreed, I'm sending you a pull request with the channel-switch
stuff Micha=C5=82 and I have been working on.

This includes my combination and reservation patchsets and the VLAN copy
chanctx from Micha=C5=82 that my reservation patchset depends on.

Please pull.

The following changes since commit 73fb08e24ae840bc518facc2c605dd6bb3751fec=
:

  cfg80211: remove macro ASSERT_RDEV_LOCK(rdev) (2014-03-19 21:29:58 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/mac80211-next-csa.git =
for-johannes

for you to fetch changes up to 5824e703a7a1dbd766aa445fff8518ddf90468be:

  mac80211: allow reservation of a running chanctx (2014-03-24 10:18:32 +02=
00)

----------------------------------------------------------------
Luciano Coelho (9):
      cfg80211: refactor cfg80211_can_use_iftype_chan()
      cfg80211/mac80211: refactor cfg80211_chandef_dfs_required()
      cfg80211/mac80211: move interface counting for combination check to m=
ac80211
      cfg80211/mac80211: move combination check to mac80211 for ibss
      cfg80211/mac80211: move more combination checks to mac80211
      mac80211: split ieee80211_vif_change_channel in two
      mac80211: refactor ieee80211_assign/unassign_vif_chanctx into one
      mac80211: implement chanctx reservation
      mac80211: allow reservation of a running chanctx

Michal Kazior (1):
      mac80211: protect AP VLAN list with local->mtx

 Documentation/DocBook/80211.tmpl |   1 +
 include/net/cfg80211.h           |  31 ++++++-
 include/net/mac80211.h           |   7 ++
 net/mac80211/cfg.c               |  16 +++-
 net/mac80211/chan.c              | 384 +++++++++++++++++++++++++++++++++++=
++++++++++++++++++++++-------------------
 net/mac80211/ibss.c              |  64 +++++++++----
 net/mac80211/ieee80211_i.h       |  21 ++++-
 net/mac80211/iface.c             |  15 ++-
 net/mac80211/mesh.c              |   9 +-
 net/mac80211/util.c              |  76 +++++++++++++++
 net/wireless/chan.c              |  74 +++++++++++----
 net/wireless/core.c              |  11 +--
 net/wireless/core.h              |  29 ------
 net/wireless/ibss.c              |  24 -----
 net/wireless/mesh.c              |  25 -----
 net/wireless/mlme.c              |  14 +--
 net/wireless/nl80211.c           |  59 ++++--------
 net/wireless/util.c              | 139 ++++++++++++++++------------
 18 files changed, 651 insertions(+), 348 deletions(-)


--=-sDS4tPg/YP4klQzWtpjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABAgAGBQJTL+7cAAoJEKFHnKIaPMX6BW4P/j44aGIch7o4BwGYizLttSUq
8qIyVhp8RZOEIrR2xxWKdwSne+p7hiyIGBKqQGVPW6majd8TvRE5str1iphn0X5s
cU+oJfGDJyaR2Y8iIM9z8ZNxAf1nLrY05PwnntSDcrY0oPG2X+HuCepzkonATuJZ
LKizcS+HIaf9z7bNKHsYee9AfqFhCGEHam2AZNlKcC6+gySXjnbDxDJ+oMRgsnPG
ylv5WqD+3RjqoW/kezdLTX7hIEtrOuJgfbXiUlcP9q8nsyQ3tedAnddNfSTfdHUu
GwgP7EfT6/RDF8vL8qw3mGyHpRwNowL7BKsbtxNB/4ykLOB3aLYTNgO/ldkcYhUS
tqMkqCW70deQPPW5wYZZuMSytmWzGST2VbqjV+BoBQ2ZC6/on32LHR6YxiynyQ3m
E4rNqRm0cm8NyOMz0MIvMWynk2qsV6dlVNAn6+HFqseI/Zj8DZ5RBUvNG63BI4Sy
JQZxGPx7PTTPFx0FHVhH87/fzt9Fnym91wbrReJGIITNFa6vM1jaF5/DzkXXqg1a
MQtGx9w+n+VQ1HzVMckEQjhCedndBoWt2xXvDbkxqUJXDWFYFnzB1qfQ0E5OfoNw
4ktLdl6b/KGN1fEmix+Upy/BwWo9kZ+fdf0cq9t0Yn9NRPOj/+gXkyehlC6pefyf
Idx9ms6cV+rqw5U/JjbJ
=hIS2
-----END PGP SIGNATURE-----

--=-sDS4tPg/YP4klQzWtpjr--

