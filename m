Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58430C6783C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 08:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2036220835
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 08:56:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2036220835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbeJLQ2N (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 12:28:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36382 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727976AbeJLQ2M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 12:28:12 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 151A531524C9;
        Fri, 12 Oct 2018 08:56:48 +0000 (UTC)
Received: from localhost (unknown [10.40.205.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96CCC79597;
        Fri, 12 Oct 2018 08:56:47 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
Subject: [PATCH v4 8/8] rt2800: comment and simplify AGC init for RT6352
Date:   Fri, 12 Oct 2018 10:56:31 +0200
Message-Id: <1539334591-9965-9-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1539334591-9965-1-git-send-email-sgruszka@redhat.com>
References: <1539334591-9965-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 12 Oct 2018 08:56:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

We do not need separate lines for calculating register values.
Also add comment that value is different than in vendor driver.

Suggested-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index ba7470897f3c..29b08d63e95b 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -3986,9 +3986,12 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		rt2800_bbp_write(rt2x00dev, 195, 141);
 		rt2800_bbp_write(rt2x00dev, 196, reg);
 
-		/* AGC init */
-		reg = rf->channel <= 14 ? 0x1c : 0x24;
-		reg += 2 * rt2x00dev->lna_gain;
+		/* AGC init.
+		 * Despite the vendor driver using different values here for
+		 * RT6352 chip, we use 0x1c for now. This may have to be changed
+		 * once TSSI got implemented.
+		 */
+		reg = (rf->channel <= 14 ? 0x1c : 0x24) + 2*rt2x00dev->lna_gain;
 		rt2800_bbp_write_with_rx_chain(rt2x00dev, 66, reg);
 
 		rt2800_iq_calibrate(rt2x00dev, rf->channel);
-- 
2.7.5

