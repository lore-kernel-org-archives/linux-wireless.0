Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35006 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751370AbeAZREe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 12:04:34 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2018-01-26
Date: Fri, 26 Jan 2018 19:04:29 +0200
Message-ID: <87mv10sg9u.fsf@kamboji.qca.qualcomm.com> (sfid-20180126_180456_332856_4D25A68E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

this is a pull request to net-next for 4.16, more info in the signed tag
below. Please let me know if you have any problems.

Kalle

The following changes since commit ebdd7b491b8a65d65936e07004caabca4a3c94a0:

  Merge branch 'mlxsw-Add-support-for-mirror-action-with-flower' (2018-01-21 18:21:31 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-for-davem-2018-01-26

for you to fetch changes up to 30ce7f4456ae40e970d9e82fe63c5e55147af0c0:

  mt76: validate rx CCMP PN (2018-01-26 11:20:52 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for 4.16

Major changes:

wil6210

* add PCI device id for Talyn

* support flashless device

ath9k

* improve RSSI/signal accuracy on AR9003 series

mt76

* validate CCMP PN from received frames to avoid replay attacks

qtnfmac

* support 64-bit network stats

* report more hardware information to kernel log and some via ethtool

----------------------------------------------------------------
Arend Van Spriel (2):
      brcmfmac: assure bcdc dcmd api does not return value > 0
      brcmfmac: separate firmware errors from i/o errors

Dedy Lansky (1):
      wil6210: support flashless device

Felix Fietkau (10):
      mt76: fix transmission of encrypted management frames
      ath9k: discard undersized packets
      mt76: retry rx polling as long as there is budget left
      mt76: fix TSF value in probe responses
      mt76: add an intermediate struct for rx status information
      mt76: get station pointer by wcid and pass it to mac80211
      mt76: implement A-MPDU rx reordering in the driver code
      mt76: split mt76_rx_complete
      mt76: pass the per-vif wcid to the core for multicast rx
      mt76: validate rx CCMP PN

Igor Mitsyanko (2):
      qtnfmac: do not use mutexes in timer context
      qtnfmac: do not use bus mutex for events processing

Kalle Valo (1):
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Lior David (2):
      wil6210: fix random failure to bring network interface up
      wil6210: enlarge FW mac_rgf_ext section for Sparrow D0

Lorenzo Bianconi (5):
      mt76x2: fix WMM parameter configuration
      mt76x2: dfs: avoid tasklet scheduling during mt76x2_dfs_init_params()
      mt76x2: dfs: add set_domain handler
      mt76x2: dfs: take into account dfs region in mt76x2_dfs_init_params()
      mt76x2: init: disable all pending tasklets during device removal

Luis de Bethencourt (1):
      rtl8xxxu: Fix trailing semicolon

Maya Erez (5):
      wil6210: add Talyn PCIe device ID
      wil6210: recognize Talyn JTAG ID
      wil6210: add support for Talyn AHB address map
      wil6210: configure OTP HW vectors in SW reset flow
      wil6210: support parsing brd file address from fw file

Ping-Ke Shih (10):
      rtlwifi: btcoex: extend get_wifi_bw to support bandwidth 80M
      rtlwifi: btcoex: Add switch band notify for btc
      rtlwifi: btcoex: Add variable ant_div_cfg to support antenna diversity
      rtlwifi: btcoex: add scan_notify within ips_notify if RFON
      rtlwifi: btcoex: Add wifi_only series ops to control solo card
      rtlwifi: btcoex: add boolean variables dbg_mode
      rtlwifi: 8822be has to report vht capability to mac80211
      rtlwifi: Add ratr_table for newer IC
      rtlwifi: Add spec_ver to check whether use new rate-id or not
      rtlwifi: btcoex: Fix some static warnings from Sparse

Ramon Fried (1):
      wcn36xx: release DMA memory in case of error

Sergey Matyukevich (4):
      qtnfmac: modify supported interface combinations
      qtnfmac: validate interface combinations on changes
      qtnfmac: fix STA disconnect procedure
      qtnfmac: remove redundant 'unlikely' checks

Vasily Ulyanov (5):
      qtnfmac: remove struct qlink_cmd_set_mac_acl
      qtnfmac: fix warnings when mBSS setup is stopped
      qtnfmac: support 64-bit network interface stats
      qtnfmac: get more hardware info from card
      qtnfmac: report hardware/firmware information via ethtool

Wojciech Dubowik (4):
      ath9k: Alternative EEPROM size for AR9003
      ath9k: Read noise floor calibration data from eeprom
      ath9k: Use calibrated noise floor value when available
      ath9k: Display calibration data piers in debugfs

 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     | 133 ++++++++++-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |  10 +
 drivers/net/wireless/ath/ath9k/calib.c             |  38 +--
 drivers/net/wireless/ath/ath9k/hw.h                |   2 +
 drivers/net/wireless/ath/ath9k/recv.c              |   4 +-
 drivers/net/wireless/ath/wcn36xx/dxe.c             |  46 +++-
 drivers/net/wireless/ath/wil6210/boot_loader.h     |   9 +-
 drivers/net/wireless/ath/wil6210/fw.h              |  18 +-
 drivers/net/wireless/ath/wil6210/fw_inc.c          | 167 ++++++++++++-
 drivers/net/wireless/ath/wil6210/interrupt.c       |   6 +-
 drivers/net/wireless/ath/wil6210/main.c            | 217 ++++++++++++++---
 drivers/net/wireless/ath/wil6210/pcie_bus.c        |  46 +++-
 drivers/net/wireless/ath/wil6210/wil6210.h         |  55 ++++-
 drivers/net/wireless/ath/wil6210/wmi.c             |  90 ++++++-
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    |  17 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.c    |  24 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |  10 +-
 .../wireless/broadcom/brcm80211/brcmfmac/proto.h   |  14 +-
 drivers/net/wireless/mediatek/mt76/Makefile        |   2 +-
 drivers/net/wireless/mediatek/mt76/agg-rx.c        | 258 +++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/dma.c           |  14 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      | 116 ++++++++-
 drivers/net/wireless/mediatek/mt76/mt76.h          |  74 +++++-
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c    |  17 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h    |   2 +
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c    |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   |   8 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c    | 106 ++++++++-
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   |  41 ++--
 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c     |   6 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  | 131 +++++++----
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.h  |  19 --
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 222 ++++++++++++------
 drivers/net/wireless/quantenna/qtnfmac/core.c      | 139 ++++++++++-
 drivers/net/wireless/quantenna/qtnfmac/core.h      |  15 +-
 drivers/net/wireless/quantenna/qtnfmac/event.c     |   4 +-
 .../net/wireless/quantenna/qtnfmac/pearl/pcie.c    |   7 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |  33 +--
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   2 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        | 129 +++++++++--
 drivers/net/wireless/realtek/rtlwifi/base.h        |   2 +
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 135 +++++++----
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  64 +++++
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |  89 ++++++-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |   7 +
 drivers/net/wireless/realtek/rtlwifi/core.c        |   6 +
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   8 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  32 +++
 49 files changed, 2213 insertions(+), 383 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/agg-rx.c
