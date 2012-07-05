Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45579 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab2GEIEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 04:04:14 -0400
Message-ID: <1341475446.4455.15.camel@jlt3.sipsolutions.net> (sfid-20120705_100419_947130_25BFF425)
Subject: pull-request: mac80211-next 2012-07-05
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 05 Jul 2012 10:04:06 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-o4ZeJE026x5xhfDxzmaV"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-o4ZeJE026x5xhfDxzmaV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please pull these changes. The most important thing is the locking
regression (deadlock) fix for one of Michal's recent patches.

I have a pending fix for the queue-related crash Larry reported, but I'm
waiting for him to test it again. If you haven't pulled by then, I'll
update this pull request to include that (and the hwsim test I used.)

Thanks!

johannes

----
The following changes since commit ba0afa2f22e1e3f332e45460f99328025d44564e=
:

  mac80211: include VHT capability IE in probe requests (2012-07-02 15:13:0=
9 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to c5a7e582490c423f0685e42ee5cfb7c6de81adb0:

  cfg80211: fix locking regression in monitor channel tracking (2012-07-04 =
13:30:23 +0200)

----------------------------------------------------------------
Johannes Berg (4):
      mac80211: remove tx_frags driver callback
      mac80211_hwsim: fix NUM_BANDS usage
      mac80211: add TX prepare API
      cfg80211: fix locking regression in monitor channel tracking

Thomas Huehn (1):
      mac80211: reduce IEEE80211_TX_MAX_RATES

 drivers/net/wireless/ath/carl9170/tx.c |    6 ++---
 drivers/net/wireless/mac80211_hwsim.c  |    4 ++--
 drivers/net/wireless/p54/txrx.c        |    6 ++---
 include/net/mac80211.h                 |   38 ++++++++++++++++------------=
----
 net/mac80211/driver-ops.h              |   22 +++++++++++-------
 net/mac80211/main.c                    |    2 +-
 net/mac80211/mlme.c                    |    8 +++++++
 net/mac80211/trace.h                   |    7 ++++++
 net/mac80211/tx.c                      |   10 +++------
 net/wireless/core.c                    |    8 ++-----
 net/wireless/core.h                    |    4 +++-
 11 files changed, 65 insertions(+), 50 deletions(-)


--=-o4ZeJE026x5xhfDxzmaV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJP9Up2AAoJEDBSmw7B7bqrOyIP/1AwbV6ASS6qoItmoD7nYeGO
MZz8PpGaTEwHs86yxu0YLQDpecxGDkgTQvh7OBMbbOkDqGLY1cisW9Rlfrs561Mn
LSU5Ep3gL/iWWPOwoWlUtSch5s4oYVrJ8B/i6JSPWr5Zy7QXpUD6hOZCMYyaUN2M
umvdF4T7QDCKTpRcyJ6ColcluM4e8hrzeFn+uzZU4Rtg1FZZ7J5g6HnJUGNIWIoD
uJMWCMdki5JvXdlM72KLTVe1AqV+aY3FihRedhsp14NERs/fGZqBv7a58vCapMAq
CcDNf/NmfLopxFCCXCQbykR3I7j8wTkH7GXYGx5lAJSU4ZCBkn3CRLPnKQWfEKDf
pXCJKB6Ocw4Tgz/A2maDgxYnsQQ3B+OmWyblGAPNYtbEvc7381u5EIshGODzr682
PCtN2kKiPQIfjyvHeQqjxXkdtk2ffrHXQQ54oFOlTbDUjuWeGOqBAJ6XFfZgT/Kx
GpIHCXosDAd9nP5kxRVA8dQHBLaC3+o4VAQPBp2KqiRgmgrJTUZ9eQODxtCaxAri
KXttxngmVOUpjGQ6SJb5iK+YLhQKQS6zir4u3mNMw66KEnQK4f9NqUxI6jreeMIC
Pelq/NYeHLKT3SbXYjuR4WMRH5Og/Rg44BrPwq5sOdxJZuqIeSUakNCI/ocTT/AI
FVO9rc98OqJn1jf6ad5x
=VMCP
-----END PGP SIGNATURE-----

--=-o4ZeJE026x5xhfDxzmaV--

