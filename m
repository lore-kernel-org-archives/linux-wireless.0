Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE7D1C28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 14:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7651D20895
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 14:42:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="pL6hoN1e"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7651D20895
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbeJMWSV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 18:18:21 -0400
Received: from nbd.name ([46.4.11.11]:36898 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726273AbeJMWSU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 18:18:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Cc:To:Subject:From:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Wchj8q6sLNv8AQx0JC1QzZm6pMOskPuONysvwFz5ttU=; b=pL6hoN1eEijGJYXEzNBrBVEJKC
        6JawlrLYfCPbGZWZb8E2eV+v/ba6zQieP8B9UrIhhpd/6XcsFkWoA62+pSWtyEFn/g8rvBWCuJwTo
        Ivi2dn/3CsJajdBrHRYkW+ddlf+gRz8HX+RR4KVCNjg0qWWnsfbKJ80ehHIo05SJOKF4=;
From:   Felix Fietkau <nbd@nbd.name>
Subject: pull request: mt76 2018-10-13
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
Message-ID: <b1a9e887-ecba-8e72-4b1c-169a19809c49@nbd.name>
Date:   Sat, 13 Oct 2018 16:40:55 +0200
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

Here's another batch of mt76 code cleanup / deduplication / fixes

- Felix

The following changes since commit c894696188d5c2af1e636e458190e80c53fb893d:

  rtlwifi: rtl8821ae: replace _rtl8821ae_mrate_idx_to_arfr_id with generic version (2018-10-13 15:00:37 +0300)

are available in the Git repository at:

  https://github.com/nbd168/wireless tags/mt76-for-kvalo-2018-10-13

for you to fetch changes up to f27a058199ee6da50d724302d42fff94a00851c7:

  mt76x0: phy: do not run calibration during channel switch (2018-10-13 16:35:16 +0200)

----------------------------------------------------------------
mt76 patches for 4.20

* mt76x0 fixes
* mt76x0e improvements (should be usable now)
* usb support improvements
* more mt76x0/mt76x2 unification work
* minor fix for aggregation + powersave clients

----------------------------------------------------------------
Felix Fietkau (2):
      mt76: do not store aggregation sequence number for null-data frames
      mt76: mt76x0e: another fix for the external PA current setting

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

Stanislaw Gruszka (7):
      mt76x0: print BBP version only for debug
      mt76x0: correct RF access via RF_CSR register.
      mt76: allow to identify bus
      mt76x0: correct RF reg pairs write for PCIe
      mt76x0: use bus helper to identify rf access method
      mt76: reserve enough room for USB tx skbs
      mt76x0: remove dma.h

YueHaibing (1):
      mt76x0: pci: fix set external PA I/O current

 drivers/net/wireless/mediatek/mt76/mmio.c             |   1 +
 drivers/net/wireless/mediatek/mt76/mt76.h             |   9 +++
 drivers/net/wireless/mediatek/mt76/mt76x0/dma.h       | 126 ---------------------------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c    |  55 ++++++++---------
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h    |   6 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c      |   9 ++-
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c      |  22 ++++---
 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h       |   3 +
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c       |  49 ++++++++++-----
 drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c   |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c       | 311 ++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c   |   7 +--
 drivers/net/wireless/mediatek/mt76/mt76x02.h          |  25 +++++---
 drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c   |  33 +++++------
 drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h   |  37 +++---------
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c      | 206 +++++++++++++++++++++++++++++++--------------------------------
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h      |  31 +++++-----
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c      |  74 +++++++++++------------
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h      |  14 +++--
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c     |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c      | 167 +++++++++++++++++++++++++++++++++++++---------------
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.h      |  39 ++++++++++--
 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h     |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c     |  29 +++++----
 drivers/net/wireless/mediatek/mt76/mt76x02_usb.h      |   8 +--
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c |  20 +------
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c  |  27 ++++-----
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c     | 120 ++++++++++++++++++-------------------
 drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c    |  80 +++++++++++--------------
 drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h    |  23 +++++++-
 drivers/net/wireless/mediatek/mt76/mt76x2/init.c      |   3 +
 drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c       |   5 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h    |   2 -
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c  |  18 +++---
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c  |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c   |   6 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c   | 100 ++++++++-----------------------
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c       |  61 +++----------------
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c  |  11 ++--
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c   |   6 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c  |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c   |  18 +++---
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c   |  32 +++++-----
 drivers/net/wireless/mediatek/mt76/tx.c               |   3 +-
 drivers/net/wireless/mediatek/mt76/usb.c              |   1 +
 47 files changed, 879 insertions(+), 936 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/dma.h
