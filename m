Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 689B5C282DE
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 406C32133D
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbfDILh0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 07:37:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52164 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfDILhZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 07:37:25 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 62D777D7CC;
        Tue,  9 Apr 2019 11:37:25 +0000 (UTC)
Received: from localhost (ovpn-204-224.brq.redhat.com [10.40.204.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 000105D71E;
        Tue,  9 Apr 2019 11:37:24 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>,
        Gabor Juhos <juhosg@openwrt.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 02/21] rt2x00: rt2800lib: add rf_vals for RF3853
Date:   Tue,  9 Apr 2019 13:36:49 +0200
Message-Id: <1554809828-13500-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
References: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 09 Apr 2019 11:37:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800.h    |  4 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 65 ++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800.h b/drivers/net/wireless/ralink/rt2x00/rt2800.h
index b05ed2f3025a..ddd4b0be04ee 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800.h
@@ -48,7 +48,8 @@
  * RF2853 2.4G/5G 3T3R
  * RF3320 2.4G 1T1R(RT3350/RT3370/RT3390)
  * RF3322 2.4G 2T2R(RT3352/RT3371/RT3372/RT3391/RT3392)
- * RF3053 2.4G/5G 3T3R(RT3883/RT3563/RT3573/RT3593/RT3662)
+ * RF3053 2.4G/5G 3T3R(RT3563/RT3573/RT3593)
+ * RF3853 2.4G/5G 3T3R(RT3883/RT3662)
  * RF5592 2.4G/5G 2T2R
  * RF3070 2.4G 1T1R
  * RF5360 2.4G 1T1R
@@ -72,6 +73,7 @@
 #define RF5592				0x000f
 #define RF3070				0x3070
 #define RF3290				0x3290
+#define RF3853				0x3853
 #define RF5350				0x5350
 #define RF5360				0x5360
 #define RF5362				0x5362
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 071465854a45..8f6702f24cd4 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -9146,6 +9146,66 @@ static const struct rf_channel rf_vals_3x_xtal20[] = {
 	{14,   0xF0,	 2,  0x18},
 };
 
+static const struct rf_channel rf_vals_3853[] = {
+	{1,  241, 6, 2},
+	{2,  241, 6, 7},
+	{3,  242, 6, 2},
+	{4,  242, 6, 7},
+	{5,  243, 6, 2},
+	{6,  243, 6, 7},
+	{7,  244, 6, 2},
+	{8,  244, 6, 7},
+	{9,  245, 6, 2},
+	{10, 245, 6, 7},
+	{11, 246, 6, 2},
+	{12, 246, 6, 7},
+	{13, 247, 6, 2},
+	{14, 248, 6, 4},
+
+	{36, 0x56, 8, 4},
+	{38, 0x56, 8, 6},
+	{40, 0x56, 8, 8},
+	{44, 0x57, 8, 0},
+	{46, 0x57, 8, 2},
+	{48, 0x57, 8, 4},
+	{52, 0x57, 8, 8},
+	{54, 0x57, 8, 10},
+	{56, 0x58, 8, 0},
+	{60, 0x58, 8, 4},
+	{62, 0x58, 8, 6},
+	{64, 0x58, 8, 8},
+
+	{100, 0x5b, 8, 8},
+	{102, 0x5b, 8, 10},
+	{104, 0x5c, 8, 0},
+	{108, 0x5c, 8, 4},
+	{110, 0x5c, 8, 6},
+	{112, 0x5c, 8, 8},
+	{114, 0x5c, 8, 10},
+	{116, 0x5d, 8, 0},
+	{118, 0x5d, 8, 2},
+	{120, 0x5d, 8, 4},
+	{124, 0x5d, 8, 8},
+	{126, 0x5d, 8, 10},
+	{128, 0x5e, 8, 0},
+	{132, 0x5e, 8, 4},
+	{134, 0x5e, 8, 6},
+	{136, 0x5e, 8, 8},
+	{140, 0x5f, 8, 0},
+
+	{149, 0x5f, 8, 9},
+	{151, 0x5f, 8, 11},
+	{153, 0x60, 8, 1},
+	{157, 0x60, 8, 5},
+	{159, 0x60, 8, 7},
+	{161, 0x60, 8, 9},
+	{165, 0x61, 8, 1},
+	{167, 0x61, 8, 3},
+	{169, 0x61, 8, 5},
+	{171, 0x61, 8, 7},
+	{173, 0x61, 8, 9},
+};
+
 static const struct rf_channel rf_vals_5592_xtal20[] = {
 	/* Channel, N, K, mod, R */
 	{1, 482, 4, 10, 3},
@@ -9409,6 +9469,11 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		spec->channels = rf_vals_3x;
 		break;
 
+	case RF3853:
+		spec->num_channels = ARRAY_SIZE(rf_vals_3853);
+		spec->channels = rf_vals_3853;
+		break;
+
 	case RF5592:
 		reg = rt2800_register_read(rt2x00dev, MAC_DEBUG_INDEX);
 		if (rt2x00_get_field32(reg, MAC_DEBUG_INDEX_XTAL)) {
-- 
2.7.5

