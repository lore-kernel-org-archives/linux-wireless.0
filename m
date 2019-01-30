Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5600EC282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 16:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 281EC207E0
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 16:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731682AbfA3QCV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 11:02:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40458 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731234AbfA3QCV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 11:02:21 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EC888C056796;
        Wed, 30 Jan 2019 16:02:20 +0000 (UTC)
Received: from localhost (ovpn-204-66.brq.redhat.com [10.40.204.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CFBD1001F59;
        Wed, 30 Jan 2019 16:02:20 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH v3 0/7] mt76x02: Beacon support for USB
Date:   Wed, 30 Jan 2019 17:02:12 +0100
Message-Id: <1548864139-27729-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 30 Jan 2019 16:02:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

We can configure beaconing, but without TBTT interrupt we
can not support PS buffering. This can be added later using
kernel hrtimer, if we can keep it in sync with device timer.

I tested AP and IBSS modes.

Stanislaw Gruszka (7):
  mt76x02: use mask for vifs
  mt76x02: use commmon add interface for mt76x2u
  mt76x02: initialize mutli bss mode when set up address
  mt76x02: minor beaconing init changes
  mt76x02: init beacon config for mt76x2u
  mt76: beaconing fixes for USB
  mt76x02: enable support for IBSS and MESH

 drivers/net/wireless/mediatek/mt76/mac80211.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  5 +-
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 44 ++++++++++-
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  6 +-
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 77 ++++++++++---------
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  4 +-
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |  6 +-
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  | 15 +---
 8 files changed, 90 insertions(+), 69 deletions(-)

-- 
2.19.2

