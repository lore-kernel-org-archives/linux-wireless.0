Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94878C64EAD
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 11:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56CDA214C5
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 11:56:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56CDA214C5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbeJITMs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 15:12:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36000 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbeJITMs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 15:12:48 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E4A9B3086249;
        Tue,  9 Oct 2018 11:56:11 +0000 (UTC)
Received: from localhost (unknown [10.40.205.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA43A6B481;
        Tue,  9 Oct 2018 11:56:10 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
Subject: [PATCH v3 1/4] rt2x00: remove unneeded check
Date:   Tue,  9 Oct 2018 13:56:07 +0200
Message-Id: <1539086170-32528-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 09 Oct 2018 11:56:12 +0000 (UTC)
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
v2 -> v3:
- fix wrongly applied hung during rebase
- add SoB

 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 103 ++++++++++++-------------
 1 file changed, 50 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 9e7b8933d30c..1a2bf6c49b82 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -2963,6 +2963,7 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 					 struct rf_channel *rf,
 					 struct channel_info *info)
 {
+	int idx = rf->channel-1;
 	u8 rfcsr;
 
 	rt2800_rfcsr_write(rt2x00dev, 8, rf->rf1);
@@ -3001,60 +3002,56 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 
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

