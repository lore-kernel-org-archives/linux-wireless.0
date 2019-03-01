Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A723EC43381
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 14:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68906206DD
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 14:56:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dRULPZq4";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="C71mKaib"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388094AbfCAO4I (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 09:56:08 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33376 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfCAO4H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 09:56:07 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 299FF60907; Fri,  1 Mar 2019 14:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551452166;
        bh=rwixTeJdGjUFssSrS1Lo6IWiLdJgj+MVq+Flw3CXVKk=;
        h=From:To:Cc:Subject:Date:From;
        b=dRULPZq4o5p1vkJrU4Yl962eWGcQcYB2zBcP/BWJQAQDlbqr/1kOt8JuMeF/uImFK
         QHdhJgaHDaIoOpHBchxpMApwT0oN9PQqk96hWi41aQWoHtPAR8TCIgQsyvx6SmWRPD
         WNQTuVoYVrvfXNLMC4BzNie46pqhZWtC6vtUpnps=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9AD6D602A7;
        Fri,  1 Mar 2019 14:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551452165;
        bh=rwixTeJdGjUFssSrS1Lo6IWiLdJgj+MVq+Flw3CXVKk=;
        h=From:To:Cc:Subject:Date:From;
        b=C71mKaibk9134fW76EkemXKgc5uhMotv51a+swN77gxe84pbskmSPjANoZbwcbHrH
         YEtPnuCEMcOxlAogxIAN3PRp2m0MPLBN+bJF7gPqX43QfZDngkJQWEcJ5YwrEV84lk
         O2a/l+ok8pWpoZTFZG2+ilKAQ1lOqMQvpMK4ZAqw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9AD6D602A7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2019-03-01
Date:   Fri, 01 Mar 2019 16:55:59 +0200
Message-ID: <8736o6hce8.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

as Linus gave us one more week here are few more patches to net-next for
5.1. Please let me know if there are any problems.

Kalle

The following changes since commit bd16693f359bbab8776541c06a6df32f3996638e:

  net: fix double-free in bpf_lwt_xmit_reroute (2019-02-24 22:24:50 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git tags/wireless-drivers-next-for-davem-2019-03-01

for you to fetch changes up to 501faf710230b67e470b314868110357cf3a554d:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/a=
th.git (2019-02-28 11:50:40 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for 5.1

Last set of patches. A new hardware support for mt76 otherwise quite
normal.

Major changes:

mt76

* add driver for MT7603E/MT7628

ath10k

* more preparation for SDIO support

wil6210

* support up to 20 stations in AP mode

----------------------------------------------------------------
Abhishek Ambure (3):
      ath10k: add support for ack rssi value of management tx packets
      ath10k: add support for ack rssi value of data tx packets
      ath10k: update the max num of peers supported for WCN3990

Ahmad Masri (2):
      wil6210: support up to 20 stations in AP mode
      wil6210: accessing 802.3 addresses via utility functions

Alagu Sankar (3):
      ath10k: sdio: set hi_acs_flags
      ath10k: sdio: disable fwlog prints
      ath10k: don't report unset rssi values to mac80211

Alexei Avshalom Lazar (1):
      wil6210: check null pointer in _wil_cfg80211_merge_extra_ies

Andrea Greco (1):
      ath9k: debugfs: Fix SPUR-DOWN field

Colin Ian King (1):
      rsi: fix missing null pointer check from a failed ieee80211_probereq_=
get call

Dedy Lansky (2):
      wil6210: add option to drop Tx packets when Tx ring is full
      wil6210: fix invalid sta statistics update

Felix Fietkau (11):
      mt76: mt76x02: fix TSF sync mode
      mt76: mt76x02: fix beacon timer drift adjustment
      mt76: mt76x02: fix beacon timer issue
      mt76: mt76x02: only reset beacon drift counter when enabling beacons
      mt76: mt76x02: issue watchdog reset on MCU request timeout
      mt76: mt76x02: fix ED/CCA enabling/disabling
      mt76: mt76x2: unify mt76x2[u]_mac_resume
      mt76: mt76x02: set MT_TXOP_HLDR_TX40M_BLK_EN for mt76x2
      mt76: add driver callback for when a sta is associated
      dt-bindings: net: mt76: update binding for mt7603 driver
      mt76: add driver for MT7603E and MT7628/7688

Kalle Valo (2):
      Merge tag 'mt76-for-kvalo-2019-02-26' of https://github.com/nbd168/wi=
reless
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Larry Finger (8):
      rtlwifi: Fix errors in spacing in wifi.h
      rtlwifi: Fix problems with block comments in wifi.h
      rtlwifi: Fix alignment errors in wifi.h
      rtlwifi: Fix blank line errors in main header files
      rtlwifi: Fix all blank line irregularities in main code files
      rtlwifi: rtl8192ce: Fix missing blank lines
      rtlwifi: rtl8192cu: Fix problems with blank lines
      rtlwifi: rtl8192com: Fix blank line problems

Lorenzo Bianconi (6):
      mt76: usb: fix warning in mt76u_buf_free
      mt76: usb: introduce mt76u_fill_bulk_urb routine
      mt76: usb: simplify rx buffer allocation
      mt76: usb: simplify mt76u_tx_build_sg routine
      mt76: usb: check urb->num_sgs limit in mt76u_process_rx_entry
      mt76: remove no longer used routine declarations

Maya Erez (2):
      wil6210: remove rtap_include_phy_info module param
      wil6210: ignore HALP ICR if already handled

Rafa=C5=82 Mi=C5=82ecki (2):
      brcmfmac: fix size of the struct msgbuf_ring_status
      brcmfmac: print firmware reported general status errors

Rakesh Pillai (2):
      ath10k: fix descriptor size in ce tx completion for WCN3990
      ath10k: enhance logging for vdev pdev & peer set param

Stanislaw Gruszka (3):
      mt76usb: allow mt76u_bulk_msg be used for reads
      mt76usb: use synchronous msg for mcu command responses
      mt76usb: remove usb_mcu.c

Surabhi Vishnoi (6):
      ath10k: Fix length of wmi tlv command for protected mgmt frames
      ath10k: Fix the incorrect updation of NSS data in tx stats
      ath10k: Fix the wrong updation of BW in tx_stats debugfs entry
      ath10k: Fix the wrong updation of SGI in tx_stats debugfs
      ath10k: Fix the wrong calculation ht_idx and idx of rate table for tx=
_stats
      ath10k: Fill rx duration for each peer in fw_stats for WCN3990

Toke H=C3=B8iland-J=C3=B8rgensen (1):
      ath9k: Make sure to zero status.tx_time before reporting TX status

Wen Gong (2):
      ath10k: sdio: reset chip on power_down()
      ath10k: remove the calibration data fetch for sdio

Wen Yang (1):
      mt76: fix a leaked reference by adding a missing of_node_put

Yu Wang (1):
      ath10k: correct the format of host memory chunks in wmi init command

YueHaibing (4):
      ath9k: remove set but not used variable 'acq'
      rtlwifi: rtl8723be: Remove set but not used variable 'b_last_is_cur_r=
dlstate'
      rtlwifi: rtl8723ae: Remove set but not used variable 'bt_retry_cnt'
      rtlwifi: rtl8192se: Remove set but not used variable 'seg_ptr'

 .../bindings/net/wireless/mediatek,mt76.txt        |   19 +
 drivers/net/wireless/ath/ath10k/ce.c               |   66 +-
 drivers/net/wireless/ath/ath10k/ce.h               |    2 +
 drivers/net/wireless/ath/ath10k/core.c             |   29 +-
 drivers/net/wireless/ath/ath10k/core.h             |    2 +-
 drivers/net/wireless/ath/ath10k/debug.c            |    3 +
 drivers/net/wireless/ath/ath10k/debugfs_sta.c      |    7 +-
 drivers/net/wireless/ath/ath10k/htt.h              |   86 +
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   50 +-
 drivers/net/wireless/ath/ath10k/hw.c               |   32 +-
 drivers/net/wireless/ath/ath10k/hw.h               |   28 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |   24 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |  109 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h          |   45 +
 drivers/net/wireless/ath/ath10k/wmi.c              |   44 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |   21 +-
 drivers/net/wireless/ath/ath9k/debug.c             |    2 +-
 drivers/net/wireless/ath/ath9k/recv.c              |    9 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |    3 +
 drivers/net/wireless/ath/wil6210/cfg80211.c        |   20 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |   23 +-
 drivers/net/wireless/ath/wil6210/interrupt.c       |   12 +-
 drivers/net/wireless/ath/wil6210/main.c            |   13 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c      |   10 +-
 drivers/net/wireless/ath/wil6210/trace.h           |    3 +-
 drivers/net/wireless/ath/wil6210/txrx.c            |  254 +--
 drivers/net/wireless/ath/wil6210/txrx.h            |   51 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.c       |   11 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |   16 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |   83 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |   26 +-
 drivers/net/wireless/mediatek/mt76/Kconfig         |    1 +
 drivers/net/wireless/mediatek/mt76/Makefile        |    3 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        |   24 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |    5 +
 drivers/net/wireless/mediatek/mt76/mt76.h          |   29 +-
 drivers/net/wireless/mediatek/mt76/mt7603/Kconfig  |    9 +
 drivers/net/wireless/mediatek/mt76/mt7603/Makefile |    6 +
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |  186 +++
 drivers/net/wireless/mediatek/mt76/mt7603/core.c   |   73 +
 .../net/wireless/mediatek/mt76/mt7603/debugfs.c    |   56 +
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |  215 +++
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c |  168 ++
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.h |   86 +
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |  578 +++++++
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    | 1749 ++++++++++++++++=
++++
 drivers/net/wireless/mediatek/mt76/mt7603/mac.h    |  242 +++
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |  709 ++++++++
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c    |  483 ++++++
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.h    |  110 ++
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |  253 +++
 drivers/net/wireless/mediatek/mt76/mt7603/pci.c    |   80 +
 drivers/net/wireless/mediatek/mt76/mt7603/regs.h   |  774 +++++++++
 drivers/net/wireless/mediatek/mt76/mt7603/soc.c    |   85 +
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |    2 +
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |    2 +
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |    6 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |   16 -
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |    1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |    9 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c   |    1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |   42 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |   36 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |    9 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mac.c    |    3 +
 drivers/net/wireless/mediatek/mt76/mt76x2/mac.h    |    8 +-
 .../net/wireless/mediatek/mt76/mt76x2/mt76x2u.h    |    1 -
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c   |    7 -
 .../net/wireless/mediatek/mt76/mt76x2/pci_phy.c    |    7 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   11 -
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c   |    5 -
 .../net/wireless/mediatek/mt76/mt76x2/usb_mac.c    |   13 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_main.c   |    5 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_phy.c    |    3 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |  154 +-
 drivers/net/wireless/mediatek/mt76/usb_mcu.c       |   57 -
 drivers/net/wireless/realtek/rtlwifi/base.c        |    7 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |    8 +
 drivers/net/wireless/realtek/rtlwifi/efuse.c       |    8 +-
 drivers/net/wireless/realtek/rtlwifi/ps.c          |    1 +
 drivers/net/wireless/realtek/rtlwifi/rc.c          |    2 +
 drivers/net/wireless/realtek/rtlwifi/regd.c        |    1 -
 .../wireless/realtek/rtlwifi/rtl8192c/dm_common.c  |    6 +-
 .../wireless/realtek/rtlwifi/rtl8192c/fw_common.c  |    5 +-
 .../net/wireless/realtek/rtlwifi/rtl8192c/main.c   |    1 -
 .../wireless/realtek/rtlwifi/rtl8192c/phy_common.c |    1 +
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.c    |    7 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/phy.c   |    1 +
 .../net/wireless/realtek/rtlwifi/rtl8192ce/table.c |    1 -
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.c   |    8 +
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |    9 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.h    |    4 -
 .../net/wireless/realtek/rtlwifi/rtl8192cu/mac.c   |    8 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/mac.h   |    3 -
 .../net/wireless/realtek/rtlwifi/rtl8192cu/trx.c   |    7 +
 .../net/wireless/realtek/rtlwifi/rtl8192cu/trx.h   |    2 -
 .../net/wireless/realtek/rtlwifi/rtl8192se/fw.c    |    6 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c   |    2 -
 .../net/wireless/realtek/rtlwifi/rtl8723be/dm.c    |    3 -
 drivers/net/wireless/realtek/rtlwifi/usb.c         |    3 +
 drivers/net/wireless/realtek/rtlwifi/usb.h         |    5 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  351 ++--
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |    4 +
 103 files changed, 7121 insertions(+), 768 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/Kconfig
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/Makefile
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/core.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/debugfs.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/dma.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/mac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/main.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/mcu.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/pci.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/regs.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/soc.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/usb_mcu.c

--=20
Kalle Valo
