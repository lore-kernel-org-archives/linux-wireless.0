Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85108C4360F
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 09:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5332D2070B
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 09:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732789AbfC0J6h (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 05:58:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42894 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731904AbfC0J6h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 05:58:37 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 35A00301988A;
        Wed, 27 Mar 2019 09:58:37 +0000 (UTC)
Received: from localhost (unknown [10.40.205.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BDA025D6B3;
        Wed, 27 Mar 2019 09:58:36 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: [PATCH 2/8] rt2800: new flush implementation for SoC devices
Date:   Wed, 27 Mar 2019 10:58:25 +0100
Message-Id: <1553680711-15730-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1553680711-15730-1-git-send-email-sgruszka@redhat.com>
References: <1553680711-15730-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 27 Mar 2019 09:58:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use new flush_queue() callback for SoC devices, what was already done for
PCIe devices.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800soc.c b/drivers/net/wireless/ralink/rt2x00/rt2800soc.c
index a502816214ab..05a801774713 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800soc.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800soc.c
@@ -203,7 +203,7 @@ static const struct rt2x00lib_ops rt2800soc_rt2x00_ops = {
 	.start_queue		= rt2800mmio_start_queue,
 	.kick_queue		= rt2800mmio_kick_queue,
 	.stop_queue		= rt2800mmio_stop_queue,
-	.flush_queue		= rt2x00mmio_flush_queue,
+	.flush_queue		= rt2800mmio_flush_queue,
 	.write_tx_desc		= rt2800mmio_write_tx_desc,
 	.write_tx_data		= rt2800_write_tx_data,
 	.write_beacon		= rt2800_write_beacon,
-- 
2.7.5

