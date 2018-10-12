Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B5FDC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 08:56:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5FEA20835
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 08:56:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5FEA20835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbeJLQ2F (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 12:28:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36894 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727705AbeJLQ2F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 12:28:05 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A5A96307D986;
        Fri, 12 Oct 2018 08:56:40 +0000 (UTC)
Received: from localhost (unknown [10.40.205.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3970484951;
        Fri, 12 Oct 2018 08:56:39 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
Subject: [PATCH v4 4/8] rt2800: fix registers init for MT7620
Date:   Fri, 12 Oct 2018 10:56:27 +0200
Message-Id: <1539334591-9965-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1539334591-9965-1-git-send-email-sgruszka@redhat.com>
References: <1539334591-9965-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 12 Oct 2018 08:56:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There is duplicated 'if (rt2x00_rt(rt2x00dev, RT6352))' entry that
causes we do not perform register initialization for RT6352 (MT7620
SOCs) in correct branch. Fix this and disable registers initialization
that is specific to particular MT7620 revision.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index daf20d7424ac..16d6d99b1d44 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -5451,8 +5451,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 					      0x00000000);
 		}
 	} else if (rt2x00_rt(rt2x00dev, RT5390) ||
-		   rt2x00_rt(rt2x00dev, RT5392) ||
-		   rt2x00_rt(rt2x00dev, RT6352)) {
+		   rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
@@ -5466,6 +5465,10 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000401);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x000C0000);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x000C0408);
+		/* TODO add chip version support and init registers
+		 * according to the version.
+		 */
+#if 0
 		rt2800_register_write(rt2x00dev, MIMO_PS_CFG, 0x00000002);
 		rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0x00150F0F);
 		rt2800_register_write(rt2x00dev, TX_ALC_VGA3, 0x06060606);
@@ -5480,6 +5483,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		reg = rt2800_register_read(rt2x00dev, TX_ALC_CFG_1);
 		rt2x00_set_field32(&reg, TX_ALC_CFG_1_ROS_BUSY_EN, 0);
 		rt2800_register_write(rt2x00dev, TX_ALC_CFG_1, reg);
+#endif
 	} else {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000000);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
-- 
2.7.5

