Return-Path: <SRS0=M0/e=RK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3A64C43381
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 11:59:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AEFC2081B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 11:59:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="SQba1pGi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfCGL7g (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Mar 2019 06:59:36 -0500
Received: from nbd.name ([46.4.11.11]:43654 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbfCGL7g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Mar 2019 06:59:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Cc:To:Subject:From:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2+ySVOlAtK/hRKCAzRcokdQ3T0PYz63uEkIDcGA5HSE=; b=SQba1pGiCqA9c1W89t1S6AAP5m
        VQ4vht9UoKqF9W7koReqBRJhRZ7K2q/podczsPkpGe3iCGLS1wPSO/0q6VB9peJSAFbY+8IvSoNCy
        WUylrQh5M4Vw1ipQ5q9K2g81y0R4kgllX5b1OaTJm1XNRWHWbF3XLoMn6xWWWmG3emjI=;
From:   Felix Fietkau <nbd@nbd.name>
Subject: pull request: mt76 2019-03-07
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
Message-ID: <241bb056-21ef-0343-7a17-368a07359180@nbd.name>
Date:   Thu, 7 Mar 2019 12:59:33 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.5.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,

here's another pull request with fixes for 5.1

- Felix

The following changes since commit 4177c5d94264b57f426ef5c45a788808d1a1e536:

  net/sched: act_tunnel_key: Fix double free dst_cache (2019-03-05 12:57:28 -0800)

are available in the Git repository at:

  https://github.com/nbd168/wireless tags/mt76-for-kvalo-2019-03-07

for you to fetch changes up to 411e05f4e87794332f328ca3fa201b731f023db5:

  mt76x2u: remove duplicated entry in mt76x2u_device_table (2019-03-07 12:55:30 +0100)

----------------------------------------------------------------
mt76 patches for 5.1

* fix hardware restart for mt76x2
* fix writing txwi on USB devices
* fix (and disable by default) ED/CCA support on 76x2
* fix powersave issues on 7603
* fix return value check for ioremap on 7603
* fix duplicate USB device IDs

----------------------------------------------------------------
Felix Fietkau (15):
      mt76: rewrite dma descriptor base and ring size on queue reset
      mt76: mt76x02: when setting a key, use PN from mac80211
      mt76: mt76x2: implement full device restart on watchdog reset
      mt76: mt76x02: only update the base mac address if necessary
      mt76: mt76x02: reduce false positives in ED/CCA tx blocking
      mt76: mt7603: fix tx status HT rate validation
      mt76: mt76x2: fix external LNA gain settings
      mt76: mt76x2: fix 2.4 GHz channel gain settings
      mt76: mt7603: clear ps filtering mode before releasing buffered frames
      mt76: mt7603: fix up hardware queue index for PS filtered packets
      mt76: mt7603: notify mac80211 about buffered frames in ps queue
      mt76: mt7603: clear the service period on releasing PS filtered packets
      mt76: when releasing PS frames, end the service period if no frame was found
      mt76: mt76x02: disable ED/CCA by default
      mt76: mt7603: set moredata flag when queueing ps-filtered packets

Lorenzo Bianconi (2):
      mt76: introduce q->stopped parameter
      mt76x2u: remove duplicated entry in mt76x2u_device_table

Stanislaw Gruszka (1):
      mt76x02: fix hdr pointer in write txwi for USB

Wei Yongjun (1):
      mt76: fix return value check in mt76_wmac_probe()

 drivers/net/wireless/mediatek/mt76/dma.c              |  7 ++++++-
 drivers/net/wireless/mediatek/mt76/mt76.h             |  2 ++
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c       | 17 +++++++++++++++--
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c       |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c      | 16 ++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt7603/soc.c       |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x02.h          |  4 ++++
 drivers/net/wireless/mediatek/mt76/mt76x02_debugfs.c  | 27 +++++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c      |  3 ++-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c      | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h      |  2 ++
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c     | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c      |  2 ++
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c |  3 ++-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c     | 14 ++++++++++----
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h    |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c  |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c   | 21 +++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c       | 30 ++++++++++++++++++++++--------
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c       |  3 +--
 drivers/net/wireless/mediatek/mt76/tx.c               | 11 ++++++++++-
 drivers/net/wireless/mediatek/mt76/usb.c              |  6 +++++-
 22 files changed, 287 insertions(+), 38 deletions(-)
