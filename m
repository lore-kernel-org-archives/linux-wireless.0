Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCF22836E
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 02:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785637280; cv=none; b=H14Dq0dTBTZ5WeMtGREOcYDqee2ql+zNwtD2MyR11xfuCmwpaUuO8dDU6ohhoL9Y1WZuJ5blCsSI5SnKuoHe8qpIeojSnPR7jVUD/h8EWRq4Awjuf7J0lbQ1Kd5kTcz/bG+yiMKp2ZKZXbuPrwLm3dh35H/gYqyP+6tWqd2iE/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785637280; c=relaxed/simple;
	bh=scu+MCpM3zmd1ELzMGtmNa/7oK8TtD+HeplfuezT8ag=;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type; b=pf3Mu5Xo9rpx553BSFQKHbZr/Tx6u3cLR4DvbfOWHGNbPOgfIIJdCOkpbCfprFzrYMevnQ90QAEsmDkPbynE3rTB4fchqva8K7jFitP1Sw2BgiTTQYW2xhoG+VaYwQZG7ORAiOW3iC3gUAOx1jF+W3RKmUrek7krQUvg6F3Yb2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=I/gvd84V; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="I/gvd84V"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6722LCXA03086775, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785637272; bh=umY/5X54qFp4st7jFzWOpfRVRXjCAsPF0IISwEkdsrE=;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type;
	b=I/gvd84VM5C08GX/ctibdE2+UaXV8yyEND6VMPqvpPwP8/6ESURu9Y2x8lfj4xZ7W
	 b9w3xTlmkMk3Gpu3qMOl/C7dUot9/LzoPnlMMyz7CBcioYgXxp2w1zx0KuLXiBK9mk
	 zEMvm64kKnRIrxlYlUnkoxJjL0T2ajlX2ZZ8HonKcpyHsYzlKlnYnorf7A6rjEj8tK
	 AGFuJScNb2R8w5M/CwbWTxNZ+Ijmcvlu6ET4xYbR0QP0GDRH5RJ/6SaRsIpT6tEy14
	 0I7ZjaqnMnLSKCVQTdwy9Ikqz0stvnzN82FD+df6mxXNjUkcpGHNkExyVSMN02wC4m
	 vXcgLds/UBQkg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6722LCXA03086775
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 2 Aug 2026 10:21:12 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 2 Aug 2026 10:21:12 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 2 Aug 2026 10:21:12 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Sun, 2 Aug 2026 10:21:12 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
Subject: pull-request: rtw-next-2026-08-02
Message-ID: <4230f3d5-43f3-4be2-b7c6-d4aed93721aa@RTKEXHMBS05.realtek.com.tw>
Date: Sun, 2 Aug 2026 10:21:12 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi,

A pull-request of rtw-next to wireless-next tree, more info below. Please
let me know if any problems.

Thanks
Ping-Ke

---

The following changes since commit dc59e4fea9d83f03bad6bddf3fa2e52491777482:

  Linux 7.2-rc1 (2026-06-28 12:01:31 -0700)

are available in the Git repository at:

  https://github.com/pkshih/rtw.git tags/rtw-next-2026-08-02

for you to fetch changes up to 86c3125c75d79ee7fb4d045bb9ada4c5b067eacc:

  wifi: rtw89: 8922d: enable Makefile and Kconfig for RTL8922DE (2026-08-02 09:55:20 +0800)

----------------------------------------------------------------
rtw-next patches for v7.3

Some random cleanups and fixes on rtlwifi, rtw88 and rtw89. The major
features added to rtw89 are listed:

rtw89:

 - add LED support

 - update BT-coexistence mechanism to support dual Bluetooth for RTL8922D

 - support WiFi 7 chip RTL8922DE

----------------------------------------------------------------
Abdun Nihaal (3):
      wifi: rtlwifi: rtl8192du: Fix possible memory leak in rtl92du_init_sw_vars()
      wifi: rtlwifi: pci: fix error path in rtl_pci_probe()
      wifi: rtw88: Fix potential memory leak in rtw_txq_push_skb()

Anirudh Srinivasan (2):
      PCI: Move Spacemit vendor and device IDs to linux/pci_ids.h
      wifi: rtw89: pci: enable 36-bit DMA on spacemit K3

Bitterblue Smith (2):
      wifi: rtw88: 8822c: Don't process RF path C in query_phy_status_page{0,1}
      wifi: rtw88: 8822b: Don't process RF path C in query_phy_status_page1

Bitterblue Smith (S.E.A. Datentechnik GmbH) (1):
      wifi: rtw88: Enable receiving control frames in monitor mode

Chelsy Ratnawat (1):
      wifi: rtlwifi: rtl8192d: remove dead SMPS rate mask code

Chen Jung Ku (1):
      wifi: rtw88: 8822c: replace msleep() with fsleep() for DPK delays

Chia-Yuan Li (1):
      wifi: rtw89: fw: use MAC source for IO offload delay command

Chih-Kang Chang (6):
      wifi: rtw89: disable sniffer mode in RX filter when initialization for Wi-Fi 7 chips
      wifi: rtw89: pci: disable phy error flag related to refclk
      wifi: rtw89: wow: only WiFi 6 chips initialize RF registers in WoWLAN mode
      wifi: rtw89: 8852a: fix RSSI report when average beacon RSSI is not ready
      wifi: rtw89: rfk: update TXIQK H2C command format to v1
      wifi: rtw89: 8922d: bypass TXIQK when scan

Chin-Yen Lee (2):
      wifi: rtw89: wow: use MLD address in WoWLAN ARP replies for MLO stations
      wifi: rtw89: wow: add QoS control field to WoWLAN ARP response for MLO

Ching-Te Ku (63):
      wifi: rtw89: coex: force to exit Wi-Fi LPS while Bluetooth profile exist
      wifi: rtw89: coex: offset current BT info to BT0 for dual BT configuration
      wifi: rtw89: coex: Move wifi related counters to wifi info
      wifi: rtw89: coex: Extend bt_slot_req for dual MAC wifi
      wifi: rtw89: coex: Move Bluetooth related counters to BT info
      wifi: rtw89: coex: Refine third party module related coexistence
      wifi: rtw89: coex: Add TX/RX RF parameter format version 9
      wifi: rtw89: coex: Renaming drvinfo_type to drvinfo_ver
      wifi: rtw89: coex: Add Wi-Fi firmware 0.35.94.1 support for RTL8922D
      wifi: rtw89: coex: Add RTL8922D chip string
      wifi: rtw89: coex: Add Init info version 10
      wifi: rtw89: coex: add rtw89_btc_init() entry for initialization once
      wifi: rtw89: coex: Update TDMA descriptor for dual MAC
      wifi: rtw89: coex: Add Bluetooth binding for Bluetooth TX power setting
      wifi: rtw89: coex: Add Bluetooth binding for Bluetooth RX gain setting
      wifi: rtw89: coex: Add WiFi/Bluetooth adapter binding info
      wifi: rtw89: coex: Add TDMA binding for dual MAC
      wifi: rtw89: coex: Update scoreboard related logic for dual Bluetooth
      wifi: rtw89: coex: Add Co-RX logic
      wifi: rtw89: coex: Add Wi-Fi role info version 10
      wifi: rtw89: coex: Rearrange coexistence control structure
      wifi: rtw89: coex: Update driver outsource info to firmware version 6
      wifi: rtw89: ceox: Update antenna & grant signal setting
      wifi: rtw89: coex: Rearrange Bluetooth firmware report entry
      wifi: rtw89: coex: Refine send firmware command function
      wifi: rtw89: coex: Refine _reset_btc_var()
      wifi: rtw89: coex: Correct SET_RFE settings
      wifi: rtw89: coex: Add firmware report control report v11
      wifi: rtw89: coex: update external control length by case
      wifi: rtw89: coex: Update coexistence version to 9.24.0
      wifi: rtw89: coex: Add version 107 TX/RX info for firmware feature
      wifi: rtw89: coex: Add version 9 report control info
      wifi: rtw89: coex: Fix unexpected grant-signal assignee
      wifi: rtw89: coex: Branch out version 105 firmware report map index
      wifi: rtw89: coex: Refine chip initial related structure
      wifi: rtw89: coex: Add driver info H2C command index version 103
      wifi: rtw89: coex: Fix Wi-Fi role info H2C command header issue
      wifi: rtw89: coex: Add firmware 0.29.133.X support for RTL8852B family
      wifi: rtw89: coex: Add TDMA version 4
      wifi: rtw89: coex: Add slots version 2
      wifi: rtw89: coex: Add cycle status report version 105
      wifi: rtw89: coex: Add wifi role info version 101
      wifi: rtw89: coex: Add firmware 0.27.97.X support for RTL8852C
      wifi: rtw89: coex: Add chip initial info version 11 for RTL8922A/D
      wifi: rtw89: coex: Add Wi-Fi MLO info version 2 H2C command
      wifi: rtw89: coex: Add firmware 0.35.111.X support for RTL8922A/D
      wifi: rtw89: coex: Rearrange _ntfy_role_info info
      wifi: rtw89: coex: Separate _ntfy_role_info into two function
      wifi: rtw89: coex: Decrease Wi-Fi special packet protect time
      wifi: rtw89: coex: complete GPIO debug configuration handler
      wifi: rtw89: coex: Refine RF calibration notify flow
      wifi: rtw89: coex: Fix log dump format with proper newline
      wifi: rtw89: coex: Add BTC report version 8 support for BT sub-reports
      wifi: rtw89: coex: Add dual Bluetooth debug info dump
      wifi: rtw89: coex: Fix TDMA v8 handling to unblock BTC report parsing
      wifi: rtw89: coex: Fix H2C command redundant send & version fall through
      wifi: rtw89: coex: Handle Bluetooth LE-Audio related coexistence feature
      wifi: rtw89: coex: Fix Bluetooth link weight not updated on profile change
      wifi: rtw89: coex: Fix BT-info parsing for 5/6 GHz band & dual Bluetooth
      wifi: rtw89: coex: Clear BT link weight when BT is disabled
      wifi: rtw89: coex: Change Wi-Fi link_mode_v0 translating timing
      wifi: rtw89: coex: Port _update_bt_ctrl_lps() for BT profile-based LPS control
      wifi: rtw89: coex: Update Wi-Fi/Bluetooth coexistence version to 9.24.1

Dan Carpenter (1):
      wifi: rtw89: debug: fix off by on in rtw89_ppdu_str()

David Lee (1):
      wifi: rtw89: 8852cu: add quirk to disable 2.4 GHz band

Dawei Feng (1):
      wifi: rtw88: pci: fix resource leak on failed NAPI setup

Dian-Syuan Yang (2):
      wifi: rtw89: drop packet offload entry on H2C addition failure to avoid scan issue
      wifi: rtw89: refine RX filter configuration for WiFi 7 generation

Dmitry Morgun (1):
      wifi: rtw89: check return values in rtw89_ops_start_ap()

Eric Huang (5):
      wifi: rtw89: 8922d: remove CCK bandwidth compensation
      wifi: rtw89: 8922d: dynamic adjust channel smoothing
      wifi: rtw89: 8922d: fix EMLSR BB switch sequence for MLO mode transition
      wifi: rtw89: phy: fix bandedge primary channel for 2.4GHz 40MHz and 6GHz
      wifi: rtw89: pack I/O during bb_sethw to reduce API execution time

Fan Wu (1):
      wifi: rtl8xxxu: fix use-after-free from rx_urb_wq on stop

GuoHan Zhao (1):
      wifi: rtw89: wow: fix unsupported cipher debug messages

Johnson Tsai (2):
      wifi: rtw89: add LED support to reflect the wireless association status
      wifi: rtw89: add multicolor LED support for RTL8852CU valve board

Mihail Dimoski (1):
      wifi: rtw88: disable ASPM and deep PS on ASUS TUF Gaming A15 FA506II

Panagiotis Petrakopoulos (1):
      wifi: rtw89: use str_enable_disable() helper

Pengpeng Hou (1):
      wifi: rtw89: fix HE extended capability length check

Ping-Ke Shih (24):
      wifi: rtw89: fw: add first set of firmware features by version for RTL8922D
      wifi: rtw89: fw: support scan offload v2 for WiFi 7 chips
      wifi: rtl8xxxu: 8723bu: remove reference of non-existing firmware rtl8723bu_bt.bin
      wifi: rtw89: mac: finish active TX immediately without waiting for DMAC
      wifi: rtw89: mac: pass chip version to firmware
      wifi: rtw89: fw: lower debug level for UDM1 debug register
      wifi: rtw89: 8922d: set TX compensation by format v2
      wifi: rtw89: efuse: no need to export rtw89_efuse_read_ecv_be()
      wifi: rtw89: efuse: read thermal calibration value for RTL8922D
      wifi: rtw89: 8922d: read default digital voltage calibration values
      wifi: rtw89: add thermal protect by digital voltage reduction
      wifi: rtw89: 8922d: set ANA CLK enter to 500KHz
      wifi: rtw89: 8922d: update scaling factor for RX path
      wifi: rtw89: phy: add NCTL check for WiFi 7 chips
      wifi: rtw89: unify access struct of TX power track tables
      wifi: rtw89: set needed firmware elements for early chips transition
      wifi: rtw89: mac: abstract register definition of firmware boot debug
      wifi: rtw89: 8922d: add TX time limit for 2GHz band
      wifi: rtw89: fw: do bb_preinit before downloading firmware
      wifi: rtw89: wow: extend timeout unit to avoid SER false alarm
      wifi: rtw89: pci: set PCIe maximum TS1 for RTL8922DE
      wifi: rtw89: 8922d: reduce IO in power-on function
      wifi: rtw89: phy: set CFR to manual mode for some 2GHz channels
      wifi: rtw89: 8922d: enable Makefile and Kconfig for RTL8922DE

Po-Hao Huang (2):
      wifi: rtw89: fix scan offload version check logic
      wifi: rtw89: change scan offload format to V3 for WiFi 7 IC

Runyu Xiao (1):
      wifi: rtlwifi: rtl8192du: check QoS TID before indexing tids

Sang-Heon Jeon (2):
      wifi: rtlwifi: rtl8821ae: remove conditional return with no effect in _rtl8821ae_llt_write()
      wifi: rtw89: remove conditional return with no effect in sys_init_*()

Stanislaw Gruszka (1):
      wifi: rtl818x: initialize eeprom_93cx6 struct to zero

Wentao Guan (1):
      wifi: rtw89: fw: correct preload field of w2 in rtw89_fw_h2c_default_cmac_tbl_be()

William Hansen-Baird (4):
      wifi: rtlwifi: rtl8723be: Remove unnecessary irq save/restore in hw_init()
      wifi: rtlwifi: fix disabling of ASPM for RTL8723BE with AER flooding
      wifi: rtlwifi: convert pci if-statement to ID table
      wifi: rtlwifi: disable ASPM for RTL8723BE with subsystem ID 17aa:b736

Yuhang.chen (1):
      wifi: rtw89: pci: add .shutdown callback to stop rfkill polling on reboot

Zong-Zhe Yang (5):
      wifi: rtw89: fw: fix link ID filling for LPS MLO common info
      wifi: rtw89: introduce helper to get tx shape index
      wifi: rtw89: add tx shape v0 to keep built-in arrays compatible during transitions
      wifi: rtw89: extend tx shape format for regulatory 6 GHz power type
      wifi: rtw89: debug: add diagnosis for RF

 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |    2 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |    2 +-
 drivers/net/wireless/realtek/rtl8xxxu/8723b.c      |   11 +-
 drivers/net/wireless/realtek/rtl8xxxu/core.c       |   20 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   49 +-
 .../wireless/realtek/rtlwifi/rtl8192d/hw_common.c  |   21 +-
 .../net/wireless/realtek/rtlwifi/rtl8192du/sw.c    |   12 +-
 .../net/wireless/realtek/rtlwifi/rtl8192du/trx.c   |    3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |    6 -
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |    7 +-
 drivers/net/wireless/realtek/rtw88/bf.c            |    6 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    8 +-
 drivers/net/wireless/realtek/rtw88/main.h          |    1 +
 drivers/net/wireless/realtek/rtw88/pci.c           |   14 +-
 drivers/net/wireless/realtek/rtw88/rtw8723x.c      |    3 +-
 drivers/net/wireless/realtek/rtw88/rtw8814a.c      |    3 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |    4 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.h      |    3 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |    9 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   15 +-
 drivers/net/wireless/realtek/rtw88/rtw88xxa.c      |    3 +-
 drivers/net/wireless/realtek/rtw88/tx.c            |    1 +
 drivers/net/wireless/realtek/rtw89/Kconfig         |   29 +
 drivers/net/wireless/realtek/rtw89/Makefile        |    9 +
 drivers/net/wireless/realtek/rtw89/coex.c          | 7138 ++++++++++++--------
 drivers/net/wireless/realtek/rtw89/coex.h          |  155 +-
 drivers/net/wireless/realtek/rtw89/core.c          |  128 +-
 drivers/net/wireless/realtek/rtw89/core.h          | 1401 +++-
 drivers/net/wireless/realtek/rtw89/debug.c         |  124 +-
 drivers/net/wireless/realtek/rtw89/debug.h         |    1 +
 drivers/net/wireless/realtek/rtw89/efuse.h         |    7 +
 drivers/net/wireless/realtek/rtw89/efuse_be.c      |  117 +-
 drivers/net/wireless/realtek/rtw89/fw.c            | 1696 ++++-
 drivers/net/wireless/realtek/rtw89/fw.h            |  360 +-
 drivers/net/wireless/realtek/rtw89/led.c           |  139 +
 drivers/net/wireless/realtek/rtw89/led.h           |   37 +
 drivers/net/wireless/realtek/rtw89/led_mc.c        |   81 +
 drivers/net/wireless/realtek/rtw89/mac.c           |   71 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |   52 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   38 +-
 drivers/net/wireless/realtek/rtw89/mac_be.c        |   87 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   17 +
 drivers/net/wireless/realtek/rtw89/pci.h           |    6 +-
 drivers/net/wireless/realtek/rtw89/pci_be.c        |   11 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |   95 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |   28 +-
 drivers/net/wireless/realtek/rtw89/phy_be.c        |   53 +-
 drivers/net/wireless/realtek/rtw89/reg.h           |  100 +-
 drivers/net/wireless/realtek/rtw89/rtw8851b.c      |  148 +-
 drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c  |   22 +-
 .../net/wireless/realtek/rtw89/rtw8851b_table.c    |   23 +-
 .../net/wireless/realtek/rtw89/rtw8851b_table.h    |    2 +-
 drivers/net/wireless/realtek/rtw89/rtw8851be.c     |    2 +
 drivers/net/wireless/realtek/rtw89/rtw8851bu.c     |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |   91 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.c  |   36 +-
 .../net/wireless/realtek/rtw89/rtw8852a_table.c    |   27 +-
 .../net/wireless/realtek/rtw89/rtw8852a_table.h    |    2 +-
 drivers/net/wireless/realtek/rtw89/rtw8852ae.c     |    2 +
 drivers/net/wireless/realtek/rtw89/rtw8852au.c     |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852b.c      |   84 +-
 .../net/wireless/realtek/rtw89/rtw8852b_common.c   |    7 +-
 drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c  |   36 +-
 .../net/wireless/realtek/rtw89/rtw8852b_table.c    |   31 +-
 .../net/wireless/realtek/rtw89/rtw8852b_table.h    |    2 +-
 drivers/net/wireless/realtek/rtw89/rtw8852be.c     |    2 +
 drivers/net/wireless/realtek/rtw89/rtw8852bt.c     |   86 +-
 drivers/net/wireless/realtek/rtw89/rtw8852bte.c    |    2 +
 drivers/net/wireless/realtek/rtw89/rtw8852bu.c     |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |   87 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c  |  101 +-
 .../net/wireless/realtek/rtw89/rtw8852c_table.c    |   39 +-
 .../net/wireless/realtek/rtw89/rtw8852c_table.h    |    2 +-
 drivers/net/wireless/realtek/rtw89/rtw8852ce.c     |    2 +
 drivers/net/wireless/realtek/rtw89/rtw8852cu.c     |   57 +-
 drivers/net/wireless/realtek/rtw89/rtw8922a.c      |  142 +-
 drivers/net/wireless/realtek/rtw89/rtw8922ae.c     |    3 +
 drivers/net/wireless/realtek/rtw89/rtw8922au.c     |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8922d.c      |  521 +-
 drivers/net/wireless/realtek/rtw89/rtw8922de.c     |    3 +
 drivers/net/wireless/realtek/rtw89/wow.c           |   27 +-
 drivers/pci/controller/dwc/pcie-spacemit-k1.c      |    3 -
 include/linux/pci_ids.h                            |    4 +
 83 files changed, 9566 insertions(+), 4217 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw89/led.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/led.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/led_mc.c
