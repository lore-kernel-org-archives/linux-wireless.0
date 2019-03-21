Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D851C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 15:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F285F21874
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 15:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbfCUPZt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:25:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57926 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfCUPZt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 11:25:49 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E81583099FC9;
        Thu, 21 Mar 2019 15:25:48 +0000 (UTC)
Received: from localhost (ovpn-204-211.brq.redhat.com [10.40.204.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C687D5C21F;
        Thu, 21 Mar 2019 15:25:45 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 00/12] mt76usb: some cleanups and optimizations
Date:   Thu, 21 Mar 2019 16:25:25 +0100
Message-Id: <20190321152537.19105-1-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 21 Mar 2019 15:25:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Significant change is remove mt76u_buf and use urb directly
and allocate urb and sg as linear data for better cache usage.
Other that that, set consist only of some minor cleanups.

RFC -> v1:
- introduce mt76u_tx_setup_buffers
- calculate data_len differently
- fix *usb->sg bug on intermediate patches
- use (struct scatterlist *)(e->urb + 1) trick

Rebased on latest tree and 
[PATCH v2 00/12] mt76x02: AP support for USB with PS
https://lore.kernel.org/linux-wireless/1552991867-5087-1-git-send-email-sgruszka@redhat.com/
  
Not rebased on
[PATCH 1/6] mt76: use mac80211 txq scheduling
https://lore.kernel.org/linux-wireless/20190316204242.73560-1-nbd@nbd.name/
It easer to rebase '[PATCH 5/6] mt76: move tx tasklet to struct mt76_dev'
from that set of top of my 2 pending sets. 

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

 drivers/net/wireless/mediatek/mt76/mt76.h     |  15 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |   2 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/usb.c      | 243 ++++++++----------
 4 files changed, 118 insertions(+), 146 deletions(-)

-- 
2.20.1

