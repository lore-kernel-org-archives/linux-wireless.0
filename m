Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E6FC282CE
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CFF320857
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfDILhg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 07:37:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47116 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfDILhg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 07:37:36 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D8D9E30944E3;
        Tue,  9 Apr 2019 11:37:35 +0000 (UTC)
Received: from localhost (ovpn-204-224.brq.redhat.com [10.40.204.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 756DF17B56;
        Tue,  9 Apr 2019 11:37:35 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>,
        Gabor Juhos <juhosg@openwrt.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 08/21] rt2x00: rt2800lib: add BBP register initialization for RT3883
Date:   Tue,  9 Apr 2019 13:36:55 +0200
Message-Id: <1554809828-13500-9-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
References: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 09 Apr 2019 11:37:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 44 ++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 671b4fec4144..c6a3e02cd6dd 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -6511,6 +6511,47 @@ static void rt2800_init_bbp_3593(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 }
 
+static void rt2800_init_bbp_3883(struct rt2x00_dev *rt2x00dev)
+{
+	rt2800_init_bbp_early(rt2x00dev);
+
+	rt2800_bbp_write(rt2x00dev, 4, 0x50);
+	rt2800_bbp_write(rt2x00dev, 47, 0x48);
+
+	rt2800_bbp_write(rt2x00dev, 86, 0x46);
+	rt2800_bbp_write(rt2x00dev, 88, 0x90);
+
+	rt2800_bbp_write(rt2x00dev, 92, 0x02);
+
+	rt2800_bbp_write(rt2x00dev, 103, 0xc0);
+	rt2800_bbp_write(rt2x00dev, 104, 0x92);
+	rt2800_bbp_write(rt2x00dev, 105, 0x34);
+	rt2800_bbp_write(rt2x00dev, 106, 0x12);
+	rt2800_bbp_write(rt2x00dev, 120, 0x50);
+	rt2800_bbp_write(rt2x00dev, 137, 0x0f);
+	rt2800_bbp_write(rt2x00dev, 163, 0x9d);
+
+	/* Set ITxBF timeout to 0x9C40=1000msec */
+	rt2800_bbp_write(rt2x00dev, 179, 0x02);
+	rt2800_bbp_write(rt2x00dev, 180, 0x00);
+	rt2800_bbp_write(rt2x00dev, 182, 0x40);
+	rt2800_bbp_write(rt2x00dev, 180, 0x01);
+	rt2800_bbp_write(rt2x00dev, 182, 0x9c);
+
+	rt2800_bbp_write(rt2x00dev, 179, 0x00);
+
+	/* Reprogram the inband interface to put right values in RXWI */
+	rt2800_bbp_write(rt2x00dev, 142, 0x04);
+	rt2800_bbp_write(rt2x00dev, 143, 0x3b);
+	rt2800_bbp_write(rt2x00dev, 142, 0x06);
+	rt2800_bbp_write(rt2x00dev, 143, 0xa0);
+	rt2800_bbp_write(rt2x00dev, 142, 0x07);
+	rt2800_bbp_write(rt2x00dev, 143, 0xa1);
+	rt2800_bbp_write(rt2x00dev, 142, 0x08);
+	rt2800_bbp_write(rt2x00dev, 143, 0xa2);
+	rt2800_bbp_write(rt2x00dev, 148, 0xc8);
+}
+
 static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 {
 	int ant, div_mode;
@@ -6955,6 +6996,9 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	case RT3593:
 		rt2800_init_bbp_3593(rt2x00dev);
 		return;
+	case RT3883:
+		rt2800_init_bbp_3883(rt2x00dev);
+		return;
 	case RT5390:
 	case RT5392:
 		rt2800_init_bbp_53xx(rt2x00dev);
-- 
2.7.5

