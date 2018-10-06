Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A30C64EB8
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 10:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59A8021473
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 10:03:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="uJSI3Ozi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59A8021473
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbeJFRGf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 13:06:35 -0400
Received: from nbd.name ([46.4.11.11]:46746 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726919AbeJFRGf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 13:06:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BP9c+Er/GzscC3GSxCXc4kD/YfegQz7IxME63isbX4w=; b=uJSI3OzicgITRExDWVgAom65eM
        /3KJI9WCJhSDlSV4BYzLr485Waqy9x5Mvn1j1Z5oimC9CaZpQpIlfN5AO8e29lmMYEj/qrrTkjATP
        lfm/FAG04KrlEs9sExBdvqZUiksRMR6vGKf0AGagFuI0m3HNt3WNXVvVDnNDCWLFE4II=;
Subject: pull request: mt76 2018-10-05 v2
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
References: <783b92c4-0fba-35d8-9fdb-2c3462aa9f7f@nbd.name>
 <87sh1jh0fo.fsf@kamboji.qca.qualcomm.com>
From:   Felix Fietkau <nbd@nbd.name>
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
Message-ID: <20524062-9770-24d6-b1d8-9dfbe30e6b1f@nbd.name>
Date:   Sat, 6 Oct 2018 12:03:50 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <87sh1jh0fo.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,

here's the fixed version of the previous pull request. I've dropped
the broken patch from the previous round.

- Felix

The following changes since commit e1c02eb16a9c742178874a7d1a08d300981715fb:

  qtnfmac: implement dump_station support for STA mode (2018-10-05 14:01:44 +0300)

are available in the Git repository at:

  https://github.com/nbd168/wireless tags/mt76-for-kvalo-2018-10-05

for you to fetch changes up to 9b43960b899c71c758209a58c7e8d7d6e481e272:

  mt76: move irq handler in mt76x02-lib moudle (2018-10-05 20:05:46 +0200)

----------------------------------------------------------------
mt76 patches for 4.20

* unify code between mt76x0, mt76x2
* mt76x0 fixes
* another fix for rx buffer allocation regression on usb
* move mt76x2 source files to mt76x2 folder
* more work on mt76x0e support

----------------------------------------------------------------
Colin Ian King (1):
      mt76: fix header guard macro define names

Lorenzo Bianconi (30):
      mt76x0: pci: add mt76x0e_cleanup routine
      mt76x2: move mt76x2 source files to mt76x2 folder
      mt76: usb: fix hw initialization sequence
      mt76x0: usb: stop cal/mac workqueues at hw stop
      mt76: move mt76x02_tx_get_max_txpwr_adj in mt76x02_util.c
      mt76: add get_tx_txpwr_adj function pointer to mt76_driver_ops
      mt76: move mt76x02_mac_write_txwi in mt76x02-lib module
      mt76: usb: use mt76x02u_tx_prepare_skb to fill txwi
      mt76x0: init: remove unnecessary configurations
      mt76: move mt76x02_phy_get_min_avg_rssi in mt76x02_phy.c
      mt76: move mt76x02_rx_get_sta and mt76x02_rx_get_sta_wcid in mt76x02_util.h
      mt76x0: mac: use sta ewma estimation for rssi tracking
      mt76x0: remove unused variable in mt76x0_dev
      mt76x0: remove hw_atomic_mutex mutex in mt76x0_dev
      mt76x2: move mt76x2_dev in mt76x02_util.h
      mt76x0: merge mt76x0_dev in mt76x02_dev
      mt76: move mt76x02_mac_process_rx in mt76x02-lib module
      mt76: unify rxwi parsing between mt76x2 and mt76x0 drivers
      mt76: move mt76x02_tx in mt76x02-lib module
      mt76: move txrx shared routines in mt76x02_txrx.c
      mt76: rename mt76x02_util.h in mt76x02.h
      mt76x2: remove leftover function declatarions
      mt76: move tpc routines in mt76x02-lib module
      mt76: move mt76x02_tx_prepare_skb in mt76x02_txrx.c
      mt76: usb: move mt76x02u_tx_complete_skb in mt76x02_usb_core.c
      mt76: move mt76x02_mac_poll_tx_status in mt76x02-lib moudle
      mt76: move mt76x02_tx_complete in mt76x02-lib module
      mt76: use mt76x02_dev instead of mt76_dev in mt76x02_mmio.c
      mt76: move tx_tasklet management in mt76x02-lib moudle
      mt76: move irq handler in mt76x02-lib moudle

Stanislaw Gruszka (1):
      mt76: fix frag length allocation for usb

 drivers/net/wireless/mediatek/mt76/Kconfig                                 |  43 +-------------
 drivers/net/wireless/mediatek/mt76/Makefile                                |  26 ++-------
 drivers/net/wireless/mediatek/mt76/mt76.h                                  |   6 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/Kconfig                          |  20 +++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/Makefile                         |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c                        |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c                         |  28 ++++-----
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h                         |  18 ++----
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c                           |  50 ++++++----------
 drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h                       |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c                            |  82 +++-----------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h                            |  20 -------
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c                           |  19 +++---
 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h                            |   8 +--
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h                         | 135 +++++++-----------------------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c                            |  44 +++++++++-----
 drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c                        |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c                            | 112 +++++++++++++----------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/trace.h                          |   1 -
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c                             | 101 --------------------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c                            |  68 +++++++++-------------
 drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c                        |   6 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h                               | 208 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/{mt76x2_dfs.h => mt76x02_dfs.h}         |  40 ++++++-------
 drivers/net/wireless/mediatek/mt76/mt76x02_dma.h                           |   8 +--
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c                           | 239 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h                           |  32 ++++++++--
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h                           |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c                          | 179 +++++++++++++++++++++++++++++++++++++++++++-------------
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c                           |  48 +++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.h                           |   1 +
 drivers/net/wireless/mediatek/mt76/{mt76x2_trace.c => mt76x02_trace.c}     |   2 +-
 drivers/net/wireless/mediatek/mt76/{mt76x2_trace.h => mt76x02_trace.h}     |  31 +++++-----
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c                          | 203 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_usb.h                           |   9 ++-
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c                      |  57 ++++++++++++++++--
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c                          |  55 +-----------------
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h                          |  78 -------------------------
 drivers/net/wireless/mediatek/mt76/mt76x2.h                                | 210 ------------------------------------------------------------------
 drivers/net/wireless/mediatek/mt76/mt76x2/Kconfig                          |  20 +++++++
 drivers/net/wireless/mediatek/mt76/mt76x2/Makefile                         |  16 +++++
 drivers/net/wireless/mediatek/mt76/{mt76x2_debugfs.c => mt76x2/debugfs.c}  |  12 ++--
 drivers/net/wireless/mediatek/mt76/mt76x2/dfs.h                            |  26 +++++++++
 drivers/net/wireless/mediatek/mt76/{mt76x2_eeprom.c => mt76x2/eeprom.c}    |  42 ++++++++------
 drivers/net/wireless/mediatek/mt76/{mt76x2_eeprom.h => mt76x2/eeprom.h}    |  12 ++--
 drivers/net/wireless/mediatek/mt76/{mt76x2_init_common.c => mt76x2/init.c} |  14 ++---
 drivers/net/wireless/mediatek/mt76/{mt76x2_common.c => mt76x2/mac.c}       |  46 +++++++++------
 drivers/net/wireless/mediatek/mt76/{mt76x2_dma.c => mt76x2/mac.h}          |  32 +++++-----
 drivers/net/wireless/mediatek/mt76/{mt76x2_mcu_common.c => mt76x2/mcu.c}   |  13 ++---
 drivers/net/wireless/mediatek/mt76/{mt76x2_mcu.h => mt76x2/mcu.h}          |   6 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h                         | 107 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/{ => mt76x2}/mt76x2u.h                  |  41 ++++++-------
 drivers/net/wireless/mediatek/mt76/{mt76x2_pci.c => mt76x2/pci.c}          |   7 +--
 drivers/net/wireless/mediatek/mt76/{mt76x2_dfs.c => mt76x2/pci_dfs.c}      | 146 +++++++++++++++++++++++-----------------------
 drivers/net/wireless/mediatek/mt76/{mt76x2_init.c => mt76x2/pci_init.c}    |  70 +++++++++-------------
 drivers/net/wireless/mediatek/mt76/{mt76x2_mac.c => mt76x2/pci_mac.c}      |  99 +++++--------------------------
 drivers/net/wireless/mediatek/mt76/{mt76x2_main.c => mt76x2/pci_main.c}    |  31 +++++-----
 drivers/net/wireless/mediatek/mt76/{mt76x2_mcu.c => mt76x2/pci_mcu.c}      |  11 ++--
 drivers/net/wireless/mediatek/mt76/{mt76x2_phy.c => mt76x2/pci_phy.c}      |  35 +++++------
 drivers/net/wireless/mediatek/mt76/{mt76x2_tx.c => mt76x2/pci_tx.c}        |  43 ++------------
 drivers/net/wireless/mediatek/mt76/{mt76x2_phy_common.c => mt76x2/phy.c}   |  71 ++++------------------
 drivers/net/wireless/mediatek/mt76/{mt76x2_usb.c => mt76x2/usb.c}          |  10 ++--
 drivers/net/wireless/mediatek/mt76/{mt76x2u_init.c => mt76x2/usb_init.c}   |  40 ++++++-------
 drivers/net/wireless/mediatek/mt76/{mt76x2u_mac.c => mt76x2/usb_mac.c}     |  14 ++---
 drivers/net/wireless/mediatek/mt76/{mt76x2u_main.c => mt76x2/usb_main.c}   |  19 +++---
 drivers/net/wireless/mediatek/mt76/{mt76x2u_mcu.c => mt76x2/usb_mcu.c}     |  20 +++----
 drivers/net/wireless/mediatek/mt76/{mt76x2u_phy.c => mt76x2/usb_phy.c}     |  15 ++---
 drivers/net/wireless/mediatek/mt76/mt76x2_core.c                           |  76 ------------------------
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h                            |  64 --------------------
 drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c                     | 239 ---------------------------------------------------------------------------
 drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c                      | 118 -------------------------------------
 drivers/net/wireless/mediatek/mt76/mt76x2u_core.c                          |  53 -----------------
 drivers/net/wireless/mediatek/mt76/usb.c                                   |   2 +-
 73 files changed, 1684 insertions(+), 2088 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/Kconfig
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02.h
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_dfs.h => mt76x02_dfs.h} (76%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_trace.c => mt76x02_trace.c} (97%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_trace.h => mt76x02_trace.h} (86%)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_util.h
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/Kconfig
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_debugfs.c => mt76x2/debugfs.c} (92%)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/dfs.h
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_eeprom.c => mt76x2/eeprom.c} (91%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_eeprom.h => mt76x2/eeprom.h} (83%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_init_common.c => mt76x2/init.c} (95%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_common.c => mt76x2/mac.c} (53%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_dma.c => mt76x2/mac.h} (59%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_mcu_common.c => mt76x2/mcu.c} (90%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_mcu.h => mt76x2/mcu.h} (93%)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
 rename drivers/net/wireless/mediatek/mt76/{ => mt76x2}/mt76x2u.h (55%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_pci.c => mt76x2/pci.c} (93%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_dfs.c => mt76x2/pci_dfs.c} (84%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_init.c => mt76x2/pci_init.c} (87%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_mac.c => mt76x2/pci_mac.c} (66%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_main.c => mt76x2/pci_main.c} (91%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_mcu.c => mt76x2/pci_mcu.c} (95%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_phy.c => mt76x2/pci_phy.c} (92%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_tx.c => mt76x2/pci_tx.c} (75%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_phy_common.c => mt76x2/phy.c} (82%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_usb.c => mt76x2/usb.c} (95%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2u_init.c => mt76x2/usb_init.c} (88%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2u_mac.c => mt76x2/usb_mac.c} (94%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2u_main.c => mt76x2/usb_main.c} (92%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2u_mcu.c => mt76x2/usb_mcu.c} (93%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2u_phy.c => mt76x2/usb_phy.c} (94%)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_core.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
