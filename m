Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A16DEC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 11:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6512F2173C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 11:42:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="RtOrlFWB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfBZLmC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 06:42:02 -0500
Received: from nbd.name ([46.4.11.11]:38626 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbfBZLmC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 06:42:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Cc:To:Subject:From:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EXerCO4y6M9l0Jcvtm6zcSG0kCqoMl35g/WW4U8O3Gw=; b=RtOrlFWBAg75JL1h2YmXO9WxB3
        GrPvj0j4m4CpX3PxzByzlNupyfnvBOrXs9CWTLkkSFQbLC9qS9KDact4HM5+ssYH7STqQx/V7Z3DY
        FTJSZfCHZ/hslpcoeYfQ/kS4ooejYzn3SOXTaWZGneKRXMhtZf956ac6/nn/8+pCffrw=;
From:   Felix Fietkau <nbd@nbd.name>
Subject: pull request: mt76 2019-02-26 v2
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Openpgp: preference=signencrypt
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 mQGiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwbQcRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPohgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQuQINBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabiEkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <11927365-0cd5-1fbc-c895-254b2e5c73e7@nbd.name>
Date:   Tue, 26 Feb 2019 12:41:59 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,

here's another pull request for 5.1
v2: add two missing patches, fix bisect issues

- Felix

The following changes since commit bd16693f359bbab8776541c06a6df32f3996638e:

  net: fix double-free in bpf_lwt_xmit_reroute (2019-02-24 22:24:50 -0800)

are available in the Git repository at:

  https://github.com/nbd168/wireless tags/mt76-for-kvalo-2019-02-26

for you to fetch changes up to c8846e1015022d2531ac4c895783e400b3e5babe:

  mt76: add driver for MT7603E and MT7628/7688 (2019-02-26 12:29:56 +0100)

----------------------------------------------------------------
mt76 patches for 5.1

* add driver for MT7603E/MT7628
* fix ED/CCA issues
* fix USB issues
* more code unification
* fix beacon timer issues
* fix recovery from MCU timeout issues

----------------------------------------------------------------
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

Lorenzo Bianconi (6):
      mt76: usb: fix warning in mt76u_buf_free
      mt76: usb: introduce mt76u_fill_bulk_urb routine
      mt76: usb: simplify rx buffer allocation
      mt76: usb: simplify mt76u_tx_build_sg routine
      mt76: usb: check urb->num_sgs limit in mt76u_process_rx_entry
      mt76: remove no longer used routine declarations

Stanislaw Gruszka (3):
      mt76usb: allow mt76u_bulk_msg be used for reads
      mt76usb: use synchronous msg for mcu command responses
      mt76usb: remove usb_mcu.c

 Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt |   19 +
 drivers/net/wireless/mediatek/mt76/Kconfig                       |    1 +
 drivers/net/wireless/mediatek/mt76/Makefile                      |    3 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c                    |    5 +
 drivers/net/wireless/mediatek/mt76/mt76.h                        |   29 +-
 drivers/net/wireless/mediatek/mt76/mt7603/Kconfig                |    9 +
 drivers/net/wireless/mediatek/mt76/mt7603/Makefile               |    6 +
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c               |  186 +++++++++
 drivers/net/wireless/mediatek/mt76/mt7603/core.c                 |   73 ++++
 drivers/net/wireless/mediatek/mt76/mt7603/debugfs.c              |   56 +++
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c                  |  215 +++++++++++
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c               |  168 ++++++++
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.h               |   86 +++++
 drivers/net/wireless/mediatek/mt76/mt7603/init.c                 |  578 ++++++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c                  | 1749 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt7603/mac.h                  |  242 ++++++++++++
 drivers/net/wireless/mediatek/mt76/mt7603/main.c                 |  709 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c                  |  483 +++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.h                  |  110 ++++++
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h               |  253 +++++++++++++
 drivers/net/wireless/mediatek/mt76/mt7603/pci.c                  |   80 ++++
 drivers/net/wireless/mediatek/mt76/mt7603/regs.h                 |  774 +++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt7603/soc.c                  |   85 +++++
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c                 |    2 +
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c                 |    2 +
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c                  |    6 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c                  |   16 -
 drivers/net/wireless/mediatek/mt76/mt76x02.h                     |    1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c                 |    9 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c                 |    1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c                |   42 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c             |   36 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c                |    9 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mac.c                  |    3 +
 drivers/net/wireless/mediatek/mt76/mt76x2/mac.h                  |    8 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h              |    1 -
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c             |    7 -
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c              |    7 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c                  |   11 -
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c             |    5 -
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c              |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c             |    5 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c              |    3 +-
 drivers/net/wireless/mediatek/mt76/usb.c                         |  154 +++-----
 drivers/net/wireless/mediatek/mt76/usb_mcu.c                     |   57 ---
 45 files changed, 6037 insertions(+), 280 deletions(-)
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
