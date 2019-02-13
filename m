Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D776C282C2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 10:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 059D0207E0
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 10:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388063AbfBMKJU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 05:09:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51278 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727580AbfBMKJU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 05:09:20 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8D71381F01;
        Wed, 13 Feb 2019 10:09:19 +0000 (UTC)
Received: from localhost (unknown [10.40.205.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2054B5C219;
        Wed, 13 Feb 2019 10:09:18 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: [PATCH v5 1/5] rt2x00: remove unneeded check
Date:   Wed, 13 Feb 2019 11:09:12 +0100
Message-Id: <1550052556-7158-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1550052556-7158-1-git-send-email-sgruszka@redhat.com>
References: <1550052556-7158-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 13 Feb 2019 10:09:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Tomislav Požega <pozega.tomislav@gmail.com>

Remove band check from rf53xx channel config routine since all chips
using it are single band.

Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 103 ++++++++++++-------------
 1 file changed, 50 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 7f813f6f8792..0165e274a884 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -2966,6 +2966,7 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 					 struct channel_info *info)
 {
 	u8 rfcsr;
+	int idx = rf->channel-1;
 
 	rt2800_rfcsr_write(rt2x00dev, 8, rf->rf1);
 	rt2800_rfcsr_write(rt2x00dev, 9, rf->rf3);
@@ -3003,60 +3004,56 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 
 	rt2800_freq_cal_mode1(rt2x00dev);
 
-	if (rf->channel <= 14) {
-		int idx = rf->channel-1;
-
-		if (rt2x00_has_cap_bt_coexist(rt2x00dev)) {
-			if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F)) {
-				/* r55/r59 value array of channel 1~14 */
-				static const char r55_bt_rev[] = {0x83, 0x83,
-					0x83, 0x73, 0x73, 0x63, 0x53, 0x53,
-					0x53, 0x43, 0x43, 0x43, 0x43, 0x43};
-				static const char r59_bt_rev[] = {0x0e, 0x0e,
-					0x0e, 0x0e, 0x0e, 0x0b, 0x0a, 0x09,
-					0x07, 0x07, 0x07, 0x07, 0x07, 0x07};
-
-				rt2800_rfcsr_write(rt2x00dev, 55,
-						   r55_bt_rev[idx]);
-				rt2800_rfcsr_write(rt2x00dev, 59,
-						   r59_bt_rev[idx]);
-			} else {
-				static const char r59_bt[] = {0x8b, 0x8b, 0x8b,
-					0x8b, 0x8b, 0x8b, 0x8b, 0x8a, 0x89,
-					0x88, 0x88, 0x86, 0x85, 0x84};
-
-				rt2800_rfcsr_write(rt2x00dev, 59, r59_bt[idx]);
-			}
+	if (rt2x00_has_cap_bt_coexist(rt2x00dev)) {
+		if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F)) {
+			/* r55/r59 value array of channel 1~14 */
+			static const char r55_bt_rev[] = {0x83, 0x83,
+				0x83, 0x73, 0x73, 0x63, 0x53, 0x53,
+				0x53, 0x43, 0x43, 0x43, 0x43, 0x43};
+			static const char r59_bt_rev[] = {0x0e, 0x0e,
+				0x0e, 0x0e, 0x0e, 0x0b, 0x0a, 0x09,
+				0x07, 0x07, 0x07, 0x07, 0x07, 0x07};
+
+			rt2800_rfcsr_write(rt2x00dev, 55,
+					   r55_bt_rev[idx]);
+			rt2800_rfcsr_write(rt2x00dev, 59,
+					   r59_bt_rev[idx]);
 		} else {
-			if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F)) {
-				static const char r55_nonbt_rev[] = {0x23, 0x23,
-					0x23, 0x23, 0x13, 0x13, 0x03, 0x03,
-					0x03, 0x03, 0x03, 0x03, 0x03, 0x03};
-				static const char r59_nonbt_rev[] = {0x07, 0x07,
-					0x07, 0x07, 0x07, 0x07, 0x07, 0x07,
-					0x07, 0x07, 0x06, 0x05, 0x04, 0x04};
-
-				rt2800_rfcsr_write(rt2x00dev, 55,
-						   r55_nonbt_rev[idx]);
-				rt2800_rfcsr_write(rt2x00dev, 59,
-						   r59_nonbt_rev[idx]);
-			} else if (rt2x00_rt(rt2x00dev, RT5390) ||
-				   rt2x00_rt(rt2x00dev, RT5392) ||
-				   rt2x00_rt(rt2x00dev, RT6352)) {
-				static const char r59_non_bt[] = {0x8f, 0x8f,
-					0x8f, 0x8f, 0x8f, 0x8f, 0x8f, 0x8d,
-					0x8a, 0x88, 0x88, 0x87, 0x87, 0x86};
-
-				rt2800_rfcsr_write(rt2x00dev, 59,
-						   r59_non_bt[idx]);
-			} else if (rt2x00_rt(rt2x00dev, RT5350)) {
-				static const char r59_non_bt[] = {0x0b, 0x0b,
-					0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0a,
-					0x0a, 0x09, 0x08, 0x07, 0x07, 0x06};
-
-				rt2800_rfcsr_write(rt2x00dev, 59,
-						   r59_non_bt[idx]);
-			}
+			static const char r59_bt[] = {0x8b, 0x8b, 0x8b,
+				0x8b, 0x8b, 0x8b, 0x8b, 0x8a, 0x89,
+				0x88, 0x88, 0x86, 0x85, 0x84};
+
+			rt2800_rfcsr_write(rt2x00dev, 59, r59_bt[idx]);
+		}
+	} else {
+		if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F)) {
+			static const char r55_nonbt_rev[] = {0x23, 0x23,
+				0x23, 0x23, 0x13, 0x13, 0x03, 0x03,
+				0x03, 0x03, 0x03, 0x03, 0x03, 0x03};
+			static const char r59_nonbt_rev[] = {0x07, 0x07,
+				0x07, 0x07, 0x07, 0x07, 0x07, 0x07,
+				0x07, 0x07, 0x06, 0x05, 0x04, 0x04};
+
+			rt2800_rfcsr_write(rt2x00dev, 55,
+					   r55_nonbt_rev[idx]);
+			rt2800_rfcsr_write(rt2x00dev, 59,
+					   r59_nonbt_rev[idx]);
+		} else if (rt2x00_rt(rt2x00dev, RT5390) ||
+			   rt2x00_rt(rt2x00dev, RT5392) ||
+			   rt2x00_rt(rt2x00dev, RT6352)) {
+			static const char r59_non_bt[] = {0x8f, 0x8f,
+				0x8f, 0x8f, 0x8f, 0x8f, 0x8f, 0x8d,
+				0x8a, 0x88, 0x88, 0x87, 0x87, 0x86};
+
+			rt2800_rfcsr_write(rt2x00dev, 59,
+					   r59_non_bt[idx]);
+		} else if (rt2x00_rt(rt2x00dev, RT5350)) {
+			static const char r59_non_bt[] = {0x0b, 0x0b,
+				0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0a,
+				0x0a, 0x09, 0x08, 0x07, 0x07, 0x06};
+
+			rt2800_rfcsr_write(rt2x00dev, 59,
+					   r59_non_bt[idx]);
 		}
 	}
 }
-- 
2.7.5

