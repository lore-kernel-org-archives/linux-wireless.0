Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A616C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 08:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B36521580
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 08:37:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B36521580
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbeI0Oyk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 10:54:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60755 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbeI0Oyk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 10:54:40 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E5E7C8830C;
        Thu, 27 Sep 2018 08:37:34 +0000 (UTC)
Received: from localhost (unknown [10.43.2.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABD792270C;
        Thu, 27 Sep 2018 08:37:32 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [RFC 0/4] mt76x0: phy/rf fixups for PCIe
Date:   Thu, 27 Sep 2018 10:37:26 +0200
Message-Id: <1538037450-18949-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 27 Sep 2018 08:37:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is RFC for now, especially I'm interesting if patch 3 and 4
is direction we should go.

This is on top of Lorenzo github mt7610ev5 branch. 

Stanislaw Gruszka (4):
  mt76x0: print BBP version only for debug
  mt76x0: correct RF access via RF_CSR regiser.
  mt76: allow to identify bus
  mt76x0: correct RF reg pairs write for PCIe

 drivers/net/wireless/mediatek/mt76/mmio.c         |  1 +
 drivers/net/wireless/mediatek/mt76/mt76.h         |  9 ++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c   | 27 ++++++++++++++++-------
 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h |  4 ++--
 drivers/net/wireless/mediatek/mt76/usb.c          |  1 +
 5 files changed, 32 insertions(+), 10 deletions(-)

-- 
1.9.3

