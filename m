Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41024 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751676AbdKCOLq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Nov 2017 10:11:46 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2017-11-03
Date: Fri, 03 Nov 2017 16:11:41 +0200
Message-ID: <87shdvwixu.fsf@kamboji.qca.qualcomm.com> (sfid-20171103_151212_438662_2B036B56)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

another pull request to net-next for v4.15. I'm at the airport on my way
to Netdev 2.2, so please pay extra attention if I made any stupid
mistakes. And as always, please let me know if there are any problems.

If Linus does not release final v4.14 on Sunday, and gives us one more
week before the merge window, I'll try to send one more pull request
next week.

Kalle

The following changes since commit aec72f3392b1d598a979e89c4fdb131965ae0ab3:

  net-tun: fix panics at dismantle time (2017-10-20 13:31:26 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git tags/wireless-drivers-next-for-davem-2017-11-03

for you to fetch changes up to e226fb5affccca98c405de80527180224d93d251:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/a=
th.git (2017-11-02 19:48:25 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for 4.15

Mostly fixes this time, but also few new features.

Major changes:

wil6210

* remove ssid debugfs file

rsi

* add WOWLAN support for suspend, hibernate and shutdown states

ath10k

* add support for CCMP-256, GCMP and GCMP-256 ciphers on hardware
  where it's supported (QCA99x0 and QCA4019)

----------------------------------------------------------------
Amitkumar Karwar (2):
      rsi: move rsi_sdio_reinit_device() out of CONFIG_PM
      rsi: fix kbuild reported build errors with CONFIG_PM off

Anilkumar Kolli (3):
      ath10k: move ath10k_mac_tdls_vif*() functions
      ath10k: block offchannel operations if TDLS session is active
      ath10k: fix sending wmi cmd during the tdls teardown

Arnd Bergmann (2):
      brcmsmac: split up wlc_phy_workarounds_nphy
      brcmsmac: reindent split functions

Ben Greear (1):
      ath10k: store coverage-class in case firmware is not booted

Beni Lev (1):
      iwlwifi: mvm: allow reading UMAC error data from SMEM in A000 devices

Bhumika Goyal (1):
      ath10k: make ath10k_hw_ce_regs const

Brian Norris (2):
      ath10k: fix core PCI suspend when WoWLAN is supported but disabled
      ath10k: fix build errors with !CONFIG_PM

Christos Gkekas (2):
      ath10k: spectral: remove redundant check in write_file_spectral_count=
()
      ath9k: debug: Remove redundant check

Colin Ian King (1):
      ath9k: make const array reg_hole_list static, reduces object code size

Ganapathi Bhat (1):
      mwifiex: do not transmit in 11N rates when connected in TKIP security

Himanshu Jha (1):
      ath9k: remove cast to void pointer

Igor Mitsyanko (1):
      qtnfmac: advertise support of inactivity timeout

Joe Perches (1):
      bcma: Use bcma_debug and not pr_cont in MIPS driver

Johannes Berg (6):
      iwlwifi: mvm: allocate reorder buffer according to need
      iwlwifi: mvm: pass baid_data to iwl_mvm_release_frames()
      iwlwifi: pcie: remove set but not used variable tcph
      wil6210: remove wil6210_uapi.h from MAINTAINERS
      wil6210: remove SSID debugfs
      libertas: don't write wdev->ssid/_len

Kalle Valo (3):
      Merge tag 'iwlwifi-next-for-kalle-2017-10-18' of git://git.kernel.org=
/.../iwlwifi/iwlwifi-next
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Karun Eagalapati (3):
      rsi: sdio: add WOWLAN support for S3 suspend state
      rsi: sdio: Add WOWLAN support for S4 hibernate state
      rsi: sdio: Add WOWLAN support for S5 shutdown state

Kees Cook (9):
      rtlwifi: Convert timers to use timer_setup()
      qtnfmac: Convert timers to use timer_setup()
      iwlegacy: Convert timers to use timer_setup()
      atmel: Convert timers to use timer_setup()
      cw1200: Convert timers to use timer_setup()
      drivers/wireless: rsi: Convert timers to use timer_setup()
      mwifiex: Convert timers to use timer_setup()
      libertas: Convert timers to use timer_setup()
      ath: Convert timers to use timer_setup()

Liad Kaufman (1):
      iwlwifi: mvm: add missing lq_color

Loic Poulain (1):
      wcn36xx: Disable 5GHz for wcn3620

Luca Coelho (3):
      iwlwifi: mvm: move umac_error_event_table validity check to where it'=
s set
      iwlwifi: define minimum valid address for umac_error_event_table in c=
fg
      iwlwifi: pcie: sort IDs for the 9000 series for easier comparisons

Miaoqing Pan (1):
      ath9k: fix tx99 potential info leak

Nik Nyby (1):
      rtlwifi: rtl8821ae: Fix typo in variable name

Ping-Ke Shih (1):
      rtlwifi: Remove seq_number from rtl_tid_data

Rajkumar Manoharan (1):
      ath10k: add new cipher suite support

Sara Sharon (1):
      iwlwifi: mvm: remove duplicated fields in mvm reorder buffer

Sergey Matyukevich (4):
      qtnfmac: modify full Tx queue error reporting
      qtnfmac: enable registration of more mgmt frames
      qtnfmac: drop nonexistent function declaration
      qtnfmac: modify full Tx queue recovery

Thomas Meyer (1):
      ath9k: Use ARRAY_SIZE macro

Venkateswara Naralasetty (1):
      ath10k: check power save support in STA mode through FW IE

Ville Syrj=C3=A4l=C3=A4 (1):
      ath9k: Avoid a potential deadlock

 MAINTAINERS                                        |    1 -
 drivers/bcma/driver_mips.c                         |   11 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |    7 +-
 drivers/net/wireless/ath/ath10k/core.c             |   13 +
 drivers/net/wireless/ath/ath10k/core.h             |    3 +
 drivers/net/wireless/ath/ath10k/htt_rx.c           |    6 +-
 drivers/net/wireless/ath/ath10k/hw.c               |   13 +-
 drivers/net/wireless/ath/ath10k/hw.h               |    7 +-
 drivers/net/wireless/ath/ath10k/mac.c              |  168 +-
 drivers/net/wireless/ath/ath10k/pci.c              |   46 +-
 drivers/net/wireless/ath/ath10k/pci.h              |    2 +-
 drivers/net/wireless/ath/ath10k/spectral.c         |    2 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |    3 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |    1 +
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |    6 +-
 drivers/net/wireless/ath/ath6kl/core.h             |    2 +-
 drivers/net/wireless/ath/ath6kl/main.c             |    5 +-
 drivers/net/wireless/ath/ath6kl/txrx.c             |    6 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |    4 +-
 drivers/net/wireless/ath/ath6kl/wmi.h              |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |    5 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |    4 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |    4 +-
 drivers/net/wireless/ath/ath9k/channel.c           |   19 +-
 drivers/net/wireless/ath/ath9k/debug.c             |    4 +-
 drivers/net/wireless/ath/ath9k/dfs.c               |    2 +-
 drivers/net/wireless/ath/ath9k/gpio.c              |   14 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |    8 +-
 drivers/net/wireless/ath/ath9k/htc.h               |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   27 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   10 +-
 drivers/net/wireless/ath/ath9k/init.c              |   12 +-
 drivers/net/wireless/ath/ath9k/link.c              |   10 +-
 drivers/net/wireless/ath/ath9k/main.c              |   22 +-
 drivers/net/wireless/ath/ath9k/mci.c               |    2 +-
 drivers/net/wireless/ath/ath9k/tx99.c              |    5 +
 drivers/net/wireless/ath/ath9k/wmi.c               |    4 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   12 +-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |    6 +
 drivers/net/wireless/ath/wil6210/debugfs.c         |   45 -
 drivers/net/wireless/ath/wil6210/main.c            |   15 +-
 drivers/net/wireless/ath/wil6210/p2p.c             |    4 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |    2 +-
 drivers/net/wireless/atmel/atmel.c                 |   10 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        | 1675 ++++++++++------=
----
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |    2 +-
 drivers/net/wireless/intel/iwlegacy/3945-rs.c      |   10 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |    9 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |    4 +-
 drivers/net/wireless/intel/iwlegacy/common.h       |    2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c      |    3 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |    3 +-
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c      |    3 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |    4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |    1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   20 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   43 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   49 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   44 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   10 +
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   17 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   84 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |    5 +-
 drivers/net/wireless/marvell/libertas/cfg.c        |    3 -
 drivers/net/wireless/marvell/libertas/if_usb.c     |    6 +-
 drivers/net/wireless/marvell/libertas/main.c       |   21 +-
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |    6 +-
 drivers/net/wireless/marvell/libertas_tf/main.c    |    7 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |    7 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |    5 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |    3 +-
 drivers/net/wireless/marvell/mwifiex/init.c        |    7 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |    3 +-
 drivers/net/wireless/marvell/mwifiex/main.h        |    4 +-
 drivers/net/wireless/marvell/mwifiex/tdls.c        |    7 +-
 drivers/net/wireless/marvell/mwifiex/usb.c         |    9 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |   24 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |    5 +-
 drivers/net/wireless/quantenna/qtnfmac/core.c      |   29 +-
 drivers/net/wireless/quantenna/qtnfmac/core.h      |    4 +-
 .../net/wireless/quantenna/qtnfmac/pearl/pcie.c    |   15 +-
 .../quantenna/qtnfmac/pearl/pcie_bus_priv.h        |    1 +
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |   11 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |   26 +-
 drivers/net/wireless/realtek/rtlwifi/base.h        |    4 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |    2 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   17 -
 drivers/net/wireless/realtek/rtlwifi/ps.c          |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/dm.c    |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/dm.h    |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |    7 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.h    |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/sw.c    |   12 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |   10 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   17 -
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |    1 -
 drivers/net/wireless/rsi/rsi_91x_core.c            |    8 +
 drivers/net/wireless/rsi/rsi_91x_hal.c             |    7 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |  135 +-
 drivers/net/wireless/rsi/rsi_91x_main.c            |    5 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |   69 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |  141 ++
 drivers/net/wireless/rsi/rsi_common.h              |    5 +-
 drivers/net/wireless/rsi/rsi_main.h                |   12 +-
 drivers/net/wireless/rsi/rsi_mgmt.h                |   33 +-
 drivers/net/wireless/st/cw1200/main.c              |    3 +-
 drivers/net/wireless/st/cw1200/queue.c             |    6 +-
 drivers/net/wireless/st/cw1200/sta.c               |    5 +-
 drivers/net/wireless/st/cw1200/sta.h               |    2 +-
 111 files changed, 1838 insertions(+), 1426 deletions(-)

--=20
Kalle Valo
