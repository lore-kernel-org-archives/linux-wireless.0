Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41935C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 15:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04E7F2077C
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 15:46:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04E7F2077C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbeJJXJK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 19:09:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54662 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbeJJXJK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 19:09:10 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 165938A004;
        Wed, 10 Oct 2018 15:46:26 +0000 (UTC)
Received: from localhost (ovpn-204-35.brq.redhat.com [10.40.204.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6A9417ADD;
        Wed, 10 Oct 2018 15:46:25 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
Subject: [PATCH 3/4] rt2800: remove unneeded RT6352 check
Date:   Wed, 10 Oct 2018 17:46:19 +0200
Message-Id: <1539186380-31949-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1539186380-31949-1-git-send-email-sgruszka@redhat.com>
References: <1539186380-31949-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 10 Oct 2018 15:46:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove rt2x00_rt(rt2x00dev, RT6352)) check from
rt2800_config_channel_rf53xx() which is not called for RT6352 devices.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index acbd9d4a8a3a..a2cdd3a5034a 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -3037,8 +3037,7 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 			rt2800_rfcsr_write(rt2x00dev, 59,
 					   r59_nonbt_rev[idx]);
 		} else if (rt2x00_rt(rt2x00dev, RT5390) ||
-			   rt2x00_rt(rt2x00dev, RT5392) ||
-			   rt2x00_rt(rt2x00dev, RT6352)) {
+			   rt2x00_rt(rt2x00dev, RT5392)) {
 			static const char r59_non_bt[] = {0x8f, 0x8f,
 				0x8f, 0x8f, 0x8f, 0x8f, 0x8f, 0x8d,
 				0x8a, 0x88, 0x88, 0x87, 0x87, 0x86};
-- 
2.7.5

