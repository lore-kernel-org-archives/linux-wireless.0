Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:65053 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbaBQNXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 08:23:11 -0500
Received: by mail-ea0-f170.google.com with SMTP id g15so5434916eak.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 05:23:08 -0800 (PST)
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
	jan-niklas.meier@volkswagen.de, Rostislav Lisovy <lisovy@gmail.com>
Subject: [RFC 0/4] mac80211 & ath9k: ITS-G5 (IEEE 802.11p) basic support
Date: Mon, 17 Feb 2014 14:22:50 +0100
Message-Id: <1392643374-3545-1-git-send-email-lisovy@gmail.com> (sfid-20140217_142316_412792_8EA6E9C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch-set is a RFC of the ongoing work of adding main features of
the Intelligent Transport Systems (ITS) G5 standard into the Linux
kernel. ITS-G5 is the European version of the car2car DSRC wireless
communication protocol stack. It uses the OCB mode defined in IEEE
802.11p. To access the medium the so called DCC (Decentralized
Congestion Control Mechanism) is used -- that is slightly modified
combination of the 802.11e EDCA, Transmit Rate Control (TRC), Transmit
Datarate Control (TDC) and per packet Transmit Power Control (TPC).
The higher layer protocols are specific (different from the IEEE 1609
WAVE).

The ITS-G5 standards are freely available on-line. The ones describing
ITS-G5 PHY and MAC are ETSI EN 302 663 [1] and ETSI TS 102 687 [2].
[1] http://www.etsi.org/deliver/etsi_en/302600_302699/302663/01.02.01_60/en_302663v010201p.pdf
[2] http://www.etsi.org/deliver/etsi_ts/102600_102699/102687/01.01.01_60/ts_102687v010101p.pdf


This patch-set modifies mac80211 subsystem and ath9k driver to enable
setting of the OCB mode, setting channel type to 5 or 10 MHz and
setting frequency between 5850 and 5925 MHz. To make this fully
functional changes in CRDA (+wireless-regdb) and 'iw' tool are
necessary (these are not included in this patch-set).

The OCB (i.e. 'Out of Context of the BSS') is a special mode enabling
STAs communication without being associated to an AP or to each other.
The BSSID is set to all FF's. Every STA receives all frames from every
STA in range and transmits to every STA tuned to the same channel
(the motivation behind that is that there will be no time for
authentication/association when there are two cars going against each
other in high speed).

The main frequency used (for the Control Channel -- CCH) is set once
and stays fixed. No beacons are sent or received.


Summary of the first two patches (5/10 MHz channel setting):
* New channel TYPE flags are added -- i.e. NL80211_CHAN_WIDTH_5 and
  NL80211_CHAN_WIDTH_10. The reason is to make it possible to
  configure the ITS-G5 from user-space with commands like
    sudo iw dev wlan0 set freq 5890 10MHZ

* New channel restricting flags are added -- the most important is the
  one restricting the channel for OCB mode only (necessary for
  frequency range 5850--5925)

* The commit fe7ef5e9ba0c60bab01390493a4c6790f7b093af has been
  reverted to make the regd probing possible for 5/10 MHz channels

* Add frequencies ranging from 5850 to 5925 as supported in the ath9k
  driver

The second two patches (adding the OCB mode) do the following:
* Add new 'interface mode' -- NL80211_IFTYPE_OCB

* Add new 'struct ieee80211_if_ocb' containing data specific for the
  interface in the OCB mode

* Instead of modifying the ieee80211_set_wmm_default() add new
  ieee80211_set_wmm_itsg5() with configuration specific for ITS-G5 --
  This will be merged in single function in the future.

* Add the ieee80211_set_ocb_channel() function.
  Since the 'set_channel()' function is not present anymore (the only
  remnant is now in the 'set_monitor_channel()'), I was not able to
  figure out how to set a fixed channel by user on interface
  configuration (there is no 'ocb_join()' function), thus I am using the
  deprecated '_oper_chandef' field in 'struct ieee80211_local *local'.
  Any suggestions how to make it properly are very welcome.

* Modify __ieee80211_recalc_idle() to disable idle if the interface is
  in the OCB mode (this will be probably unnecessary when the chanctx
  will be used properly)

* The most important part is the initialization of the OCB mode in the
  ieee80211_do_open() function

* Add ocb.c file containing the OCB specific functions -- i.e. add STA,
  process management frame, do the housekeeping, setup sdata

* Modify the RX/TX path to be able to process frames when in the OCB
  mode

Rostislav Lisovy (4):
  mac80211: Allow 5/10 MHz channel setting (for OCB)
  ath9k: Allow 5/10 MHz channel setting (for OCB)
  mac80211: Add OCB (IEEE 802.11p) mode
  ath9k: Add OCB (IEEE 802.11p) mode

 drivers/net/wireless/ath/ath9k/ani.c          |   1 +
 drivers/net/wireless/ath/ath9k/ath9k.h        |   1 +
 drivers/net/wireless/ath/ath9k/debug.c        |   4 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   5 +
 drivers/net/wireless/ath/ath9k/hw.c           |   1 +
 drivers/net/wireless/ath/ath9k/hw.h           |   3 +-
 drivers/net/wireless/ath/ath9k/init.c         |  23 ++-
 drivers/net/wireless/ath/ath9k/main.c         |   5 +-
 drivers/net/wireless/ath/ath9k/recv.c         |   8 +-
 drivers/net/wireless/ath/ath9k/xmit.c         |   6 +
 drivers/net/wireless/ath/regd.c               |  11 +-
 drivers/net/wireless/rtlwifi/regd.c           |   9 +-
 include/net/cfg80211.h                        |  21 ++-
 include/net/mac80211.h                        |   4 +-
 include/uapi/linux/nl80211.h                  |  24 ++-
 net/mac80211/Kconfig                          |  11 ++
 net/mac80211/Makefile                         |   3 +-
 net/mac80211/cfg.c                            |  43 ++++-
 net/mac80211/debug.h                          |  10 ++
 net/mac80211/driver-ops.h                     |   3 +-
 net/mac80211/ieee80211_i.h                    |  46 ++++++
 net/mac80211/iface.c                          |  63 +++++++-
 net/mac80211/main.c                           |  12 +-
 net/mac80211/ocb.c                            | 219 ++++++++++++++++++++++++++
 net/mac80211/rx.c                             |  30 ++++
 net/mac80211/tx.c                             |  21 ++-
 net/mac80211/util.c                           |  72 +++++++++
 net/mac80211/wme.c                            |   4 +
 net/wireless/chan.c                           |  27 +++-
 net/wireless/core.c                           |   3 -
 net/wireless/core.h                           |   4 +
 net/wireless/nl80211.c                        |  18 +++
 net/wireless/rdev-ops.h                       |  11 ++
 net/wireless/reg.c                            | 117 ++++++++++++--
 net/wireless/util.c                           |   7 +-
 36 files changed, 805 insertions(+), 48 deletions(-)
 create mode 100644 net/mac80211/ocb.c

-- 
1.8.5.1

