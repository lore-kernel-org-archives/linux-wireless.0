Return-Path: <SRS0=8CYu=OJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47F96C04EB8
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 11:34:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EECD4206B7
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 11:34:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="XAXHY0Ts"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EECD4206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbeK3Wn1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 30 Nov 2018 17:43:27 -0500
Received: from nbd.name ([46.4.11.11]:43850 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726512AbeK3Wn0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Nov 2018 17:43:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Subject:From:Cc:To:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PFBdrFgwvdw0uSyqURqQEQDvSVKSKV1qhORHwtzl5N4=; b=XAXHY0TsdDLTAhMh90fjT2Sohi
        2uJOi0BNJLviFxGVplgj87RW/X9510LQLtWwLJa5DyvcZfB3QVmy4tzKblxgsmgTDMF3y3K+YcLOK
        BCpKu3FjBycIRoDE+FDTleWfpHoCltPoNJVBQmijBNpfmG9+8/yvedUsecoULKi2oAIg=;
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
From:   Felix Fietkau <nbd@nbd.name>
Subject: pull request: mt76 2018-11-30
Openpgp: preference=signencrypt
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 xsDiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwc0cRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPsJgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQzsFNBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabwkkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <b65d2a36-4cf4-1536-fd0f-f3bcbaf000fc@nbd.name>
Date:   Fri, 30 Nov 2018 12:34:25 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,

here's my first pull request for 4.21

- Felix

The following changes since commit b72c51a58e6d63ef673ac96b8ab5bc98799c5f7b:

  brcmfmac: Fix out of bounds memory access during fw load (2018-11-29 17:33:10 +0200)

are available in the Git repository at:

  https://github.com/nbd168/wireless tags/mt76-for-kvalo-2018-11-30

for you to fetch changes up to e28487ea84a9c081c6d8d7da319427f7fcc32ff5:

  mt76: replace sta_add/remove ops with common sta_state function (2018-11-30 12:30:37 +0100)

----------------------------------------------------------------
first batch of mt76 patches for 4.21

* use the same firmware for mt76x2e and mt76x2u
* mt76x2 fixes
* mt76x0 fixes
* mt76x0e survey support
* more unification between mt76x2 and mt76x0
* mt76x0e AP mode support
* mt76x0e DFS support
* rework and fix tx status handling for mt76x0 and mt76x2

----------------------------------------------------------------
Felix Fietkau (13):
      mt76: clean up unused leftover EXPORT_SYMBOLs
      mt76: mt76x0: handle chip specific initval differences
      mt76: clean up more unused EXPORT_SYMBOLs
      mt76: mt76x02: skip station tx status for non-sta wcid entries
      mt76: mt76x02: only override control->sta on sw-encrypted tx
      mt76: add support for reporting tx status with skb
      mt76: avoid queue/status spinlocks while passing tx status to mac80211
      mt76: do not wake tx queues during flush
      mt76: fix race condition in station removal
      mt76: add mt76_sta_remove helper
      mt76: mt76x02: make group_wcid the first member in struct mt76x02_vif
      mt76: mt76x02: remove mt76x02_txq_init
      mt76: replace sta_add/remove ops with common sta_state function

Lorenzo Bianconi (49):
      mt76x2: align mt76x2 and mt76x2u firmware
      mt76x2u: align channel gain logic to mt76x2 one
      mt76x0: phy: use proper name convention
      mt76x0: phy: simplify rf configuration routines
      mt76x0: phy: improve code readability in initvals_phy.h
      mt76x0: pci: add get_survey support
      mt76: move mt76x02_mac_work routine in mt76x02-lib module
      mt76: move mt76x02_debugfs in mt76x02-lib module
      mt76x0: use shared debugfs implementation
      mt76x0: use mt76x02_mac_work as stats handler
      mt76x2u: introduce mac workqueue support
      mt76x0: phy: unify calibration between mt76x0u and mt76x0e
      mt76: usb: fix static tracepoints
      mt76x0: init: simplify mt76x0_init_mac_registers
      mt76x0: pci: add missing MODULE_FIRMWARE macro
      mt76x0: mac: remove mt76x0_mac_set_ampdu_factor
      mt76x0: align mt76x0u and mt76x0e fw version
      mt76: move mt76x02_mac_set_short_preamble in mt76x02_mac.c
      mt76: move mt76x02_init_device in mt76x02-lib module
      mt76: move mac beacon routines in mt76x02-lib module
      mt76: move tx beacon routines in mt76x02-lib module
      mt76x0: pci: add pre_tbtt_tasklet support
      mt76: move mt76x02_sw_scan and mt76x02_sw_scan_complete in mt76x02-lib module
      mt76: move mt76x02_get_txpower in mt76x02_util.c
      mt76: move mt76x02_sta_ps in mt76x02-lib module
      mt76: introduce mt76x02_init_beacon_config routine
      mt76x0: pci: enable AP support
      mt76: move mt76x02_set_tx_ackto in mt76x02-lib module
      mt76x0: update init vals for MT_TX_PROT registers
      mt76: move tx protection routines in mt76x02-lib module
      mt76: move mt76x02_bss_info_changed in mt76x02-lib module
      mt76: move dfs support in mt76x02-lib module
      mt76x0: pci: add DFS support
      mt76x0: phy: use mt76_poll_msec in mt76x0_phy_temp_sensor
      mt76x0: init: use mt76x02_mac_shared_key_setup in mt76x0_init_hardware
      mt76x2: move wcid_tx_rate conf at bootstrap
      mt76x0: init: use mt76x02_mac_wcid_setup for wcid configuration
      mt76x2u: init: remove not useful configuration
      mt76x2u: init: use common routines for wcid/key initialization
      mt76: move mt76x02_eeprom_copy in mt76x02-lib module
      mt76x0: phy: introduce tssi calibration support
      mt76x0: phy: use tssi reported value to configure tx power if available
      mt76x0: dfs: fix IBI_R11 configuration on non-radar channels
      mt76: introduce mt76x02_config_mac_addr_list routine
      mt76x0: pci: enable VHT rates in IBSS mode
      mt76x2u: phy: add TX_SHAPING calibration
      mt76x2u: phy: run phy_channel_calibrate after channel switch
      mt76x2u: main: use mt76x02_bss_info_changed utility routine
      mt76x2u: init: remove mt76x2u_init_beacon_offsets routine

Stanislaw Gruszka (10):
      mt76x0: do not perform MCU calibration for MT7630
      mt76x0: antenna select corrections
      mt76x0: do not overwrite other MT_BBP(AGC, 8) fields
      mt76x0: use band parameter for LC calibration
      mt76: remove mcu_msg_alloc
      mt76: remove wait argument from mt76x02_mcu_function_select
      mt76: remove wait argument from mt76x02_mcu_set_radio_state
      mt76x02: run calibration after scanning
      mt76x02: assure we update gain after scan
      mt76: remove wait argument from mt76x02_mcu_calibrate

 drivers/net/wireless/mediatek/mt76/Makefile                                |    3 +-
 drivers/net/wireless/mediatek/mt76/dma.c                                   |   14 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c                              |   80 +++++
 drivers/net/wireless/mediatek/mt76/mt76.h                                  |   60 +++-
 drivers/net/wireless/mediatek/mt76/mt76x0/Makefile                         |    6 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c                        |   87 -----
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c                         |   22 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c                           |  137 ++------
 drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h                       |   15 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/initvals_phy.h                   | 1313 +++++++++++++++++++++++++++++++++-----------------------------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c                            |  197 -----------
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c                           |  100 +-----
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h                         |   36 +--
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c                            |   35 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c                        |    4 -
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c                            |  898 +++++++++++++++++++++++++++++++++-----------------
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.h                            |   17 +
 drivers/net/wireless/mediatek/mt76/mt76x0/trace.c                          |   21 --
 drivers/net/wireless/mediatek/mt76/mt76x0/trace.h                          |  312 ------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c                            |   18 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c                        |   23 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h                               |   43 ++-
 drivers/net/wireless/mediatek/mt76/{mt76x2/debugfs.c => mt76x02_debugfs.c} |   22 +-
 drivers/net/wireless/mediatek/mt76/{mt76x2/pci_dfs.c => mt76x02_dfs.c}     |  153 +++++----
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.h                           |    5 +
 drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c                        |   12 +
 drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h                        |   15 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c                           |  324 +++++++++++++++----
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h                           |   38 +--
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c                           |   44 ++-
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h                           |   16 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c                          |  128 +++++++-
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c                           |    1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c                          |   31 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c                      |   42 ++-
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c                       |   18 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c                          |  334 ++++++++++++++++---
 drivers/net/wireless/mediatek/mt76/mt76x2/Makefile                         |    6 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/dfs.h                            |   26 --
 drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c                         |   15 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/init.c                           |   32 --
 drivers/net/wireless/mediatek/mt76/mt76x2/mac.h                            |    7 -
 drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c                            |   22 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h                         |   20 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h                        |    3 -
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c                       |  134 +-------
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c                        |  203 ------------
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c                       |  123 +------
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c                        |    3 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c                        |  114 +------
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c                         |  142 --------
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c                            |   95 +++++-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c                            |    4 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c                       |   44 +--
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c                       |   55 +---
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c                        |   32 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c                        |   78 ++---
 drivers/net/wireless/mediatek/mt76/tx.c                                    |  153 ++++++++-
 drivers/net/wireless/mediatek/mt76/usb.c                                   |   12 +-
 drivers/net/wireless/mediatek/mt76/usb_trace.h                             |   29 +-
 60 files changed, 2783 insertions(+), 3193 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/trace.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/trace.h
 rename drivers/net/wireless/mediatek/mt76/{mt76x2/debugfs.c => mt76x02_debugfs.c} (86%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2/pci_dfs.c => mt76x02_dfs.c} (84%)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/dfs.h
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c
