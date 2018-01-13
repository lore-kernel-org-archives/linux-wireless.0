Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56030 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933432AbeAMKdt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Jan 2018 05:33:49 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2018-01-13
Date: Sat, 13 Jan 2018 12:33:43 +0200
Message-ID: <87po6eqc8o.fsf@kamboji.qca.qualcomm.com> (sfid-20180113_113419_382832_E762F735)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

this is a pull request to net-next tree for 4.16, more info in the
signed tag below. I'm not expecting any problems but please let me know
if you have any.

Kalle

The following changes since commit f66faae2f80a45feafc04ce63ef744ac4b6e8c05:

  Merge branch 'ipv6-ipv4-nexthop-align' (2018-01-07 21:29:41 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-for-davem-2018-01-13

for you to fetch changes up to 4330b53e9662f8d105da5916899f98d2138dcb1e:

  b43: Replace mdelay with usleep_range in b43_radio_2057_init_post (2018-01-11 21:54:01 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for 4.16

Here are patches which have been accumulating over the holidays and
after the New Year. Business as usual and nothing special really
standing out.

But what's noteworthy here is that Larry Finger is stepping down as
the rtlwifi maintainer. He has been maintaining rtlwifi since it was
applied back in 2010 in commit 0c8173385e54 ("rtl8192ce: Add new
driver") and it has been no easy role trying to juggle between the
vendor, demanding upstream community and users. So big thank you to
Larry for all his efforts!

ath10k

* more preparation work for wcn3990 support

* add memory dump to firmware coredump files

wil6210

* support scheduled scan

* support 40-bit DMA addresses

qtnfmac

* support MAC address based access control

* support for radar detection and Channel Availibility Check (CAC)

mwifiex

* firmware coredump for usb devices

rtlwifi

* Larry Finger steps down as the maintainer and Ping-Ke Shih becomes
  the new maintainer

* add debugfs interfaces to dump register and btcoex status, and also
  write registers and h2c

----------------------------------------------------------------
Alan Liu (1):
      ath10k: add memory dump support for QCA6174/QCA9377

Arend Van Spriel (5):
      brcmfmac: Rename buscore to core for consistency
      brcmfmac: More efficient and slightly easier to read fixup for 4339 chips
      brcmfmac: Remove array of functions
      brcmfmac: add comment block in brcmf_sdio_buscore_read()
      brcmfmac: rename brcmf_sdiod_buff_{read,write}() functions

Arnd Bergmann (1):
      wil6210: fix build warnings without CONFIG_PM

Balaji Pothunoori (1):
      ath10k: advertise TDLS wider bandwidth support for 5GHz

Colin Ian King (4):
      ath10k: wmi: remove redundant integer fc
      mt76: fix memcpy to potential null pointer on failed allocation
      wl1251: check return from call to wl1251_acx_arp_ip_filter
      wcn36xx: fix incorrect assignment to msg_body.min_ch_time

Dan Carpenter (1):
      rtlwifi: check for array overflow

Dedy Lansky (2):
      wil6210: support Scheduled scan
      wil6210: remove leftover "FIXME"s

Double Lo (1):
      brcmfmac: Support 43455 save-restore (SR) feature if FW include -sr

Emmanuel Grumbach (2):
      iwlwifi: fw: fix the enums in the rate scaling API
      iwlwifi: define and use if iwl_mvm_has_tlc_offload

Erik Stromdahl (3):
      ath10k: fix spelling error
      ath10k: remove unused prototype
      ath10k: bugfix: add USB case in ath10k_core_probe_fw

Felix Fietkau (6):
      mt76x2: remove some harmless WARN_ONs in tx status and rx path
      mt76x2: increase OFDM SIFS time
      mt76x2: add channel argument to eeprom tx power functions
      mt76x2: initialize channel power limits at probe time
      mt76x2: convert between per-chain tx power and combined output
      mt76x2: configure rx filter based on monitor mode setting

Fengguang Wu (2):
      mt76: fix debugfs_simple_attr.cocci warnings
      mt76: fix returnvar.cocci warnings

Frank A. Cancio Bello (1):
      rtlwifi: Remove unnecessary parentheses

Golan Ben Ami (2):
      iwlwifi: support internal debug data collection for new devices
      iwlwifi: avoid duplicate sw reset executions in the code

Govind Singh (11):
      ath10k: Update rx descriptor for WCN3990 target
      ath10k: Add support for 64 bit HTT in-order indication msg
      ath10k: Add support for 64 bit htt rx ring cfg
      ath10k: Add support for 64 bit HTT frag descriptor
      ath10k: Add support for htt_data_tx_desc_64 descriptor
      ath10k: Add hw param for rx ring size support
      ath10k: Add paddrs_ring_64 support for 64bit target
      ath10k: Use dma_addr_t for ce buffers to support 64bit target
      ath10k: Add support for 64 bit ce descriptor
      ath10k: Add SNOC bus type for WCN3990 target
      ath10k: Add debug mask for SNOC bus type

Gustavo A. R. Silva (1):
      rtlwifi: mark expected switch fall-through in rtl_make_smps_action

Himanshu Jha (1):
      brcmfmac: Use zeroing memory allocator than allocator/memset

Ian Molton (6):
      brcmfmac: Remove {r,w}_sdreg32
      brcmfmac: stabilise the value of ->sbwad in use for some xfer routines.
      brcmfmac: Correctly handle accesses to SDIO func0
      brcmfmac: Remove func0 from function array
      brcmfmac: Replace function index with function pointer
      brcmfmac: Clean up interrupt macros

Igor Mitsyanko (6):
      qtnfmac: check that MAC exists in regulatory notifier
      qtnfmac: add support for radar detection and CAC
      qtnfmac: change default interface mode from AP to STA
      qtnfmac: check for passed channel being NULL in MGMT_TX command
      qtnfmac: modify GET_STA_STATS cmd format for back/forward compatibility
      qtnfmac: keeping track of "generation" for STA info

Jia-Ju Bai (1):
      b43: Replace mdelay with usleep_range in b43_radio_2057_init_post

Kalle Valo (8):
      ath10k: remove deprecated fw_crash_dump debugfs file
      ath10k: refactor firmware crashdump code to coredump.c
      ath10k: detach coredump.c from debug.c
      ath10k: add coredump_mask module parameter
      ath10k: add memory dump support QCA988X
      ath10k: update copyright year
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      Merge tag 'iwlwifi-next-for-kalle-2017-12-20' of git://git.kernel.org/.../iwlwifi/iwlwifi-next

Larry Finger (1):
      MAINTAINERS: Change maintainer for rtlwifi

Lazar Alexei (1):
      wil6210: support 40bit DMA addresses

Lior David (1):
      wil6210: remove reference to preset_chandef

Lorenzo Bianconi (3):
      mt76x2: init: disable APCLI by default
      mt76x2: init: fix rx filter default value during init
      mt76x2: eeprom: fix typo in mt76x2_get_power_info_5g()

Markus Elfring (1):
      rt2x00: Delete an error message for a failed memory allocation in rt2x00queue_allocate()

Masanari Iida (1):
      rt2x00: Fix a typo in printk

Maya Erez (3):
      wil6210: add platform capabilities bitmap
      wil6210: set platform features based on FW capabilities
      wil6210: prevent parallel suspend and dump collection

Mordechay Goodstein (2):
      iwlwifi: runtime: sync FW and host clocks for logs
      iwlwifi: add skb address to tx cmd in trace events data

Ping-Ke Shih (5):
      rtlwifi: fix parenthesis alignment
      rtlwifi: rtl8723: Add error handling to no existing firmware
      rtlwifi: Improve debugging by using debugfs
      rtlwifi: btcoex: Use seq_file to dump btcoex status
      rtlwifi: fill FW version and subversion

Rakesh Pillai (2):
      ath10k: Add hw param for 64-bit address support
      ath10k: Add fw feature flag for non-bmi firmware load

Sara Sharon (2):
      iwlwifi: mvm: support RX flags API change
      iwlwifi: mvm: don't warn on multiple packets when opening a queue

Sergey Matyukevich (2):
      qtnfmac: pass complete channel data between driver and firmware
      qtnfmac: fix rssi data passed to wireless core

Shaul Triebitz (3):
      iwlwifi: mvm: force quota update upon NoA setting
      iwlwifi: mvm: adjust to quota offload
      iwlwifi: mvm: send the low latency command

Shreeya Patel (1):
      rtlwifi: Remove unnecessary 'out of memory' message

Stanislaw Gruszka (2):
      rt2x00: pause almost full queue early
      rt2x00: do not pause queue unconditionally on error path

Tobin C. Harding (1):
      rtlwifi: use kcalloc instead of multiply

Vasily Ulyanov (2):
      qtnfmac: fill wiphy's extended capabilities
      qtnfmac: support MAC address based access control

Xinming Hu (4):
      mwifiex: refactor device dump code to make it generic for usb interface
      mwifiex: device dump support for usb interface
      mwifiex: debugfs: trigger device dump for usb interface
      mwifiex: cancel pcie/sdio work in remove/shutdown handler

 MAINTAINERS                                        |   6 +-
 drivers/net/wireless/ath/ath10k/Makefile           |   1 +
 drivers/net/wireless/ath/ath10k/ahb.c              |   2 +-
 drivers/net/wireless/ath/ath10k/bmi.c              |   2 +-
 drivers/net/wireless/ath/ath10k/bmi.h              |   2 +-
 drivers/net/wireless/ath/ath10k/ce.c               | 636 +++++++++++--
 drivers/net/wireless/ath/ath10k/ce.h               |  60 +-
 drivers/net/wireless/ath/ath10k/core.c             | 241 +++--
 drivers/net/wireless/ath/ath10k/core.h             |  26 +-
 drivers/net/wireless/ath/ath10k/coredump.c         | 993 +++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/coredump.h         | 225 +++++
 drivers/net/wireless/ath/ath10k/debug.c            | 277 +-----
 drivers/net/wireless/ath/ath10k/debug.h            |  19 +-
 drivers/net/wireless/ath/ath10k/debugfs_sta.c      |   2 +-
 drivers/net/wireless/ath/ath10k/hif.h              |   2 +-
 drivers/net/wireless/ath/ath10k/htc.c              |   2 +-
 drivers/net/wireless/ath/ath10k/htc.h              |   2 +-
 drivers/net/wireless/ath/ath10k/htt.c              |   9 +-
 drivers/net/wireless/ath/ath10k/htt.h              | 145 ++-
 drivers/net/wireless/ath/ath10k/htt_rx.c           | 184 +++-
 drivers/net/wireless/ath/ath10k/htt_tx.c           | 600 +++++++++++--
 drivers/net/wireless/ath/ath10k/hw.c               |   2 +-
 drivers/net/wireless/ath/ath10k/hw.h               |   9 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   7 +-
 drivers/net/wireless/ath/ath10k/mac.h              |   2 +-
 drivers/net/wireless/ath/ath10k/pci.c              | 233 ++++-
 drivers/net/wireless/ath/ath10k/pci.h              |   2 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h          |  52 +-
 drivers/net/wireless/ath/ath10k/spectral.c         |   2 +-
 drivers/net/wireless/ath/ath10k/spectral.h         |   2 +-
 drivers/net/wireless/ath/ath10k/swap.c             |   2 +-
 drivers/net/wireless/ath/ath10k/swap.h             |   2 +-
 drivers/net/wireless/ath/ath10k/targaddrs.h        |   2 +-
 drivers/net/wireless/ath/ath10k/testmode.c         |   2 +-
 drivers/net/wireless/ath/ath10k/testmode_i.h       |   2 +-
 drivers/net/wireless/ath/ath10k/thermal.c          |   2 +-
 drivers/net/wireless/ath/ath10k/thermal.h          |   2 +-
 drivers/net/wireless/ath/ath10k/trace.h            |   2 +-
 drivers/net/wireless/ath/ath10k/txrx.c             |   2 +-
 drivers/net/wireless/ath/ath10k/txrx.h             |   2 +-
 drivers/net/wireless/ath/ath10k/wmi-ops.h          |   2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |   4 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h          |   2 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |   2 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |   9 +-
 drivers/net/wireless/ath/ath10k/wow.c              |   2 +-
 drivers/net/wireless/ath/ath10k/wow.h              |   2 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |   2 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c        |  68 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |   1 -
 drivers/net/wireless/ath/wil6210/interrupt.c       |   2 +-
 drivers/net/wireless/ath/wil6210/main.c            |  67 +-
 drivers/net/wireless/ath/wil6210/netdev.c          |   2 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c        |  61 +-
 drivers/net/wireless/ath/wil6210/pm.c              |  17 +
 drivers/net/wireless/ath/wil6210/pmc.c             |  11 +-
 drivers/net/wireless/ath/wil6210/txrx.c            |  14 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |  17 +-
 drivers/net/wireless/ath/wil6210/wil_crash_dump.c  |  11 +
 drivers/net/wireless/ath/wil6210/wil_platform.h    |  15 +-
 drivers/net/wireless/ath/wil6210/wmi.c             | 241 ++++-
 drivers/net/wireless/ath/wil6210/wmi.h             | 100 ++-
 drivers/net/wireless/broadcom/b43/phy_n.c          |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 214 ++---
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  20 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 275 +++---
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  31 +-
 drivers/net/wireless/intel/iwlwifi/Makefile        |   1 +
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h  |   4 +-
 .../net/wireless/intel/iwlwifi/fw/api/mac-cfg.h    |  19 +
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     |  34 +-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    | 195 ++++
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h    |  87 ++
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |  33 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |  13 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |  14 +-
 .../wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h  |   7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  99 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   6 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/quota.c     |   4 +
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  30 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   7 -
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  77 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |  11 +-
 drivers/net/wireless/marvell/mwifiex/debugfs.c     |  13 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |  11 +
 drivers/net/wireless/marvell/mwifiex/init.c        |  10 +
 drivers/net/wireless/marvell/mwifiex/main.c        |  97 +-
 drivers/net/wireless/marvell/mwifiex/main.h        |  13 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c        |  15 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |  16 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |   4 +
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |  61 ++
 drivers/net/wireless/mediatek/mt76/debugfs.c       |   7 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c |  43 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h |   7 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   |  38 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c    |  28 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   |  19 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c    |   2 +
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c    |  30 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |  60 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 375 +++++---
 drivers/net/wireless/quantenna/qtnfmac/commands.h  |   5 +
 drivers/net/wireless/quantenna/qtnfmac/core.c      |  13 +-
 drivers/net/wireless/quantenna/qtnfmac/core.h      |   8 +-
 drivers/net/wireless/quantenna/qtnfmac/event.c     |  76 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     | 340 +++++--
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    |  78 +-
 .../net/wireless/quantenna/qtnfmac/qlink_util.h    |   4 +
 drivers/net/wireless/quantenna/qtnfmac/util.c      |   8 +-
 drivers/net/wireless/quantenna/qtnfmac/util.h      |   4 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c     |  32 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c   |  12 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |  26 +-
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    | 203 ++---
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.h    |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 269 +++---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 206 ++---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 285 +++---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h    |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 177 ++--
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 133 ++-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  14 +-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |   6 +
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |   1 +
 drivers/net/wireless/realtek/rtlwifi/core.c        |  28 +-
 drivers/net/wireless/realtek/rtlwifi/debug.c       | 483 +++++++++-
 drivers/net/wireless/realtek/rtlwifi/debug.h       |  12 +
 drivers/net/wireless/realtek/rtlwifi/efuse.c       |   4 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   6 +
 drivers/net/wireless/realtek/rtlwifi/rc.c          |  16 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/fw.c    |   2 +
 .../realtek/rtlwifi/rtl8723com/fw_common.c         |   4 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |   9 +
 drivers/net/wireless/ti/wl1251/main.c              |   3 +-
 152 files changed, 6840 insertions(+), 2152 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/coredump.c
 create mode 100644 drivers/net/wireless/ath/ath10k/coredump.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h

-- 
Kalle Valo
