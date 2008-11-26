Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58374 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbYKZPbM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 10:31:12 -0500
Date: Wed, 26 Nov 2008 10:22:15 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Subject: pull request: wireless-next-2.6 2008-11-26
Message-ID: <20081126152215.GE3552@tuxdriver.com> (sfid-20081126_163116_209446_7CCC4EF8)
References: <20081125221753.GC25962@tuxdriver.com> <20081125.161451.142025705.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081125.161451.142025705.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave,

(This is version 2, without the defconfig changes as requested. -- JWL)

Yet another giant bunch of patches intended for 2.6.29, mostly a variety
of driver updates...

Please let me know if there are problems!

Thanks,

John

---

Individual patches are available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-next-2.6/

---

The following changes since commit 2f9889a20cd2854bc6305198255c617b0b4eb719:
  David S. Miller (1):
        Revert "hso: Fix crashes on close."

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6.git master

Abhijeet Kolekar (2):
      iwlwifi : fix checkpatch.pl errors
      iwl3945 : Fix ad-hoc mode for 3945

Andrey Borzenkov (1):
      orinoco: indicate it is using dBm in wireless_stats and spy

Bob Copeland (1):
      ath5k: set mac address in add_interface

Chatre, Reinette (1):
      iwlwifi: replace magic constants with define

Christian Lamparter (5):
      p54: enable Mesh Point support
      p54: minor fixes
      p54pci: cache firmware for suspend/resume
      p54: honour bss_info_changed's basic_rates and other settings
      p54: fix wmm queue settings

David Kilroy (4):
      orinoco: Separate fw caching from download
      orinoco: Cache Symbol firmware
      orinoco: Resume spectrum_cs in the same way as orinoco_cs
      orinoco: Provide option to avoid unnecessary fw caching

Felix Fietkau (1):
      ath5k: Clean up eeprom parsing and add missing calibration data

Henrique de Moraes Holschuh (2):
      rfkill: preserve state across suspend
      rfkill: always call get_state() hook on resume

Herton Ronaldo Krzesinski (3):
      rtl8187: fix 8187B throughput regression
      rtl8187: implement conf_tx callback to configure tx queues
      rtl8187: feedback transmitted packets using tx close descriptor for 8187B

Ivan Kuten (1):
      mac80211: fix unaligned access in ieee80211_wep_encrypt_data

Ivo van Doorn (5):
      rt2x00: Cleanup indirect register access
      rt2x00: Move rt73usb register access wrappers into rt2x00usb
      rt2x00: Fix TX failure path
      rt2x00: Detect USB BULK in/out endpoints
      rt2x00: Don't switch off LED on initialization

Johannes Berg (1):
      ath5k: name pci driver "ath5k" too

John W. Linville (1):
      mac80211_hwsim: fix-up some print_mac merge damage

Jouni Malinen (2):
      nl80211: Report max TX power in NL80211_BAND_ATTR_FREQS
      nl80211: Change max TX power to be in mBm instead of dBm

Kolekar, Abhijeet (1):
      iwl3945 : Simplify iwl3945_pci_probe

Larry Finger (3):
      rtl8187: Remove module warning and dependence on CONFIG_EXPERIMENTAL
      mac80211: Fix pid rate-setting algorithm to allow rate changes
      rtl8187: Fix transmission count sent to mac80211

Luis R. Rodriguez (15):
      cfg80211: mark negative frequencies as invalid
      cfg80211: remove switch from __regulatory_hint()
      cfg80211: remove switch from __set_regdom()
      cfg80211: separate intersection section in __set_regdom()
      cfg80211: expect different rd in cfg80211 when intersecting
      cfg80211: call_crda() won't tell us if CRDA was present
      cfg80211: mark regdomains with > NL80211_MAX_SUPP_REG_RULES invalid
      cfg80211/mac80211: Add 802.11d support
      cfg80211: add support for custom firmware regulatory solutions
      iwlwifi: enable custom fw regulatory solution
      ath9k: Clarify we only want 32-bit DMA
      ath9k: make DMA memory consistent
      mac80211: don't assume driver has been attached on registration
      mac80211: make Minstrel the default rate control algorithm
      ath9k: Handle -ENOMEM on RX gracefully

Senthil Balasubramanian (5):
      ath9k: INI update for atheros chipets.
      ath9k: incorrect noise floor threshold values.
      ath9k: Build RFKILL feature even when RFKILL subsystem is a MODULE
      ath9k: IRQ should be disabled before calling free_irq()
      ath9k: Race condition in accessing TX and RX buffers.

Sujith (21):
      mac80211: Use the HT capabilities from the IE instead of the station's caps.
      ath9k: Merge struct ath_tx_ratectrl with ath_rate_node
      ath9k: Simplify RC alloc/free functions
      ath9k: Remove ath_setup_rates
      ath9k: Remove ath_rate_newassoc()
      ath9k: Remove half/quarter rate tables
      ath9k: Nuke fixed rate handling in driver
      ath9k: Revamp RX handling
      ath9k: We don't support non-HT devices, so remove superfluous code.
      ath9k: Remove rate control reference in VAP
      ath9k: Remove ath_rate_softc
      ath9k: Use rate_driver_data
      ath9k: Remove ath9k_rate_table
      ath9k: General code scrub
      ath9k: Use helpers
      ath9k: Move TX completion routine to xmit.c
      ath9k: Fix bug in deciphering channel flags
      ath9k: Update TX trigger level on a FIFO underrun.
      ath9k: Use straightforward PCI routines to setup the TX buffer.
      ath9k: Code scrub
      ath9k: Use proper TX channel width for setting channels

Tomas Winkler (4):
      iwlwifi: consolidate station management code
      iwlwifi: rs: remove fc variable and other cleanups
      iwlwifi: iwl-fh.h cleanup
      iwlwifi: enable base band calibration in 5000 HW

Vasanthakumar Thiagarajan (3):
      ath9k: Configure AR_PHY_SWITCH_COM with apropriate antenna control
      ath9k: Fix panic while unregistering rfkill
      ath9k: Dont update rate control for every AMPDU

Vivek Natarajan (1):
      mac80211: Look out for some other AP when disassoc is received.

Winkler, Tomas (4):
      iwlwifi: move iwl_clear_stations_table to iwl-sta.c
      iwlwifi: 4965 define firmware file name once
      iwlwifi: TX setup fix confusion between TX queue and TX DMA channel
      iwlwifi: TX update chicken bits

Zhu, Yi (2):
      iwlwifi: configure_filter rewrite
      iwlwifi: some fh document fix and cleanup

 drivers/net/wireless/Kconfig                   |   17 +-
 drivers/net/wireless/ath5k/ath5k.h             |    7 -
 drivers/net/wireless/ath5k/attach.c            |   12 +-
 drivers/net/wireless/ath5k/base.c              |   15 +-
 drivers/net/wireless/ath5k/eeprom.c            | 1194 +++++++++++++++--
 drivers/net/wireless/ath5k/eeprom.h            |  253 +++-
 drivers/net/wireless/ath5k/reset.c             |    2 +-
 drivers/net/wireless/ath9k/Makefile            |    3 +-
 drivers/net/wireless/ath9k/ath9k.h             |   49 +-
 drivers/net/wireless/ath9k/beacon.c            |   88 +-
 drivers/net/wireless/ath9k/calib.c             |    4 +-
 drivers/net/wireless/ath9k/core.c              | 1652 -----------------------
 drivers/net/wireless/ath9k/core.h              |  280 +----
 drivers/net/wireless/ath9k/eeprom.c            |   11 +-
 drivers/net/wireless/ath9k/hw.c                |  276 ++---
 drivers/net/wireless/ath9k/hw.h                |   23 +-
 drivers/net/wireless/ath9k/initvals.h          |  701 +++++++---
 drivers/net/wireless/ath9k/mac.c               |    4 +-
 drivers/net/wireless/ath9k/main.c              | 1503 ++++++++++++++++++----
 drivers/net/wireless/ath9k/rc.c                | 1696 +++++++++---------------
 drivers/net/wireless/ath9k/rc.h                |  219 +---
 drivers/net/wireless/ath9k/recv.c              |  600 ++++------
 drivers/net/wireless/ath9k/xmit.c              |  465 +++-----
 drivers/net/wireless/iwlwifi/iwl-3945-io.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h        |    1 -
 drivers/net/wireless/iwlwifi/iwl-4965.c        |   27 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c        |   27 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c      |   50 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c         |  121 +--
 drivers/net/wireless/iwlwifi/iwl-core.c        |   26 +-
 drivers/net/wireless/iwlwifi/iwl-core.h        |    3 -
 drivers/net/wireless/iwlwifi/iwl-dev.h         |    7 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h          |   55 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-io.h          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c          |   75 --
 drivers/net/wireless/iwlwifi/iwl-sta.c         |  157 +++-
 drivers/net/wireless/iwlwifi/iwl-sta.h         |   14 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c          |   11 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c    |  272 +++--
 drivers/net/wireless/mac80211_hwsim.c          |   14 +-
 drivers/net/wireless/orinoco/orinoco.c         |  160 ++-
 drivers/net/wireless/orinoco/orinoco.h         |    6 +-
 drivers/net/wireless/orinoco/spectrum_cs.c     |   21 +-
 drivers/net/wireless/p54/p54.h                 |    3 +
 drivers/net/wireless/p54/p54common.c           |   69 +-
 drivers/net/wireless/p54/p54common.h           |    2 +-
 drivers/net/wireless/p54/p54pci.c              |   42 +-
 drivers/net/wireless/p54/p54pci.h              |    2 +-
 drivers/net/wireless/rt2x00/rt2400pci.c        |  125 +--
 drivers/net/wireless/rt2x00/rt2500pci.c        |  125 +--
 drivers/net/wireless/rt2x00/rt2500usb.c        |  151 +--
 drivers/net/wireless/rt2x00/rt2x00.h           |    8 +-
 drivers/net/wireless/rt2x00/rt2x00leds.c       |    6 -
 drivers/net/wireless/rt2x00/rt2x00mac.c        |    3 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c        |   25 +
 drivers/net/wireless/rt2x00/rt2x00pci.h        |   18 +
 drivers/net/wireless/rt2x00/rt2x00queue.c      |   14 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h      |   22 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c        |  113 ++-
 drivers/net/wireless/rt2x00/rt2x00usb.h        |  136 ++
 drivers/net/wireless/rt2x00/rt61pci.c          |  165 +--
 drivers/net/wireless/rt2x00/rt73usb.c          |  433 +++----
 drivers/net/wireless/rtl818x/rtl8187.h         |    7 +
 drivers/net/wireless/rtl818x/rtl8187_dev.c     |  214 +++-
 drivers/net/wireless/rtl818x/rtl8187_rtl8225.c |    6 -
 include/linux/ieee80211.h                      |   62 +
 include/linux/nl80211.h                        |    5 +
 include/linux/rfkill.h                         |    1 +
 include/net/wireless.h                         |   22 +
 net/mac80211/Kconfig                           |    8 +-
 net/mac80211/ht.c                              |    2 +-
 net/mac80211/main.c                            |    5 +-
 net/mac80211/mlme.c                            |   15 +-
 net/mac80211/rc80211_pid_algo.c                |    2 +-
 net/mac80211/wep.c                             |    7 +-
 net/rfkill/rfkill.c                            |   17 +-
 net/wireless/Kconfig                           |   11 +
 net/wireless/core.c                            |    5 +-
 net/wireless/core.h                            |   13 +
 net/wireless/nl80211.c                         |    5 +-
 net/wireless/reg.c                             |  586 +++++++-
 net/wireless/reg.h                             |   21 +-
 83 files changed, 6610 insertions(+), 5993 deletions(-)
 delete mode 100644 drivers/net/wireless/ath9k/core.c

Omnibus patch available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-next-2.6-2008-11-26.patch.bz2
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
