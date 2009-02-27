Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34910 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805AbZB0UpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 15:45:22 -0500
Date: Fri, 27 Feb 2009 15:41:10 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org
Subject: pull request: wireless-next-2.6 2009-02-27
Message-ID: <20090227204110.GJ3687@tuxdriver.com> (sfid-20090227_214527_047012_ABE2E3CF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave,

Here is an even bigger batch of changes intended for 2.6.30.  They run
the usual gamut of wireless driver and mac80211 changes...

I have reverted the genetlink patch from Johannes and another of
his that relied upon it.  There is also still that ugly one from me.
It is a kluge but it prevents a crash on my Lenovo T400.  I bisected
the crash down to "mac80211: use cfg80211s BSS infrastructure",
which is already in net-next-2.6.  Still, if it is too ugly then let
me know and I'll reformulate without it.

Please let me know if there are problems!

Thanks,

John

---

Individual patches are available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-next-2.6/

---

The following changes since commit f11c179eea77b8afc2fb7cb4b9a8815b85e3c16f:
  David S. Miller (1):
        Merge branch 'master' of master.kernel.org:/.../davem/net-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6.git master

Abhijeet Kolekar (7):
      iwl3945: use iwl_rx_scan handlers
      iwl3945: use iwl_mac_hw_scan callback
      iwl3945: use iwl rx handlers
      iwl3945: use iwl_rx_reply_error notification
      iwl3945: remove duplicate interrupt code
      iwl3945: use iwl_isr
      iwl3945: use SW rfkill from iwlwifi

Alina Friedrichsen (4):
      ath9k: Don't reset TSF after scanning automatically
      mac80211: Introduce a generic commit() to apply changes
      mac80211: Don't merge with the same BSSID
      mac80211: Give it some time to do the TSF sync

Bing Zhao (1):
      libertas: fix power save issue in libertas_sdio module

Bob Copeland (11):
      ath9k: remove write-only current_rd_inuse
      ath9k: save a few calls to ath9k_regd_get_eepromRD
      ath9k: convert isWwrSKU macro into C code
      ath9k: remove ath9k_regd_get_rd()
      ath9k: remove prototype for ath9k_regd_get_current_country
      ath9k: move common regulatory code out of if() branches
      ath5k: don't mask off interrupt bits
      ath5k: use spin_lock_irqsave for beacon lock
      ath5k: move beacon processing to a tasklet
      ath5k: compute rts/cts duration after computing full pktlen
      ath9k: fix 802.11g conformance test limit typo

Dan Williams (5):
      hostap: convert usage of net/ieee80211.h to linux/ieee80211.h
      make net/ieee80211.h private to ipw2x00
      cfg80211: age scan results on resume
      ipw2x00: age scan results on resume
      libertas: use private SDIO workqueue to avoid scheduling latency

David Kilroy (2):
      orinoco: validate firmware header
      orinoco: prevent accessing memory outside the firmware image

Fenghua Yu (1):
      iwlwifi: dma mapping read and write changes

Helmut Schaa (1):
      iwlagn: clean up error path in iwl_pci_probe

Ivo van Doorn (4):
      rt2x00: uncomment get_tsf
      rt2x00: Remove check for rf word 0
      rt2x00: Add various new USB IDs for rt73usb
      rt2x00: Fix RF offset

Jason Andryuk (7):
      at76c50x-usb: update to latest mac80211 hw scan api
      at76c50x-usb: convert at76_debug to an unsigned int
      at76c50x-usb: fix oops on disconnect
      at76c50x-usb: clean up DMA on stack
      at76c50x-usb: additional disconnect fixes
      iwl3945: initialize is_valid_rtc_data_addr function pointer
      iwl3945: re-add iwl_poll_direct_bit return value check

Jiri Slaby (1):
      ipw2200, fix ipw io functions

Johannes Berg (8):
      mac80211: disallow moving netns
      mac80211: fix aggregation for hardware with ampdu queues
      mac80211: split IBSS/managed code
      cfg80211/mac80211: fill qual.qual value/adjust max_qual.qual
      mac80211: add missing kernel-doc
      nl80211: remove admin requirement from station get
      cfg80211: clean up signal type
      mac80211/cfg80211: move iwrange handler to cfg80211

John Daiker (1):
      b43: checkpatch.pl cleanups

John W. Linville (2):
      airo: correct improper initialization of local variable
      iwlagn: default to MAX_UCODE_BEACON_INTERVAL in iwl_adjust_beacon_interval

Jouni Malinen (4):
      nl80211: Optional IEs into scan request
      nl80211: Provide access to STA TX/RX packet counters
      ath9k: Unlock sc->mutex on error path
      nl80211: Avoid AP mode BUG_ON hang with invalid lock assert

Kalle Valo (3):
      at76c50x-usb: add driver
      at76c50x-usb: add link to the TODO list
      at76c50x-usb: use dev_name() instead of struct device.bus_id

Luis R. Rodriguez (23):
      cfg80211: rename cfg80211_registered_device's idx to wiphy_idx
      cfg80211: add wiphy_idx_valid to check for wiphy_idx sanity
      cfg80211: rename cfg80211_drv_mutex to cfg80211_mutex
      nl80211: disallow user requests prior to regulatory_init()
      cfg80211: add regulatory_hint_core() to separate the core reg hint
      cfg80211: propagate -ENOMEM during regulatory_init()
      cfg80211: add assert_cfg80211_lock() to ensure proper protection
      cfg80211: make regulatory_request use wiphy_idx instead of wiphy
      cfg80211: protect first access of last_request on 11d hint under mutex
      cfg80211: remove likely from an 11d hint case
      cfg80211: free rd on unlikely event on 11d hint
      cfg80211: move all regulatory hints to workqueue
      cfg80211: comments style cleanup
      cfg80211: allow drivers that agree on regulatory to agree
      cfg80211: rename regdom_changed to regdom_changes() and use it
      cfg80211: enable active-scan / beaconing on Ch 1-11 for world regdom
      cfg80211: enable 5 GHz world roaming channels
      cfg80211: Add AP beacon regulatory hints
      ath9k: follow beacon hints on reg_notifier when world roaming
      cfg80211: make __regulatory_hint() static
      cfg80211: pass the regulatory_request struct in __regulatory_hint()
      cfg80211: do not kzalloc() again for a new request on __regulatory_hint
      cfg80211: pass the regulatory_request to ignore_request

Michael Buesch (16):
      b43: Move DMA stop sanity check
      b43: Fix DMA buffer size handling
      b43: Optimize DMA buffers
      b43: Add slot count compiletime assertion
      b43: Fix radio host flags
      b43: Honor the no-slow-clock boardflag
      b43: Enable PCI slow clock workaround, if needed.
      mac80211: Add software scan notifiers
      b43: Implement sw scan callbacks
      b43: Convert usage of b43_phy_set()
      b43: Convert usage of b43_phy_mask()
      b43: Convert usage of b43_phy_maskset()
      b43: Convert usage of b43_radio_set()
      b43: Convert usage of b43_radio_mask()
      b43: Convert usage of b43_radio_maskset()
      b43: Remove bogus integer truncation warnings

Randy Dunlap (1):
      wireless: fix for CONFIG_NL80211=n

Reinette Chatre (2):
      iwlwifi: use singlethread workqueue
      iwlwifi: Fix and rework Kconfig file

Roel Kluin (3):
      wavelan: Test arraysize before an element of the array.
      p54: misplaced parentheses
      b43: Fix LO calibration txctl reg value

Senthil Balasubramanian (1):
      ath9k: Add open loop control support

Sujith (21):
      ath9k: Store the correct max TX power level
      ath9k: Fix rd_ext EEPROM capability for AR9285
      ath9k: Enable Fractional N mode
      ath9k: Enable TSF Out of Range Interrupt
      ath9k: Initialize AGC calibration properly
      ath9k: Fix bug in disabling MIB counters
      ath9k: Fix incorrect noise floor reading for 4k EEPROM
      ath9k: Decrease minimum NF threshold
      mac80211: Extend the rate control API with an update callback
      ath9k: Program the RTC registers correctly
      ath9k: Fix HW wait timeout
      ath9k: Fix antenna assignment bug in TX status processing
      ath9k: Initialize channel change time
      ath9k: Remove a few unused capability macros
      ath9k: Remove ath_txq_depth and get the queue depth directly
      ath9k: Use beacon interval directly
      ath9k: Remove multiple macro occurrences
      ath9k: Add PER to RC debug statistics
      ath9k: Fix bug in EEPROM chainmask retrieval
      ath9k: Fix PCI shutdown sequence
      ath9k: Add appropriate ANI values for AP mode

Vasanthakumar Thiagarajan (3):
      mac80211: Make sure non-HT connection when IEEE80211_STA_TKIP_WEP_USED is set
      ath9k: Fix PTK/GTK handshake timeout
      ath9k: Filter out beacons from other BSS in STA mode

Wu, Fengguang (1):
      iwlwifi: report correct and detailed values about requested txpower

 drivers/net/wireless/Kconfig                       |    8 +
 drivers/net/wireless/Makefile                      |    2 +
 drivers/net/wireless/airo.c                        |    3 +-
 drivers/net/wireless/at76c50x-usb.c                | 2501 ++++++++++++++++++++
 drivers/net/wireless/at76c50x-usb.h                |  463 ++++
 drivers/net/wireless/ath5k/base.c                  |   84 +-
 drivers/net/wireless/ath5k/base.h                  |    1 +
 drivers/net/wireless/ath9k/ani.c                   |    7 +-
 drivers/net/wireless/ath9k/ath9k.h                 |   12 +-
 drivers/net/wireless/ath9k/beacon.c                |    8 +-
 drivers/net/wireless/ath9k/calib.c                 |   64 +-
 drivers/net/wireless/ath9k/calib.h                 |    2 +-
 drivers/net/wireless/ath9k/debug.c                 |   12 +-
 drivers/net/wireless/ath9k/debug.h                 |    9 +-
 drivers/net/wireless/ath9k/eeprom.c                |  232 ++-
 drivers/net/wireless/ath9k/eeprom.h                |   37 +-
 drivers/net/wireless/ath9k/hw.c                    |  117 +-
 drivers/net/wireless/ath9k/hw.h                    |   20 +-
 drivers/net/wireless/ath9k/mac.c                   |   30 +-
 drivers/net/wireless/ath9k/mac.h                   |    3 +-
 drivers/net/wireless/ath9k/main.c                  |   72 +-
 drivers/net/wireless/ath9k/pci.c                   |    7 +-
 drivers/net/wireless/ath9k/phy.c                   |   19 +-
 drivers/net/wireless/ath9k/phy.h                   |   29 +
 drivers/net/wireless/ath9k/rc.c                    |   10 +-
 drivers/net/wireless/ath9k/recv.c                  |   12 +-
 drivers/net/wireless/ath9k/reg.h                   |   12 +-
 drivers/net/wireless/ath9k/regd.c                  |  123 +-
 drivers/net/wireless/ath9k/regd.h                  |    9 -
 drivers/net/wireless/ath9k/xmit.c                  |   28 +-
 drivers/net/wireless/b43/debugfs.c                 |    4 +-
 drivers/net/wireless/b43/dma.c                     |   64 +-
 drivers/net/wireless/b43/dma.h                     |   17 +-
 drivers/net/wireless/b43/lo.c                      |   77 +-
 drivers/net/wireless/b43/main.c                    |   74 +-
 drivers/net/wireless/b43/phy_a.c                   |  111 +-
 drivers/net/wireless/b43/phy_g.c                   |  611 ++----
 drivers/net/wireless/b43/pio.c                     |   16 +-
 drivers/net/wireless/b43/rfkill.c                  |    2 +-
 drivers/net/wireless/b43/wa.c                      |  113 +-
 drivers/net/wireless/hostap/hostap.h               |    2 +-
 drivers/net/wireless/hostap/hostap_80211.h         |    2 +-
 drivers/net/wireless/hostap/hostap_80211_rx.c      |   88 +-
 drivers/net/wireless/hostap/hostap_80211_tx.c      |   51 +-
 drivers/net/wireless/hostap/hostap_ap.c            |  138 +-
 drivers/net/wireless/hostap/hostap_ap.h            |    6 +-
 drivers/net/wireless/hostap/hostap_hw.c            |   24 +-
 drivers/net/wireless/hostap/hostap_info.c          |    1 +
 drivers/net/wireless/hostap/hostap_ioctl.c         |    1 +
 drivers/net/wireless/hostap/hostap_main.c          |   38 +-
 drivers/net/wireless/ipw2x00/Kconfig               |    2 +-
 .../net/wireless/ipw2x00}/ieee80211.h              |    3 +
 drivers/net/wireless/ipw2x00/ipw2100.c             |   12 +-
 drivers/net/wireless/ipw2x00/ipw2100.h             |    8 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |  116 +-
 drivers/net/wireless/ipw2x00/ipw2200.h             |    7 +-
 drivers/net/wireless/ipw2x00/libipw_geo.c          |    2 +-
 drivers/net/wireless/ipw2x00/libipw_module.c       |   17 +-
 drivers/net/wireless/ipw2x00/libipw_rx.c           |    5 +-
 drivers/net/wireless/ipw2x00/libipw_tx.c           |    2 +-
 drivers/net/wireless/ipw2x00/libipw_wx.c           |   27 +-
 drivers/net/wireless/iwlwifi/Kconfig               |   56 +-
 drivers/net/wireless/iwlwifi/Makefile              |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c            |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c             |  173 +--
 drivers/net/wireless/iwlwifi/iwl-core.c            |  108 +-
 drivers/net/wireless/iwlwifi/iwl-core.h            |   14 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h             |    4 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c            |   68 +
 drivers/net/wireless/iwlwifi/iwl-tx.c              |    6 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c        |  437 +----
 drivers/net/wireless/libertas/defs.h               |    1 +
 drivers/net/wireless/libertas/if_sdio.c            |   20 +-
 drivers/net/wireless/orinoco/fw.c                  |   49 +-
 drivers/net/wireless/orinoco/hermes_dld.c          |   99 +-
 drivers/net/wireless/orinoco/hermes_dld.h          |   12 +-
 drivers/net/wireless/p54/p54common.c               |    4 +-
 drivers/net/wireless/rt2x00/rt2400pci.c            |    3 -
 drivers/net/wireless/rt2x00/rt2400pci.h            |    4 +-
 drivers/net/wireless/rt2x00/rt2500pci.c            |    3 -
 drivers/net/wireless/rt2x00/rt2500pci.h            |    4 +-
 drivers/net/wireless/rt2x00/rt2500usb.c            |    3 -
 drivers/net/wireless/rt2x00/rt2500usb.h            |    4 +-
 drivers/net/wireless/rt2x00/rt2x00debug.c          |   10 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |    3 -
 drivers/net/wireless/rt2x00/rt61pci.h              |    4 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |   19 +-
 drivers/net/wireless/rt2x00/rt73usb.h              |    4 +-
 drivers/net/wireless/wavelan.c                     |    3 +-
 drivers/net/wireless/zd1211rw/zd_mac.c             |    6 +-
 include/linux/nl80211.h                            |    5 +
 include/net/cfg80211.h                             |   31 +-
 include/net/mac80211.h                             |   26 +-
 include/net/wireless.h                             |   17 +-
 net/mac80211/Makefile                              |    1 +
 net/mac80211/agg-rx.c                              |    6 +-
 net/mac80211/agg-tx.c                              |  191 +-
 net/mac80211/cfg.c                                 |   49 +-
 net/mac80211/debugfs_netdev.c                      |   48 +-
 net/mac80211/ht.c                                  |   19 +-
 net/mac80211/ibss.c                                |  905 +++++++
 net/mac80211/ieee80211_i.h                         |  140 +-
 net/mac80211/iface.c                               |   77 +-
 net/mac80211/key.c                                 |    2 +-
 net/mac80211/main.c                                |   24 +-
 net/mac80211/mlme.c                                | 1665 ++++----------
 net/mac80211/rate.h                                |   12 +
 net/mac80211/rx.c                                  |   37 +-
 net/mac80211/scan.c                                |   62 +-
 net/mac80211/spectmgmt.c                           |   26 +-
 net/mac80211/sta_info.c                            |   15 +-
 net/mac80211/sta_info.h                            |    5 +-
 net/mac80211/tx.c                                  |   29 +-
 net/mac80211/util.c                                |  254 ++-
 net/mac80211/wext.c                                |  262 +--
 net/mac80211/wme.c                                 |  161 +--
 net/mac80211/wme.h                                 |    6 -
 net/wireless/core.c                                |  103 +-
 net/wireless/core.h                                |   36 +-
 net/wireless/nl80211.c                             |   75 +-
 net/wireless/nl80211.h                             |    4 +
 net/wireless/reg.c                                 |  945 ++++++--
 net/wireless/reg.h                                 |   36 +-
 net/wireless/scan.c                                |   64 +-
 net/wireless/sysfs.c                               |    9 +-
 net/wireless/wext-compat.c                         |   97 +
 126 files changed, 8007 insertions(+), 4142 deletions(-)
 create mode 100644 drivers/net/wireless/at76c50x-usb.c
 create mode 100644 drivers/net/wireless/at76c50x-usb.h
 rename {include/net => drivers/net/wireless/ipw2x00}/ieee80211.h (99%)
 create mode 100644 net/mac80211/ibss.c

Omnibus patch is available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-next-2.6-2009-02-27.patch.bz2

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
