Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52679 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab2INMsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 08:48:36 -0400
Message-ID: <1347626944.4060.7.camel@jlt4.sipsolutions.net> (sfid-20120914_144858_559019_1E813C7B)
Subject: pull-request: mac80211-next 2012-09-14
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 14 Sep 2012 14:49:04 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-3b7Y9p6IkdpmHFJDYOwQ"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3b7Y9p6IkdpmHFJDYOwQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

It's been a while since my last pull request, but I've collected a
number of patches. Depending on when the merge window opens this might
be my last non-fixes pull request for this tree.

So, what do we have here?

Eliad sped up roaming by not using synchronize_rcu() as much, deferring
station freeing to an RCU callback.

Antonio ("ordex") improved IBSS auth frame handling, in particular
sending a deauth in failure cases. Should be rare though.

Felix fixed an issue with using skb->dev after the dev might have
disappeared.

Chun-Yeow fixed an issue with mesh peer link blocking.

The first patch included here from Michal refactors some code in
preparation for the multi-channel work.

Finally, Peter, Wei and myself have cleanups, small improvements and
preparations for multi-channel as well as a fix for country/power
constraint IE handling that caused us to use much too low power in some
scenarios.

Please pull :-)

Thanks,
johannes

------------

The following changes since commit 768be59f30f2ee8958ba3718101162c694efab12=
:

  cfg80211: fix indentation (2012-09-05 16:54:05 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 9385d04f2872057a2029901190391fe192b18693:

  mac80211: allow re-open the blocked peer link in mesh (2012-09-14 14:25:1=
6 +0200)

----------------------------------------------------------------
Antonio Quartulli (2):
      mac80211: move ieee80211_send_deauth_disassoc outside mlme code
      mac80211: reply to AUTH with DEAUTH if sta allocation fails in IBSS

Chun-Yeow Yeoh (1):
      mac80211: allow re-open the blocked peer link in mesh

Eliad Peller (2):
      mac80211: use synchronize_net() on key destroying
      mac80211: use call_rcu() on sta deletion

Felix Fietkau (1):
      mac80211: validate skb->dev in the tx status path

Johannes Berg (11):
      Merge remote-tracking branch 'mac80211/master' into mac80211-next
      mac80211: don't hang on to sched_scan_ies
      mac80211: disconnect if channel switch fails
      Merge remote-tracking branch 'wireless-next/master' into mac80211-nex=
t
      wireless: remove obsolete chan no/center freq conversion functions
      mac80211_hwsim: move module_init/exit
      mac80211: check power constraint IE size when parsing
      mac80211: add key flag for management keys
      mac80211: remove unneeded CONFIG_PM ifdef
      mac80211: handle power constraint/country IE better
      mac80211: change locking around ieee80211_recalc_smps

Michal Kazior (1):
      mac80211: refactor set_channel_type

Peter Senna Tschudin (1):
      net/mac80211/scan.c: removes unnecessary semicolon

Wei Yongjun (1):
      mac80211: use list_move instead of list_del/list_add

 Documentation/networking/ip-sysctl.txt             |    6 -
 drivers/bcma/Kconfig                               |    4 +-
 drivers/bcma/bcma_private.h                        |    2 +
 drivers/bcma/driver_chipcommon_nflash.c            |   28 +-
 drivers/bcma/driver_chipcommon_pmu.c               |    4 +-
 drivers/bcma/driver_chipcommon_sflash.c            |  123 ++-
 drivers/bcma/driver_mips.c                         |    6 +-
 drivers/bcma/host_pci.c                            |   11 +-
 drivers/bcma/host_soc.c                            |    2 +-
 drivers/bcma/main.c                                |   17 +
 drivers/bcma/scan.c                                |   15 +-
 drivers/bluetooth/bcm203x.c                        |    8 +-
 drivers/bluetooth/bfusb.c                          |   12 +-
 drivers/bluetooth/bluecard_cs.c                    |    5 +-
 drivers/bluetooth/bpa10x.c                         |    8 +-
 drivers/bluetooth/bt3c_cs.c                        |    5 +-
 drivers/bluetooth/btmrvl_sdio.c                    |   15 +-
 drivers/bluetooth/btsdio.c                         |    8 +-
 drivers/bluetooth/btuart_cs.c                      |    5 +-
 drivers/bluetooth/btusb.c                          |   13 +-
 drivers/bluetooth/btwilink.c                       |    8 +-
 drivers/bluetooth/dtl1_cs.c                        |    3 +-
 drivers/isdn/hardware/mISDN/avmfritz.c             |    7 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |    3 +-
 drivers/net/ethernet/broadcom/tg3.c                |   71 +-
 drivers/net/ethernet/broadcom/tg3.h                |    8 +-
 drivers/net/ethernet/qlogic/qlge/qlge_main.c       |    1 +
 drivers/net/ethernet/seeq/seeq8005.c               |    4 +-
 drivers/net/tun.c                                  |    6 +-
 drivers/net/usb/kaweth.c                           |    2 +-
 drivers/net/wireless/ath/ath5k/ath5k.h             |    2 +-
 drivers/net/wireless/ath/ath5k/base.c              |    5 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |    6 +-
 drivers/net/wireless/ath/ath5k/phy.c               |   43 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |  149 ++--
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   31 +-
 drivers/net/wireless/ath/ath9k/main.c              |    2 +-
 drivers/net/wireless/ath/ath9k/rc.c                |  812 +++++++++-------=
----
 drivers/net/wireless/ath/ath9k/rc.h                |    4 -
 drivers/net/wireless/ath/carl9170/carl9170.h       |    1 +
 drivers/net/wireless/ath/carl9170/fw.c             |    1 +
 drivers/net/wireless/ath/carl9170/mac.c            |    2 +-
 drivers/net/wireless/ath/carl9170/main.c           |    4 +-
 drivers/net/wireless/ath/carl9170/rx.c             |   16 +-
 drivers/net/wireless/b43/Makefile                  |    1 +
 drivers/net/wireless/b43/b43.h                     |   10 +-
 drivers/net/wireless/b43/main.c                    |   51 +-
 drivers/net/wireless/b43/phy_common.c              |   17 +-
 drivers/net/wireless/b43/phy_common.h              |    6 +
 drivers/net/wireless/b43/phy_n.c                   |  668 +++++++++++++++-
 drivers/net/wireless/b43/phy_n.h                   |    1 +
 drivers/net/wireless/b43/radio_2057.c              |  141 ++++
 drivers/net/wireless/b43/radio_2057.h              |  430 +++++++++++
 drivers/net/wireless/b43/tables_nphy.c             |   75 ++
 drivers/net/wireless/b43/tables_nphy.h             |   10 +
 drivers/net/wireless/b43legacy/main.c              |    2 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    4 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   13 +-
 .../net/wireless/brcm80211/include/brcmu_wifi.h    |    5 -
 drivers/net/wireless/iwlegacy/common.c             |   15 +-
 drivers/net/wireless/iwlegacy/common.h             |    2 -
 drivers/net/wireless/iwlwifi/dvm/agn.h             |    9 +-
 drivers/net/wireless/iwlwifi/dvm/debugfs.c         |   56 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |    2 +-
 drivers/net/wireless/iwlwifi/dvm/main.c            |   24 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c              |    2 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c             |  141 +++-
 drivers/net/wireless/iwlwifi/iwl-drv.h             |    6 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h         |    3 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h           |   12 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c            |    6 +
 drivers/net/wireless/iwlwifi/pcie/internal.h       |    1 +
 drivers/net/wireless/iwlwifi/pcie/rx.c             |   16 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c          |   28 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c             |   26 +-
 drivers/net/wireless/mac80211_hwsim.c              |   10 +-
 drivers/net/wireless/mwifiex/11n.c                 |   26 +
 drivers/net/wireless/mwifiex/11n.h                 |   15 +
 drivers/net/wireless/mwifiex/11n_aggr.c            |   14 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c       |   66 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.h       |    5 +
 drivers/net/wireless/mwifiex/Makefile              |    2 +
 drivers/net/wireless/mwifiex/cfg80211.c            |   17 +-
 drivers/net/wireless/mwifiex/cmdevt.c              |    5 +-
 drivers/net/wireless/mwifiex/decl.h                |    3 +
 drivers/net/wireless/mwifiex/fw.h                  |   42 +-
 drivers/net/wireless/mwifiex/init.c                |  107 +--
 drivers/net/wireless/mwifiex/ioctl.h               |    5 +-
 drivers/net/wireless/mwifiex/main.c                |    3 +
 drivers/net/wireless/mwifiex/main.h                |   38 +-
 drivers/net/wireless/mwifiex/scan.c                |    6 +-
 drivers/net/wireless/mwifiex/sta_cmd.c             |   55 +-
 drivers/net/wireless/mwifiex/sta_event.c           |   64 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c           |   12 +-
 drivers/net/wireless/mwifiex/sta_rx.c              |   38 +-
 drivers/net/wireless/mwifiex/txrx.c                |    5 +
 drivers/net/wireless/mwifiex/uap_cmd.c             |    1 +
 drivers/net/wireless/mwifiex/uap_event.c           |  290 +++++++
 drivers/net/wireless/mwifiex/uap_txrx.c            |  255 ++++++
 drivers/net/wireless/mwifiex/wmm.c                 |   59 +-
 drivers/net/wireless/p54/eeprom.c                  |  108 ++-
 drivers/net/wireless/p54/eeprom.h                  |   12 +
 drivers/net/wireless/p54/p54pci.c                  |   88 ++-
 drivers/net/wireless/p54/p54pci.h                  |    1 +
 drivers/ssb/driver_mipscore.c                      |   28 +-
 include/linux/bcma/bcma_driver_chipcommon.h        |  111 +++
 include/linux/bcma/bcma_regs.h                     |    4 +
 include/linux/ieee80211.h                          |   80 --
 include/linux/ssb/ssb_driver_chipcommon.h          |    4 +-
 include/net/bluetooth/bluetooth.h                  |   10 +
 include/net/bluetooth/hci.h                        |   11 +
 include/net/bluetooth/hci_core.h                   |   22 +-
 include/net/bluetooth/l2cap.h                      |   17 +-
 include/net/bluetooth/smp.h                        |    8 +-
 include/net/cfg80211.h                             |    2 +
 include/net/inet_sock.h                            |    9 +
 include/net/ip_fib.h                               |    6 +-
 include/net/mac80211.h                             |   12 +-
 include/net/netns/ipv4.h                           |    2 -
 include/net/route.h                                |    3 +
 net/bluetooth/a2mp.c                               |   16 +-
 net/bluetooth/af_bluetooth.c                       |  141 ++++
 net/bluetooth/bnep/sock.c                          |   22 +-
 net/bluetooth/cmtp/sock.c                          |   23 +-
 net/bluetooth/hci_core.c                           |    6 +-
 net/bluetooth/hci_event.c                          |   93 +--
 net/bluetooth/hci_sock.c                           |   13 +-
 net/bluetooth/hidp/sock.c                          |   22 +-
 net/bluetooth/l2cap_core.c                         |   32 +-
 net/bluetooth/l2cap_sock.c                         |   22 +-
 net/bluetooth/mgmt.c                               |   34 +-
 net/bluetooth/rfcomm/sock.c                        |   14 +-
 net/bluetooth/sco.c                                |   16 +-
 net/bridge/br_sysfs_if.c                           |    6 +-
 net/core/rtnetlink.c                               |   16 +-
 net/ipv4/fib_frontend.c                            |    1 +
 net/ipv4/fib_semantics.c                           |   42 +-
 net/ipv4/fib_trie.c                                |   53 +-
 net/ipv4/ip_input.c                                |    2 -
 net/ipv4/route.c                                   |  183 +++--
 net/ipv4/sysctl_net_ipv4.c                         |   11 -
 net/ipv4/tcp.c                                     |    5 +-
 net/ipv4/tcp_input.c                               |    6 +-
 net/ipv4/tcp_ipv4.c                                |   20 +-
 net/ipv4/tcp_minisocks.c                           |    2 +-
 net/ipv4/xfrm4_policy.c                            |    1 +
 net/ipv6/ip6_input.c                               |    2 -
 net/ipv6/route.c                                   |    8 +-
 net/mac80211/cfg.c                                 |   43 +-
 net/mac80211/chan.c                                |   67 +-
 net/mac80211/ibss.c                                |   33 +-
 net/mac80211/ieee80211_i.h                         |   23 +-
 net/mac80211/iface.c                               |   15 +-
 net/mac80211/key.c                                 |    2 +-
 net/mac80211/main.c                                |   10 +-
 net/mac80211/mesh.c                                |   24 +-
 net/mac80211/mesh.h                                |    2 +-
 net/mac80211/mesh_plink.c                          |   47 +-
 net/mac80211/mlme.c                                |  211 ++---
 net/mac80211/offchannel.c                          |    3 +-
 net/mac80211/scan.c                                |   44 +-
 net/mac80211/sta_info.c                            |  121 +--
 net/mac80211/sta_info.h                            |    2 +
 net/mac80211/status.c                              |   48 +-
 net/mac80211/tx.c                                  |   40 +-
 net/mac80211/util.c                                |   51 +-
 net/openvswitch/actions.c                          |    3 -
 net/wireless/nl80211.c                             |    4 +-
 net/wireless/reg.c                                 |   19 +-
 170 files changed, 4814 insertions(+), 1764 deletions(-)
 create mode 100644 drivers/net/wireless/b43/radio_2057.c
 create mode 100644 drivers/net/wireless/b43/radio_2057.h
 create mode 100644 drivers/net/wireless/mwifiex/uap_event.c
 create mode 100644 drivers/net/wireless/mwifiex/uap_txrx.c


--=-3b7Y9p6IkdpmHFJDYOwQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQUyfAAAoJEDBSmw7B7bqreA4P/irxkqjVL7bhOiwj02jT8GLM
DKXg+EPqQBnjOVAvpOYywBV6G6e1ZfN8NqzZK0fW+SJTrAacqPWnn3Bmy+MPlGL3
ctcbh/IbR68JokfJESoKFFs6nRCoW/R5YbQ9Bgpor73suVjBKfdZi1039DaFhm9h
PyVzJBUkR2Sd0qKc3HKLTWXLTMiaFymj83GUpgWJ7lMdQRF0fxRSjg1AGllLk2Hk
9mj01riYGu80huisXNgCYuIFEWxFl2hN3kw7J/sJDnJm+5uCyAZ+Lac5GLat4o78
yhmPHuKkVabaDO9AfMkgJuKzB0bpznZEEmcU0GDxFeMzkKdzuWJTieOYF7yoXwD2
J3VDoOmIzHYcuHbwAqlKcGruVBd9NNP3flOh5zxSNfzrzqD6jQmOr518UJW6eOG4
YLxUgTR3O2YXxrsXNekzRXDY7Y1G2RV5b+eqjgwaG64EIF3sR3A1+YhWYWT5kJJe
pH2MimgGvZGJolIjBh6gSU7GILjead6uWfNZ9bSSWNED+kJIgYFf4ucNp9wM6sgk
bTXsO3GGZSpmJlNcN7+1C2p9jP0HKaBqSylqfXG6Yoh0HnRyvhAoJe+af3w7Lus8
o725cFwGvreoIVs1nJDVOlhJRsxbUY1nfbrUM0ndF6Kth+tTEaGfCQGsE/ugCkTy
jNyfN4NyMwl2kmGqGLGU
=jxCm
-----END PGP SIGNATURE-----

--=-3b7Y9p6IkdpmHFJDYOwQ--

