Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52581 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab3DHLje (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 07:39:34 -0400
Message-ID: <1365421170.25475.9.camel@jlt4.sipsolutions.net> (sfid-20130408_133938_475100_520E73DD)
Subject: pull-request: mac80211-next 2013-04-08
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 08 Apr 2013 13:39:30 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-JOBRaQa7VsNv7h8wAvLu"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JOBRaQa7VsNv7h8wAvLu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Here's another big pull request for the -next stream. This one has a ton
of driver updates, which hopefully addresses all drivers, but maybe you
have more new drivers than I have in my tree? Not entirely sure, let me
know if this is the case and then I can merge wireless-next.

I'm including a large number of small changes, see the shortlog. The two
bigger things are making VHT compatible with not using channel contexts
(from Karl) and the stop-while-suspended fixes I developed together with
Stanislaw.

Let me know if there are any problems.

johannes



The following changes since commit f00f188f8212fec9976394976c4fd5d4a3bc4dcf=
:

  cfg80211: fix error return code in cfg80211_init() (2013-03-20 14:09:56 +=
0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to ddc4db2e3d5393ede7a9222bb3b7522a603a4678:

  mac80211: make ieee802_11_parse_elems an inline (2013-04-08 11:08:32 +020=
0)

----------------------------------------------------------------
Alexander Bondar (2):
      mac80211: allow drivers to set default uAPSD parameters
      mac80211: disable uAPSD if all ACs are under ACM

Ben Greear (3):
      mac80211: make beacon-loss-count configurable
      mac80211: add beacon stats to debugfs
      mac80211: be more careful about sending beacon-loss-events

Bob Copeland (1):
      mac80211: return new mpath from mesh_path_add()

Chun-Yeow Yeoh (1):
      mac80211: fix the PREP mesh hwmp debug message

Emmanuel Grumbach (1):
      mac80211: return the RSSI in dBm

Janusz Dziedzic (3):
      cfg80211: add P2P Notice of Absence attribute
      mac80211: use ieee80211_p2p_noa_attr structure
      mac80211: add P2P NoA settings

Johannes Berg (15):
      mac80211: ibss: disable beaconing before freeing beacon
      mac80211: ibss: use beacon_data struct for beacon and probe response
      mac80211: remove ancient reference to master interface
      mac80211: remove unused IE pointers from parser
      mac80211: check DSSS params IE length in parser
      mac80211: check ERP info IE length in parser
      mac80211: parse Timeout Interval Element using a struct
      mac80211: remove outdated comment referring to master interface
      mac80211: purge remain-on-channel items when suspending
      mac80211: destroy virtual monitor interface across suspend
      mac80211: fix do_stop handling while suspended
      mac80211: don't fiddle with netdev queues in MLME code
      mac80211: replace some dead code by a warning
      mac80211: don't start new netdev queues if driver stopped
      mac80211: make ieee802_11_parse_elems an inline

Jouni Malinen (1):
      cfg80211: Document update_ft_ies() cfg80211_ops

Karl Beldan (3):
      mac80211: Use a cfg80211_chan_def in ieee80211_hw_conf_chan
      mac80211: let drivers not supporting channel contexts use VHT
      mac80211_hwsim: advertise VHT support also when channels =3D=3D 1

 drivers/net/wireless/adm8211.c                     |   3 +-
 drivers/net/wireless/at76c50x-usb.c                |   4 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |  14 +--
 drivers/net/wireless/ath/ath5k/base.c              |   2 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |   4 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |   2 +-
 drivers/net/wireless/ath/ath9k/calib.c             |   2 +-
 drivers/net/wireless/ath/ath9k/common.c            |   5 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |  16 +--
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   8 +-
 drivers/net/wireless/ath/ath9k/hw.c                |   5 +-
 drivers/net/wireless/ath/ath9k/link.c              |   2 +-
 drivers/net/wireless/ath/ath9k/main.c              |  10 +-
 drivers/net/wireless/ath/ath9k/rc.c                |   4 +-
 drivers/net/wireless/ath/ath9k/recv.c              |   6 +-
 drivers/net/wireless/ath/carl9170/debug.c          |   5 +-
 drivers/net/wireless/ath/carl9170/mac.c            |   8 +-
 drivers/net/wireless/ath/carl9170/main.c           |   9 +-
 drivers/net/wireless/ath/carl9170/phy.c            |   4 +-
 drivers/net/wireless/b43/b43.h                     |   2 +-
 drivers/net/wireless/b43/main.c                    |   8 +-
 drivers/net/wireless/b43/phy_ht.c                  |   5 +-
 drivers/net/wireless/b43/phy_lcn.c                 |   5 +-
 drivers/net/wireless/b43/phy_n.c                   |   5 +-
 drivers/net/wireless/b43legacy/main.c              |   9 +-
 drivers/net/wireless/brcm80211/brcmsmac/channel.c  |   4 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   6 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   4 +-
 drivers/net/wireless/iwlegacy/3945-rs.c            |   2 +-
 drivers/net/wireless/iwlegacy/4965-rs.c            |   2 +-
 drivers/net/wireless/iwlegacy/common.c             |   2 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c              |   2 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c            |   9 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c        |  12 +-
 drivers/net/wireless/libertas_tf/main.c            |   8 +-
 drivers/net/wireless/mac80211_hwsim.c              |  45 ++++---
 drivers/net/wireless/mwl8k.c                       |  36 +++---
 drivers/net/wireless/p54/fwio.c                    |   4 +-
 drivers/net/wireless/p54/main.c                    |   4 +-
 drivers/net/wireless/p54/txrx.c                    |   4 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |   8 +-
 drivers/net/wireless/rt2x00/rt2x00config.c         |  10 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |   2 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |   2 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c         |   4 +-
 drivers/net/wireless/rtl818x/rtl8180/grf5101.c     |   3 +-
 drivers/net/wireless/rtl818x/rtl8180/max2820.c     |   2 +-
 drivers/net/wireless/rtl818x/rtl8180/rtl8225.c     |   3 +-
 drivers/net/wireless/rtl818x/rtl8180/sa2400.c      |   3 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c         |   4 +-
 drivers/net/wireless/rtl818x/rtl8187/rtl8225.c     |   3 +-
 drivers/net/wireless/rtlwifi/base.c                |   4 +-
 drivers/net/wireless/rtlwifi/core.c                |   6 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c       |   4 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c       |   8 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c       |   4 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c       |   4 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c       |   4 +-
 drivers/net/wireless/ti/wl1251/main.c              |   5 +-
 drivers/net/wireless/ti/wlcore/main.c              |   2 +-
 drivers/net/wireless/zd1211rw/zd_mac.c             |   4 +-
 include/linux/ieee80211.h                          |  30 +++++
 include/net/cfg80211.h                             |   4 +
 include/net/mac80211.h                             |  37 ++++--
 net/mac80211/cfg.c                                 |  42 ++++---
 net/mac80211/chan.c                                |  11 +-
 net/mac80211/debugfs_netdev.c                      |  11 ++
 net/mac80211/debugfs_sta.c                         |   2 +
 net/mac80211/ibss.c                                | 140 ++++++++++-------=
----
 net/mac80211/ieee80211_i.h                         |  35 +++---
 net/mac80211/iface.c                               | 116 +++++++++++------
 net/mac80211/main.c                                |  75 ++++++-----
 net/mac80211/mesh.c                                |   2 +-
 net/mac80211/mesh.h                                |   3 +-
 net/mac80211/mesh_hwmp.c                           |  26 ++--
 net/mac80211/mesh_pathtbl.c                        |  56 ++++-----
 net/mac80211/mlme.c                                | 128 ++++++++++-------=
--
 net/mac80211/offchannel.c                          |   6 +-
 net/mac80211/pm.c                                  |   8 +-
 net/mac80211/scan.c                                |  11 +-
 net/mac80211/trace.h                               |  43 +++----
 net/mac80211/tx.c                                  |  11 +-
 net/mac80211/util.c                                |  53 +++-----
 83 files changed, 674 insertions(+), 556 deletions(-)


--=-JOBRaQa7VsNv7h8wAvLu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRYqxyAAoJEDBSmw7B7bqrQrcP/29Ah9mKWq2b9s84QuhtDtNl
Ft2p0+ABGuSujRaq0RI/IcTGpEFvz2P2rhn/A7Rv6dzGGlWnvz4POsPdEUuRN0ST
/3baRm4IVIRg238T3RV/qOuO2glT4tPUsEkYtD7Khab8zt9ckEwZpUuczOsIavCY
/TuT1TLbtJkrjRTpGVP104xcb9Fk3OPgHUDLqWSrqqa6pfnMMrU3AwAsK6hFK1LB
pqhSsW9BdmXq3zXlLBMhPAspmpWQmTVoRs1nLVj2PGYsvnFPuoSB9OvSIFF1CNTa
coghboblM+cTy8G5YEb/n+cy3E2ddumxGsin1EYcmtKH/cFqG/WAtkNyswYKXHJo
FkkdIuzKfUmPo7GHjNUtK0pdnoX6OSCx9aoALGGFeRYRMB3ph1uQE6smNUcar0na
sPa8c5ub4dyMwKRnuwESQQ+vEUhWzPjAcPl6q6jqo1AF97d1zhGEfavhidx5R606
zgkSqZBFUwAFZPruYU/zktg/RiSjJMrZbK9RCqvfR97Ex+SogEXRYYOpdrJvhZgH
WC5z/ZmXXIqQ+M6Zy93BNRq8zr2GzIXi6IYEKV5sapDd+Cu5oK/d1mU5fAOvcSjs
TvM39s+8CjkjwNIW64c+1DvYf+yKEZvzxgJSIUc4Hi7fcuRejtRs3uK4D5otzJ/U
3VUk2mrLrNPbTeLlTrSm
=9mzw
-----END PGP SIGNATURE-----

--=-JOBRaQa7VsNv7h8wAvLu--

