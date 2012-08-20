Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36478 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab2HTMa5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 08:30:57 -0400
Message-ID: <1345465849.4459.27.camel@jlt3.sipsolutions.net> (sfid-20120820_143102_461444_CC1C252B)
Subject: pull-request: mac80211-next 2012-08-20
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 20 Aug 2012 14:30:49 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-QjJv3GrIy34X7IYHj0vl"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QjJv3GrIy34X7IYHj0vl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Here's my promised post-vacation pull request for new features.

I've included two fixes for wlcore which should've gone to your tree but
were required for the major TX API rework from Thomas Huehn.

Also included is the second VHT patch, to include VHT capabilities in
association, from Mahesh Palivela.

Aside from a multitude of random cleanups and small fixes from various
people including myself, those being mostly preparations for our multi-
channel work, I've also finally included the P2P Device abstraction work
that makes it possible to use a separate virtual interface for P2P
Device work for those devices that need it (for whatever reason,
sometimes just for MAC address assignment.)

There's a small merge conflict with your tree in hwsim, but very easy to
resolve, my tree modifies some code that was removed already. Please
pull and let me know if there are any problems.

johannes


The following changes since commit 173f8654746c138a08f51a8a0db7747763a896a2=
:

  Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/g=
it/tytso/ext4 (2012-07-27 20:52:25 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to dcf33963c48e1959c83fda84e336dbb000eefa3f:

  mac80211: clean up ieee80211_subif_start_xmit (2012-08-20 14:13:46 +0200)

----------------------------------------------------------------
Antonio Quartulli (1):
      mac80211: add supported rates change notification in IBSS

Arik Nemtsov (2):
      wlcore: don't get the hlid from a queued skb
      wlcore: op_tx: pass sta explicitly when inferring frame hlid

Chun-Yeow Yeoh (1):
      mac80211: don't re-init rate control when receiving mesh beacon

Eliad Peller (1):
      mac80211: add PS flag to bss_conf

Emmanuel Grumbach (1):
      mac80211: don't call mgd_prepare_tx when associated

Eyal Shapira (1):
      mac80211: avoid using synchronize_rcu in ieee80211_set_probe_resp

Johannes Berg (36):
      mac80211: don't react to beacon loss if HW monitoring
      mac80211: supress HT/VHT disable if not supported
      mac80211: rename sta to new_sta
      mac80211: set channel only once during auth/assoc
      mac80211: use oper_channel in mesh
      mac80211: use oper_channel in ibss
      mac80211: use oper_channel in managed mlme
      mac80211: use oper_channel in utils and config
      mac80211: fix current vs. operating channel in preq/beacon
      mac80211: use correct channel in TX
      mac80211: manage carrier state in mesh
      mac80211: enable WDS carrier only after adding station
      mac80211: use eth_broadcast_addr
      mac80211: reset station MLME flags upon new association
      wireless: add radiotap A-MPDU status field
      mac80211: support A-MPDU status reporting
      mac80211: remove unneeded 'bssid' variable
      mac80211: clean up CSA handling code
      mac80211: fix CSA handling timer
      mac80211: check size of channel switch IE when parsing
      mac80211: make ieee80211_beacon_connection_loss_work static
      cfg80211: add P2P Device abstraction
      mac80211: support P2P Device abstraction
      mac80211: add IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF
      mac80211_hwsim: add support for P2P Device
      mac80211: simplify buffers in aes_128_cmac_vector
      mac80211: mesh: don't use global channel type
      mac80211: remove almost unused local variable
      mac80211: remove freq/chantype from debugfs
      mac80211: use oper_channel in rate init
      mac80211: don't assume channel is set in tracing
      mac80211: use RX status band instead of current band
      mac80211: check operating channel in scan
      mac80211: convert ops checks to WARN_ON
      mac80211: pass channel to ieee80211_send_probe_req
      mac80211: clean up ieee80211_subif_start_xmit

Mahesh Palivela (1):
      mac80211: VHT (11ac) association

Thomas Huehn (1):
      mac80211: move TX station pointer and restructure TX

Thomas Pedersen (6):
      mac80211: improve cleanup when leaving mesh
      mac80211: remove ieee80211_clean_sdata()
      mac80211: don't request ack for peering close
      mac80211: skb leak in mesh_plink_frame_tx()
      mac80211: use skb_queue_walk() in mesh_path_assign_nexthop
      mac80211: clean up mpath_move_to_queue()

Vladimir Kondratiev (1):
      cfg80211: unify IE search

 drivers/net/wireless/adm8211.c                     |    4 +-
 drivers/net/wireless/at76c50x-usb.c                |    4 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |    3 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |    1 +
 drivers/net/wireless/ath/ath9k/htc.h               |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |    6 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |    2 +-
 drivers/net/wireless/ath/ath9k/main.c              |    5 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |    9 +-
 drivers/net/wireless/ath/carl9170/carl9170.h       |    4 +-
 drivers/net/wireless/ath/carl9170/tx.c             |   16 +-
 drivers/net/wireless/b43/main.c                    |    3 +-
 drivers/net/wireless/b43legacy/main.c              |    1 +
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    6 +-
 drivers/net/wireless/iwlegacy/3945-mac.c           |   12 +-
 drivers/net/wireless/iwlegacy/4965-mac.c           |   26 +-
 drivers/net/wireless/iwlegacy/4965.h               |    8 +-
 drivers/net/wireless/iwlwifi/dvm/agn.h             |    4 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |    6 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c              |   16 +-
 drivers/net/wireless/libertas_tf/main.c            |    4 +-
 drivers/net/wireless/mac80211_hwsim.c              |   12 +-
 drivers/net/wireless/mwl8k.c                       |   17 +-
 drivers/net/wireless/p54/lmac.h                    |    4 +-
 drivers/net/wireless/p54/main.c                    |    2 +-
 drivers/net/wireless/p54/txrx.c                    |   15 +-
 drivers/net/wireless/rt2x00/rt2x00.h               |    4 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |    4 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |   20 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c         |    6 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c         |    6 +-
 drivers/net/wireless/rtlwifi/base.c                |    3 +-
 drivers/net/wireless/rtlwifi/core.c                |    8 +-
 drivers/net/wireless/rtlwifi/pci.c                 |   16 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c       |    5 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h       |    1 +
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c       |    5 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.h       |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c       |    5 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.h       |    1 +
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c       |    5 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.h       |    1 +
 drivers/net/wireless/rtlwifi/usb.c                 |   15 +-
 drivers/net/wireless/rtlwifi/wifi.h                |   13 +-
 drivers/net/wireless/ti/wl1251/main.c              |    4 +-
 drivers/net/wireless/ti/wlcore/main.c              |    6 +-
 drivers/net/wireless/ti/wlcore/tx.c                |   61 +++--
 drivers/net/wireless/ti/wlcore/tx.h                |    4 +-
 drivers/net/wireless/zd1211rw/zd_mac.c             |    6 +-
 drivers/staging/winbond/wbusb.c                    |    4 +-
 include/linux/nl80211.h                            |   30 +-
 include/net/cfg80211.h                             |   40 ++-
 include/net/ieee80211_radiotap.h                   |   11 +
 include/net/mac80211.h                             |   87 ++++--
 net/mac80211/aes_cmac.c                            |    6 +-
 net/mac80211/cfg.c                                 |   68 +++--
 net/mac80211/debugfs.c                             |   32 ---
 net/mac80211/driver-ops.h                          |   11 +-
 net/mac80211/ibss.c                                |   15 +-
 net/mac80211/ieee80211_i.h                         |   30 +-
 net/mac80211/iface.c                               |  289 ++++++++++++----=
----
 net/mac80211/main.c                                |   21 +-
 net/mac80211/mesh.c                                |   28 +-
 net/mac80211/mesh.h                                |    3 +
 net/mac80211/mesh_hwmp.c                           |    2 -
 net/mac80211/mesh_pathtbl.c                        |   44 ++-
 net/mac80211/mesh_plink.c                          |   38 ++-
 net/mac80211/mlme.c                                |  240 ++++++++++------
 net/mac80211/offchannel.c                          |    6 +
 net/mac80211/rate.h                                |    2 +-
 net/mac80211/rx.c                                  |   58 +++-
 net/mac80211/scan.c                                |   12 +-
 net/mac80211/status.c                              |   22 +-
 net/mac80211/trace.h                               |   11 +-
 net/mac80211/tx.c                                  |   71 ++---
 net/mac80211/util.c                                |   57 ++--
 net/wireless/chan.c                                |    7 +-
 net/wireless/core.c                                |   53 +++-
 net/wireless/mlme.c                                |   10 +-
 net/wireless/nl80211.c                             |  122 ++++++++-
 net/wireless/radiotap.c                            |    2 +
 net/wireless/util.c                                |   36 +--
 84 files changed, 1247 insertions(+), 619 deletions(-)


--=-QjJv3GrIy34X7IYHj0vl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQMi35AAoJEDBSmw7B7bqrsBcP/R96S4hoXFWQNb2IWvwkYU85
+d3vvrUhY1MfFi85JnyeCiNqyycl0JUI7T/YXcfOU/Q1715oXj2FcP4/lCQfzKsK
b7qhhCNKIi0y2Li5qgdanhA5Ih3BPRS8NcCUmRks3nWrlQ6ZamvMIOXmiP6d1ebc
NzpetcJNb2Xl+sOg2A9ep5jSDsRBvkVOymaoSHceN4rwl99ZHbj6WApmgt2ZCj90
0sdK9PdV6iQ0T4sVwLG2ON3+uDrwL+ZbNwtlwmkU95435Bdqdvpp2r12jRpbBmqo
xXfsvI3HXYWqZNtGthQ+uIUaL/skgXpkQnfzicqLjB/PFQFtDCXAJwt/XOLq25a6
W6mzjoAQE9JcuNz2qo+OOAjAGStkxwMj+LfXoX1L4YpYRJfkIEdtVqcN+XXAnu3L
qXwKyqx3DFKSghuLAwMOv5vOecDxhiEwfOA6yiw/wKgr5sHYLQoV8Um/iH+P35JQ
nwQszCFyKfvInmBO5eHBJ0LjJoJke6PuZ0Pur2+n/1IXsSTpJe+8Sdgpk24QZnjn
UFXbEZHLbWIeYZCzCv4/D5ZEHp2o+MqW2hSNWOdgY/uKj7ZkbFAoVJEJAfa9cpdd
RvONBOR0Eh6HlKeMklBW76lQqGSVBkFdVCKXrSnsJ541QIPxBIK6gVmO/SvJXw1f
VOLlkDUmDyybaafbODvj
=CeUB
-----END PGP SIGNATURE-----

--=-QjJv3GrIy34X7IYHj0vl--

