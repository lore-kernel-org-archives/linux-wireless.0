Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:52381 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934334Ab3DIPEu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 11:04:50 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 05/11] rt2800: move GPIO_SWITCH setup to 3390 specific rfcsr init
Date: Tue,  9 Apr 2013 17:05:24 +0200
Message-Id: <1365519930-3230-6-git-send-email-stf_xl@wp.pl> (sfid-20130409_170454_327188_EAFCC0F3)
In-Reply-To: <1365519930-3230-1-git-send-email-stf_xl@wp.pl>
References: <1365519930-3230-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 216ceb6..83554da 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4668,6 +4668,8 @@ static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
 {
+	u32 reg;
+
 	rt2800_rfcsr_write(rt2x00dev, 0, 0xa0);
 	rt2800_rfcsr_write(rt2x00dev, 1, 0xe1);
 	rt2800_rfcsr_write(rt2x00dev, 2, 0xf1);
@@ -4700,6 +4702,10 @@ static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 29, 0x8f);
 	rt2800_rfcsr_write(rt2x00dev, 30, 0x20);
 	rt2800_rfcsr_write(rt2x00dev, 31, 0x0f);
+
+	rt2800_register_read(rt2x00dev, GPIO_SWITCH, &reg);
+	rt2x00_set_field32(&reg, GPIO_SWITCH_5, 0);
+	rt2800_register_write(rt2x00dev, GPIO_SWITCH, reg);
 }
 
 static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
@@ -4985,11 +4991,7 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	}
 
 
-	if (rt2x00_rt(rt2x00dev, RT3390)) {
-		rt2800_register_read(rt2x00dev, GPIO_SWITCH, &reg);
-		rt2x00_set_field32(&reg, GPIO_SWITCH_5, 0);
-		rt2800_register_write(rt2x00dev, GPIO_SWITCH, reg);
-	} else if (rt2x00_rt(rt2x00dev, RT3572)) {
+	if (rt2x00_rt(rt2x00dev, RT3572)) {
 		rt2800_rfcsr_read(rt2x00dev, 6, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR6_R2, 1);
 		rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
-- 
1.7.4.4

