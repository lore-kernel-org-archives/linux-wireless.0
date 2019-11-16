Return-Path: <SRS0=oU4Q=ZI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A926C43141
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Nov 2019 11:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F03B220728
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Nov 2019 11:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfKPLS1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Nov 2019 06:18:27 -0500
Received: from smail.rz.tu-ilmenau.de ([141.24.186.67]:59104 "EHLO
        smail.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbfKPLS0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Nov 2019 06:18:26 -0500
Received: from isengard.fritz.box (unknown [87.147.48.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smail.rz.tu-ilmenau.de (Postfix) with ESMTPSA id 9683158007B;
        Sat, 16 Nov 2019 12:18:24 +0100 (CET)
From:   Markus Theil <markus.theil@tu-ilmenau.de>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Markus Theil <markus.theil@tu-ilmenau.de>
Subject: [PATCH 0/4] mt76: channel switch support for USB devices
Date:   Sat, 16 Nov 2019 12:17:05 +0100
Message-Id: <20191116111709.4686-1-markus.theil@tu-ilmenau.de>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch series adds channel switch support for mt76 usb interfaces.
When testing, I noticed that between 5 or 7 consecutive beacons had the
identical channel switch count set. After some debugging I found out,
that beacon copying over usb took far too long (up to 700ms for one call
of mt76x02u_pre_tbtt_work).

Therefore the first three patches speed up beacon copying and the last
patch enables channel switch support also for usb interfaces.

Markus Theil (4):
  mt76: mt76x02: ommit beacon slot clearing
  mt76: mt76x02: split beaconing
  mt76: speed up usb bulk copy
  mt76: mt76x02: add channel switch support for usb interfaces

 drivers/net/wireless/mediatek/mt76/mt76.h     |  2 +-
 .../wireless/mediatek/mt76/mt76x02_beacon.c   | 62 +++++++------------
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  2 +
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c |  4 ++
 .../wireless/mediatek/mt76/mt76x02_usb_core.c | 11 ++++
 .../net/wireless/mediatek/mt76/mt76x02_util.c |  2 +-
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  |  5 ++
 drivers/net/wireless/mediatek/mt76/usb.c      | 22 +++++--
 8 files changed, 63 insertions(+), 47 deletions(-)

--
2.24.0

