Return-Path: <SRS0=BTs8=U7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03053C06510
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Jul 2019 15:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D51102146F
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Jul 2019 15:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbfGBPGM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Jul 2019 11:06:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44740 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbfGBPGM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Jul 2019 11:06:12 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0588B3091740;
        Tue,  2 Jul 2019 15:06:07 +0000 (UTC)
Received: from localhost (unknown [10.43.2.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CBC65C29A;
        Tue,  2 Jul 2019 15:06:06 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 0/3] mt76: usb: alignment and endianes improvements
Date:   Tue,  2 Jul 2019 17:05:58 +0200
Message-Id: <1562079961-15527-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Tue, 02 Jul 2019 15:06:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix endian bug and do some minor optimizations in mt76u_{copy,rr,wr} .

I do not mark cc stable endian fix as noboby reported this issue,
i.e. use the driver on big endian machine, but make it a separate patch,
so it can be backported if needed.

This is on top of:
[PATCH] mt76: round up length on mt76_wr_copy 

Stanislaw Gruszka (3):
  mt76: usb: fix endian in mt76u_copy
  mt76: usb: remove unneeded {put,get}_unaligned
  mt76: usb: use full intermediate buffer in mt76u_copy

 drivers/net/wireless/mediatek/mt76/mt76.h |  5 ++++-
 drivers/net/wireless/mediatek/mt76/usb.c  | 27 ++++++++++++++++-----------
 2 files changed, 20 insertions(+), 12 deletions(-)

-- 
1.9.3

