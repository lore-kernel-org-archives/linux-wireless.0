Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46774 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387986AbeGWS3j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 14:29:39 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2018-07-23
Date: Mon, 23 Jul 2018 20:27:17 +0300
Message-ID: <87tvopx3pm.fsf@kamboji.qca.qualcomm.com> (sfid-20180723_192743_889744_BF909AF7)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

this first pull request for 4.19 got delayed as I was on vacation for
two weeks. I was supposed to send this before my vacation but didn't
manage to do it due to other urgent stuff, but I'll try to catch up with
everything this week so that we get everything ready on time for 4.19.

More info in the signed tag below and please let me know if there are
any problems.

Kalle

The following changes since commit ce397d215ccd07b8ae3f71db689aedb85d56ab40:

  Linux 4.18-rc1 (2018-06-17 08:04:49 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git tags/wireless-drivers-next-for-davem-2018-07-23

for you to fetch changes up to 4a07ed51cae18765c76d9aede5b9830d42db1546:

  mt76x2: debugfs: add sw pulse statistics to dfs debugfs (2018-07-04 18:16=
:01 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for 4.19

The first set of patches for 4.19. Only smaller features and bug
fixes, not really anything major. Also included are changes to
include/linux/bitfield.h, we agreed with Johannes that it makes sense
to apply them via wireless-drivers-next.

Major changes:

ath10k

* support channel 173

* fix spectral scan for QCA9984 and QCA9888 chipsets

ath6kl

* add support for Dell Wireless 1537

ti wlcore

* add support for runtime PM

* enable runtime PM autosuspend support

qtnfmac

* support changing MAC address

* enable source MAC address randomization support

libertas

* fix suspend and resume for SDIO cards

mt76

* add software DFS radar pattern detector for mt76x2 based devices

----------------------------------------------------------------
Andrey Shevchenko (1):
      qtnfmac: enable source MAC address randomization support

Arnd Bergmann (2):
      zd1211rw: stop using deprecated get_seconds()
      ipw2x00: track time using boottime

Ben Greear (1):
      ath10k: support use of channel 173

Brian Norris (6):
      ath10k: use crash_dump enum instead of magic numbers
      ath10k: snoc: use module_platform_driver() macro
      ath10k: snoc: use correct bus-specific pointer in RX retry
      ath10k: snoc: stop including pci.h
      ath10k: snoc: drop unused WCN3990_CE_ATTR_FLAGS
      ath10k: snoc: sort include files

Colin Ian King (3):
      ath10k: fix memory leak of tpc_stats
      ath9k: debug: fix spelling mistake "WATHDOG" -> "WATCHDOG"
      brcmsmac: make function wlc_phy_workarounds_nphy_rev1 static

Dan Carpenter (1):
      rndis_wlan: potential buffer overflow in rndis_wlan_auth_indication()

Daniel Mack (1):
      libertas: fix suspend and resume for SDIO connected cards

Eyal Reizer (1):
      wlcore: Use generic runtime pm calls for wowlan elp configuration

Felix Fietkau (9):
      mt76: fix beacon timer drift
      mt76: fix threshold for gain adjustment
      mt76: fix swapped values for RXO-18 in gain control
      mt76: adjust AGC control register 26 based on gain for VHT80
      mt76: clear false CCA counters after changing gain settings
      mt76: fix variable gain adjustment range
      mt76: add a debugfs file to dump agc calibration information
      mt76: track ewma rssi for gain adjustment per station
      mt76: improve gain adjustment in noisy environments

Govind Singh (1):
      ath10k: handle resource init failure case

Gustavo A. R. Silva (5):
      ath10k: htt_tx: mark expected switch fall-throughs
      ath5k: mark expected switch fall-through
      ath6kl: mark expected switch fall-throughs
      ath9k: mark expected switch fall-throughs
      wlcore: Fix memory leak in wlcore_cmd_wait_for_event_or_timeout

Guy Chronister (1):
      ath6kl: add support for Dell Wireless 1537

Igor Mitsyanko (1):
      qtnfmac: implement net_device_ops callback to set MAC address

Johannes Berg (3):
      bitfield: fix *_encode_bits()
      bitfield: add u8 helpers
      bitfield: add tests

Kalle Valo (1):
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Karthikeyan Periyasamy (1):
      ath10k: fix spectral scan for QCA9984 and QCA9888 chipsets

Lorenzo Bianconi (5):
      mt76x2: fix mrr idx/count estimation in mt76x2_mac_fill_tx_status()
      mt76: introduce mt76_{incr,decr} utility routines
      mt76x2: dfs: add sw event ring buffer
      mt76x2: dfs: add sw pattern detector
      mt76x2: debugfs: add sw pulse statistics to dfs debugfs

Niklas Cassel (1):
      ath10k: do not mix spaces and tabs in Kconfig

Omer Efrat (1):
      wireless-drivers: use BIT_ULL for NL80211_STA_INFO_ attribute types

Rafa=C5=82 Mi=C5=82ecki (5):
      brcmfmac: detect firmware support for monitor interface
      brcmfmac: detect firmware support for radiotap monitor frames
      brcmfmac: handle msgbuf packets marked with monitor mode flag
      brcmfmac: define more bits for the flags of struct brcmf_sta_info_le
      brcmfmac: update STA info struct to the v5

Sebastian Andrzej Siewior (3):
      libertas_tf: use irqsave() in USB's complete callback
      libertas: use irqsave() in USB's complete callback
      zd1211rw: use irqsave() in USB's complete callback

Stefan Agner (1):
      brcmsmac: fix wrap around in conversion from constant to s16

Surabhi Vishnoi (1):
      ath10k: skip data calibration for non-bmi target

Tony Lindgren (7):
      wlcore: Add missing PM call for wlcore_cmd_wait_for_event_or_timeout()
      wlcore: Make sure PM calls are paired
      wlcore: Add support for runtime PM
      wlcore: Fix misplaced PM call for scan_complete_work()
      wlcore: Fix timout errors after recovery
      wlcore: Make sure firmware is initialized in wl1271_op_add_interface()
      wlcore: Enable runtime PM autosuspend support

Varsha Rao (2):
      brcmsmac: Remove unnecessary parentheses
      net: ipw2x00: Replace NULL comparison with !priv

Wei Yongjun (1):
      ath10k: make some functions static

Xinming Hu (1):
      mwifiex: uap: do not chok ethernet header in bridge path

YueHaibing (4):
      ath10k: fix incorrect size of dma_free_coherent in ath10k_ce_alloc_sr=
c_ring_64
      ath10k: use dma_zalloc_coherent instead of allocator/memset
      atmel: use memdup_user to simplify the code
      atmel: using strlcpy() to avoid possible buffer overflows

 drivers/net/wireless/ath/ath10k/Kconfig            |  24 +-
 drivers/net/wireless/ath/ath10k/ce.c               |   2 +-
 drivers/net/wireless/ath/ath10k/ce.h               |  42 ++
 drivers/net/wireless/ath/ath10k/core.c             |  19 +-
 drivers/net/wireless/ath/ath10k/core.h             |   3 +-
 drivers/net/wireless/ath/ath10k/debug.c            |  21 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |   4 +-
 drivers/net/wireless/ath/ath10k/hw.h               |   3 +
 drivers/net/wireless/ath/ath10k/mac.c              |   7 +-
 drivers/net/wireless/ath/ath10k/pci.h              |  42 --
 drivers/net/wireless/ath/ath10k/snoc.c             |  47 +-
 drivers/net/wireless/ath/ath10k/snoc.h             |   1 -
 drivers/net/wireless/ath/ath10k/spectral.c         |   2 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |  14 +-
 drivers/net/wireless/ath/ath5k/pcu.c               |   1 +
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |  17 +-
 drivers/net/wireless/ath/ath6kl/sdio.c             |   1 +
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        |   2 +
 drivers/net/wireless/ath/ath9k/ar9002_phy.c        |   1 +
 drivers/net/wireless/ath/ath9k/debug.c             |   2 +-
 drivers/net/wireless/ath/ath9k/main.c              |   1 +
 drivers/net/wireless/ath/wil6210/cfg80211.c        |  18 +-
 drivers/net/wireless/atmel/atmel.c                 |  14 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  40 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  25 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   2 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |   2 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |   6 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  43 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |  18 +
 .../broadcom/brcm80211/brcmsmac/phy/phy_cmn.c      |   2 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        |   2 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_qmath.c    |   2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |  18 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.h       |  12 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |   6 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.h       |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   6 +-
 drivers/net/wireless/marvell/libertas/cfg.c        |  12 +-
 drivers/net/wireless/marvell/libertas/dev.h        |   1 +
 drivers/net/wireless/marvell/libertas/if_sdio.c    |  30 +-
 drivers/net/wireless/marvell/libertas/if_usb.c     |   7 +-
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |   8 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  14 +-
 drivers/net/wireless/marvell/mwifiex/uap_txrx.c    |  52 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |  12 +
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |  16 +-
 .../net/wireless/mediatek/mt76/mt76x2_debugfs.c    |  22 +
 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c    | 377 ++++++++++++++-
 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h    |  64 +++
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c    |  39 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   |   7 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c    | 107 ++++-
 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c     |  33 ++
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |   3 +
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |  57 ++-
 drivers/net/wireless/quantenna/qtnfmac/core.c      |  25 +
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |  20 +
 drivers/net/wireless/rndis_wlan.c                  |   6 +-
 drivers/net/wireless/ti/wl18xx/debugfs.c           |  29 +-
 drivers/net/wireless/ti/wlcore/acx.c               |   1 -
 drivers/net/wireless/ti/wlcore/cmd.c               |  10 +
 drivers/net/wireless/ti/wlcore/debugfs.c           |  90 ++--
 drivers/net/wireless/ti/wlcore/main.c              | 528 ++++++++++++++---=
----
 drivers/net/wireless/ti/wlcore/ps.c                | 146 ------
 drivers/net/wireless/ti/wlcore/ps.h                |   3 -
 drivers/net/wireless/ti/wlcore/scan.c              |  13 +-
 drivers/net/wireless/ti/wlcore/sysfs.c             |  13 +-
 drivers/net/wireless/ti/wlcore/testmode.c          |  20 +-
 drivers/net/wireless/ti/wlcore/tx.c                |  10 +-
 drivers/net/wireless/ti/wlcore/vendor_cmd.c        |  30 +-
 drivers/net/wireless/ti/wlcore/wlcore.h            |   1 -
 drivers/net/wireless/ti/wlcore/wlcore_i.h          |   1 -
 drivers/net/wireless/zydas/zd1211rw/zd_chip.c      |   2 +-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |  21 +-
 include/linux/bitfield.h                           |   7 +-
 lib/Kconfig.debug                                  |   7 +
 lib/Makefile                                       |   1 +
 lib/test_bitfield.c                                | 168 +++++++
 79 files changed, 1787 insertions(+), 704 deletions(-)
 create mode 100644 lib/test_bitfield.c
