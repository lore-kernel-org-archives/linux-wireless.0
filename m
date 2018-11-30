Return-Path: <SRS0=8CYu=OJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73767C64EB4
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 13:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B9F220660
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 13:33:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="L+tSvIuq";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="J/0n2KWF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B9F220660
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbeLAAmz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 30 Nov 2018 19:42:55 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57102 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbeLAAmz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Nov 2018 19:42:55 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1233F612EE; Fri, 30 Nov 2018 13:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543584815;
        bh=u753U7oXl3ORMYsfyhTi2y6junJHpD86Z6Jg6hJtpoE=;
        h=From:To:Cc:Subject:Date:From;
        b=L+tSvIuqFgTl4b1WveT80SJaPIg2LBu9dJ1iMlghEcH/o/UlLoyydBpdJMAfkRoB4
         HXNjeJIUWb5vhCHkfwwG+fU4Q+81iicx6MVjITtSDMd91EZEo8rLghlf8XSBlETYDd
         PkaN9GEgMZvTAJ8l33vukrrN780QGFZnTCiAQNoQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C2ABA612EE;
        Fri, 30 Nov 2018 13:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543584813;
        bh=u753U7oXl3ORMYsfyhTi2y6junJHpD86Z6Jg6hJtpoE=;
        h=From:To:Cc:Subject:Date:From;
        b=J/0n2KWFWK85HbWw0XZMJgFdB+7+gyP799YBzPoTuNy4HDKF4zDEG0Rliv2bR2D+0
         zm5D5ah+rbIrxD/pclC+FCVrgX+qsGz7idKn1msiSRbRv7U/OG2bZ09D/z9inH3kfp
         xJ4NVvmGY/9YmUT+aAsmZIIKLKRMzQKzpwGWVTc4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C2ABA612EE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2018-11-30
Date:   Fri, 30 Nov 2018 15:33:29 +0200
Message-ID: <874lby666u.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

here's a pull request to net-next tree for 4.21, more info below. Please
let me know if you have any problems.

Kalle


The following changes since commit 651022382c7f8da46cb4872a545ee1da6d097d2a:

  Linux 4.20-rc1 (2018-11-04 15:37:52 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git tags/wireless-drivers-next-for-davem-2018-11-30

for you to fetch changes up to b72c51a58e6d63ef673ac96b8ab5bc98799c5f7b:

  brcmfmac: Fix out of bounds memory access during fw load (2018-11-29 17:3=
3:10 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for 4.21

First set of patches for 4.21. Most notable here is support for
Quantenna's QSR1000/QSR2000 chipsets and more flexible ways to provide
nvram files for brcmfmac.

Major changes:

brcmfmac

* add support for first trying to get a board specific nvram file

* add support for getting nvram contents from EFI variables

qtnfmac

* use single PCIe driver for all platforms and rename
  Kconfig option CONFIG_QTNFMAC_PEARL_PCIE to CONFIG_QTNFMAC_PCIE

* add support for QSR1000/QSR2000 (Topaz) family of chipsets

ath10k

* add support for WCN3990 firmware crash recovery

* add firmware memory dump support for QCA4019

wil6210

* add firmware error recovery while in AP mode

ath9k

* remove experimental notice from dynack feature

iwlwifi

* PCI IDs for some new 9000-series cards

* improve antenna usage on connection problems

* new firmware debugging infrastructure

* some more work on 802.11ax

* improve support for multiple RF modules with 22000 devices

cordic

* move cordic macros and defines to a public header file

* convert brcmsmac and b43 to fully use cordic library

----------------------------------------------------------------
Ahmad Masri (5):
      wil6210: refactor disconnect flow
      wil6210: notify cqm packet loss on disable_ap_sme
      wil6210: fix debugfs memory access alignment
      wil6210: remove unnecessary alignment code from rx flow
      wil6210: fix freeing of rx buffers in EDMA mode

Alexei Avshalom Lazar (2):
      wil6210: fix reset flow for Talyn-mb
      wil6210: add general initialization/size checks

Ali MJ Al-Nasrawy (1):
      brcmsmac: never log "tid x is not agg'able" by default

Andrei Otcheretianski (1):
      iwlwifi: mvm: Send non offchannel traffic via AP sta

Anilkumar Kolli (3):
      ath10k: dump tx stats in rate table format
      ath10k: add memory dump support for QCA4019
      ath10k: assign proper firmware crash dump structure

Avraham Stern (2):
      iwlwifi: mvm: switch management tx antenna only on tx failure
      iwlwifi: mvm: toggle tx antenna if tx fails during connection establi=
shment

Brian Norris (8):
      ath10k: snoc: remove 'wcn3990' from generic resource handling
      ath10k: snoc: fix unabalanced regulator error handling
      ath10k: snoc: relax voltage requirements
      ath10k: snoc: fix unbalanced clock error handling
      ath10k: ath10k_snoc_{read,write}32() should be static
      ath10k: assign 'n_cipher_suites' for WCN3990
      ath10k: don't assume this is a PCI dev in generic code
      ath10k: fix struct init whitespace in SNOC driver

Christophe JAILLET (1):
      wlcore: Fix the return value in case of error in 'wlcore_vendor_cmd_s=
mart_config_start()'

Colin Ian King (3):
      ath10k: fix some spelling mistakes
      rsi: fix spelling mistake "Initialzing" -> "Initializing"
      brcmfmac: fix spelling mistake "Retreiving" -> "Retrieving"

Dan Carpenter (2):
      ath10k: fixup extended per sta tx statistics
      wireless: airo: potential buffer overflow in sprintf()

Dan Haab (1):
      brcmfmac: support STA info struct v7

Dedy Lansky (2):
      wil6210: make sure Rx ring sizes are correlated
      wil6210: add recovery for FW error while in AP mode

Emmanuel Grumbach (3):
      iwlwifi: mvm: remove unused conversion table
      iwlwifi: mvm: remove assignment of the reciprocal
      iwlwifi: mvm: add support for TWT capabilities

Gustavo A. R. Silva (22):
      ath9k: ar5008_phy: mark expected switch fall-through
      ath9k: ar9002_phy: mark expected switch fall-throughs
      ath9k: hw: mark expected switch fall-through
      ath6kl: Mark expected switch fall-through
      carl9170: rx: mark expected switch fall-through
      carl9170: tx: mark expected switch fall-throughs
      rtl8xxxu: Mark expected switch fall-throughs
      rtl8xxxu: Fix missing break in switch
      iwlegacy: 4965-mac: mark expected switch fall-through
      iwlegacy: common: mark expected switch fall-throughs
      orinoco_usb: mark expected switch fall-through
      prism54: isl_38xx: Mark expected switch fall-through
      prism54: isl_ioctl: mark expected switch fall-through
      prism54: islpci_dev: mark expected switch fall-through
      mwifiex: Mark expected switch fall-through
      rt2x00: rt2400pci: mark expected switch fall-through
      rt2x00: rt2500pci: mark expected switch fall-through
      rt2x00: rt2800lib: mark expected switch fall-throughs
      rt2x00: rt61pci: mark expected switch fall-through
      ray_cs: mark expected switch fall-throughs
      rtlwifi: rtl8821ae: phy: Mark expected switch fall-through
      zd1201: mark expected switch fall-through

Hamad Kadmany (1):
      wil6210: remove fake support for RXHASH

Hans de Goede (9):
      brcmfmac: Remove firmware-loading code duplication
      brcmfmac: Remove recursion from firmware load error handling
      brcmfmac: Add support for first trying to get a board specific nvram =
file
      brcmfmac: Set board_type used for nvram file selection to machine-com=
patible
      brcmfmac: Set board_type from DMI on x86 based machines
      brcmfmac: Cleanup brcmf_fw_request_done()
      brcmfmac: Add support for getting nvram contents from EFI variables
      brcmfmac: Fix ccode from EFI nvram when necessary
      brcmfmac: Call brcmf_dmi_probe before brcmf_of_probe

Igor Mitsyanko (1):
      qtnfmac_pcie: use single PCIe driver for all platforms

Ihab Zhaika (1):
      iwlwifi: add new cards for 9560, 9462, 9461 and killer series

Johannes Berg (2):
      iwlwifi: mvm: synchronize TID queue removal
      iwlwifi: mvm: remove queue_info_lock

Kalle Valo (3):
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      Merge tag 'iwlwifi-next-for-kalle-2018-11-11' of git://git.kernel.org=
/.../iwlwifi/iwlwifi-next
      Merge tag 'iwlwifi-next-for-kalle-2018-11-23' of git://git.kernel.org=
/.../iwlwifi/iwlwifi-next

Larry Finger (1):
      b43: Fix error in cordic routine

Lior Cohen (2):
      iwlwifi: add fw dump upon RT ucode start failure
      iwlwifi: add debugfs file to read fw debug data recording

Lior David (2):
      wil6210: fix memory leak in wil_find_tx_bcast_2
      wil6210: fix locking in wmi_call

Lorenzo Bianconi (5):
      ath9k: dynack: use authentication messages for 'late' ack
      ath9k: dynack: move debug log after buffer increments
      ath9k: dynack: check da->enabled first in sampling routines
      ath9k: dynack: make ewma estimation faster
      ath9k: dynack: remove 'experimental' tag

Luca Coelho (1):
      iwlwifi: fix cfg structs for 22000 with different RF modules

Lyude Paul (1):
      brcmfmac: Fix out of bounds memory access during fw load

Maya Erez (3):
      wil6210: increase RX rings and RX buff array size
      wil6210: fix L2 RX status handling
      wil6210: fix RGF_CAF_ICR address for Talyn-MB

Naftali Goldstein (2):
      iwlwifi: fw: do not set sgi bits for HE connection
      iwlwifi: mvm: add description to a few generic assert numbers

Priit Laes (3):
      lib: cordic: Move cordic macros and defines to header file
      brcmsmac: Use cordic-related macros from common cordic library
      b43: Use cordic algorithm from kernel library

Rafa=C5=82 Mi=C5=82ecki (1):
      brcmutil: print invalid chanspec when WARN-ing

Rakesh Pillai (1):
      ath10k: fill the channel survey results for WCN3990 correctly

Sara Sharon (12):
      iwlwifi: pcie: don't reset TXQ write pointer
      iwlwifi: dbg: avoid passing trigger around
      iwlwifi: dbg: use helper to check if debug type is set
      iwlwifi: fw: use helper to determine whether to dump paging
      iwlwifi: dbg: don't limit dump decisions to all or monitor
      iwlwifi: dbg: split fifos dump
      iwlwifi: fw: add FW API of new TLV infrastructure
      iwlwifi: trans: parse and store debug ini TLVs
      iwlwifi: trans: support loading ini TLVs from external file
      iwlwifi: dbg: disable triggers for ini
      iwlwifi: dbg: add apply point logic
      iwlwifi: fw: support API change to debug TLVs

Sergey Matyukevich (2):
      qtnfmac: add support for Topaz chipsets
      qtnfmac: fix error handling in control path

Shahar S Matityahu (1):
      iwlwifi: trans: Clear persistence bit when starting the FW

Shaokun Zhang (1):
      rtlwifi: rtl8192de: Fix misleading REG_MCUFWDL information

Shaul Triebitz (3):
      iwlwifi: mvm: set MAC_FILTER_IN_11AX in AP mode
      iwlwifi: mvm: send the STA_HE_CTXT command in AP mode
      iwlwifi: mvm: set HW capability VHT_EXT_NSS_BW

Surabhi Vishnoi (1):
      ath10k: add support for WCN3990 firmware crash recovery

Tova Mussai (1):
      iwlwifi: mvm: enable low latency for soft ap

Wei Yongjun (1):
      ath10k: fix copy-paste error in ath10k_qmi_setup_msa_resources()

Yangtao Li (3):
      ath10k: fix some typo
      cw1200: fix small typo
      iwlegacy: fix small typo

YueHaibing (4):
      ath10k: remove set but not used variable 'tlv_len'
      libertas: remove set but not used variable 'int_type'
      rtlwifi: btcoex: remove set but not used variable 'ppsc'
      iwlwifi: mvm: remove set but not used variable 'he_phy_data'

zhong jiang (3):
      ath9k: remove set but not used variable 'new_flags'
      rtlwifi: rtl8723ae: Remove set but not used variables and #defines
      rtlwifi: Remove same duplicated includes

 drivers/net/wireless/ath/ath10k/core.c             |    5 +
 drivers/net/wireless/ath/ath10k/core.h             |    5 +
 drivers/net/wireless/ath/ath10k/coredump.c         |  118 +-
 drivers/net/wireless/ath/ath10k/coredump.h         |    1 +
 drivers/net/wireless/ath/ath10k/debugfs_sta.c      |   12 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   17 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   11 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |    8 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |  228 ++--
 drivers/net/wireless/ath/ath10k/snoc.h             |   17 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |    6 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h          |   10 +
 drivers/net/wireless/ath/ath10k/wmi.c              |  128 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |   13 +
 drivers/net/wireless/ath/ath10k/wow.c              |    4 +-
 drivers/net/wireless/ath/ath6kl/main.c             |    1 +
 drivers/net/wireless/ath/ath9k/Kconfig             |    2 +-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        |    2 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c        |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_mci.c        |    4 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |    2 +-
 drivers/net/wireless/ath/ath9k/dynack.c            |   61 +-
 drivers/net/wireless/ath/ath9k/dynack.h            |    6 +-
 drivers/net/wireless/ath/ath9k/hw.c                |    1 +
 drivers/net/wireless/ath/ath9k/xmit.c              |    5 +-
 drivers/net/wireless/ath/carl9170/rx.c             |    1 +
 drivers/net/wireless/ath/carl9170/tx.c             |    3 +
 drivers/net/wireless/ath/wil6210/cfg80211.c        |  104 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |   17 +-
 drivers/net/wireless/ath/wil6210/main.c            |  227 +++-
 drivers/net/wireless/ath/wil6210/netdev.c          |    5 +-
 drivers/net/wireless/ath/wil6210/txrx.c            |   14 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.c       |   92 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.h       |    4 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |   21 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |   56 +-
 drivers/net/wireless/broadcom/b43/Kconfig          |    1 +
 drivers/net/wireless/broadcom/b43/phy_common.c     |   47 -
 drivers/net/wireless/broadcom/b43/phy_common.h     |    9 -
 drivers/net/wireless/broadcom/b43/phy_lp.c         |   13 +-
 drivers/net/wireless/broadcom/b43/phy_n.c          |   13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/Makefile  |    2 +
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |    7 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |    8 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/dmi.c |  116 ++
 .../broadcom/brcm80211/brcmfmac/firmware.c         |  215 ++--
 .../broadcom/brcm80211/brcmfmac/firmware.h         |    1 +
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |   40 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |   11 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |    1 +
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |    1 +
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |    4 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_int.h      |    7 -
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c      |    4 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        |    4 +-
 .../net/wireless/broadcom/brcm80211/brcmutil/d11.c |   14 +-
 drivers/net/wireless/cisco/airo.c                  |    2 +-
 drivers/net/wireless/intel/iwlegacy/3945-rs.c      |    2 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |    2 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |    2 +
 drivers/net/wireless/intel/iwlwifi/Makefile        |    1 +
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |    1 -
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |  401 +++++++
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h    |   39 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |  384 ++++--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |   40 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |    7 +
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |   26 +
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |    5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |  230 ++++
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h   |   87 ++
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   24 +-
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h |    2 +
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |    7 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   25 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |    2 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |   14 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |    5 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   46 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   31 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   18 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |    4 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |    6 -
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  114 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |    4 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   83 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   54 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   52 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   44 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  225 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |    3 +-
 .../net/wireless/intersil/orinoco/orinoco_usb.c    |    1 +
 drivers/net/wireless/intersil/prism54/isl_38xx.c   |    1 +
 drivers/net/wireless/intersil/prism54/isl_ioctl.c  |    1 +
 drivers/net/wireless/intersil/prism54/islpci_dev.c |    1 +
 drivers/net/wireless/marvell/libertas/if_spi.c     |    4 +-
 drivers/net/wireless/marvell/mwifiex/ie.c          |    1 +
 drivers/net/wireless/quantenna/qtnfmac/Kconfig     |   15 +-
 drivers/net/wireless/quantenna/qtnfmac/Makefile    |    9 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |   21 +-
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c |  282 +++--
 .../wireless/quantenna/qtnfmac/pcie/pcie_priv.h    |   20 +-
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   |  211 +---
 .../wireless/quantenna/qtnfmac/pcie/topaz_pcie.c   | 1219 ++++++++++++++++=
++++
 .../quantenna/qtnfmac/pcie/topaz_pcie_ipc.h        |   94 ++
 .../quantenna/qtnfmac/pcie/topaz_pcie_regs.h       |   45 +
 .../net/wireless/quantenna/qtnfmac/qtn_hw_ids.h    |    4 +-
 drivers/net/wireless/quantenna/qtnfmac/util.c      |   18 +
 drivers/net/wireless/quantenna/qtnfmac/util.h      |    2 +
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c     |    2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c     |    2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |    4 +
 drivers/net/wireless/ralink/rt2x00/rt61pci.c       |    2 +-
 drivers/net/wireless/ray_cs.c                      |    2 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |    5 +
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |    4 -
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c   |    1 -
 .../net/wireless/realtek/rtlwifi/rtl8192de/fw.c    |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/phy.c   |    5 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/table.c |    4 -
 .../net/wireless/realtek/rtlwifi/rtl8723ae/table.h |    2 -
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   |    1 +
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c   |    1 -
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c        |    4 +-
 drivers/net/wireless/st/cw1200/sta.c               |    2 +-
 drivers/net/wireless/ti/wlcore/vendor_cmd.c        |    2 +-
 drivers/net/wireless/zydas/zd1201.c                |    1 +
 include/linux/cordic.h                             |    9 +
 lib/cordic.c                                       |   23 +-
 131 files changed, 4620 insertions(+), 1144 deletions(-)
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie_=
ipc.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie_=
regs.h
