Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58813 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab0IUU3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 16:29:36 -0400
Date: Tue, 21 Sep 2010 16:17:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org
Subject: pull request: wireless-next-2.6 2010-09-21
Message-ID: <20100921201705.GC2448@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave,

I apologize for this being another huge batch of udpates.  FWIW,
I got a little behind on the merging while at the wireless summit in
SF a couple of weeks ago.  Anyway, I'll try harder to keep-up!

This is largely the usual round of (mostly driver) updates.
Some highlights of this round include the addition of carl9170
(a community-developed successor to ar9170), some significant code
refactoring in ath5k to improve maintainability, and some wl1271
improvements from the guys at TI (including some related OMAP bits
that have been ACKed by the appropriate arch guys).  Helmut Schaa
continues to send rt2x00 updates, and the Intel and Atheros teams
have their usual strong showings as well.

Please let me know if ther are problems!

Thanks,

John

---

The following changes since commit 462fb2af9788a82a534f8184abfde31574e1cfa0:

  bridge : Sanitize skb before it enters the IP stack (2010-09-19 12:42:34 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6.git for-davem

Ben Greear (2):
      ath9k: calcrxfilter should take multiple VIFs into account.
      ath9k: Print rxfilter in debugfs.

Bill Jordan (1):
      nl80211: Uninitialized variable

Bob Copeland (1):
      ath5k: reorder base.c to remove fwd decls

Bruno Randolf (17):
      ath: Copy cryptographic capability flags into ath
      ath: Copy key cache management functions from ath9k to ath
      ath5k: Use common ath key management functions
      ath5k: Remove old ath5k key handling functions
      ath/ath9k: Replace common->splitmic with a flag
      ath5k: Use common crypt capabilities flags
      ath9k: Use common ath key management functions
      ath/ath5k/ath9k: Fix crypto capabilities merge issue
      ath5k: Use four hardware queues
      ath5k: Fix queue debug file
      ath5k: Fix TX queues stopping
      ath5k: Move tx frame completion into separate function
      ath5k: Add watchdog for stuck TX queues
      ath5k: Count how many times a queue got stuck
      ath5k: Keep last descriptor in queue
      ath5k: Simplify cw_min/max and AIFS configuration
      ath5k: Add tx queue configuration function

Christian Lamparter (14):
      carl9170: mac80211 glue and command interface
      carl9170: Register maps, tx/rx descriptor formats and eeprom layout
      carl9170: PHY/RF and MAC routines
      carl9170: 802.11 rx/tx processing and usb backend
      carl9170: firmware parser and debugfs code
      carl9170: Makefile, Kconfig files and MAINTAINERS
      carl9170: update AR9170 phy initvals
      carl9170: use rx chainmask from eeprom
      carl9170: fix noise dBm conversion
      carl9170: don't load bogus nf of chain 1
      carl9170: abort tasklet during usb reset
      carl9170: fix state downgrade during reset
      carl9170: reinit phy after HT settings have changed
      carl9170: fix hang in AP mode when HT STA does PSM

Eliad Peller (2):
      wl1271: avoid redundant memcpy of rx_status
      wl1271: bugfix: use bitwise-AND instead of logical-AND

Fabio Rossi (1):
      ath5k: avoid unneeded calibration error messages

Felix Fietkau (9):
      ath9k: fix BSSID mask calculation
      mac80211: add a note about iterating interfaces during add_interface()
      ath9k_hw: handle rx key miss
      ath9k_hw: remove useless hw capability flags
      ath9k: clean up block ack window handling
      ath9k: fix an aggregation start related race condition
      ath9k: clean up / fix aggregation session flush
      ath9k: move ath_tx_aggr_check() to the rate control module
      ath9k: make the driver specific rate control module optional

Helmut Schaa (5):
      rt2x00: Initialize AMPDU_BA_WINSIZE register
      rt2x00: Check for specific changed flags when updating the erp config
      rt2x00: Mask out unused interrupts in rt2800pci
      rt2x00: Enable missing interrupts in rt61pci
      rt2x00: fix oops in rt2x00lib_txdone with rt61pci

Jay Sternberg (1):
      iwlwifi: corrections to debug output of ucode statistics

Joe Perches (1):
      include/net/cfg80211.h: wiphy_<level> messages use dev_printk

Johannes Berg (14):
      iwlwifi: fix PAN parameters while scanning
      iwlwifi: implement beacon interval change
      iwlwifi: avoid sending too many commands
      iwlwifi: improve timing handling with dual-mode
      iwlwifi: fix and describe iwl_adjust_beacon_interval
      iwlwifi: remove unused conf variables
      iwlwifi: unify scan start checks
      iwlwifi: move scan completed flags handling
      mac80211: match only assigned bss in sta_info_get_bss
      mac80211: use correct station flags lock
      cfg80211/mac80211: use lockdep_assert_held
      mac80211: set running state earlier
      cfg80211/nl80211: introduce p2p device types
      mac80211: add p2p device type support

John W. Linville (5):
      wl1271: remove warnings in wl1271_sdio_set_power
      iwlwifi: fix sparse warning about wrong enum for band parameter
      ath9k: make ath_ant_div_conf_fast_divbias static
      libertas: correct sparse warnings
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem

Julia Lawall (1):
      drivers/net/wireless/iwlwifi/iwl-agn.c: Fix return value from an unsigned function

Lars Ericsson (1):
      rt2x00: Antenna diversity does not work in 2.6.35

Luis R. Rodriguez (10):
      ath9k: fix power save race conditions
      ath9k: fix regression on beacon loss after bgscan
      ath9k: fix enabling ANI / tx monitor after bg scan
      mac80211: add helper for reseting the connection monitor
      mac80211: reset probe send counter upon connection timer reset
      mac80211: reset connection idle when going offchannel
      mac80211: make the beacon monitor available externally
      mac80211: disable beacon monitor while going offchannel
      mac80211: send last 3/5 probe requests as unicast
      ath9k: fix regression which disabled ps on ath9k

Michael Buesch (1):
      p54spi: Add error message for eeprom failure

Nikitas Angelinas (2):
      drivers/net/wireless/ath/ath9k: use ARRAY_SIZE macro in ani.c
      net/wireless: use ARRAY_SIZE macro in radiotap.c

Ohad Ben-Cohen (8):
      wl1271: sdio: claim host only when doing IO
      wl12xx: make wl12xx.h common to both spi and sdio
      wl1271: propagate set_power's return value
      wl12xx: add platform data passing support
      wl1271: take irq info from private board data
      wl1271: make ref_clock configurable by board
      omap: zoom: add fixed regulator device for wlan
      omap: zoom: add mmc3/wl1271 device support

Rajkumar Manoharan (7):
      ath9k_htc: Enable fastcc for HTC devices.
      ath9k_hw: Restore ANI registers to default during partial reset for AR9271
      ath9k_hw: Support fastcc for AR7010
      ath9k_htc: Fix memory leak on WMI event handler
      ath9k_htc: Fix CPU usage issue during scan period
      ath9k_hw: remove warning in ath9k_hw_def_get_num_ant_config
      ath9k_htc: Fix register read through bulk pipe

Senthil Balasubramanian (1):
      ath9k: fix regression which prevents chip sleep after CAB data

Stanislaw Gruszka (11):
      iwlwifi: cancel scan when down the device
      iwlwifi: report scan completion when abort fail
      iwlwifi: rework iwl_scan_cancel_timeout
      iwlwifi: rewrite scan completion
      iwlwifi: force scan complete after timeout
      iwlwifi: assure we complete scan in scan_abort and scan_check works
      iwlwifi: do not force complete scan too early
      mac80211: wait for scan work complete before restarting hw
      iwlwifi: cleanup scan initiate check
      iwlwifi: use IWL_DEBUG_SCAN for debug scanning
      iwlwifi: apply settings when finishing scan

Stephen Hemminger (2):
      ray_cs: make data const
      airo: make strings const

Steve deRosier (1):
      mac80211: Fix dangling pointer in ieee80211_xmit

Tomas Winkler (1):
      iwlwifi: fix default LQ table in 5.2 band

Vasanthakumar Thiagarajan (3):
      ath9k_hw: Add capability flag for Antenna diversity and combining feature
      ath9k_hw: Add functions to get/set antenna diversity configuration
      ath9k: Implement an algorithm for Antenna diversity and combining

Wey-Yi Guy (14):
      iwlagn: open/close envlope to force move BT state machine
      iwlwifi: remember the last uCode sysassert error code
      iwlwifi: allow configure protection mode
      iwlwifi: make sure runtime calibration is enabled after association
      iwlwifi: remove code repetition
      iwlagn: add bt_status_read for 5150
      iwlagn: keep track fail tx reason counter
      iwlagn: keep track of failure tx status
      iwlagn: log aggregation tx command status
      iwlagn: keep track of aggregated tx frames failure counter
      iwlagn: adding aggregated frame failure status to debugfs
      iwlagn: correct naming for failure reply tx status
      iwlagn: minor coex API changes
      iwlagn: initialize both tx/rx prio boost parameters

 MAINTAINERS                                        |    9 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |    2 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |    2 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c       |   54 +
 drivers/net/wireless/Makefile                      |    2 +
 drivers/net/wireless/airo.c                        |    8 +-
 drivers/net/wireless/ath/Kconfig                   |    1 +
 drivers/net/wireless/ath/Makefile                  |    4 +-
 drivers/net/wireless/ath/ath.h                     |   34 +-
 drivers/net/wireless/ath/ath5k/ath5k.h             |   20 +-
 drivers/net/wireless/ath/ath5k/attach.c            |   14 +-
 drivers/net/wireless/ath/ath5k/base.c              | 5337 ++++++++++----------
 drivers/net/wireless/ath/ath5k/base.h              |    9 +-
 drivers/net/wireless/ath/ath5k/debug.c             |   11 +-
 drivers/net/wireless/ath/ath5k/pcu.c               |  191 -
 drivers/net/wireless/ath/ath5k/phy.c               |    2 +-
 drivers/net/wireless/ath/ath5k/qcu.c               |   99 +-
 drivers/net/wireless/ath/ath5k/reg.h               |   42 -
 drivers/net/wireless/ath/ath9k/Kconfig             |    8 +
 drivers/net/wireless/ath/ath9k/Makefile            |    2 +-
 drivers/net/wireless/ath/ath9k/ani.c               |    5 +-
 drivers/net/wireless/ath/ath9k/ar9002_hw.c         |   50 +
 drivers/net/wireless/ath/ath9k/ar9002_phy.c        |   35 +
 drivers/net/wireless/ath/ath9k/ar9002_phy.h        |    2 +
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |    3 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |   66 +-
 drivers/net/wireless/ath/ath9k/common.c            |  270 -
 drivers/net/wireless/ath/ath9k/common.h            |    6 -
 drivers/net/wireless/ath/ath9k/debug.c             |   53 +-
 drivers/net/wireless/ath/ath9k/eeprom.h            |    5 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c         |    6 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c       |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c        |    4 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   32 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    5 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   11 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |    3 +-
 drivers/net/wireless/ath/ath9k/hw.c                |  305 +--
 drivers/net/wireless/ath/ath9k/hw.h                |   53 +-
 drivers/net/wireless/ath/ath9k/init.c              |   17 +-
 drivers/net/wireless/ath/ath9k/mac.c               |    2 +
 drivers/net/wireless/ath/ath9k/mac.h               |   21 -
 drivers/net/wireless/ath/ath9k/main.c              |   36 +-
 drivers/net/wireless/ath/ath9k/phy.h               |    3 -
 drivers/net/wireless/ath/ath9k/rc.c                |   16 +
 drivers/net/wireless/ath/ath9k/rc.h                |   11 +
 drivers/net/wireless/ath/ath9k/recv.c              |  563 ++-
 drivers/net/wireless/ath/ath9k/virtual.c           |   63 +-
 drivers/net/wireless/ath/ath9k/wmi.c               |   72 +-
 drivers/net/wireless/ath/ath9k/wmi.h               |    6 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   95 +-
 drivers/net/wireless/ath/carl9170/Kconfig          |   41 +
 drivers/net/wireless/ath/carl9170/Makefile         |    4 +
 drivers/net/wireless/ath/carl9170/carl9170.h       |  627 +++
 drivers/net/wireless/ath/carl9170/cmd.c            |  188 +
 drivers/net/wireless/ath/carl9170/cmd.h            |  158 +
 drivers/net/wireless/ath/carl9170/debug.c          |  906 ++++
 drivers/net/wireless/ath/carl9170/debug.h          |  134 +
 drivers/net/wireless/ath/carl9170/eeprom.h         |  216 +
 drivers/net/wireless/ath/carl9170/fw.c             |  395 ++
 drivers/net/wireless/ath/carl9170/fwcmd.h          |  268 +
 drivers/net/wireless/ath/carl9170/fwdesc.h         |  237 +
 drivers/net/wireless/ath/carl9170/hw.h             |  736 +++
 drivers/net/wireless/ath/carl9170/led.c            |  190 +
 drivers/net/wireless/ath/carl9170/mac.c            |  604 +++
 drivers/net/wireless/ath/carl9170/main.c           | 1855 +++++++
 drivers/net/wireless/ath/carl9170/phy.c            | 1810 +++++++
 drivers/net/wireless/ath/carl9170/phy.h            |  567 +++
 drivers/net/wireless/ath/carl9170/rx.c             |  909 ++++
 drivers/net/wireless/ath/carl9170/tx.c             | 1373 +++++
 drivers/net/wireless/ath/carl9170/usb.c            | 1138 +++++
 drivers/net/wireless/ath/carl9170/version.h        |    7 +
 drivers/net/wireless/ath/carl9170/wlan.h           |  412 ++
 drivers/net/wireless/ath/key.c                     |  568 +++
 drivers/net/wireless/ath/reg.h                     |   23 +
 drivers/net/wireless/iwlwifi/iwl-1000.c            |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945.h            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c            |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c            |    3 +
 drivers/net/wireless/iwlwifi/iwl-6000.c            |    2 +
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c     |  503 +-
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h     |    7 +
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c        |   18 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c         |  314 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h          |    9 -
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c       |   34 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c             |   49 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h             |    9 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h        |   19 +-
 drivers/net/wireless/iwlwifi/iwl-core.c            |   72 +-
 drivers/net/wireless/iwlwifi/iwl-core.h            |    6 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c         |   58 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h             |   56 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c            |  381 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c             |   19 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c              |    4 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c        |   99 +-
 drivers/net/wireless/libertas/cfg.c                |    6 +-
 drivers/net/wireless/libertas/mesh.c               |    2 +-
 drivers/net/wireless/mac80211_hwsim.c              |   15 +-
 drivers/net/wireless/p54/p54spi.c                  |    2 +
 drivers/net/wireless/ray_cs.c                      |   16 +-
 drivers/net/wireless/rt2x00/rt2400pci.c            |  122 +-
 drivers/net/wireless/rt2x00/rt2500pci.c            |  123 +-
 drivers/net/wireless/rt2x00/rt2500usb.c            |   34 +-
 drivers/net/wireless/rt2x00/rt2800.h               |   12 +
 drivers/net/wireless/rt2x00/rt2800lib.c            |   68 +-
 drivers/net/wireless/rt2x00/rt2800lib.h            |    3 +-
 drivers/net/wireless/rt2x00/rt2800pci.c            |   26 +-
 drivers/net/wireless/rt2x00/rt2x00.h               |    3 +-
 drivers/net/wireless/rt2x00/rt2x00config.c         |    9 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h            |    3 +-
 drivers/net/wireless/rt2x00/rt2x00link.c           |   12 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |    6 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |   51 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |   47 +-
 drivers/net/wireless/wl12xx/Kconfig                |    5 +-
 drivers/net/wireless/wl12xx/wl1251_sdio.c          |    2 +-
 drivers/net/wireless/wl12xx/wl1251_spi.c           |    2 +-
 drivers/net/wireless/wl12xx/wl1271.h               |    3 +-
 drivers/net/wireless/wl12xx/wl1271_boot.c          |   11 +-
 drivers/net/wireless/wl12xx/wl1271_boot.h          |    1 -
 drivers/net/wireless/wl12xx/wl1271_io.h            |    9 +-
 drivers/net/wireless/wl12xx/wl1271_main.c          |    8 +-
 drivers/net/wireless/wl12xx/wl1271_rx.c            |    4 +-
 drivers/net/wireless/wl12xx/wl1271_sdio.c          |   58 +-
 drivers/net/wireless/wl12xx/wl1271_spi.c           |    8 +-
 drivers/net/wireless/wl12xx/wl12xx_platform_data.c |   28 +
 include/linux/nl80211.h                            |    4 +
 include/linux/{spi => }/wl12xx.h                   |    8 +-
 include/net/cfg80211.h                             |   37 +-
 include/net/mac80211.h                             |   29 +-
 net/mac80211/cfg.c                                 |   30 +-
 net/mac80211/chan.c                                |    2 +-
 net/mac80211/driver-ops.h                          |    6 +-
 net/mac80211/driver-trace.h                        |   21 +-
 net/mac80211/ieee80211_i.h                         |    2 +
 net/mac80211/iface.c                               |   34 +-
 net/mac80211/key.c                                 |    2 +-
 net/mac80211/main.c                                |   18 +
 net/mac80211/mlme.c                                |   42 +-
 net/mac80211/offchannel.c                          |    7 +
 net/mac80211/rx.c                                  |    4 +-
 net/mac80211/sta_info.c                            |    4 +-
 net/mac80211/tx.c                                  |    1 +
 net/mac80211/util.c                                |   22 +-
 net/wireless/core.c                                |   51 +-
 net/wireless/core.h                                |    9 +-
 net/wireless/mlme.c                                |    3 +-
 net/wireless/nl80211.c                             |   58 +-
 net/wireless/radiotap.c                            |    3 +-
 net/wireless/reg.c                                 |    6 +-
 net/wireless/sme.c                                 |    9 +-
 net/wireless/util.c                                |   15 +-
 155 files changed, 18884 insertions(+), 4948 deletions(-)
 create mode 100644 drivers/net/wireless/ath/carl9170/Kconfig
 create mode 100644 drivers/net/wireless/ath/carl9170/Makefile
 create mode 100644 drivers/net/wireless/ath/carl9170/carl9170.h
 create mode 100644 drivers/net/wireless/ath/carl9170/cmd.c
 create mode 100644 drivers/net/wireless/ath/carl9170/cmd.h
 create mode 100644 drivers/net/wireless/ath/carl9170/debug.c
 create mode 100644 drivers/net/wireless/ath/carl9170/debug.h
 create mode 100644 drivers/net/wireless/ath/carl9170/eeprom.h
 create mode 100644 drivers/net/wireless/ath/carl9170/fw.c
 create mode 100644 drivers/net/wireless/ath/carl9170/fwcmd.h
 create mode 100644 drivers/net/wireless/ath/carl9170/fwdesc.h
 create mode 100644 drivers/net/wireless/ath/carl9170/hw.h
 create mode 100644 drivers/net/wireless/ath/carl9170/led.c
 create mode 100644 drivers/net/wireless/ath/carl9170/mac.c
 create mode 100644 drivers/net/wireless/ath/carl9170/main.c
 create mode 100644 drivers/net/wireless/ath/carl9170/phy.c
 create mode 100644 drivers/net/wireless/ath/carl9170/phy.h
 create mode 100644 drivers/net/wireless/ath/carl9170/rx.c
 create mode 100644 drivers/net/wireless/ath/carl9170/tx.c
 create mode 100644 drivers/net/wireless/ath/carl9170/usb.c
 create mode 100644 drivers/net/wireless/ath/carl9170/version.h
 create mode 100644 drivers/net/wireless/ath/carl9170/wlan.h
 create mode 100644 drivers/net/wireless/ath/key.c
 create mode 100644 drivers/net/wireless/wl12xx/wl12xx_platform_data.c
 rename include/linux/{spi => }/wl12xx.h (82%)

Omnibus patch available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-next-2.6-2010-09-21.patch.bz2

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
