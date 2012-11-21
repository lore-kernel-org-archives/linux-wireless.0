Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44851 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab2KUOaB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 09:30:01 -0500
Message-ID: <1353508227.10444.33.camel@jlt4.sipsolutions.net> (sfid-20121121_153008_517622_FBB7874A)
Subject: pull-request: mac80211-next 2012-11-21
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 21 Nov 2012 15:30:27 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-UV7uJM87FavGt8nqrOR2"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UV7uJM87FavGt8nqrOR2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Third (and last for today) pull request :-)

This one contains the mac80211-next material. Apart from a few small new
features and cleanups I have two fixes for the channel context code. The
RX_END timestamp support will probably be reworked again as Simon Barber
noted the calculations weren't really valid, but the discussions there
are still going on and it's better than what we had before.

I haven't included the VHT changes yet, I want them to have a bit more
review time on the mailing list (only posted yesterday), and I also
think I might want to hold them for 3.9. OTOH, channel contexts are new
in 3.8 so if I put them into 3.8 we don't have two versions of channel
contexts. Haven't made up my mind yet, any thoughts? :-)

Please pull.

Thanks,
johannes

The following changes since commit 6352c87ff69daa2211419ec2c34ddb8bc116c505=
:

  mac80211: reassign channel contexts before stations (2012-11-09 17:34:36 =
+0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 77d2ece6fde80631193054edc9c9a3edad519565:

  mac80211: Add debugfs callbacks for station addition/removal (2012-11-21 =
11:46:25 +0100)

----------------------------------------------------------------
Amitkumar Karwar (1):
      nl/cfg80211: advertise OBSS scan requirement

Arend van Spriel (1):
      mac80211: check add_chanctx callback before use in ieee80211_reconfig

Eliad Peller (1):
      mac80211: make remain_on_channel() op pass vif param

Johannes Berg (4):
      mac80211: use CMAC_PN_LEN
      mac80211: introduce IEEE80211_NUM_TIDS and use it
      mac80211: support radiotap vendor namespace RX data
      mac80211: fix channel context suspend/reconfig handling

Jouni Malinen (1):
      cfg80211: Add TDLS event to allow drivers to request operations

Sujith Manoharan (1):
      mac80211: Add debugfs callbacks for station addition/removal

Thomas Pedersen (1):
      mac80211: support RX_FLAG_MACTIME_END

 drivers/net/wireless/ath/ath5k/base.c          |  2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c  |  2 +-
 drivers/net/wireless/ath/ath9k/recv.c          |  2 +-
 drivers/net/wireless/b43/xmit.c                |  2 +-
 drivers/net/wireless/b43legacy/xmit.c          |  2 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c |  2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c       |  2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c    |  1 +
 drivers/net/wireless/iwlwifi/dvm/rx.c          |  2 +-
 drivers/net/wireless/mac80211_hwsim.c          | 36 ++++++++++-
 drivers/net/wireless/p54/txrx.c                |  2 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c     |  2 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c     |  2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c   |  2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c   |  2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c   |  2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c   |  2 +-
 drivers/net/wireless/ti/wl1251/rx.c            |  2 +-
 include/linux/ieee80211.h                      |  2 +
 include/net/cfg80211.h                         | 19 ++++++
 include/net/mac80211.h                         | 39 +++++++++++-
 include/uapi/linux/nl80211.h                   | 10 +++
 net/mac80211/agg-rx.c                          |  2 +-
 net/mac80211/agg-tx.c                          | 12 ++--
 net/mac80211/cfg.c                             |  6 +-
 net/mac80211/debugfs_key.c                     |  6 +-
 net/mac80211/debugfs_sta.c                     | 19 ++++--
 net/mac80211/driver-ops.h                      | 39 +++++++++++-
 net/mac80211/ht.c                              |  4 +-
 net/mac80211/ibss.c                            | 29 ++-------
 net/mac80211/ieee80211_i.h                     | 11 ++++
 net/mac80211/key.c                             | 15 ++---
 net/mac80211/key.h                             |  8 +--
 net/mac80211/mesh_sync.c                       | 44 +++----------
 net/mac80211/offchannel.c                      |  2 +-
 net/mac80211/pm.c                              | 44 ++++++++++++-
 net/mac80211/rx.c                              | 87 +++++++++++++++++++++-=
----
 net/mac80211/sta_info.c                        | 10 +--
 net/mac80211/sta_info.h                        | 19 +++---
 net/mac80211/trace.h                           | 13 ++--
 net/mac80211/util.c                            | 76 ++++++++++++++++++++--
 net/wireless/nl80211.c                         | 47 ++++++++++++++
 net/wireless/trace.h                           | 23 +++++++
 43 files changed, 497 insertions(+), 158 deletions(-)


--=-UV7uJM87FavGt8nqrOR2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQrOWDAAoJEDBSmw7B7bqr0CYP/3Syw33uRKQjoCJk40+eG8IC
YTYjV3mvvdVp4UY7Pd8IYNuM3iZS5YLOY4cfCxveu1KNTh5B3k7dHHAefEhEVwZK
xLenel9+avc8Se+p2FPiTFtp/8fscOoHEUvkBpwcy7ilLaTVcab4zWhEGRkjaU7R
vYK/zRKlNnaJF8yLlfF8bo385QAvBZWpa8v5pYrq32LwuUkf4APUsQXz4DtNi/kl
mqm1awHB895j6zD9HfQ15NyjAU28Ssu/SujoEiAJPDhR3kuEqEDsO/HlNxBHEuYa
zGSC4jGyu3nkIeaui6sTFrX/v0UEPzqTFZ/MrBk99biEMSoNbc3FIb7DgwA1HwDS
U9H5zUd5DtQ4VUUY2wzJfhSnPz90jeuDy54TX1krPZfn+bXeH5zYxYXpvA1kJTw8
/CdDEzF5Qw5ZuDUd0azA6nWx5xYNFc+xdi1XCbgpNk3zemEZcImaL0eLr2Hdk+WX
ckGgefPUOVN9VVbqHzNp3jCxmx1dgRq5jjVYHEUPzMSKmbBFL9sxdvwTXx9Y1kQE
m4axOyCwAbrEeMt0JdSrBMfPFrGzSlAPE0GbpWS3PggLAEcLQYpreMa3Q6PJrU4T
fM0NQeJnPbc6ECnKunoywLc+grd4TOzUQpP4cA6PWcHrpl5PKGDamAt4lxi4Q5xa
w4DiSUzSEDJtePnrSWzM
=wUgz
-----END PGP SIGNATURE-----

--=-UV7uJM87FavGt8nqrOR2--

