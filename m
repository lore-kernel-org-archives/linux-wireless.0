Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC97C00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB6022087D
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:31:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB6022087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbeJHPlg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 11:41:36 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:51300 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbeJHPlg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 11:41:36 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9QwN-0000mG-IL; Mon, 08 Oct 2018 10:30:59 +0200
Message-ID: <1538987449.3687.1.camel@sipsolutions.net>
Subject: Re: [PATCH 0/3] split code in mt76x02_util.{c,h}
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Date:   Mon, 08 Oct 2018 10:30:49 +0200
In-Reply-To: <20181001223429.21061-1-lorenzo.bianconi@redhat.com> (sfid-20181002_003452_526371_1703B331)
References: <20181001223429.21061-1-lorenzo.bianconi@redhat.com>
         (sfid-20181002_003452_526371_1703B331)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo,

It would help - also for patchwork tracking - if you could thread your
patch series properly.

FWIW, that should be the default in git send-email, so I think you need
to either update your version or change its configuration. Unless you
weren't using --compose option and sent the 0/N manually beforehand or
something?

johannes

On Tue, 2018-10-02 at 00:34 +0200, Lorenzo Bianconi wrote:
> Move shared tx/rx code in mt76x02_txrx.c. Moreover rename
> mt76x02_util.h in mt76x02.h since now it contains most
> relevant mt76x02 data structures
> 
> Lorenzo Bianconi (3):
>   mt76: move txrx shared routines in mt76x02_txrx.c
>   mt76: rename mt76x02_util.h in mt76x02.h
>   mt76x2: remove leftover function declatarions
> 
>  drivers/net/wireless/mediatek/mt76/Makefile   |   3 +-
>  .../net/wireless/mediatek/mt76/mt76x0/init.c  |   3 -
>  .../net/wireless/mediatek/mt76/mt76x0/mac.c   |   4 +-
>  .../net/wireless/mediatek/mt76/mt76x0/main.c  |   3 +-
>  .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |   5 +-
>  .../net/wireless/mediatek/mt76/mt76x0/pci.c   |   2 -
>  .../net/wireless/mediatek/mt76/mt76x0/usb.c   |   1 -
>  .../mt76/{mt76x02_util.h => mt76x02.h}        |   3 +
>  .../net/wireless/mediatek/mt76/mt76x02_mac.c  |   5 +-
>  .../net/wireless/mediatek/mt76/mt76x02_mmio.c |   5 +-
>  .../net/wireless/mediatek/mt76/mt76x02_txrx.c | 159 ++++++++++++++++++
>  .../wireless/mediatek/mt76/mt76x02_usb_core.c |   5 +-
>  .../net/wireless/mediatek/mt76/mt76x02_util.c | 145 +---------------
>  .../net/wireless/mediatek/mt76/mt76x2/mac.c   |   1 -
>  .../net/wireless/mediatek/mt76/mt76x2/mac.h   |   3 +-
>  .../net/wireless/mediatek/mt76/mt76x2/mcu.c   |   1 -
>  .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  14 +-
>  .../wireless/mediatek/mt76/mt76x2/mt76x2u.h   |   1 -
>  .../wireless/mediatek/mt76/mt76x2/pci_core.c  |   1 -
>  .../wireless/mediatek/mt76/mt76x2/pci_dfs.c   |   1 -
>  .../wireless/mediatek/mt76/mt76x2/pci_dma.c   |   2 -
>  .../wireless/mediatek/mt76/mt76x2/pci_init.c  |   2 -
>  .../wireless/mediatek/mt76/mt76x2/pci_mac.c   |   1 -
>  .../wireless/mediatek/mt76/mt76x2/pci_main.c  |   1 -
>  .../wireless/mediatek/mt76/mt76x2/pci_mcu.c   |   1 -
>  .../wireless/mediatek/mt76/mt76x2/pci_tx.c    |   2 -
>  .../wireless/mediatek/mt76/mt76x2/usb_init.c  |   3 +-
>  .../wireless/mediatek/mt76/mt76x2/usb_main.c  |   1 -
>  28 files changed, 175 insertions(+), 203 deletions(-)
>  rename drivers/net/wireless/mediatek/mt76/{mt76x02_util.h => mt76x02.h} (98%)
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
> 
