Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E10C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 20:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA35D217D7
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 20:19:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="CrJgKuR3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbfBRUTy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 15:19:54 -0500
Received: from nbd.name ([46.4.11.11]:58494 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727400AbfBRUTx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 15:19:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Cc:To:Subject:From:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=de4GLOwjtDF33QQQGJJLpe/Ni3FlKB1ItKrWD/F3ljY=; b=CrJgKuR3IVkjuj8E6nN5bF81xG
        UYnJqTa288dvuSzHVVYHlwvAgLraNctNsJ5xPHzI7jsJSfJdLTtON+BMu5Qpgh9htKpVun/R2AQOE
        l2r57tOTAC4hf5k9Dt2BfA9pTs8f8iIjnN+hAFoT0HagSrIScEMs04jI2gW0gm5tZnjw=;
From:   Felix Fietkau <nbd@nbd.name>
Subject: pull request: mt76 2019-02-18
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
Message-ID: <13bb375f-9800-3b09-d7c2-c97b263691b5@nbd.name>
Date:   Mon, 18 Feb 2019 21:19:50 +0100
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

- Felix

The following changes since commit f77ecde5f206195cdce16dd2ac92d7ca0305ba2b:

  Merge tag 'iwlwifi-next-for-kalle-2019-02-14' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next (2019-02-18 20:10:46 +0200)

are available in the Git repository at:

  https://github.com/nbd168/wireless tags/mt76-for-kvalo-2019-02-18

for you to fetch changes up to 9f688473408b6334c5da5ec085f9ea1954675fe7:

  mt76: mt76x2: simplify per-chain signal strength handling (2019-02-18 20:41:50 +0100)

----------------------------------------------------------------
mt76 patches for 5.1

* beacon support for USB devices (mesh+ad-hoc only)
* mt76x0 tx power fixes
* fixes for encryption, calibration and ED/CCA
* more code unification
* USB fixes
* fix for using the correct hweight8 function

----------------------------------------------------------------
Ben Hutchings (1):
      mt76: Use the correct hweight8() function

Felix Fietkau (11):
      mt76: fix software encryption issues
      mt76: mt76x2: avoid running DPD calibration if tx is blocked
      mt76: explicitly disable energy detect cca during scan
      mt76: run MAC work every 100ms
      mt76: clear CCA timer stats in mt76x02_edcca_init
      mt76: measure the time between mt76x02_edcca_check runs
      mt76: increase ED/CCA tx block threshold
      mt76: fix tx status timeout processing
      mt76: fix corrupted software generated tx CCMP PN
      mt76: fix resetting software IV flag on key delete
      mt76: mt76x2: simplify per-chain signal strength handling

Lorenzo Bianconi (21):
      mt76x0: eeprom: fix VHT mcs{8,9} rate power offset
      mt76: move mt76_mcu_msg_alloc in mt76-core
      mt76: move mt76_mcu_get_response in mt76-core
      mt76: move mt76_mcu_rx_event in mt76-core
      mt76x0: mcu: remove useless commented configuration
      mt76: move mt76_dma_tx_queue_skb_raw in mt76-core module
      mt76: remove add_buf pointer in mt76_queue_ops
      mt76: move alloc_device common code in mt76_alloc_device
      mt76x2u: remove mt76x2u_alloc_device routine
      mt76x0: remove mt76x0u_alloc_device routine
      mt76x2: remove mt76x2_alloc_device routine
      mt76x0: phy: report target_power in debugfs
      mt76x0: init: introduce mt76x0_init_txpower routine
      mt76: usb: fix possible NULL pointer dereference in mt76u_mcu_deinit
      mt76: usb: fix possible memory leak in mt76u_buf_free
      mt76: usb: do not run mt76u_queues_deinit twice
      mt76: usb: move mt76u_check_sg in usb.c
      mt76: usb: do not use sg buffers for mcu messages
      mt76: usb: use a linear buffer for tx/rx datapath if sg is not supported
      mt76: usb: introduce disable_usb_sg parameter
      mt76: usb: use dev_err_ratelimited instead of dev_err in mt76u_complete_rx

Ryder Lee (1):
      mt76: change the return type of mt76_dma_attach()

Stanislaw Gruszka (9):
      mt76x02: use mask for vifs
      mt76x02: use commmon add interface for mt76x2u
      mt76x02: initialize mutli bss mode when set up address
      mt76x02: minor beaconing init changes
      mt76x02: init beacon config for mt76x2u
      mt76: beaconing fixes for USB
      mt76x02: enable support for IBSS and MESH
      mt76x02u: use usb_bulk_msg to upload firmware
      mt76x02u: remove bogus check and comment padding

 drivers/net/wireless/mediatek/mt76/Makefile           |   3 +-
 drivers/net/wireless/mediatek/mt76/dma.c              |  29 ++++++++++++++++--
 drivers/net/wireless/mediatek/mt76/dma.h              |   2 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c         |  11 +++++--
 drivers/net/wireless/mediatek/mt76/mcu.c              |  60 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h             |  32 ++++++++++++++-----
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c    |  16 +++++-----
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h    |   7 +++--
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c      |  39 ++++++++++++-----------
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h    |   4 ---
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c       |  19 +++++++-----
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c       |  11 ++++---
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c       |  26 +++++++++-------
 drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c   |   6 ----
 drivers/net/wireless/mediatek/mt76/mt76x02.h          |   7 +++--
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c      |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c      |  90 ++++++++++++++++++++++++++++++++++++++++++-----------
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h      |   8 ++---
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c      |  69 ++++++-----------------------------------
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h      |   6 ++++
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c     |  12 ++------
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c |  14 ++++++---
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c  |  72 +++++++++++--------------------------------
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c     |  79 ++++++++++++++++++++++++-----------------------
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h    |   1 -
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h   |   1 -
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c       |  26 ++++++++++++----
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c  |  31 +------------------
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c  |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c   |   6 ++--
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c       |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c       |  24 +++++++++++----
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c  |  32 ++-----------------
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c  |  17 ++--------
 drivers/net/wireless/mediatek/mt76/tx.c               |   5 +--
 drivers/net/wireless/mediatek/mt76/usb.c              | 162 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------
 drivers/net/wireless/mediatek/mt76/usb_mcu.c          |  13 ++++----
 37 files changed, 524 insertions(+), 422 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mcu.c
