Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f46.google.com ([209.85.221.46]:42402 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728547AbeIQWBN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Sep 2018 18:01:13 -0400
Received: by mail-wr1-f46.google.com with SMTP id v17-v6so17988926wrr.9
        for <linux-wireless@vger.kernel.org>; Mon, 17 Sep 2018 09:33:05 -0700 (PDT)
Received: from localhost.localdomain ([31.147.208.18])
        by smtp.googlemail.com with ESMTPSA id c3-v6sm17807307wrm.56.2018.09.17.09.33.03
        for <linux-wireless@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Mon, 17 Sep 2018 09:33:04 -0700 (PDT)
From: =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/5] rt2x00: remove unneeded check
Date: Mon, 17 Sep 2018 18:32:53 +0200
Message-Id: <1537201975-3032-3-git-send-email-pozega.tomislav@gmail.com> (sfid-20180917_183318_867915_03D11272)
In-Reply-To: <1537201975-3032-1-git-send-email-pozega.tomislav@gmail.com>
References: <1537201975-3032-1-git-send-email-pozega.tomislav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove band check from rf53xx channel config routine since all chips
using it are single band.

Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |  103 ++++++++++++------------
 1 files changed, 50 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 5546bd8..a47bbb6 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -2809,6 +2809,7 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 					 struct rf_channel *rf,
 					 struct channel_info *info)
 {
+	int idx = rf->channel-1;
 	u8 rfcsr;
 
 	rt2800_rfcsr_write(rt2x00dev, 8, rf->rf1);
@@ -2847,60 +2848,56 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 
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
1.7.0.4
