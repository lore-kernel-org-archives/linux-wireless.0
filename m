Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9796BC677E5
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 11:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60A66214D5
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 11:01:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60A66214D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbeJISRg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 14:17:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36148 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbeJISRf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 14:17:35 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3F2853084028;
        Tue,  9 Oct 2018 11:01:12 +0000 (UTC)
Received: from localhost (unknown [10.40.205.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2BCF694DD;
        Tue,  9 Oct 2018 11:01:11 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
Subject: [PATCH v2 3/4] rt2x00: update TX_SW_CFG2 value
Date:   Tue,  9 Oct 2018 13:01:06 +0200
Message-Id: <1539082867-4264-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1539082867-4264-1-git-send-email-sgruszka@redhat.com>
References: <1539082867-4264-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 09 Oct 2018 11:01:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Tomislav Požega <pozega.tomislav@gmail.com>

Use default value of TX_SW_CFG2 register that is in charge
of LNA timings. Works for somewhat higher RX throughput.

Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 463c9117ba06..3d5c78f11ee5 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -5465,7 +5465,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	} else if (rt2x00_rt(rt2x00dev, RT6352)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000401);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x000C0000);
-		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x000C0408);
 		rt2800_register_write(rt2x00dev, MIMO_PS_CFG, 0x00000002);
 		rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0x00150F0F);
 		rt2800_register_write(rt2x00dev, TX_ALC_VGA3, 0x06060606);
-- 
2.7.5

