Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D0DBC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 248B320844
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:45:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="UbzBl1gx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbfAVPp6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:45:58 -0500
Received: from nbd.name ([46.4.11.11]:51410 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729204AbfAVPp5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:45:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Subject:From:Cc:To:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ERHr9nmnAVfzJzVVcAJsvelF+fncnLjfOEiN0eNonO0=; b=UbzBl1gxeo41weyrAQuWePj/Vy
        aCwLkyg78mxZDCa7zA0u4lI7DCHtHXGC6GLbtOh1dDC8FTYPYCMVdcFLEHbvkHhTwX2D5uGw0PGBH
        j7gJrKnx5/NBFr2H0I5SA/jAByAhqH+pJ/DpTKd+NmTCHLZvvRRnqGvpvsj4sDdIH0m8=;
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
From:   Felix Fietkau <nbd@nbd.name>
Subject: pull request: mt76 2019-01-22
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
Message-ID: <190a2c7e-d6ab-2984-2f25-e2ac34aede08@nbd.name>
Date:   Tue, 22 Jan 2019 16:45:55 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,

here's my first pull request for 5.1

- Felix

The following changes since commit 4ad0be160544ffbdafb7cec39bb8e6dd0a97317a:

  brcmfmac: Use firmware_request_nowarn for the clm_blob (2019-01-10 13:41:03 +0200)

are available in the Git repository at:

  https://github.com/nbd168/wireless tags/mt76-for-kvalo-2019-01-22

for you to fetch changes up to d225581df3147060bc99e931b11f7cf2dcb1b2ca:

  mt76: avoid scheduling tx queues for powersave stations (2019-01-22 16:37:35 +0100)

----------------------------------------------------------------
first batch of mt76 patches for 5.1

* fixes for mt76x0/mt76x2
* energy detect regulatory compliance fixes
* tx status handling fixes
* preparation for MT7603 support
* channel switch announcement support

----------------------------------------------------------------
Colin Ian King (1):
      mt76: make const array 'data' static, shrinks object size

Felix Fietkau (12):
      mt76: add size check for additional rx fragments
      mt76: throttle transmission of buffered multicast packets
      mt76: request tx status for powersave released EOSP packet
      mt76: fix tx status reporting for non-probing frames
      mt76: set IEEE80211_HW_NEEDS_UNIQUE_STA_ADDR flag
      mt76: move mt76x02_get_txpower to mt76 core
      mt76: move mt76x02_phy_get_min_avg_rssi to mt76 core
      mt76: fix rssi ewma tracking
      mt76: fix signedness of rx status signal field
      mt76: add channel switch announcement support
      mt76: fix per-chain signal strength reporting
      mt76: avoid scheduling tx queues for powersave stations

Hauke Mehrtens (1):
      mt76: Add missing include of linux/module.h

Lorenzo Bianconi (17):
      mt76: dma: remove napi from mt76_dma_rx_fill signature
      mt76: usb: do not build the skb if reported len does not fit in buf_size
      mt76: fix typo in mt76x02_check_mac_err routine
      mt76: mac: run mt76x02_mac_work routine atomically
      mt76: usb: avoid queue/status spinlocks while passing tx status to mac80211
      mt76x0: pci: fix ACS support
      mt76x2: add static qualifier to mt76x2_init_hardware
      mt76: dfs: run mt76x02_dfs_set_domain atomically
      mt76x2: init: set default value for MT_TX_LINK_CFG
      mt76: add energy detect CCA support to mt76x{0,2}e drivers
      mt76: mac: minor optimizations in mt76x02_mac_tx_rate_val
      mt76: dma: do not build skb if reported len does not fit in buf_size
      mt76: mmio: introduce mt76x02_check_tx_hang watchdog
      mt76: dma: avoid indirect call in mt76_dma_tx_queue_skb
      mt76: use proper name for __MT76x02_H macro
      mt76: add led support to mt76x0e driver
      mt76: do not report out-of-range rx nss

Stanislaw Gruszka (4):
      mt76x02: do not set protection on set_rts_threshold callback
      mt76x02: fixup MT_PROT_RATE_* defines
      mt76x02: set protection according to ht operation element
      mt76x0: configure MT_VHT_HT_FBK_CFG1

 drivers/net/wireless/mediatek/mt76/dma.c              |  31 ++++++++------
 drivers/net/wireless/mediatek/mt76/mac80211.c         |  68 +++++++++++++++++++++++++++++-
 drivers/net/wireless/mediatek/mt76/mt76.h             |  23 +++++++++-
 drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h  |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c       |  11 ++++-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c       |   6 ++-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c       |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c   |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h          |  22 +++++++---
 drivers/net/wireless/mediatek/mt76/mt76x02_debugfs.c  |   2 +
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c      |   6 +++
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c      | 222 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h      |  12 +++---
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c     | 142 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c      |  47 ---------------------
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.h      |   1 -
 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h     |  38 +++++++++++++++--
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c     |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c     |  89 ++++++++++++++++++++++++++++++---------
 drivers/net/wireless/mediatek/mt76/mt76x2/init.c      |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x2/mcu.h       |  23 ----------
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h    |   1 -
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c  |  58 ++-----------------------
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c  |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c   |   2 +
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c       |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c  |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/tx.c               |  17 +++++---
 drivers/net/wireless/mediatek/mt76/usb.c              |  20 ++++-----
 drivers/net/wireless/mediatek/mt76/util.c             |  42 ++++++++++++++++++
 32 files changed, 664 insertions(+), 241 deletions(-)
