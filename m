Return-Path: <SRS0=Y2GN=M2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6572CC7112A
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Oct 2018 15:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D761204FD
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Oct 2018 15:05:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KeOliAdF";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZHA3PRte"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D761204FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbeJNWqa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 14 Oct 2018 18:46:30 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33938 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbeJNWqa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Oct 2018 18:46:30 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 39C896087D; Sun, 14 Oct 2018 15:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539529515;
        bh=mSMoOsI5S2SbuRw0+4CdMy5isA/SsfwFQR4Vo8mE2XY=;
        h=From:To:Cc:Subject:Date:From;
        b=KeOliAdFvrY58A1Ri8k34pszXYoZ39M1BpaW2QSTwkP3sEwvHj9X+O1om9wwUQT3B
         gfdEqr7BiFv5mbbH9QVQWs2wV11ur/i7OTNYg7CKejjBiaPS/J+sNPu/JJ1wMQpz9W
         7eFeceYdGC032uA9nWbS3fWUt2HvAK1TsXJJkbGc=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0BCEB6024C;
        Sun, 14 Oct 2018 15:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539529513;
        bh=mSMoOsI5S2SbuRw0+4CdMy5isA/SsfwFQR4Vo8mE2XY=;
        h=From:To:Cc:Subject:Date:From;
        b=ZHA3PRtezkEaksUvcElZeYMS2MTU460YDr8Ooouvbgoccsvi/BhHDimcaj1dwcxuu
         zvsEFSlM3RIwn0ZtyFL3N0/Hwr58MZ0LRPw6+3i4GI9vyGb62qIP4aKsaMvq7agbqy
         4cGqt02+JkYpybxim7IY+rDjZhosKUXKU3TO+igg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0BCEB6024C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: pull-request: wireless-drivers-next 2018-10-14
Date:   Sun, 14 Oct 2018 18:05:08 +0300
Message-ID: <874ldo1sd7.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

here's most likely the final pull request to net-next for 4.20. These
have not yet been in linux-next due to timing on my part (see below) but
luckily kbuild bot is back in action so I have pretty good confidence
with these.

I'm about to leave for a vacation and I will be offline the next 8 days.
But Johannes (CCed) kindly promised to look after driver patches while
I'm gone and see if there's anything urgent needing attention. So please
do let him know if there are any problems :)

Kalle

The following changes since commit d864991b220b7c62e81d21209e1fd978fd67352c:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2018-10-12 21:38:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-for-davem-2018-10-14

for you to fetch changes up to f95cd52476dee761a1a8ebe617dd01793e0eb39c:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2018-10-14 12:21:43 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for 4.20

Third set of patches for 4.20. Most notable is finalising ath10k
wcn3990 support, all components should be implemented now.

Major changes:

ath10k

* support NET_DETECT WoWLAN feature

* wcn3990 basic functionality now working after we got QMI support

mt76

* mt76x0e improvements (should be usable now)

* more mt76x0/mt76x2 unification work

brcmsmac

* fix a problem on AP mode with clients using power save mode

iwlwifi

* support for a new scan type: fast balance

----------------------------------------------------------------
Ali MJ Al-Nasrawy (1):
      brcmsmac: AP mode: update beacon when TIM changes

Arnd Bergmann (1):
      ath9k: fix RX_STAT_INC() etc macros

Ayala Beker (2):
      iwlwifi: mvm: introduce a new fragmented scan type: fast balance
      iwlwifi: mvm: use fast balance scan in case of DCM mode with P2P GO

Balaji Pothunoori (1):
      ath10k: management tx ack rssi capability check

Carl Huang (1):
      ath10k: allocate small size dma memory in ath10k_pci_diag_write_mem

Colin Ian King (1):
      rtlwifi: rtl8821ae: replace _rtl8821ae_mrate_idx_to_arfr_id with generic version

Dan Carpenter (1):
      ath10k: htt: remove some dead code

Felix Fietkau (2):
      mt76: do not store aggregation sequence number for null-data frames
      mt76: mt76x0e: another fix for the external PA current setting

Govind Singh (5):
      ath10k: add qmi service helpers for wcn3990 qmi client
      dt: bindings: add bindings for msa memory region
      firmware: qcom: scm: Add WLAN VMID for Qualcomm SCM interface
      ath10k: add debug mask for QMI layer
      ath10k: add QMI message handshake for wcn3990 client

Gustavo A. R. Silva (2):
      ath10k: htt_rx: fix signedness bug in ath10k_update_per_peer_tx_stats
      ath10k: remove unnecessary comparison of unsigned integer with < 0

Jia-Ju Bai (1):
      iwlegacy: Add a lock assertion in il4965_send_rxon_assoc()

Johannes Berg (11):
      iwlwifi: mvm: give TX queue info struct a name
      iwlwifi: mvm: move queue management into sta.c
      iwlwifi: mvm: remove per-queue hw refcount
      iwlwifi: mvm: clean up iteration in iwl_mvm_inactivity_check()
      iwlwifi: mvm: move queue reconfiguration into new function
      iwlwifi: mvm: reconfigure queues during inactivity check
      iwlwifi: mvm: remove RECONFIGURING queue state
      iwlwifi: mvm: make queue TID change more explicit
      iwlwifi: mvm: make iwl_mvm_scd_queue_redirect() static
      iwlwifi: mvm: move iwl_mvm_sta_alloc_queue() down
      iwlwifi: mvm: kill INACTIVE queue state

Kalle Valo (3):
      Merge tag 'iwlwifi-next-for-kalle-2018-10-12' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge tag 'mt76-for-kvalo-2018-10-13' of https://github.com/nbd168/wireless
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Lorenzo Bianconi (26):
      mt76x0: phy: fix bank check in mt76x0_rf_csr_{wr,rr}
      mt76: use mt76x02_dev instead of mt76_dev in mt76x02_mcu.c
      mt76: use mt76x02_dev instead of mt76_dev in mt76x02_phy.c
      mt76: use mt76x02_dev instead of mt76_dev in mt76x02_util.c
      mt76: use mt76x02_dev instead of mt76_dev in mt76x02_usb_mcu.c
      mt76: use mt76x02_dev instead of mt76_dev in mt76x02_mac.c
      mt76: use mt76x02_dev instead of mt76_dev in mt76x02_txrx.c
      mt76: use mt76x02_dev instead of mt76_dev in mt76x02_eeprom.c
      mt76x0: pci: report firmware version using ethtool
      mt76x0: pci: add missing mac80211 callbacks
      mt76: disable ldpc coding for mt76x0 devices
      mt76x0: pci: add mt76x0_register_device in mt76x0e_register_device
      mt76x0: phy: fix restore phase in mt76x0_phy_recalibrate_after_assoc
      mt76x0: phy: remove channel parameter from mt76x0_phy_set_chan_bbp_params
      mt76: move mt76x02_phy_set_bw in mt76x02-lib module
      mt76: move mt76x02_phy_set_band in mt76x02-lib module
      mt76x0: pci: rename mt76x0_phy_calibrate
      mt76x0: pci: introduce mt76x0_phy_calirate routine
      mt76x0: phy: update set_channel for mt76x0e devices
      mt76x0: eeprom: introduce mt76x0_tssi_enabled routine
      mt76x0: phy: add phy/vco temperature compensation
      mt76: move rssi_gain_thresh routines in mt76x02-lib module
      mt76: move mt76x02_phy_adjust_vga_gain in mt76/mt76x02_phy.c
      mt76: introduce mt76x02_init_agc_gain routine
      mt76x0: phy: align channel gain logic to mt76x2 one
      mt76x0: phy: do not run calibration during channel switch

Lubomir Rintel (2):
      libertas: don't set URB_ZERO_PACKET on IN USB transfer
      libertas: return errno from lbs_add_card()

Luca Coelho (1):
      iwlwifi: mvm: check return value of rs_rate_from_ucode_rate()

Rakesh Pillai (2):
      ath10k: set probe request oui during driver start
      ath10k: add support to create boardname for non-bmi target

Sara Sharon (3):
      iwlwifi: mvm: don't send keys when entering D3
      iwlwifi: pcie: don't pad AMSDU packets
      iwlwifi: trace: change trace to trace one TB at a time

Sergey Matyukevich (3):
      qtnfmac: use 'help' in Kconfig
      qtnfmac: use SPDX identifier for pcie bus layer files
      qtnfmac_pcie: cleanup Pearl platform headers

Shahar S Matityahu (2):
      iwlwifi: dump debug data before stop device
      iwlwifi: mvm: move rt status check to the start of the resume flow

Sriram R (1):
      ath10k: fix possible out of bound access of ath10k_rates array

Stanislaw Gruszka (7):
      mt76x0: print BBP version only for debug
      mt76x0: correct RF access via RF_CSR register.
      mt76: allow to identify bus
      mt76x0: correct RF reg pairs write for PCIe
      mt76x0: use bus helper to identify rf access method
      mt76: reserve enough room for USB tx skbs
      mt76x0: remove dma.h

Wen Gong (2):
      ath10k: support NET_DETECT WoWLAN feature
      ath10k: add peer flush in ath10k_flush for STATION

YueHaibing (3):
      mt76x0: pci: fix set external PA I/O current
      rtl8xxxu: Remove set but not used variables 'usedesc40' and 'seq_number'
      wil6210: fix debugfs_simple_attr.cocci warnings

 .../bindings/net/wireless/qcom,ath10k.txt          |    6 +
 drivers/net/wireless/ath/ath10k/Kconfig            |    1 +
 drivers/net/wireless/ath/ath10k/Makefile           |    4 +-
 drivers/net/wireless/ath/ath10k/core.c             |   14 +-
 drivers/net/wireless/ath/ath10k/core.h             |    5 +
 drivers/net/wireless/ath/ath10k/debug.c            |    2 +-
 drivers/net/wireless/ath/ath10k/debug.h            |    1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c           |    5 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   76 +-
 drivers/net/wireless/ath/ath10k/pci.c              |   23 +-
 drivers/net/wireless/ath/ath10k/qmi.c              | 1019 ++++++++++
 drivers/net/wireless/ath/ath10k/qmi.h              |  129 ++
 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c     | 2072 ++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h     |  677 +++++++
 drivers/net/wireless/ath/ath10k/snoc.c             |  267 ++-
 drivers/net/wireless/ath/ath10k/snoc.h             |    4 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h          |   21 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |  187 ++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h          |  254 +++
 drivers/net/wireless/ath/ath10k/wmi.h              |   57 +
 drivers/net/wireless/ath/ath10k/wow.c              |  168 ++
 drivers/net/wireless/ath/ath9k/antenna.c           |    8 +-
 drivers/net/wireless/ath/ath9k/common-spectral.c   |    8 +-
 drivers/net/wireless/ath/ath9k/debug.c             |   24 +-
 drivers/net/wireless/ath/ath9k/debug.h             |   20 +-
 drivers/net/wireless/ath/ath9k/main.c              |    2 +-
 drivers/net/wireless/ath/ath9k/recv.c              |   18 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   18 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |   14 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |   26 +
 .../wireless/broadcom/brcm80211/brcmsmac/main.h    |    1 +
 drivers/net/wireless/intel/iwlegacy/4965.c         |    2 +
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   27 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |    1 +
 .../net/wireless/intel/iwlwifi/iwl-devtrace-data.h |   30 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   64 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |    9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   54 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   24 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  115 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  837 +++++---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |    8 -
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   34 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  420 +---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |   28 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   29 +-
 drivers/net/wireless/marvell/libertas/if_cs.c      |    4 +-
 drivers/net/wireless/marvell/libertas/if_sdio.c    |    4 +-
 drivers/net/wireless/marvell/libertas/if_spi.c     |    4 +-
 drivers/net/wireless/marvell/libertas/if_usb.c     |    7 +-
 drivers/net/wireless/marvell/libertas/main.c       |   17 +-
 drivers/net/wireless/mediatek/mt76/mmio.c          |    1 +
 drivers/net/wireless/mediatek/mt76/mt76.h          |    9 +
 drivers/net/wireless/mediatek/mt76/mt76x0/dma.h    |  126 --
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |   55 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h |    6 +
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |    9 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |   22 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h    |    3 +
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |    3 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |   49 +-
 .../net/wireless/mediatek/mt76/mt76x0/pci_mcu.c    |    1 +
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |  311 +--
 .../net/wireless/mediatek/mt76/mt76x0/usb_mcu.c    |    7 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |   25 +-
 .../net/wireless/mediatek/mt76/mt76x02_eeprom.c    |   33 +-
 .../net/wireless/mediatek/mt76/mt76x02_eeprom.h    |   37 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |  206 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |   31 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c   |   74 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h   |   14 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c   |  167 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.h   |   39 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h  |    4 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c  |   29 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_usb.h   |    8 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  |   20 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |   27 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |  120 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c |   80 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h |   23 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/init.c   |    3 +
 drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c    |    5 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h |    2 -
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c   |   18 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_mac.c    |    2 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_main.c   |    2 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_mcu.c    |    6 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_phy.c    |  100 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c    |   61 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c   |   11 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_mac.c    |    6 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_main.c   |    4 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_mcu.c    |   18 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_phy.c    |   32 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |    3 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |    1 +
 drivers/net/wireless/quantenna/Kconfig             |    2 +-
 drivers/net/wireless/quantenna/qtnfmac/Kconfig     |    2 +-
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   |   17 +-
 .../quantenna/qtnfmac/pcie/pearl_pcie_ipc.h        |   22 +-
 .../quantenna/qtnfmac/pcie/pearl_pcie_regs.h       |  245 +--
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |    5 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |   71 +-
 include/linux/qcom_scm.h                           |    4 +-
 106 files changed, 6783 insertions(+), 2249 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/qmi.c
 create mode 100644 drivers/net/wireless/ath/ath10k/qmi.h
 create mode 100644 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c
 create mode 100644 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/dma.h
