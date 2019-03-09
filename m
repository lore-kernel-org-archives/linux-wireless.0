Return-Path: <SRS0=krUy=RM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 979A2C43381
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 13:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 458EA207E0
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 13:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbfCINtG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Mar 2019 08:49:06 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:40664 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726235AbfCINtG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Mar 2019 08:49:06 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x29Dmdxw020404, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x29Dmdxw020404
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Sat, 9 Mar 2019 21:48:39 +0800
Received: from localhost.localdomain (1.168.42.219) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Sat, 9 Mar 2019 21:48:38 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>, <johannes@sipsolutions.net>,
        <gregkh@linuxfoundation.org>
CC:     <linux-wireless@vger.kernel.org>, <Larry.Finger@lwfinger.net>,
        <sgruszka@redhat.com>, <pkshih@realtek.com>, <tehuang@realtek.com>,
        <briannorris@chromium.org>
Subject: [PATCH v7 00/14] rtw88: mac80211 driver for Realtek 802.11ac wireless network chips
Date:   Sat, 9 Mar 2019 21:48:08 +0800
Message-ID: <1552139302-20476-1-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [1.168.42.219]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

This is a new mac80211 driver for Realtek 802.11ac wireless network chips.
rtw88 now supports RTL8822BE/RTL8822CE now, with basic station mode
functionalities. The firmware for both can be found at linux-firmware.

https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
For RTL8822BE: rtw88/rtw8822b_fw.bin
For RTL8822CE: rtw88/rtw8822c_fw.bin

And for now, only PCI buses (RTL8xxxE) are supported. We will add support
for USB and SDIO in the future. The bus interface abstraction can be seen
in this driver such as hci.h. Most of the hardware setting are the same
except for some TRX path or probing setup should be separated.

Supported:

 * Basic STA/AP/ADHOC mode, and TDLS (STA is well tested)

Missing feature:

 * WOW/PNO
 * USB & SDIO bus (such as RTL8xxxU/RTL8xxxS)
 * BT coexistence (8822B/8822C are combo ICs)
 * Multiple interfaces (for now single STA is better supported)
 * Dynamic hardware calibrations (to improve/stabilize performance)

Potential problems:

 * static calibration spends too much time, and it is painful for
   driver to leave IDLE state. And slows down associate process.
   But reload function are under development, will be added soon!
 * TRX statictics misleading, as we are not reporting status correctly,
   or say, not reporting for "every" packet.


The next patch set should have BT coexistence code since RTL8822B/C are
combo ICs, and the driver for BT can be found after Linux Kernel v4.20.
So it is better to add it first to make WiFi + BT work concurrently.

Although now rtw88 is simple but we are developing more features for it.
Even we want to add support for more chips such as RTL8821C/RTL8814B.

Finally, rtw88 has many authors, listed alphabetically:

Ping-Ke Shih <pkshih@realtek.com>
Tzu-En Huang <tehuang@realtek.com>
Yan-Hsuan Chuang <yhchuang@realtek.com>


v2

 - add comment for watch dog


v3

 - change tree location to wireless-next


v4

 - remove useless "T:" and "W:" lines in MAINTAINERS file, as we don't have
   our own tree and wiki page now
 - rename patch 13 to "add MAINTAINERS entry"
 - use skb_pull to remove tx descriptors before reporting tx status to
   mac80211 stack, otherwise mac80211 tx status will always fail to match
   addr1/addr2 and will finally trigger to disconnect
 - return back to operating channel when we leave IDLE state, as mac80211
   stack expected. If we don't, mac80211 will assume we are already at
   channel 1 and start to scan. And we will never be able to connect to
   APs that are in channel 1. (which is most AP's default channel)
 - wait for async firmware load successfully, otherwise some slower platform
   might start to download firmware before loaded. And system crashes with a
   null pointer accessed.
 - fix typo for mac.h __RTW_MAc_H__ -> __RTW_MAC_H__


v5

 - add rtw_debug_mask for rtw_dbg to control debug messages
 - use dev_printk for rtw_dbg to not depend on CONFIG_DYNAMIC_DEBUG
 - remove useless rtw_pci_parse_configuration
 - keep struct and MODULE_* declaration close
 - use macro instead of ugly struct layout with #ifdef __LITTLE_ENDIAN
 - simplify efuse logical map parsing function
 - remove unused member and whole map dump for efuse
 - reduce some usage of magic number
 - enable DMA sync to avoid pci bus timeout
 - adjust download firmware sequence to avoid DMA error flag honored
 - change download firmware prototype for further use, sometimes we may
   want to download another special purposed firmware
 - move out rtw_send_rsvd_page_h2c, remove the static


v6

 - merge two patchsets
 - removal of staging/rtlwifi as it is conflicting with rtw88


v7

 - resend for missing util.[ch] in v6


Yan-Hsuan Chuang (14):
  rtw88: main files
  rtw88: core files
  rtw88: hci files
  rtw88: trx files
  rtw88: mac files
  rtw88: fw and efuse files
  rtw88: phy files
  rtw88: debug files
  rtw88: chip files
  rtw88: 8822B init table
  rtw88: 8822C init table
  rtw88: Kconfig & Makefile
  rtw88: add MAINTAINERS entry
  staging: rtlwifi: remove staging rtlwifi driver

 MAINTAINERS                                        |     6 +
 drivers/net/wireless/realtek/Kconfig               |     1 +
 drivers/net/wireless/realtek/Makefile              |     1 +
 drivers/net/wireless/realtek/rtw88/Kconfig         |    55 +
 drivers/net/wireless/realtek/rtw88/Makefile        |    20 +
 drivers/net/wireless/realtek/rtw88/debug.c         |   637 +
 drivers/net/wireless/realtek/rtw88/debug.h         |    52 +
 drivers/net/wireless/realtek/rtw88/efuse.c         |   160 +
 drivers/net/wireless/realtek/rtw88/efuse.h         |    26 +
 drivers/net/wireless/realtek/rtw88/fw.c            |   633 +
 drivers/net/wireless/realtek/rtw88/fw.h            |   222 +
 drivers/net/wireless/realtek/rtw88/hci.h           |   211 +
 drivers/net/wireless/realtek/rtw88/mac.c           |   965 +
 drivers/net/wireless/realtek/rtw88/mac.h           |    35 +
 drivers/net/wireless/realtek/rtw88/mac80211.c      |   481 +
 drivers/net/wireless/realtek/rtw88/main.c          |  1211 ++
 drivers/net/wireless/realtek/rtw88/main.h          |  1104 +
 drivers/net/wireless/realtek/rtw88/pci.c           |  1211 ++
 drivers/net/wireless/realtek/rtw88/pci.h           |   237 +
 drivers/net/wireless/realtek/rtw88/phy.c           |  1709 ++
 drivers/net/wireless/realtek/rtw88/phy.h           |   134 +
 drivers/net/wireless/realtek/rtw88/ps.c            |   166 +
 drivers/net/wireless/realtek/rtw88/ps.h            |    20 +
 drivers/net/wireless/realtek/rtw88/reg.h           |   421 +
 drivers/net/wireless/realtek/rtw88/regd.c          |   391 +
 drivers/net/wireless/realtek/rtw88/regd.h          |    67 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |  1594 ++
 drivers/net/wireless/realtek/rtw88/rtw8822b.h      |   170 +
 .../net/wireless/realtek/rtw88/rtw8822b_table.c    | 20783 +++++++++++++++++++
 .../net/wireless/realtek/rtw88/rtw8822b_table.h    |    18 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |  1890 ++
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      |   186 +
 .../net/wireless/realtek/rtw88/rtw8822c_table.c    | 11753 +++++++++++
 .../net/wireless/realtek/rtw88/rtw8822c_table.h    |    17 +
 drivers/net/wireless/realtek/rtw88/rx.c            |   151 +
 drivers/net/wireless/realtek/rtw88/rx.h            |    41 +
 drivers/net/wireless/realtek/rtw88/sec.c           |   120 +
 drivers/net/wireless/realtek/rtw88/sec.h           |    39 +
 drivers/net/wireless/realtek/rtw88/tx.c            |   367 +
 drivers/net/wireless/realtek/rtw88/tx.h            |    89 +
 drivers/net/wireless/realtek/rtw88/util.c          |    72 +
 drivers/net/wireless/realtek/rtw88/util.h          |    34 +
 drivers/staging/Kconfig                            |     2 -
 drivers/staging/Makefile                           |     1 -
 drivers/staging/rtlwifi/Kconfig                    |    12 -
 drivers/staging/rtlwifi/Makefile                   |    70 -
 drivers/staging/rtlwifi/TODO                       |    11 -
 drivers/staging/rtlwifi/base.c                     |  2815 ---
 drivers/staging/rtlwifi/base.h                     |   175 -
 drivers/staging/rtlwifi/btcoexist/Makefile         |     8 -
 drivers/staging/rtlwifi/btcoexist/halbt_precomp.h  |    74 -
 .../staging/rtlwifi/btcoexist/halbtc8822b1ant.c    |  5233 -----
 .../staging/rtlwifi/btcoexist/halbtc8822b1ant.h    |   433 -
 .../staging/rtlwifi/btcoexist/halbtc8822b2ant.c    |  5210 -----
 .../staging/rtlwifi/btcoexist/halbtc8822b2ant.h    |   487 -
 .../rtlwifi/btcoexist/halbtc8822bwifionly.c        |    54 -
 .../rtlwifi/btcoexist/halbtc8822bwifionly.h        |    24 -
 drivers/staging/rtlwifi/btcoexist/halbtcoutsrc.c   |  1837 --
 drivers/staging/rtlwifi/btcoexist/halbtcoutsrc.h   |   791 -
 drivers/staging/rtlwifi/btcoexist/rtl_btc.c        |   517 -
 drivers/staging/rtlwifi/btcoexist/rtl_btc.h        |    64 -
 drivers/staging/rtlwifi/cam.c                      |   315 -
 drivers/staging/rtlwifi/cam.h                      |    39 -
 drivers/staging/rtlwifi/core.c                     |  1996 --
 drivers/staging/rtlwifi/core.h                     |    71 -
 drivers/staging/rtlwifi/debug.c                    |   624 -
 drivers/staging/rtlwifi/debug.h                    |   223 -
 drivers/staging/rtlwifi/efuse.c                    |  1331 --
 drivers/staging/rtlwifi/efuse.h                    |   109 -
 drivers/staging/rtlwifi/halmac/halmac_2_platform.h |    41 -
 .../halmac_88xx/halmac_8822b/halmac_8822b_cfg.h    |   121 -
 .../halmac_88xx/halmac_8822b/halmac_8822b_phy.c    |    95 -
 .../halmac_8822b/halmac_8822b_pwr_seq.c            |   552 -
 .../halmac_8822b/halmac_8822b_pwr_seq.h            |    29 -
 .../halmac_88xx/halmac_8822b/halmac_api_8822b.c    |   332 -
 .../halmac_88xx/halmac_8822b/halmac_api_8822b.h    |    33 -
 .../halmac_8822b/halmac_api_8822b_pcie.c           |   312 -
 .../halmac_8822b/halmac_api_8822b_pcie.h           |    42 -
 .../halmac_8822b/halmac_api_8822b_sdio.c           |   173 -
 .../halmac_8822b/halmac_api_8822b_sdio.h           |    31 -
 .../halmac_8822b/halmac_api_8822b_usb.c            |   174 -
 .../halmac_8822b/halmac_api_8822b_usb.h            |    34 -
 .../halmac_88xx/halmac_8822b/halmac_func_8822b.c   |   403 -
 .../halmac_88xx/halmac_8822b/halmac_func_8822b.h   |    27 -
 .../rtlwifi/halmac/halmac_88xx/halmac_88xx_cfg.h   |   160 -
 .../rtlwifi/halmac/halmac_88xx/halmac_api_88xx.c   |  5970 ------
 .../rtlwifi/halmac/halmac_88xx/halmac_api_88xx.h   |   385 -
 .../halmac/halmac_88xx/halmac_api_88xx_pcie.c      |   318 -
 .../halmac/halmac_88xx/halmac_api_88xx_pcie.h      |    60 -
 .../halmac/halmac_88xx/halmac_api_88xx_sdio.c      |   963 -
 .../halmac/halmac_88xx/halmac_api_88xx_sdio.h      |    73 -
 .../halmac/halmac_88xx/halmac_api_88xx_usb.c       |   543 -
 .../halmac/halmac_88xx/halmac_api_88xx_usb.h       |    62 -
 .../rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c  |  4462 ----
 .../rtlwifi/halmac/halmac_88xx/halmac_func_88xx.h  |   310 -
 drivers/staging/rtlwifi/halmac/halmac_api.c        |   415 -
 drivers/staging/rtlwifi/halmac/halmac_api.h        |    70 -
 drivers/staging/rtlwifi/halmac/halmac_bit2.h       | 13396 ------------
 drivers/staging/rtlwifi/halmac/halmac_bit_8822b.h  | 12092 -----------
 drivers/staging/rtlwifi/halmac/halmac_fw_info.h    |   111 -
 .../rtlwifi/halmac/halmac_fw_offload_c2h_nic.h     |   173 -
 .../rtlwifi/halmac/halmac_fw_offload_h2c_nic.h     |   504 -
 .../rtlwifi/halmac/halmac_h2c_extra_info_nic.h     |   104 -
 .../staging/rtlwifi/halmac/halmac_intf_phy_cmd.h   |    43 -
 .../rtlwifi/halmac/halmac_original_c2h_nic.h       |   392 -
 .../rtlwifi/halmac/halmac_original_h2c_nic.h       |  1000 -
 .../staging/rtlwifi/halmac/halmac_pwr_seq_cmd.h    |   105 -
 drivers/staging/rtlwifi/halmac/halmac_reg2.h       |  1121 -
 drivers/staging/rtlwifi/halmac/halmac_reg_8822b.h  |   717 -
 drivers/staging/rtlwifi/halmac/halmac_rx_bd_chip.h |    37 -
 drivers/staging/rtlwifi/halmac/halmac_rx_bd_nic.h  |    37 -
 .../staging/rtlwifi/halmac/halmac_rx_desc_chip.h   |   107 -
 .../staging/rtlwifi/halmac/halmac_rx_desc_nic.h    |   122 -
 drivers/staging/rtlwifi/halmac/halmac_sdio_reg.h   |    51 -
 drivers/staging/rtlwifi/halmac/halmac_tx_bd_chip.h |   107 -
 drivers/staging/rtlwifi/halmac/halmac_tx_bd_nic.h  |   112 -
 .../staging/rtlwifi/halmac/halmac_tx_desc_chip.h   |   433 -
 .../staging/rtlwifi/halmac/halmac_tx_desc_nic.h    |   495 -
 drivers/staging/rtlwifi/halmac/halmac_type.h       |  1923 --
 drivers/staging/rtlwifi/halmac/halmac_usb_reg.h    |    17 -
 drivers/staging/rtlwifi/halmac/rtl_halmac.c        |  1373 --
 drivers/staging/rtlwifi/halmac/rtl_halmac.h        |    83 -
 drivers/staging/rtlwifi/pci.c                      |  2496 ---
 drivers/staging/rtlwifi/pci.h                      |   318 -
 drivers/staging/rtlwifi/phydm/halphyrf_ce.c        |   954 -
 drivers/staging/rtlwifi/phydm/halphyrf_ce.h        |    74 -
 drivers/staging/rtlwifi/phydm/mp_precomp.h         |    13 -
 drivers/staging/rtlwifi/phydm/phydm.c              |  1975 --
 drivers/staging/rtlwifi/phydm/phydm.h              |   935 -
 drivers/staging/rtlwifi/phydm/phydm_acs.c          |   189 -
 drivers/staging/rtlwifi/phydm/phydm_acs.h          |    46 -
 drivers/staging/rtlwifi/phydm/phydm_adaptivity.c   |   930 -
 drivers/staging/rtlwifi/phydm/phydm_adaptivity.h   |   108 -
 drivers/staging/rtlwifi/phydm/phydm_adc_sampling.c |   616 -
 drivers/staging/rtlwifi/phydm/phydm_adc_sampling.h |    85 -
 drivers/staging/rtlwifi/phydm/phydm_antdiv.c       |    72 -
 drivers/staging/rtlwifi/phydm/phydm_antdiv.h       |   290 -
 drivers/staging/rtlwifi/phydm/phydm_beamforming.h  |    37 -
 drivers/staging/rtlwifi/phydm/phydm_ccx.c          |   447 -
 drivers/staging/rtlwifi/phydm/phydm_ccx.h          |    72 -
 drivers/staging/rtlwifi/phydm/phydm_cfotracking.c  |   332 -
 drivers/staging/rtlwifi/phydm/phydm_cfotracking.h  |    49 -
 drivers/staging/rtlwifi/phydm/phydm_debug.c        |  2888 ---
 drivers/staging/rtlwifi/phydm/phydm_debug.h        |   164 -
 drivers/staging/rtlwifi/phydm/phydm_dfs.h          |    48 -
 drivers/staging/rtlwifi/phydm/phydm_dig.c          |  1521 --
 drivers/staging/rtlwifi/phydm/phydm_dig.h          |   230 -
 .../staging/rtlwifi/phydm/phydm_dynamic_rx_path.h  |    26 -
 .../rtlwifi/phydm/phydm_dynamicbbpowersaving.c     |   118 -
 .../rtlwifi/phydm/phydm_dynamicbbpowersaving.h     |    39 -
 .../staging/rtlwifi/phydm/phydm_dynamictxpower.c   |    91 -
 .../staging/rtlwifi/phydm/phydm_dynamictxpower.h   |    53 -
 .../staging/rtlwifi/phydm/phydm_edcaturbocheck.c   |   128 -
 .../staging/rtlwifi/phydm/phydm_edcaturbocheck.h   |    33 -
 drivers/staging/rtlwifi/phydm/phydm_features.h     |    22 -
 drivers/staging/rtlwifi/phydm/phydm_hwconfig.c     |  1848 --
 drivers/staging/rtlwifi/phydm/phydm_hwconfig.h     |   487 -
 drivers/staging/rtlwifi/phydm/phydm_interface.c    |   307 -
 drivers/staging/rtlwifi/phydm/phydm_interface.h    |   183 -
 drivers/staging/rtlwifi/phydm/phydm_iqk.h          |    65 -
 drivers/staging/rtlwifi/phydm/phydm_kfree.c        |   217 -
 drivers/staging/rtlwifi/phydm/phydm_kfree.h        |    31 -
 drivers/staging/rtlwifi/phydm/phydm_noisemonitor.c |   319 -
 drivers/staging/rtlwifi/phydm/phydm_noisemonitor.h |    35 -
 .../staging/rtlwifi/phydm/phydm_powertracking_ce.c |   633 -
 .../staging/rtlwifi/phydm/phydm_powertracking_ce.h |   282 -
 drivers/staging/rtlwifi/phydm/phydm_pre_define.h   |   602 -
 drivers/staging/rtlwifi/phydm/phydm_precomp.h      |    74 -
 drivers/staging/rtlwifi/phydm/phydm_psd.c          |   406 -
 drivers/staging/rtlwifi/phydm/phydm_psd.h          |    56 -
 drivers/staging/rtlwifi/phydm/phydm_rainfo.c       |  1196 --
 drivers/staging/rtlwifi/phydm/phydm_rainfo.h       |   258 -
 drivers/staging/rtlwifi/phydm/phydm_reg.h          |   140 -
 .../staging/rtlwifi/phydm/phydm_regdefine11ac.h    |    83 -
 drivers/staging/rtlwifi/phydm/phydm_regdefine11n.h |   202 -
 drivers/staging/rtlwifi/phydm/phydm_types.h        |   119 -
 .../rtlwifi/phydm/rtl8822b/halhwimg8822b_bb.c      |  1956 --
 .../rtlwifi/phydm/rtl8822b/halhwimg8822b_bb.h      |    43 -
 .../rtlwifi/phydm/rtl8822b/halhwimg8822b_mac.c     |   211 -
 .../rtlwifi/phydm/rtl8822b/halhwimg8822b_mac.h     |    27 -
 .../rtlwifi/phydm/rtl8822b/halhwimg8822b_rf.c      |  4730 -----
 .../rtlwifi/phydm/rtl8822b/halhwimg8822b_rf.h      |   118 -
 .../rtlwifi/phydm/rtl8822b/halphyrf_8822b.c        |   340 -
 .../rtlwifi/phydm/rtl8822b/halphyrf_8822b.h        |    34 -
 .../rtlwifi/phydm/rtl8822b/phydm_hal_api8822b.c    |  1804 --
 .../rtlwifi/phydm/rtl8822b/phydm_hal_api8822b.h    |    73 -
 .../rtlwifi/phydm/rtl8822b/phydm_iqk_8822b.c       |  1399 --
 .../rtlwifi/phydm/rtl8822b/phydm_iqk_8822b.h       |    37 -
 .../rtlwifi/phydm/rtl8822b/phydm_regconfig8822b.c  |   157 -
 .../rtlwifi/phydm/rtl8822b/phydm_regconfig8822b.h  |    43 -
 .../rtlwifi/phydm/rtl8822b/phydm_rtl8822b.c        |   214 -
 .../rtlwifi/phydm/rtl8822b/phydm_rtl8822b.h        |    19 -
 .../rtlwifi/phydm/rtl8822b/version_rtl8822b.h      |    23 -
 drivers/staging/rtlwifi/phydm/rtl_phydm.c          |   863 -
 drivers/staging/rtlwifi/phydm/rtl_phydm.h          |    34 -
 drivers/staging/rtlwifi/phydm/txbf/halcomtxbf.h    |    56 -
 drivers/staging/rtlwifi/phydm/txbf/haltxbf8822b.h  |    28 -
 .../staging/rtlwifi/phydm/txbf/haltxbfinterface.h  |    27 -
 drivers/staging/rtlwifi/phydm/txbf/haltxbfjaguar.h |    25 -
 .../rtlwifi/phydm/txbf/phydm_hal_txbf_api.h        |    30 -
 drivers/staging/rtlwifi/ps.c                       |   996 -
 drivers/staging/rtlwifi/ps.h                       |    39 -
 drivers/staging/rtlwifi/pwrseqcmd.h                |    83 -
 drivers/staging/rtlwifi/rc.c                       |   309 -
 drivers/staging/rtlwifi/rc.h                       |    38 -
 drivers/staging/rtlwifi/regd.c                     |   458 -
 drivers/staging/rtlwifi/regd.h                     |    52 -
 drivers/staging/rtlwifi/rtl8822be/Makefile         |     7 -
 drivers/staging/rtlwifi/rtl8822be/def.h            |    71 -
 drivers/staging/rtlwifi/rtl8822be/fw.c             |   960 -
 drivers/staging/rtlwifi/rtl8822be/fw.h             |   187 -
 drivers/staging/rtlwifi/rtl8822be/hw.c             |  2430 ---
 drivers/staging/rtlwifi/rtl8822be/hw.h             |    55 -
 drivers/staging/rtlwifi/rtl8822be/led.c            |   116 -
 drivers/staging/rtlwifi/rtl8822be/led.h            |    23 -
 drivers/staging/rtlwifi/rtl8822be/phy.c            |  2223 --
 drivers/staging/rtlwifi/rtl8822be/phy.h            |   134 -
 drivers/staging/rtlwifi/rtl8822be/reg.h            |  1642 --
 drivers/staging/rtlwifi/rtl8822be/sw.c             |   470 -
 drivers/staging/rtlwifi/rtl8822be/sw.h             |    21 -
 drivers/staging/rtlwifi/rtl8822be/trx.c            |  1004 -
 drivers/staging/rtlwifi/rtl8822be/trx.h            |   154 -
 drivers/staging/rtlwifi/stats.c                    |   249 -
 drivers/staging/rtlwifi/stats.h                    |    31 -
 drivers/staging/rtlwifi/wifi.h                     |  3362 ---
 225 files changed, 47500 insertions(+), 123718 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw88/Kconfig
 create mode 100644 drivers/net/wireless/realtek/rtw88/Makefile
 create mode 100644 drivers/net/wireless/realtek/rtw88/debug.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/debug.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/efuse.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/efuse.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/fw.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/fw.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/hci.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/mac.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/mac.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/mac80211.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/main.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/main.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/pci.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/pci.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/phy.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/phy.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/ps.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/ps.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/reg.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/regd.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/regd.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822b_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822b_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822c.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822c.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822c_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822c_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rx.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rx.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/sec.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/sec.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/tx.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/tx.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/util.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/util.h
 delete mode 100644 drivers/staging/rtlwifi/Kconfig
 delete mode 100644 drivers/staging/rtlwifi/Makefile
 delete mode 100644 drivers/staging/rtlwifi/TODO
 delete mode 100644 drivers/staging/rtlwifi/base.c
 delete mode 100644 drivers/staging/rtlwifi/base.h
 delete mode 100644 drivers/staging/rtlwifi/btcoexist/Makefile
 delete mode 100644 drivers/staging/rtlwifi/btcoexist/halbt_precomp.h
 delete mode 100644 drivers/staging/rtlwifi/btcoexist/halbtc8822b1ant.c
 delete mode 100644 drivers/staging/rtlwifi/btcoexist/halbtc8822b1ant.h
 delete mode 100644 drivers/staging/rtlwifi/btcoexist/halbtc8822b2ant.c
 delete mode 100644 drivers/staging/rtlwifi/btcoexist/halbtc8822b2ant.h
 delete mode 100644 drivers/staging/rtlwifi/btcoexist/halbtc8822bwifionly.c
 delete mode 100644 drivers/staging/rtlwifi/btcoexist/halbtc8822bwifionly.h
 delete mode 100644 drivers/staging/rtlwifi/btcoexist/halbtcoutsrc.c
 delete mode 100644 drivers/staging/rtlwifi/btcoexist/halbtcoutsrc.h
 delete mode 100644 drivers/staging/rtlwifi/btcoexist/rtl_btc.c
 delete mode 100644 drivers/staging/rtlwifi/btcoexist/rtl_btc.h
 delete mode 100644 drivers/staging/rtlwifi/cam.c
 delete mode 100644 drivers/staging/rtlwifi/cam.h
 delete mode 100644 drivers/staging/rtlwifi/core.c
 delete mode 100644 drivers/staging/rtlwifi/core.h
 delete mode 100644 drivers/staging/rtlwifi/debug.c
 delete mode 100644 drivers/staging/rtlwifi/debug.h
 delete mode 100644 drivers/staging/rtlwifi/efuse.c
 delete mode 100644 drivers/staging/rtlwifi/efuse.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_2_platform.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_8822b_cfg.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_8822b_phy.c
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_8822b_pwr_seq.c
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_8822b_pwr_seq.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_api_8822b.c
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_api_8822b.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_api_8822b_pcie.c
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_api_8822b_pcie.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_api_8822b_sdio.c
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_api_8822b_sdio.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_api_8822b_usb.c
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_api_8822b_usb.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_func_8822b.c
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_func_8822b.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_88xx_cfg.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_api_88xx.c
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_api_88xx.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_api_88xx_pcie.c
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_api_88xx_pcie.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_api_88xx_sdio.c
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_api_88xx_sdio.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_api_88xx_usb.c
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_api_88xx_usb.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_api.c
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_api.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_bit2.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_bit_8822b.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_fw_info.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_fw_offload_c2h_nic.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_fw_offload_h2c_nic.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_h2c_extra_info_nic.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_intf_phy_cmd.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_original_c2h_nic.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_original_h2c_nic.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_pwr_seq_cmd.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_reg2.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_reg_8822b.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_rx_bd_chip.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_rx_bd_nic.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_rx_desc_chip.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_rx_desc_nic.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_sdio_reg.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_tx_bd_chip.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_tx_bd_nic.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_tx_desc_chip.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_tx_desc_nic.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_type.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/halmac_usb_reg.h
 delete mode 100644 drivers/staging/rtlwifi/halmac/rtl_halmac.c
 delete mode 100644 drivers/staging/rtlwifi/halmac/rtl_halmac.h
 delete mode 100644 drivers/staging/rtlwifi/pci.c
 delete mode 100644 drivers/staging/rtlwifi/pci.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/halphyrf_ce.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/halphyrf_ce.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/mp_precomp.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_acs.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_acs.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_adaptivity.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_adaptivity.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_adc_sampling.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_adc_sampling.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_antdiv.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_antdiv.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_beamforming.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_ccx.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_ccx.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_cfotracking.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_cfotracking.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_debug.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_debug.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_dfs.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_dig.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_dig.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_dynamic_rx_path.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_dynamicbbpowersaving.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_dynamicbbpowersaving.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_dynamictxpower.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_dynamictxpower.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_edcaturbocheck.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_edcaturbocheck.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_features.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_hwconfig.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_hwconfig.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_interface.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_interface.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_iqk.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_kfree.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_kfree.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_noisemonitor.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_noisemonitor.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_powertracking_ce.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_powertracking_ce.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_pre_define.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_precomp.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_psd.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_psd.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_rainfo.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_rainfo.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_reg.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_regdefine11ac.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_regdefine11n.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/phydm_types.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/rtl8822b/halhwimg8822b_bb.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/rtl8822b/halhwimg8822b_bb.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/rtl8822b/halhwimg8822b_mac.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/rtl8822b/halhwimg8822b_mac.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/rtl8822b/halhwimg8822b_rf.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/rtl8822b/halhwimg8822b_rf.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/rtl8822b/halphyrf_8822b.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/rtl8822b/halphyrf_8822b.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/rtl8822b/phydm_hal_api8822b.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/rtl8822b/phydm_hal_api8822b.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/rtl8822b/phydm_iqk_8822b.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/rtl8822b/phydm_iqk_8822b.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/rtl8822b/phydm_regconfig8822b.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/rtl8822b/phydm_regconfig8822b.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/rtl8822b/phydm_rtl8822b.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/rtl8822b/phydm_rtl8822b.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/rtl8822b/version_rtl8822b.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/rtl_phydm.c
 delete mode 100644 drivers/staging/rtlwifi/phydm/rtl_phydm.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/txbf/halcomtxbf.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/txbf/haltxbf8822b.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/txbf/haltxbfinterface.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/txbf/haltxbfjaguar.h
 delete mode 100644 drivers/staging/rtlwifi/phydm/txbf/phydm_hal_txbf_api.h
 delete mode 100644 drivers/staging/rtlwifi/ps.c
 delete mode 100644 drivers/staging/rtlwifi/ps.h
 delete mode 100644 drivers/staging/rtlwifi/pwrseqcmd.h
 delete mode 100644 drivers/staging/rtlwifi/rc.c
 delete mode 100644 drivers/staging/rtlwifi/rc.h
 delete mode 100644 drivers/staging/rtlwifi/regd.c
 delete mode 100644 drivers/staging/rtlwifi/regd.h
 delete mode 100644 drivers/staging/rtlwifi/rtl8822be/Makefile
 delete mode 100644 drivers/staging/rtlwifi/rtl8822be/def.h
 delete mode 100644 drivers/staging/rtlwifi/rtl8822be/fw.c
 delete mode 100644 drivers/staging/rtlwifi/rtl8822be/fw.h
 delete mode 100644 drivers/staging/rtlwifi/rtl8822be/hw.c
 delete mode 100644 drivers/staging/rtlwifi/rtl8822be/hw.h
 delete mode 100644 drivers/staging/rtlwifi/rtl8822be/led.c
 delete mode 100644 drivers/staging/rtlwifi/rtl8822be/led.h
 delete mode 100644 drivers/staging/rtlwifi/rtl8822be/phy.c
 delete mode 100644 drivers/staging/rtlwifi/rtl8822be/phy.h
 delete mode 100644 drivers/staging/rtlwifi/rtl8822be/reg.h
 delete mode 100644 drivers/staging/rtlwifi/rtl8822be/sw.c
 delete mode 100644 drivers/staging/rtlwifi/rtl8822be/sw.h
 delete mode 100644 drivers/staging/rtlwifi/rtl8822be/trx.c
 delete mode 100644 drivers/staging/rtlwifi/rtl8822be/trx.h
 delete mode 100644 drivers/staging/rtlwifi/stats.c
 delete mode 100644 drivers/staging/rtlwifi/stats.h
 delete mode 100644 drivers/staging/rtlwifi/wifi.h

-- 
2.7.4

