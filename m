Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C52C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 12:21:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 402B02148E
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 12:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfA1MVx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 07:21:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41859 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbfA1MVx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 07:21:53 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2855886677;
        Mon, 28 Jan 2019 12:21:53 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A81D560BE0;
        Mon, 28 Jan 2019 12:21:50 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH v2 0/7] mt76x02: Beacon support for USB
Date:   Mon, 28 Jan 2019 13:21:41 +0100
Message-Id: <1548678108-9526-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Mon, 28 Jan 2019 12:21:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

We can configure beaconing, but without TBTT interrupt we
can not support PS buffering. This can be added later using
kernel hrtimer, if we can keep it in sycn with device timer.

I tested AP and IBSS modes.

Stanislaw Gruszka (7):
  mt76x02: use mask for vifs
  mt76x02: use commmon add interface for mt76x2u
  mt76x02: initialize mutli bss mode when set up address
  mt76x02: minor beaconing init changes
  mt76x02: init beacon config for mt76x2u
  mt76: beaconing fixes for USB
  mt76x02: enable support for IBSS, AP and MESH

 drivers/net/wireless/mediatek/mt76/mac80211.c |  3 +-
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  7 ++
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  5 +-
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 44 ++++++++++-
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  6 +-
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 73 +++++++++----------
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  | 12 ++-
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |  6 +-
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  | 15 +---
 9 files changed, 100 insertions(+), 71 deletions(-)

-- 
2.19.2

