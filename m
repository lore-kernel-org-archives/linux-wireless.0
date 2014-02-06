Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55456 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbaBFJBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 04:01:00 -0500
Message-ID: <1391677237.12789.12.camel@jlt4.sipsolutions.net> (sfid-20140206_100108_734283_0A45EBD7)
Subject: pull-request: mac80211 2014-02-06
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 06 Feb 2014 10:00:37 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-br/F9yKMfyaAEKFx78ms"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-br/F9yKMfyaAEKFx78ms
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

First round of fixes ...

This is just a collection of small fixes, the commit logs explain the
details. The only thing that isn't strictly a fix is the 5/10 MHz
enabling, I had forgotten this and there's little point in waiting
longer. The patch simply removes the force-disable code that I put in
when there was a problem with the userspace API (that has long been
fixed.)

Please pull.

johannes



The following changes since commit 53d8ab29f8f6d67e37857b68189b38fa3d87dd8e=
:

  Merge branch 'for-3.14/drivers' of git://git.kernel.dk/linux-block (2014-=
01-30 11:40:10 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to fab57a6cc227468ca9e6a4c7ff8d3b10727785ee:

  mac80211: fix virtual monitor interface iteration (2014-02-06 09:55:22 +0=
100)

----------------------------------------------------------------
Eliad Peller (1):
      mac80211: move roc cookie assignment earlier

Emmanuel Grumbach (2):
      mac80211: avoid deadlock revealed by lockdep
      mac80211: release the channel in error path in start_ap

Johannes Berg (5):
      cfg80211: re-enable 5/10 MHz support
      cfg80211: fix scan done race
      cfg80211: send scan results from work queue
      mac80211: fix fragmentation code, particularly for encryption
      mac80211: fix virtual monitor interface iteration

Pontus Fuchs (1):
      nl80211: Reset split_start when netlink skb is exhausted

Sujith Manoharan (1):
      mac80211: Fix IBSS disconnect

 net/mac80211/cfg.c     | 44 +++++++++++++++++++++++---------------------
 net/mac80211/ht.c      |  4 +++-
 net/mac80211/ibss.c    |  5 +----
 net/mac80211/iface.c   | 27 +++++++++++++++++++--------
 net/mac80211/tx.c      |  2 +-
 net/wireless/core.c    | 17 ++++++++++-------
 net/wireless/core.h    |  4 +++-
 net/wireless/nl80211.c | 32 ++++++++++++--------------------
 net/wireless/nl80211.h |  8 ++++----
 net/wireless/scan.c    | 40 +++++++++++++++++++++++++---------------
 net/wireless/sme.c     |  2 +-
 11 files changed, 102 insertions(+), 83 deletions(-)


--=-br/F9yKMfyaAEKFx78ms
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJS8081AAoJEDBSmw7B7bqrAYMQALkCbqimV7YkEeTPrL4nu601
GrAgRGsgyg6ZcQH5NppJ3kv8YMb7COUySK2ATb/zjeviT4u43r0ocoswjERQeWkZ
6tPnJa9FRkK+RW3afVtee93I5jHnSkNm9zuaSGNQvFhWGfucw4L9wXo/fNAPDxy6
DMPsruxUfF4PvDizMfbzXcntB0r5MAl/tiEu/R41HZoFauWxKVjnPVQM63Fiz2fF
V+ic8m9jNOjQZVHidG8qBDJ02plEyuAihYK6c1PK4FCLXSEd+UTdqXts79ojgnVD
7uHEPn7arPHRxkSKZ6O2eNZlpsz1qEZ8Hv8dMAJgvj+Gxiy+IoStDNd58XjXeKV6
FaWhRg8lRuw/bstuNeo+1enPy803PbT6gdYNDedkA6HP0zmrI3MHeRHwd8LqxnDv
lu0zaOfdmBqd/vF7d+sJjyyPMz1u++WyD4Y0jQTUtKHlSNigVJ+ujDRUDOpxl9EM
0S3zMLBRw9MnFFcZ7TKIqOknchOYppY8BSynq1YHR7ewUCEu2gMCJTzhpxGoo/Lq
YLgIfbThKD77EKmymZg7GXuPB14exwPs3GQOqBToGNobL5ZizfbwiM4ATXjwf0uw
d0EuRYx3YaEEI1c6e2QXw5M1tQ77bC6CdU3vohVaR1mvgsW0J9om43zOumbyVncI
lMAot4kND8pPsGZsxBjj
=p9p7
-----END PGP SIGNATURE-----

--=-br/F9yKMfyaAEKFx78ms--

