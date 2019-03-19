Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D5EAC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 19:43:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E497A2085A
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 19:43:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Li3L716V";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Li3L716V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfCSTnK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 15:43:10 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38788 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727237AbfCSTnK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 15:43:10 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DD70F60EA5; Tue, 19 Mar 2019 19:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553024588;
        bh=9/LRDOxhaihR7PeN0k2izlBJHDTkcvd3R6zKt/V+Zc0=;
        h=From:To:Cc:Subject:Date:From;
        b=Li3L716VaG7UEPw+cdFhx+fFNCdSdaHgfsTmnMCNCg8jh2fGMrwaeGzIDwsGd0Pmt
         Hy+x7j+rtcmTE3uGOoB3acJzZDXoUyCS5UhSv49+Yvqcc7YwK6wn63gqenDOGNR5oU
         yP3Nhw9r2KJbtTdaUJJpajhJg3GQAQaivnZlcqaI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 30E5C60E75;
        Tue, 19 Mar 2019 19:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553024588;
        bh=9/LRDOxhaihR7PeN0k2izlBJHDTkcvd3R6zKt/V+Zc0=;
        h=From:To:Cc:Subject:Date:From;
        b=Li3L716VaG7UEPw+cdFhx+fFNCdSdaHgfsTmnMCNCg8jh2fGMrwaeGzIDwsGd0Pmt
         Hy+x7j+rtcmTE3uGOoB3acJzZDXoUyCS5UhSv49+Yvqcc7YwK6wn63gqenDOGNR5oU
         yP3Nhw9r2KJbtTdaUJJpajhJg3GQAQaivnZlcqaI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 30E5C60E75
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2019-03-19
Date:   Tue, 19 Mar 2019 21:43:04 +0200
Message-ID: <87pnqm4pmf.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

here are some fixes to net tree for 5.1. Please let me know if there are
any problems.

Kalle

The following changes since commit 4177c5d94264b57f426ef5c45a788808d1a1e536:

  net/sched: act_tunnel_key: Fix double free dst_cache (2019-03-05 12:57:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2019-03-19

for you to fetch changes up to 7dfc45e6282a7662279d168cc1219929456f8750:

  mt76x02: do not enable RTS/CTS by default (2019-03-19 17:37:25 +0200)

----------------------------------------------------------------
wireless-drivers fixes for 5.1

First set of fixes for 5.1. Lots of fixes for mt76 this time.

iwlwifi

* fix warning with do_div()

mt7601u

* avoid using hardware which is supported by mt76

mt76

* more fixes for hweight8() usage

* fix hardware restart for mt76x2

* fix writing txwi on USB devices

* fix (and disable by default) ED/CCA support on 76x2

* fix powersave issues on 7603

* fix return value check for ioremap on 7603

* fix duplicate USB device IDs

----------------------------------------------------------------
Arnd Bergmann (1):
      iwlwifi: fix 64-bit division

Felix Fietkau (16):
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
      mt76: mt7603: use the correct hweight8() function

Kalle Valo (1):
      Merge tag 'mt76-for-kvalo-2019-03-07' of https://github.com/nbd168/wireless

Lorenzo Bianconi (3):
      mt76: introduce q->stopped parameter
      mt76x2u: remove duplicated entry in mt76x2u_device_table
      mt76: fix schedule while atomic in mt76x02_reset_state

Stanislaw Gruszka (4):
      mt76x02: fix hdr pointer in write txwi for USB
      mt7601u: check chip version on probe
      mt76x02u: check chip version on probe
      mt76x02: do not enable RTS/CTS by default

Wei Yongjun (1):
      mt76: fix return value check in mt76_wmac_probe()

 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |  4 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |  7 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      | 18 +++--
 drivers/net/wireless/mediatek/mt76/mt76.h          |  4 ++
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |  3 +-
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    | 17 ++++-
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   | 16 +++++
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/soc.c    |  4 +-
 .../net/wireless/mediatek/mt76/mt76x0/initvals.h   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    | 10 ++-
 drivers/net/wireless/mediatek/mt76/mt76x02.h       | 11 +++
 .../net/wireless/mediatek/mt76/mt76x02_debugfs.c   | 27 +++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c   |  3 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   | 67 ++++++++++++++++--
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |  2 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  | 82 +++++++++++++++++++---
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c   |  2 +
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  |  3 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  | 14 ++--
 drivers/net/wireless/mediatek/mt76/mt76x2/init.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h |  1 +
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_mcu.c    | 21 ++++++
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c    | 30 +++++---
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |  7 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_mac.c    |  1 -
 drivers/net/wireless/mediatek/mt76/tx.c            | 11 ++-
 drivers/net/wireless/mediatek/mt76/usb.c           |  6 +-
 drivers/net/wireless/mediatek/mt7601u/usb.c        |  4 ++
 32 files changed, 329 insertions(+), 58 deletions(-)

-- 
Kalle Valo
