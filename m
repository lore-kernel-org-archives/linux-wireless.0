Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 644FEC64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 10:05:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3761C20652
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 10:05:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3761C20652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbeJDQ5c (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 12:57:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42966 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727569AbeJDQ5c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 12:57:32 -0400
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.25])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E0D90659A3;
        Thu,  4 Oct 2018 10:05:00 +0000 (UTC)
Received: from localhost (unknown [10.43.2.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 854842010D5C;
        Thu,  4 Oct 2018 10:04:57 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 0/5] mt76x0: phy/rf fixups for PCIe
Date:   Thu,  4 Oct 2018 12:04:50 +0200
Message-Id: <1538647495-15213-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.25
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 04 Oct 2018 10:05:00 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Changes since RFC:
- regbase on top of mt76x02_dev change
- add patch to choose single reg RF access via mt76_is_usb()

Stanislaw Gruszka (5):
  mt76x0: print BBP version only for debug
  mt76x0: correct RF access via RF_CSR regiser.
  mt76: allow to identify bus
  mt76x0: correct RF reg pairs write for PCIe
  mt76x0: use bus helper to identify rf access method

 drivers/net/wireless/mediatek/mt76/mmio.c         |  1 +
 drivers/net/wireless/mediatek/mt76/mt76.h         |  9 ++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c   | 35 ++++++++++++++++-------
 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h |  4 +--
 drivers/net/wireless/mediatek/mt76/usb.c          |  1 +
 5 files changed, 38 insertions(+), 12 deletions(-)

-- 
1.9.3

