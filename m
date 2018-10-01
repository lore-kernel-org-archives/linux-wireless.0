Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 671B0C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 11:31:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 050822089D
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 11:31:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="mi53wbXk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 050822089D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbeJASJO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:09:14 -0400
Received: from nbd.name ([46.4.11.11]:44400 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729074AbeJASJO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:09:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Cc:To:Subject:From:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fwNHiS2vueu/6dRj4+vPkQUaV5VCyCghed/a7biPw2I=; b=mi53wbXknIJDt1qbZeSGpq0DJN
        LHDwg13wnPyGMQyv0KwXB9Zyt/JvRNJYt7SI4OCVUXDWlTNIMeRYzHG2T2XbVl2w/TJyM6X5IO9/B
        Kd9MZnKY0iX/rXcOQjzYqGBBeef7kj3BKNu5JlbeSJfrjzqB5WZEDRrY23CZX0e3ZGEY=;
From:   Felix Fietkau <nbd@nbd.name>
Subject: pull request: mt76 2018-10-01
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
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
Message-ID: <25927d7a-ddb0-a588-0979-a45f87f7e8b2@nbd.name>
Date:   Mon, 1 Oct 2018 13:31:52 +0200
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

Here's another large batch of mt76 code cleanup / deduplication / fixes

- Felix

The following changes since commit 93ed990e3a6e722b7b1e1d59b3ceb8d91e36e682:

  qtnfmac: remove set but not used variable 'vif' (2018-09-20 15:12:13 +0300)

are available in the Git repository at:

  https://github.com/nbd168/wireless tags/mt76-for-kvalo-2018-10-01

for you to fetch changes up to 5289976ad887deb07c76df7eecf553c264aeebed:

  mt76: mt76x2: fix multi-interface beacon configuration (2018-10-01 13:26:21 +0200)

----------------------------------------------------------------
mt76 patches for 4.20

* unify code between mt76x0, mt76x2
* mt76x0 fixes
* tx power configuration fix for 76x2
* more progress on mt76x0e support
* support for getting firmware version via ethtool
* fix for rx buffer allocation regression on usb
* fix for handling powersave responses
* fix for mt76x2 beacon transmission

----------------------------------------------------------------
Davide Caratti (1):
      mt76: report firmware version using ethtool

Felix Fietkau (6):
      mt76: add stbc entries to mt76_rate_power
      mt76: include linux/module.h in files using MODULE_*
      mt76x2: disable WLAN core before probe
      mt76: fix handling ps-poll frames
      mt76: check aggregation sequence number for frames sent via drv_tx
      mt76: mt76x2: fix multi-interface beacon configuration

Hauke Mehrtens (1):
      mt76: use skb_pad() instead of __skb_pad()

Lorenzo Bianconi (54):
      mt76x2: fix tx power configuration for VHT mcs 9
      mt76x0: pci: add mt7650 PCI ID
      mt76x0: pci: add fw uploading routine
      mt76: move seq_put_array in mt76-core module
      mt76: move common eeprom definitions in mt76x02-lib module
      mt76: move eeprom utility routines in mt76x02_eeprom.h
      mt76: move mt76x2_eeprom_get in mt76x02_eeprom.h
      mt76: move mt76x02_mac_setaddr in mt76x02-lib module
      mt76: move mt76x2_get_efuse_data in mt76x02-lib module
      mt76: move mt76x2_ext_pa_enabled routine in mt76x02_eeprom.c
      mt76x0: remove mt76x0_set_country_reg routine
      mt76: add mt76x02_get_rx_gain and mt76x02_get_lna_gain utility routines
      mt76x0: unify lna_gain parsing
      mt76x0: unify rssi_offset parsing
      mt76x0: unify temperature offset parsing
      mt76x0: unify freq offset parsing
      mt76: move mt76x02_eeprom_parse_hw_cap in mt76x02-lib module
      mt76x0: unify parse hw capabilities
      mt76: move mt76x2_tssi_enabled in mt76x02_eeprom.h
      mt76: usb: remove WARN_ON in mt76u_get_rx_entry_len
      mt76: move mt76_rate_power in mt76_dev
      mt76: add mt76x02_phy_set_txpower utility routine
      mt76: move rate_txpower handler in mt76 debugfs
      mt76: move mt76x02_rate_power_val in mt76x02-lib module
      mt76x0: remove mt76x0_phy_set_tx_power and mt76x0_extra_power_over_mac
      mt76x0: remove eeprom dependency from mt76x0_set_tx_power_per_rate
      mt76x0: remove eeprom dependency from mt76x0_get_power_info
      mt76x0: use shared debugfs implementation
      mt76x0: phy: introduce mt76x0_phy_set_txpower routine
      mt76: usb: make rx page_frag_cache access atomic
      mt76x0: use mt76_poll in mt76x0_set_wlan_state
      mt76: move wait_for_wpdma in mt76x02_dma.h
      mt76: add mt76x02_dma_enable/mt76x02_dma_disable utility routines
      mt76: move mt76x02_set_irq_mask in mt76x02_mmio.c
      mt76: move queue initialization in mt76x02_mmio.c
      mt76: move mt76x02_beacon_offset in mt76x02_util.c
      mt76: mmio: add implementation of wr_rp and rd_rp
      mt76: move mt76x2_wait_for_bbp in mt76x02-lib module
      mt76x0: update initvals to latest version of vendor driver
      mt76x0: pci: move mcu code in pci_mcu.c
      mt76x0: usb: move mcu code in usb_mcu.c
      mt76x0: use mt76x02 utility routines in mt76x0 init code
      mt76x0: init: remove duplicated initialization
      mt76x0: init: remove MT_PBF_SYS_CTRL configuration in mt76x0_reset_csr_bbp
      mt76x0: init rx filter in mt76x0_init_hardware
      mt76: add mt76x02_mac_start routine
      mt76x0: usb: move initialization code in usb.c
      mt76x0: pci: add hw initialization at bootstrap
      mt76x0: phy: set antenna parameter according to wireless band
      mt76: move set_{tx,rx}_path routines in mt76x02-lib module
      mt76x0: add ieee80211_ops ops pointer to mt76x0_alloc_device signature
      mt76x0: pci: add mt76x0e_{start/stop} callbacks
      mt76x0: eeprom: load eeprom data from mtd by default
      mt76x0: usb: move mt76x0u_tx_prepare_skb in usb.c

Stanislaw Gruszka (2):
      mt76: fix return value of mt76x02_wait_for_mac
      mt76x0: add quirk to disable 2.4GHz band for Archer T1U

 drivers/net/wireless/mediatek/mt76/Makefile             |   3 +-
 drivers/net/wireless/mediatek/mt76/debugfs.c            |  31 ++++++
 drivers/net/wireless/mediatek/mt76/mac80211.c           |   6 +
 drivers/net/wireless/mediatek/mt76/mmio.c               |  27 +++++
 drivers/net/wireless/mediatek/mt76/mt76.h               |  39 ++++---
 drivers/net/wireless/mediatek/mt76/mt76x0/Makefile      |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c     |  81 +-------------
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c      | 566 +++++++++++++++++++++++++++++++++++++++-------------------------------------------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h      | 132 +++-------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c        | 191 +++++---------------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h    | 405 ++++++++++++++++++++++++++++++-------------------------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c        |  98 +++++------------
 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h         |   7 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h      |  36 +++---
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c         | 111 ++++++++++++++++++-
 drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c     | 146 ++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c         | 176 +++++++----------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c          |  24 +---
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c         | 306 ++++++++++++++++++++++++++-------------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c     | 176 +++++++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_dma.h        |  17 +++
 drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c     | 156 ++++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h     | 211 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c        |  18 +++
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h        |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c        |  13 +++
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h        |  11 ++
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c       | 161 +++++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c        | 135 +++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.h        |  29 +++++
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c    |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c       |  39 +++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h       |  24 ++++
 drivers/net/wireless/mediatek/mt76/mt76x2.h             |  42 +------
 drivers/net/wireless/mediatek/mt76/mt76x2_core.c        |  28 ++---
 drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c     |  23 +---
 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c         |   7 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c         |  91 +--------------
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c      | 316 +++++++++++++++-------------------------------------
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h      | 123 +--------------------
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c        |  81 ++------------
 drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c |  24 ++--
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c         |  17 ++-
 drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c  |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c        |  10 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c         |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h         |   7 --
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu_common.c  |   7 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_pci.c         |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c         |   8 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c  |  76 +++----------
 drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c   |  14 +--
 drivers/net/wireless/mediatek/mt76/mt76x2u.h            |   3 -
 drivers/net/wireless/mediatek/mt76/mt76x2u_init.c       |  29 ++---
 drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c        |  26 +----
 drivers/net/wireless/mediatek/mt76/mt76x2u_main.c       |   6 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c        |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c        |  39 +------
 drivers/net/wireless/mediatek/mt76/tx.c                 |  36 ++++--
 drivers/net/wireless/mediatek/mt76/usb.c                |  15 ++-
 61 files changed, 2289 insertions(+), 2131 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
