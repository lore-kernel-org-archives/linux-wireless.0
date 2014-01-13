Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44268 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaAMNse (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 08:48:34 -0500
Message-ID: <1389620906.5008.12.camel@jlt4.sipsolutions.net> (sfid-20140113_144846_945128_46172B3C)
Subject: pull-request: mac80211-next 2014-01-13
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 13 Jan 2014 14:48:26 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-NbFPS9gRmfE7jh2iBQHt"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NbFPS9gRmfE7jh2iBQHt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

I'm hoping this pull request will still make it for 3.14, but I guess
it's not a huge loss if it doesn't, I'd just have to rebase around to
get things reorganised properly.

This tim eI have uAPSD fixes since I was working on that, hwsim
improvements to make dynamic radios possible for the test suite, the
evidently long-overdue channel_change_time removal and a few other small
collected fix and improvements.

Let me know if there's any problem.

johannes

---

The following changes since commit 32db6b54dfba38aa8fa4072b2a3fc6425139166a=
:

  mac80211: Add support for QoS mapping (2013-12-19 16:30:58 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 26b0e411d37a2ca5992d02884dc3fa4e1907e598:

  mac80211_hwsim: restore regulatory testing functionality (2014-01-10 20:1=
2:59 +0100)

----------------------------------------------------------------
Avinash Patil (2):
      ieee80211: add definition for TDLS wide band extended capability
      ieee80211: add definition for SMS4 key len

Chun-Yeow Yeoh (1):
      mac80211: enable WME for peer mesh STA

Emmanuel Grumbach (3):
      mac80211: clean up garbage in comment
      mac80211: simplify code in ieee80211_prepare_and_rx_handle
      mac80211: allow to set smps mode to OFF in AP mode

Ilan Peer (1):
      cfg80211: Add a function to get the number of supported channels

Johannes Berg (26):
      cfg80211/mac80211: correct qos-map locking
      mac80211: add tracing for ieee80211_sta_set_buffered
      nl80211: move vendor/testmode event skb functions out of ifdef
      mac80211: clean up netdev debugfs macros a bit
      mac80211: handle station TX latency allocation errors
      mac80211: fix memory leak in register_hw() error path
      mac80211_hwsim: fix a print message
      mac80211: clean up prepare_for_handlers() return value
      mac80211: remove channel_change_time
      mac80211: fix PS-Poll driver release TID
      mac80211: release multiple ACs in uAPSD, fix more-data bug
      mac80211: reset TX info flags when frame will be reprocessed
      mac80211: handle MMPDUs at EOSP correctly
      mac80211_hwsim: clean up netlink exit code
      mac80211_hwsim: prepare for different channel support
      mac80211_hwsim: remove regtest for now
      mac80211_hwsim: refactor radio registration
      mac80211_hwsim: refactor radio cleanup
      mac80211_hwsim: minimize rctbl module parameter usage
      mac80211_hwsim: assign index from separate counter
      mac80211_hwsim: minor netlink cleanups
      mac80211_hwsim: shuffle code to prepare for dynamic radios
      mac80211_hwsim: verify wmediumd socket
      mac80211_hwsim: register netlink even with multi-channel
      mac80211_hwsim: allow creating/destroying radios on the fly
      mac80211_hwsim: restore regulatory testing functionality

Thomas Pedersen (1):
      mac80211: sync dtim_count to TSF

Ujjal Roy (2):
      cfg80211: fix wext-compat for getting retry value
      cfg80211: add sanity check for retry limit in wext-compat

 drivers/net/wireless/adm8211.c                     |    1 -
 drivers/net/wireless/at76c50x-usb.c                |    1 -
 drivers/net/wireless/ath/ath10k/mac.c              |    1 -
 drivers/net/wireless/ath/ath5k/base.c              |    1 -
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    1 -
 drivers/net/wireless/ath/ath9k/init.c              |    1 -
 drivers/net/wireless/ath/carl9170/main.c           |   12 -
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    1 -
 drivers/net/wireless/cw1200/main.c                 |    1 -
 drivers/net/wireless/libertas/cfg.c                |    7 +-
 drivers/net/wireless/mac80211_hwsim.c              | 1246 ++++++++++------=
----
 drivers/net/wireless/mac80211_hwsim.h              |   18 +
 drivers/net/wireless/mwl8k.c                       |    2 -
 drivers/net/wireless/p54/main.c                    |    1 -
 drivers/net/wireless/rtlwifi/base.c                |    1 -
 drivers/net/wireless/ti/wl1251/main.c              |    1 -
 drivers/net/wireless/ti/wlcore/main.c              |    1 -
 drivers/staging/winbond/wbusb.c                    |    1 -
 include/linux/ieee80211.h                          |    2 +
 include/net/cfg80211.h                             |    8 +
 include/net/mac80211.h                             |    8 +-
 net/mac80211/cfg.c                                 |    3 +-
 net/mac80211/debugfs_netdev.c                      |   61 +-
 net/mac80211/ht.c                                  |    5 +-
 net/mac80211/ieee80211_i.h                         |    2 +
 net/mac80211/main.c                                |   22 +-
 net/mac80211/mesh.c                                |    1 +
 net/mac80211/mesh_plink.c                          |    1 +
 net/mac80211/rx.c                                  |   40 +-
 net/mac80211/sta_info.c                            |  238 ++--
 net/mac80211/trace.h                               |   27 +
 net/mac80211/tx.c                                  |    2 +
 net/mac80211/util.c                                |   41 +
 net/mac80211/wpa.c                                 |    2 +-
 net/wireless/nl80211.c                             |  111 +-
 net/wireless/scan.c                                |    7 +-
 net/wireless/sme.c                                 |   13 +-
 net/wireless/util.c                                |   15 +
 net/wireless/wext-compat.c                         |    6 +-
 39 files changed, 1047 insertions(+), 866 deletions(-)


--=-NbFPS9gRmfE7jh2iBQHt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJS0+6qAAoJEDBSmw7B7bqrcLkP/0KsV2dYlhqcA6GYtCuFS/JD
dBauQC8luL3oXFEmjVxkNukFEILDrNmrjTnKrxj51KXOg72XLl745Pp8LqkrEXNx
kg/6QSMIVqordJgVApsoPkuldDBUb4FBbe/7vAfDIGVOB8TPhAsdR/xdXeCAO3fo
AvqsJM3X0dl5njUM/VHUvx+OeTUbY7aqQ20Tf6VKlc91Da4o/+7KNq1hZccYxhgU
jbxLAzeQQoYC4tIl+c+3FS0WN9OYnuWjVwHtdCcjr6J/6/O78zOpECvIzUErceF6
4IKEp0H1374PVaUr9PvyWb5X+AyvtP46aaCAu9QkOJ7ZLi9MaX05nPF1/YFZ99d6
GtOdRBQNb+xesYZU6CT9cs6d3hEVao1gZwM0eLJAQTRnC0nQGH4E1eB2batDbRZ1
syN2ogLJH020ppL5cCuF2OGJgbVbjb+23aL6/Bo97RgxXBv1tKpVBUiTCgXoSYNn
8UfT1B+ptstLQGWzWiZltEuyWpywZSFT0cKAqEyQkVtYNn4BOmUAbrLGIaX5a7/H
0X63LRMAcLTuAv03BuGmisAncL9MgoBUE3lVnvD/vc9SYoTd3tjDsLVIIRDoQU7z
MG49c9qgptiJ7qhWD6nX0l3TQK3iQlZlZM4YBY736JGFyQ+ImtxMNEpGJoWdZ+6g
Imn3PHuOpsPNYdAP4LDU
=6So4
-----END PGP SIGNATURE-----

--=-NbFPS9gRmfE7jh2iBQHt--

