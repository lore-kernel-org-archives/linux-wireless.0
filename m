Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50558 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750704AbdKKNDT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 Nov 2017 08:03:19 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2017-11-11
Date: Sat, 11 Nov 2017 15:03:14 +0200
Message-ID: <87o9o9vugd.fsf@kamboji.qca.qualcomm.com> (sfid-20171111_140342_640624_877D05A7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

some more patches to net-next for v4.15. Even though I applied the last
patch only on Saturday morning, all these have been tested by kbuild bot
and most of them should also be in linux-next. Please let me know if
there are any problems.

Kalle

The following changes since commit 2798b80b385384d51a81832556ee9ad25d175f9b:

  Merge branch 'eBPF-based-device-cgroup-controller' (2017-11-05 23:26:51 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-for-davem-2017-11-11

for you to fetch changes up to fdd0bd88ceaecf729db103ac8836af5805dd2dc1:

  brcmfmac: add CLM download support (2017-11-11 03:04:09 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for 4.15

Last minute patches before the merge window. Not really anything
special standing out, mostly fixes or cleanup and some minor new
features.

Major changes:

iwlwifi

* some new PCI IDs

----------------------------------------------------------------
Arend Van Spriel (6):
      brcmfmac: handle FWHALT mailbox indication
      brcmfmac: cleanup brcmf_cfg80211_escan() function
      brcmfmac: use msecs_to_jiffies() instead of calculation using HZ
      brcmfmac: get rid of brcmf_cfg80211_escan() function
      brcmfmac: get rid of struct brcmf_cfg80211_info::active_scan field
      brcmfmac: move configuration of probe request IEs

Arnd Bergmann (4):
      rtlwifi: fix uninitialized rtlhal->last_suspend_sec time
      rtlwifi: use ktime_get_real_seconds() for suspend time
      rtlwifi: drop unused ppsc->last_wakeup_time
      rt2x00: use monotonic timestamps for frame dump

Chung-Hsien Hsu (1):
      brcmfmac: add CLM download support

Colin Ian King (5):
      rtlwifi: remove redundant pointer tid_data
      rtlwifi: remove redundant initialization to cfg_cmd
      iwlegacy: remove redundant pointer sta_priv
      orinoco_usb: remove redundant pointer dev
      zd1201: remove unused variable framelen

Emmanuel Grumbach (3):
      iwlwifi: mvm: rs: remove the ANT C from the toogle antenna logic
      iwlwifi: remove dead code for internal devices only
      iwlwifi: remove host assisted paging

Franky Lin (1):
      brcmfmac: disable packet filtering in promiscuous mode

Gustavo A. R. Silva (1):
      rsi: rsi_91x_ps: remove redundant code in str_psstate

Igor Mitsyanko (9):
      qtnfmac: use per-band HT/VHT info from wireless device
      qtnfmac: initialize HT/VHT caps "can override" masks
      qtnfmac: get rid of PHYMODE capabilities flags
      qtnfmac: extend "IE set" TLV to include frame type info
      qtnfmac: SCAN results: retreive frame type information from "IE set" TLV
      qtnfmac: convert "Append IEs" command to QTN_TLV_ID_IE_SET usage
      qtnfmac: configure and start AP interface with a single command
      qtnfmac: include HTCAP and VHTCAP into config AP command
      qtnfmac: pass all CONNECT cmd params to wireless card for processing

Ihab Zhaika (3):
      iwlwifi: add new cards for 8260 series
      iwlwifi: add new cards for 8265 series
      iwlwifi: add new cards for a000 series

Kalle Valo (1):
      Merge tag 'iwlwifi-next-for-kalle-2017-11-03' of git://git.kernel.org/.../iwlwifi/iwlwifi-next

Kees Cook (1):
      iwlwifi: mvm: Convert timers to use timer_setup()

Kirtika Ruchandani (1):
      iwlwifi: Add more call-sites for pcie reg dumper

Larry Finger (3):
      rtlwifi: rtl_pci: Fix formatting errors in pci.h
      rtlwifi: rtl_pci: Fix formatting problems in pci.c
      rtlwifi: rtl_pci: Simplify some code be eliminating extraneous variables

Liad Kaufman (1):
      iwlwifi: mvm: reset seq num after restart

Luca Coelho (1):
      iwlwifi: mvm: hold mutex when flushing in iwl_mvm_flush_no_vif()

Ping-Ke Shih (4):
      rtlwifi: rtl_pci: Add support for 8822be TX/RX BD
      rtlwifi: rtl_pci: Add fill_tx_special_desc to issue H2C data, and process TXOK in interrupt.
      rtlwifi: rtl_pci: Add ID for 8822BE
      rtlwifi: rtl_pci: Extend recognized interrupt parameters from two to four ISR

Sara Sharon (6):
      iwlwifi: mvm: use RS macro instead of duplicating the code
      iwlwifi: mvm: cleanup references to aggregation count limit
      iwlwifi: mvm: improve latency when there is a reorder timeout
      iwlwifi: fix multi queue notification for a000 devices
      iwlwifi: mvm: refactor iwl_mvm_flush_no_vif
      iwlwifi: mvm: add missing implementation of flush for a000 devices

Shahar S Matityahu (1):
      iwlwifi: drop RX frames during hardware restart

Stanislaw Gruszka (1):
      rt2x00usb: mark device removed when get ENOENT usb error

 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  10 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 162 ++----------
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |   2 -
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  | 157 ++++++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  40 +++
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   3 +
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  31 +++
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  11 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  19 ++
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  33 ++-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  18 ++
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |   2 -
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c      |  51 ----
 drivers/net/wireless/intel/iwlwifi/fw/api/paging.h |  24 --
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |   8 -
 drivers/net/wireless/intel/iwlwifi/fw/paging.c     | 103 +-------
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   3 -
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   2 -
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   6 -
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  42 +---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  15 --
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  62 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   1 -
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  23 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  50 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   3 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  10 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   7 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   1 +
 .../net/wireless/intersil/orinoco/orinoco_usb.c    |   2 -
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |  64 +----
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 276 ++++++++++++++-------
 drivers/net/wireless/quantenna/qtnfmac/commands.h  |   9 +-
 drivers/net/wireless/quantenna/qtnfmac/core.c      |   3 +-
 drivers/net/wireless/quantenna/qtnfmac/core.h      |   5 +-
 drivers/net/wireless/quantenna/qtnfmac/event.c     |  83 ++++---
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     | 138 ++++++-----
 drivers/net/wireless/ralink/rt2x00/rt2x00debug.c   |   7 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00dump.h    |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c     |   6 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |   2 -
 drivers/net/wireless/realtek/rtlwifi/core.c        |  12 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         | 275 ++++++++++----------
 drivers/net/wireless/realtek/rtlwifi/pci.h         |  31 +--
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |  10 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.h    |   3 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  11 +-
 drivers/net/wireless/rsi/rsi_91x_ps.c              |   1 -
 drivers/net/wireless/zydas/zd1201.c                |   3 +-
 66 files changed, 995 insertions(+), 904 deletions(-)
