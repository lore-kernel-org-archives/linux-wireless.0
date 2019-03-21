Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42B0C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 15:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75E8121874
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 15:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbfCUP0e (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:26:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47304 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbfCUP0e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 11:26:34 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 27DD03084213;
        Thu, 21 Mar 2019 15:26:34 +0000 (UTC)
Received: from localhost (ovpn-204-211.brq.redhat.com [10.40.204.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9A1119C59;
        Thu, 21 Mar 2019 15:26:30 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 10/12] mt76usb: remove unneded sg_init_table
Date:   Thu, 21 Mar 2019 16:25:35 +0100
Message-Id: <20190321152537.19105-11-sgruszka@redhat.com>
In-Reply-To: <20190321152537.19105-1-sgruszka@redhat.com>
References: <20190321152537.19105-1-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 21 Mar 2019 15:26:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

We already allocate with GFP_ZERO and sg marker is set later for
both RX and TX.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 7cefa4fe8251..0ae69c2fedaf 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -348,8 +348,6 @@ mt76u_urb_alloc(struct mt76_dev *dev, struct mt76_queue_entry *e)
 				       sizeof(*urb->sg), GFP_KERNEL);
 		if (!urb->sg)
 			return -ENOMEM;
-
-		sg_init_table(urb->sg, MT_SG_MAX_SIZE);
 	}
 
 	return 0;
-- 
2.20.1

