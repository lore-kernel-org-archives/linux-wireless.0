Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D4DC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9356E2147C
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfCLPGQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:06:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55866 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726931AbfCLPGO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 11:06:14 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4E77730820E4;
        Tue, 12 Mar 2019 15:06:14 +0000 (UTC)
Received: from localhost (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B5C45D71A;
        Tue, 12 Mar 2019 15:06:10 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC 00/12] mt76usb: some cleanups and optimizations
Date:   Tue, 12 Mar 2019 16:05:54 +0100
Message-Id: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 12 Mar 2019 15:06:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This should be rebased on latest patches, for now sent as RFC.

Significant change is remove mt76u_buf and use urb directly
and allocate urb and sg as linear data for better cache usage.
Other that that, set consist only of some minor cleanups.

Stanislaw Gruszka (12):
  mt76usb: change mt76u_submit_buf
  mt76: remove rx_page_lock
  mt76usb: change mt76u_fill_rx_sg arguments
  mt76usb: use usb_dev private data
  mt76usb: remove mt76u_buf redundant fileds
  mt76usb: move mt76u_buf->done to queue entry
  mt76usb: remove mt76u_buf and use urb directly
  mt76usb: remove MT_RXQ_MAIN queue from mt76u_urb_alloc
  mt76usb: resue mt76u_urb_alloc for tx
  mt76usb: remove unneded sg_init_table
  mt76usb: allocate urb and sg as linear data
  mt76usb: remove queue variable from rx_tasklet

 drivers/net/wireless/mediatek/mt76/mt76.h       |  15 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c |   4 +-
 drivers/net/wireless/mediatek/mt76/usb.c        | 231 +++++++++++-------------
 4 files changed, 111 insertions(+), 141 deletions(-)

-- 
1.9.3

