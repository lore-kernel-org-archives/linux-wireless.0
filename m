Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56562 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128AbaBFMeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 07:34:37 -0500
Message-ID: <1391690066.12789.15.camel@jlt4.sipsolutions.net> (sfid-20140206_133442_771501_5E38DEAC)
Subject: pull-request: mac80211-next 2014-02-06
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 06 Feb 2014 13:34:26 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-rpxNmJebYGEnJdJ7W9M+"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rpxNmJebYGEnJdJ7W9M+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

And here are features for -next :-)

We have some cleanups and minor fixes as well as userspace API
improvements from a lot of people, extended VHT support for radiotap
from Emmanuel, CSA improvements from Andrei, Luca and Michal. I've also
included my work on hwsim to make dynamic registration of radios
possible

Please pull.

johannes


The following changes since commit 77d143de75812596a58d126606f42d1214e09dde=
:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git=
/rw/uml (2014-01-26 11:06:16 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 63c361f5114d81db789f8f5671c76c228c35b021:

  mac80211: propagate STBC / LDPC flags to radiotap (2014-02-06 09:34:58 +0=
100)

----------------------------------------------------------------
Andrei Otcheretianski (1):
      mac80211_hwsim: add channel switch support

Antonio Quartulli (1):
      cfg80211: fix channel configuration in IBSS join

Ard Biesheuvel (1):
      mac80211: drop unused param 'encrypted' from ccmp_special_blocks()

Chun-Yeow Yeoh (1):
      mac80211: fix the increment of mesh precedence value

Emmanuel Grumbach (3):
      mac80211: remove unused radiotap vendor fields in ieee80211_rx_status
      mac80211: move VHT related RX_FLAG to another variable
      mac80211: propagate STBC / LDPC flags to radiotap

Eyal Shapira (1):
      mac80211: advertise BF STS according to AP support

Ilan Peer (2):
      cfg80211: fix few minor issues in reg_process_hint()
      mac80211: Fix ROC duration =3D=3D 0 handling

Janusz Dziedzic (4):
      nl80211: add Guard Interval support for set_bitrate_mask
      cfg80211: set preset_chandef after channel switch
      cfg80211: add helper reg_get_regdomain() function
      cfg80211: regulatory introduce maximum bandwidth calculation

Johannes Berg (22):
      cfg80211: make connect ie param const
      nl80211: check channel switch validity better
      mac80211: mesh: remove mesh_id check
      mac80211: use sdata mesh_id_len instead of wdev's
      mac80211: fix agg_status debugfs file write
      mac80211: make rate control ops const
      mac80211: make cfg80211 ops and privid const
      nl80211: make netlink attribute policies const
      cfg80211: make device_type const
      mac80211_hwsim: make netlink policy const
      mac80211: minstrel_ht: sample_table can be __read_mostly
      mac80211: remove module handling from rate control ops
      mac80211_hwsim: make P2P-Device support optional
      nl80211: check nla_parse() return values
      mac80211: add length check in ieee80211_is_robust_mgmt_frame()
      nl80211: send event when AP operation is stopped
      nl80211: fix scheduled scan RSSI matchset attribute confusion
      mac80211: remove set but unused variables
      mac80211: fix bufferable MMPDU RX handling
      wireless: sort and extend element ID list
      mac80211: order IEs in probe request correctly
      mac80211: order IEs in association request correctly

Jouni Malinen (3):
      cfg80211: Allow BSS hint to be provided for connect
      cfg80211: Advertise maximum associated STAs in AP mode
      cfg80211: Clean up connect params and channel fetching

Karl Beldan (1):
      mac80211: send {ADD,DEL}BA on AC_VO like other mgmt frames, as per sp=
ec

Luciano Coelho (4):
      mac80211: refactor ieee80211_mesh_process_chanswitch()
      mac80211: align ieee80211_mesh_csa_beacon() with ieee80211_assign_bea=
con()
      mac80211: only set CSA beacon when at least one beacon must be transm=
itted
      mac80211: ibss: remove unnecessary call to release channel

Marek Kwaczynski (1):
      mac80211: update opmode when adding new station

Michal Kazior (6):
      mac80211: batch CSA bss info notification
      mac80211: fix possible memory leak on AP CSA failure
      mac80211: move csa_active setting in STA CSA
      mac80211: fix sdata->radar_required locking
      mac80211: add missing CSA locking
      cfg80211: consider existing DFS interfaces

Shaibal Dutta (2):
      net: wireless: move regulatory timeout work to power efficient workqu=
eue
      net: rfkill: move poll work to power efficient workqueue

Simon Wunderlich (1):
      mac80211: send ibss probe responses with noack flag

andrea merello (1):
      mac80211: add check on hw->max_signal value on ieee80211_register_hw

 drivers/net/wireless/ath/ath10k/txrx.c             |   4 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |  27 ++-
 drivers/net/wireless/ath/ath9k/rc.c                |   3 +-
 drivers/net/wireless/ath/wcn36xx/txrx.c            |   3 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |   5 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.h     |   2 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  50 ++---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   3 +-
 drivers/net/wireless/iwlegacy/3945-rs.c            |   3 +-
 drivers/net/wireless/iwlegacy/4965-rs.c            |   3 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c              |   4 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c              |   4 +-
 drivers/net/wireless/iwlwifi/mvm/rx.c              |   4 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c            |   3 +
 drivers/net/wireless/libertas/cfg.c                |   3 +-
 drivers/net/wireless/mac80211_hwsim.c              |  90 ++++----
 drivers/net/wireless/mac80211_hwsim.h              |   2 +
 drivers/net/wireless/mwifiex/cfg80211.c            |   8 +-
 drivers/net/wireless/mwifiex/main.h                |   2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c           |   2 +-
 drivers/net/wireless/rndis_wlan.c                  |   4 +-
 drivers/net/wireless/rtlwifi/rc.c                  |   3 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c       |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c       |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c       |   2 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c       |   2 +-
 include/linux/ieee80211.h                          | 199 ++++++++++++-----=
-
 include/net/cfg80211.h                             |  43 ++--
 include/net/ieee80211_radiotap.h                   |   4 +
 include/net/mac80211.h                             |  52 ++---
 include/uapi/linux/nl80211.h                       |  52 ++++-
 net/mac80211/agg-tx.c                              |   2 +-
 net/mac80211/cfg.c                                 | 198 ++++++++++++-----=
-
 net/mac80211/cfg.h                                 |   2 +-
 net/mac80211/chan.c                                |   2 +
 net/mac80211/debugfs_sta.c                         |   2 +-
 net/mac80211/ht.c                                  |   2 +-
 net/mac80211/ibss.c                                |  28 ++-
 net/mac80211/ieee80211_i.h                         |  14 +-
 net/mac80211/iface.c                               |   2 +
 net/mac80211/main.c                                |   9 +-
 net/mac80211/mesh.c                                |  96 +++------
 net/mac80211/mlme.c                                |  41 +++-
 net/mac80211/rate.c                                |  46 ++---
 net/mac80211/rate.h                                |   2 +-
 net/mac80211/rc80211_minstrel.c                    |   2 +-
 net/mac80211/rc80211_minstrel.h                    |   2 +-
 net/mac80211/rc80211_minstrel_ht.c                 |   7 +-
 net/mac80211/rc80211_pid_algo.c                    |   2 +-
 net/mac80211/rx.c                                  | 101 +++------
 net/mac80211/sta_info.h                            |   2 +
 net/mac80211/status.c                              |   3 +-
 net/mac80211/tx.c                                  |  33 ++-
 net/mac80211/util.c                                |  42 +++-
 net/mac80211/vht.c                                 |  26 ++-
 net/mac80211/wpa.c                                 |   9 +-
 net/rfkill/core.c                                  |   9 +-
 net/wireless/ap.c                                  |   3 +-
 net/wireless/chan.c                                |  23 ++-
 net/wireless/core.c                                |   2 +-
 net/wireless/core.h                                |   7 +-
 net/wireless/ibss.c                                |  19 +-
 net/wireless/mesh.c                                |   6 +-
 net/wireless/mlme.c                                |   2 +-
 net/wireless/nl80211.c                             | 229 ++++++++++++++++-=
----
 net/wireless/nl80211.h                             |   2 +
 net/wireless/reg.c                                 | 188 +++++++++++++----
 net/wireless/reg.h                                 |   2 +
 net/wireless/trace.h                               |  23 ++-
 net/wireless/util.c                                |   5 +-
 70 files changed, 1151 insertions(+), 634 deletions(-)


--=-rpxNmJebYGEnJdJ7W9M+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJS84FSAAoJEDBSmw7B7bqr/AkP/2conxyHkKMuTneImVIATgXt
gSJHPhuKlucHtpjw5EHH8S63XEg/pw3FnlDJeKgZjKguJqtahEnL0+GT3MTPowd/
3H+ttGF2VbPv9F9uRg0Z6cgbEEMK+EximB5TVHRDMtHzH75qTORMoo+/MCrioFPj
gHnUQlXGlnT6gfUJuj9oogmyhLTE9zXr2lbkQ03kr/ysN9vk2v7iNgSkhSmk6ffI
b5M1Td1PkU6T5Sm0yOw269hc/b75UpsRxx5KLTV5cnW5vvxcvQsc4Aw9R2CML2GE
FaIEJdIm7w4ifuVC1Sz+tSudBvk0sPzTmbARi9Zb6wKP2ENafsfwebJqcDHtVqsl
cXLnAPkmXqG1vqu0q5EhLv9Eq3ISJJn1GfXutRZBX42NAPhCbAS5hOrDW/TIv/x9
I5Gc5vylrWwxaRgmwD/EA/JILutQmAXnrUFtuVi2NUlWSTBZklOXcTCaOG8hxsYa
ZmXI5lATw14QUa2fshR1BfEztyziZaLciyFlsaU7VQvw4Wq9WhuJvxNqX5FsqMcN
fEe6sF+Txv9pC4zUU392ovznnHIGCdUiY2qAjPwE28U11sj7biQd+LEJRhGZzKaL
jxz4ItSTiIrvh474u1+dS2qvdlC0KI+2ZIqHJI76lalB4pLlPGCCwJBwjcOVLK/2
Fdkoo+/RHuucNLSsPM2L
=Wo/k
-----END PGP SIGNATURE-----

--=-rpxNmJebYGEnJdJ7W9M+--

