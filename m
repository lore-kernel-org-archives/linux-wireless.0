Return-Path: <SRS0=QFll=PB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07915C64E75
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Dec 2018 16:24:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD0D321736
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Dec 2018 16:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725799AbeLXQYw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Dec 2018 11:24:52 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46260 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbeLXQYw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Dec 2018 11:24:52 -0500
Received: by mail-wr1-f66.google.com with SMTP id l9so11915773wrt.13
        for <linux-wireless@vger.kernel.org>; Mon, 24 Dec 2018 08:24:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xYjAo+0v0pomO7Ke0FBR6dMloRI+Aaq72zBVVL4vKVc=;
        b=kAGvxAtj1+e1GUPp6jc0n5VAh+JG7rmZsewSf3sl9ZbnUEJfR918dLJ/loRBLH1y8o
         UKFelYC4rtXdYbFoXiq/cOxZgsfgC+h9iuCMw2oQl5QSuRx23LKINVjiSe0ZGqd+SISf
         ckYpkgaPvG8EvTSrhgjZthbuv9l8h5UNDenCoKYK0a/bCDNpehm2KucFLlxY2tvYtdku
         tNqUA/vovE9KiR7CYRK7mcQew+CvKYtEesWE1Qko446EX+gEAzP8qXg3wYUYssVsVejw
         g3mnpJm71KWxZvk57uLHUdfEpp00Z/titnBI6waXhoYz8eZHNNhADVSCWm0GSp1yox74
         2NwQ==
X-Gm-Message-State: AJcUukdL5M5TXDFkBskGJM88hLZHm7uCQ72uUjlr0TRYYt9KT35F8oUx
        t2htMOE0MuwRnRFTZ9h2L+AjmBpbJ9c=
X-Google-Smtp-Source: ALg8bN4HJrvAZ7N8dVLYxAcgiJzVB5rsru9Ess9h4TTr7mzoXp7idErW8HlfKp6hKKrBeT79x3cBHg==
X-Received: by 2002:adf:f984:: with SMTP id f4mr12509388wrr.234.1545668690688;
        Mon, 24 Dec 2018 08:24:50 -0800 (PST)
Received: from localhost.localdomain.com (host89-60-dynamic.56-79-r.retail.telecomitalia.it. [79.56.60.89])
        by smtp.gmail.com with ESMTPSA id o82sm21283194wmo.29.2018.12.24.08.24.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 24 Dec 2018 08:24:49 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 0/2] introduce mt76 tx hang watchdog
Date:   Mon, 24 Dec 2018 17:24:40 +0100
Message-Id: <cover.1545667662.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Port mt76x02_check_tx_hang watchdog from vendor driver in order to
reset the card when tx mac/dma engine is stucked. Tx mac/dma stuck
occurs when the device is heavily loaded or in a noisy environment.
In that condition tx queues are not drained since the device does not
generate tx interrupts.
This series is based on "add EDCCA support to mt76x{0,2}e drivers"
https://patchwork.kernel.org/cover/10727149/

Lorenzo Bianconi (2):
  mt76: run mac work every 100ms
  mt76: introduce mt76x02_check_tx_hang watchdog

 drivers/net/wireless/mediatek/mt76/mt76.h     |  1 +
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  7 ++
 .../wireless/mediatek/mt76/mt76x02_debugfs.c  |  2 +
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 90 ++++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 23 +++++
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  |  2 +-
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  |  2 +-
 9 files changed, 125 insertions(+), 6 deletions(-)

-- 
2.20.1

