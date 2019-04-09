Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 277F8C10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC48620857
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfDILh1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 07:37:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48992 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfDILh0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 07:37:26 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D5AA9308FE95;
        Tue,  9 Apr 2019 11:37:26 +0000 (UTC)
Received: from localhost (ovpn-204-224.brq.redhat.com [10.40.204.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 758875D9D3;
        Tue,  9 Apr 2019 11:37:26 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>,
        Gabor Juhos <juhosg@openwrt.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 03/21] rt2x00: rt2800lib: enable VCO calibration for RF3853
Date:   Tue,  9 Apr 2019 13:36:50 +0200
Message-Id: <1554809828-13500-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
References: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 09 Apr 2019 11:37:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 8f6702f24cd4..7e0b2a9631fc 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -5043,6 +5043,7 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
 	case RF3053:
 	case RF3070:
 	case RF3290:
+	case RF3853:
 	case RF5350:
 	case RF5360:
 	case RF5362:
@@ -9593,6 +9594,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	case RF3053:
 	case RF3070:
 	case RF3290:
+	case RF3853:
 	case RF5350:
 	case RF5360:
 	case RF5362:
-- 
2.7.5

