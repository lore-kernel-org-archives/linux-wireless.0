Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLACK,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97965C4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 22:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A0A521B18
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 22:37:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b8CrkxQB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503419AbfBNWhG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 17:37:06 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45096 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729805AbfBNWhA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 17:37:00 -0500
Received: by mail-ot1-f67.google.com with SMTP id 32so13321800ota.12
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 14:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LzupjXb65JCyNf3+e58W7wc+MX78QjUPdaYvz+ArRfU=;
        b=b8CrkxQByQw3RRRuxYR82PZkWImi0saOZtzCruFL/6Y2BBmaNMH6aWlFmrlfLLJEbU
         Vlq2z3MGWqUDlDPwlXv3GChMp/dIhsstzKZx70EiQRSttfY3ZnJljiiGk9Btbcau8aYA
         NQcPodpSaiyVgzdJAfgGplJmJhs015FqknmT9IIz0iWO5Jcxcw8RIPGUH7utotxaWMQc
         +Y4faPGiA0G2acJLT0ZPtcZlCcQXLlV0tzq2OoP/8p/x+pVsx7Zzy/lDDVrspEP1dfJc
         xM1dE794+hK7vYmXRP3qDQRHoAS8Lo5Fp8B584xutZvdHeXymQ56vhhy4quuWtbKLmvY
         qbTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=LzupjXb65JCyNf3+e58W7wc+MX78QjUPdaYvz+ArRfU=;
        b=cbIavBR+ZSKM0Ol1eFcnkbL2CgjGzEQbRpNEIA82Xrh8/NnEMq3cQFkxPPqJwWcvl+
         bTPWart8ffZfHZxrg039r/rfqPCDoq9+baeLha0pzKaieZG1XR5QbVc3k8mlsrRhvdiW
         bxetSrONjAirFQIt4ua+UUpIt6XqHAWf5pDOiym+3oKMZAzOkMsFul1cwV8Q3tiJosSB
         LIdUyx3RLlFHvc+805DU8sswYNqmk6NUa5Hu98P2N65VVVocLWlHK2O7PyrYRNhtYaBy
         HZRAg0kPkS0iZBfJOzEbRjNOyV4EKbLtT6uQHNTpoHhdRZ8retJp6GCQY2Zzg67/6qKP
         nZmA==
X-Gm-Message-State: AHQUAuZ4kIm94mi4SG2V1fXwYZmoBmVYFnbi7SsqTj9c4f+eAKmtS/Na
        P93vsLDlWGVFbvEbLqQ5uvw=
X-Google-Smtp-Source: AHgI3IYO6r9EOhpOwm0JN0gkDak5FviT3aN1c0hRRetqNRB96exj4r5RB1zuYJAq0kK1g6j7EZdNTA==
X-Received: by 2002:aca:6206:: with SMTP id w6mr4005464oib.132.1550183817395;
        Thu, 14 Feb 2019 14:36:57 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id h1sm1463938otm.0.2019.02.14.14.36.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 14:36:56 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 8/8] rtlwifi: rtl8821ae: Remove CamelCase variables
Date:   Thu, 14 Feb 2019 16:36:44 -0600
Message-Id: <20190214223644.8035-9-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190214223644.8035-1-Larry.Finger@lwfinger.net>
References: <20190214223644.8035-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

If a macro is in CamelCase, it it converted to upper case. Variables
and routine names are converted to lower case.

The following checkpatch exceptions are also fixed:

WARNING: line over 80 characters
#316: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c:1751:
+       SET_8821AE_H2CCMD_AOAC_RSVDPAGE_LOC_GTK_EXT_MEM(u1rsvdpageloc2, GTKEXT_PG);

CHECK: spaces preferred around that '+' (ctx:VxV)
#357: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c:2591:
+                (eeaddr+1), hwinfo[eeaddr+1]);
                        ^

CHECK: spaces preferred around that '+' (ctx:VxV)
#357: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c:2591:
+                (eeaddr+1), hwinfo[eeaddr+1]);
                                          ^

CHECK: spaces preferred around that '+' (ctx:VxV)
#358: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c:2592:
+       if (0xFF == hwinfo[eeaddr+1])  /*YJ,add,120316*/
                                 ^

WARNING: Comparisons should place the constant on the right side of the test
#358: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c:2592:
+       if (0xFF == hwinfo[eeaddr+1])  /*YJ,add,120316*/

CHECK: spaces preferred around that '&' (ctx:VxV)
#501: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c:2666:
+                               pwrinfo24g->bw40_diff[rfpath][txcount] = (hwinfo[eeaddr]&0xf0) >> 4;
                                                                                        ^
Note that not all checkpatch exceptions are addressed. Those will be
handled in later patches.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 .../wireless/realtek/rtlwifi/rtl8821ae/dm.h   |  10 +-
 .../wireless/realtek/rtlwifi/rtl8821ae/fw.c   | 102 ++++----
 .../wireless/realtek/rtlwifi/rtl8821ae/hw.c   | 234 +++++++++---------
 .../wireless/realtek/rtlwifi/rtl8821ae/phy.c  | 132 +++++-----
 .../wireless/realtek/rtlwifi/rtl8821ae/phy.h  |   4 +-
 .../wireless/realtek/rtlwifi/rtl8821ae/reg.h  |  34 +--
 .../realtek/rtlwifi/rtl8821ae/table.c         | 184 +++++++-------
 7 files changed, 350 insertions(+), 350 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.h
index 8e43336b7c00..d2eb0a70b16b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.h
@@ -70,11 +70,11 @@
 #define	DM_REG_CCK_CCA_CNT_11N			0xA60
 #define	DM_REG_BB_PWR_SAV4_11N			0xA74
 /*PAGE B */
-#define	DM_REG_LNA_SWITCH_11N			0xB2C
-#define	DM_REG_PATH_SWITCH_11N			0xB30
-#define	DM_REG_RSSI_CTRL_11N			0xB38
-#define	DM_REG_CONFIG_ANTA_11N			0xB68
-#define	DM_REG_RSSI_BT_11N				0xB9C
+#define	DM_REG_LNA_SWITCH_11N			0XB2C
+#define	DM_REG_PATH_SWITCH_11N			0XB30
+#define	DM_REG_RSSI_CTRL_11N			0XB38
+#define	DM_REG_CONFIG_ANTA_11N			0XB68
+#define	DM_REG_RSSI_BT_11N				0XB9C
 /*PAGE C */
 #define	DM_REG_OFDM_FA_HOLDC_11N		0xC00
 #define	DM_REG_RX_PATH_11N				0xC04
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
index 4c87de69b54e..a0b6ebcc6c9c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
@@ -822,9 +822,9 @@ static u8 reserved_page_packet_8821[TOTAL_RESERVED_PKT_LEN_8821] = {
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	0x00, 0x80, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	/* page 3: qos null data */
-	0xC8, 0x01, 0x00, 0x00,  0x84, 0xC9, 0xB2, 0xA7,
-	0xB3, 0x6E, 0x00, 0xE0,  0x4C, 0x02, 0x51, 0x02,
-	0x84, 0xC9, 0xB2, 0xA7,  0xB3, 0x6E, 0x00, 0x00,
+	0xC8, 0x01, 0x00, 0x00,  0x84, 0xC9, 0XB2, 0xA7,
+	0XB3, 0x6E, 0x00, 0xE0,  0x4C, 0x02, 0x51, 0x02,
+	0x84, 0xC9, 0XB2, 0xA7,  0XB3, 0x6E, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
@@ -855,9 +855,9 @@ static u8 reserved_page_packet_8821[TOTAL_RESERVED_PKT_LEN_8821] = {
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	0x00, 0x80, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	/* page 4: BT qos null data */
-	0xC8, 0x01, 0x00, 0x00,  0x84, 0xC9, 0xB2, 0xA7,
-	0xB3, 0x6E, 0x00, 0xE0,  0x4C, 0x02, 0x51, 0x02,
-	0x84, 0xC9, 0xB2, 0xA7,  0xB3, 0x6E, 0x00, 0x00,
+	0xC8, 0x01, 0x00, 0x00,  0x84, 0xC9, 0XB2, 0xA7,
+	0XB3, 0x6E, 0x00, 0xE0,  0x4C, 0x02, 0x51, 0x02,
+	0x84, 0xC9, 0XB2, 0xA7,  0XB3, 0x6E, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
@@ -889,9 +889,9 @@ static u8 reserved_page_packet_8821[TOTAL_RESERVED_PKT_LEN_8821] = {
 	0x00, 0x80, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	/* page 5~7 is for wowlan */
 	/* page 5: ARP resp */
-	0x08, 0x01, 0x00, 0x00,  0x84, 0xC9, 0xB2, 0xA7,
-	0xB3, 0x6E, 0x00, 0xE0,  0x4C, 0x02, 0x51, 0x02,
-	0x84, 0xC9, 0xB2, 0xA7,  0xB3, 0x6E, 0x00, 0x00,
+	0x08, 0x01, 0x00, 0x00,  0x84, 0xC9, 0XB2, 0xA7,
+	0XB3, 0x6E, 0x00, 0xE0,  0x4C, 0x02, 0x51, 0x02,
+	0x84, 0xC9, 0XB2, 0xA7,  0XB3, 0x6E, 0x00, 0x00,
 	0xAA, 0xAA, 0x03, 0x00,  0x00, 0x00, 0x08, 0x06,
 	0x00, 0x01, 0x08, 0x00,  0x06, 0x04, 0x00, 0x02,
 	0x00, 0xE0, 0x4C, 0x02,  0x51, 0x02, 0x00, 0x00,
@@ -993,7 +993,7 @@ static u8 reserved_page_packet_8812[TOTAL_RESERVED_PKT_LEN_8812] = {
 	/* page 0: beacon */
 	0x80, 0x00, 0x00, 0x00,  0xFF, 0xFF, 0xFF, 0xFF,
 	0xFF, 0xFF, 0x00, 0xE0,  0x4C, 0x02, 0x51, 0x02,
-	0x84, 0xC9, 0xB2, 0xA7,  0xB3, 0x6E, 0x60, 0x00,
+	0x84, 0xC9, 0XB2, 0xA7,  0XB3, 0x6E, 0x60, 0x00,
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	0x64, 0x00, 0x20, 0x04,  0x00, 0x03, 0x32, 0x31,
 	0x35, 0x01, 0x08, 0x82,  0x84, 0x8B, 0x96, 0x0C,
@@ -1056,8 +1056,8 @@ static u8 reserved_page_packet_8812[TOTAL_RESERVED_PKT_LEN_8812] = {
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	/* page 1: ps-poll */
-	0xA4, 0x10, 0x09, 0xC0,  0x84, 0xC9, 0xB2, 0xA7,
-	0xB3, 0x6E, 0x00, 0xE0,  0x4C, 0x02, 0x51, 0x02,
+	0xA4, 0x10, 0x09, 0xC0,  0x84, 0xC9, 0XB2, 0xA7,
+	0XB3, 0x6E, 0x00, 0xE0,  0x4C, 0x02, 0x51, 0x02,
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
@@ -1121,9 +1121,9 @@ static u8 reserved_page_packet_8812[TOTAL_RESERVED_PKT_LEN_8812] = {
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	0x00, 0x80, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	/* page 2: null data */
-	0x48, 0x01, 0x00, 0x00,  0x84, 0xC9, 0xB2, 0xA7,
-	0xB3, 0x6E, 0x00, 0xE0,  0x4C, 0x02, 0x51, 0x02,
-	0x84, 0xC9, 0xB2, 0xA7,  0xB3, 0x6E, 0x00, 0x00,
+	0x48, 0x01, 0x00, 0x00,  0x84, 0xC9, 0XB2, 0xA7,
+	0XB3, 0x6E, 0x00, 0xE0,  0x4C, 0x02, 0x51, 0x02,
+	0x84, 0xC9, 0XB2, 0xA7,  0XB3, 0x6E, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
@@ -1186,9 +1186,9 @@ static u8 reserved_page_packet_8812[TOTAL_RESERVED_PKT_LEN_8812] = {
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	0x00, 0x80, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	/* page 3: Qos null data */
-	0xC8, 0x01, 0x00, 0x00,  0x84, 0xC9, 0xB2, 0xA7,
-	0xB3, 0x6E, 0x00, 0xE0,  0x4C, 0x02, 0x51, 0x02,
-	0x84, 0xC9, 0xB2, 0xA7,  0xB3, 0x6E, 0x00, 0x00,
+	0xC8, 0x01, 0x00, 0x00,  0x84, 0xC9, 0XB2, 0xA7,
+	0XB3, 0x6E, 0x00, 0xE0,  0x4C, 0x02, 0x51, 0x02,
+	0x84, 0xC9, 0XB2, 0xA7,  0XB3, 0x6E, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
@@ -1251,9 +1251,9 @@ static u8 reserved_page_packet_8812[TOTAL_RESERVED_PKT_LEN_8812] = {
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	0x00, 0x80, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	/* page 4: BT Qos null data */
-	0xC8, 0x01, 0x00, 0x00,  0x84, 0xC9, 0xB2, 0xA7,
-	0xB3, 0x6E, 0x00, 0xE0,  0x4C, 0x02, 0x51, 0x02,
-	0x84, 0xC9, 0xB2, 0xA7,  0xB3, 0x6E, 0x00, 0x00,
+	0xC8, 0x01, 0x00, 0x00,  0x84, 0xC9, 0XB2, 0xA7,
+	0XB3, 0x6E, 0x00, 0xE0,  0x4C, 0x02, 0x51, 0x02,
+	0x84, 0xC9, 0XB2, 0xA7,  0XB3, 0x6E, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
@@ -1317,9 +1317,9 @@ static u8 reserved_page_packet_8812[TOTAL_RESERVED_PKT_LEN_8812] = {
 	0x00, 0x80, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
 	/* page 5~7 is for wowlan */
 	/* page 5: ARP resp */
-	0x08, 0x01, 0x00, 0x00,  0x84, 0xC9, 0xB2, 0xA7,
-	0xB3, 0x6E, 0x00, 0xE0,  0x4C, 0x02, 0x51, 0x02,
-	0x84, 0xC9, 0xB2, 0xA7,  0xB3, 0x6E, 0x00, 0x00,
+	0x08, 0x01, 0x00, 0x00,  0x84, 0xC9, 0XB2, 0xA7,
+	0XB3, 0x6E, 0x00, 0xE0,  0x4C, 0x02, 0x51, 0x02,
+	0x84, 0xC9, 0XB2, 0xA7,  0XB3, 0x6E, 0x00, 0x00,
 	0xAA, 0xAA, 0x03, 0x00,  0x00, 0x00, 0x08, 0x06,
 	0x00, 0x01, 0x08, 0x00,  0x06, 0x04, 0x00, 0x02,
 	0x00, 0xE0, 0x4C, 0x02,  0x51, 0x02, 0x00, 0x00,
@@ -1521,8 +1521,8 @@ void rtl8812ae_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 	struct sk_buff *skb = NULL;
 	u32 totalpacketlen;
 	bool rtstatus;
-	u8 u1RsvdPageLoc[5] = { 0 };
-	u8 u1RsvdPageLoc2[7] = { 0 };
+	u8 u1rsvdpageloc[5] = { 0 };
+	u8 u1rsvdpageloc2[7] = { 0 };
 	bool b_dlok = false;
 	u8 *beacon;
 	u8 *p_pspoll;
@@ -1552,7 +1552,7 @@ void rtl8812ae_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 	SET_80211_PS_POLL_BSSID(p_pspoll, mac->bssid);
 	SET_80211_PS_POLL_TA(p_pspoll, mac->mac_addr);
 
-	SET_H2CCMD_RSVDPAGE_LOC_PSPOLL(u1RsvdPageLoc, PSPOLL_PG);
+	SET_H2CCMD_RSVDPAGE_LOC_PSPOLL(u1rsvdpageloc, PSPOLL_PG);
 
 	/*--------------------------------------------------------
 	 *			(3) null data
@@ -1563,7 +1563,7 @@ void rtl8812ae_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 	SET_80211_HDR_ADDRESS2(nullfunc, mac->mac_addr);
 	SET_80211_HDR_ADDRESS3(nullfunc, mac->bssid);
 
-	SET_H2CCMD_RSVDPAGE_LOC_NULL_DATA(u1RsvdPageLoc, NULL_PG);
+	SET_H2CCMD_RSVDPAGE_LOC_NULL_DATA(u1rsvdpageloc, NULL_PG);
 
 	/*---------------------------------------------------------
 	 *			(4) Qos null data
@@ -1574,7 +1574,7 @@ void rtl8812ae_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 	SET_80211_HDR_ADDRESS2(qosnull, mac->mac_addr);
 	SET_80211_HDR_ADDRESS3(qosnull, mac->bssid);
 
-	SET_H2CCMD_RSVDPAGE_LOC_QOS_NULL_DATA(u1RsvdPageLoc, QOSNULL_PG);
+	SET_H2CCMD_RSVDPAGE_LOC_QOS_NULL_DATA(u1rsvdpageloc, QOSNULL_PG);
 
 	/*---------------------------------------------------------
 	 *			(5) BT Qos null data
@@ -1585,7 +1585,7 @@ void rtl8812ae_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 	SET_80211_HDR_ADDRESS2(btqosnull, mac->mac_addr);
 	SET_80211_HDR_ADDRESS3(btqosnull, mac->bssid);
 
-	SET_H2CCMD_RSVDPAGE_LOC_BT_QOS_NULL_DATA(u1RsvdPageLoc, BT_QOSNULL_PG);
+	SET_H2CCMD_RSVDPAGE_LOC_BT_QOS_NULL_DATA(u1rsvdpageloc, BT_QOSNULL_PG);
 
 	if (!dl_whole_packets) {
 		totalpacketlen = 512 * (BT_QOSNULL_PG + 1) - 40;
@@ -1600,20 +1600,20 @@ void rtl8812ae_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 	SET_80211_HDR_ADDRESS2(arpresp, mac->mac_addr);
 	SET_80211_HDR_ADDRESS3(arpresp, mac->bssid);
 
-	SET_8821AE_H2CCMD_AOAC_RSVDPAGE_LOC_ARP_RSP(u1RsvdPageLoc2, ARPRESP_PG);
+	SET_8821AE_H2CCMD_AOAC_RSVDPAGE_LOC_ARP_RSP(u1rsvdpageloc2, ARPRESP_PG);
 
 	/*---------------------------------------------------------
 	 *			(7) Remote Wake Ctrl
 	 *----------------------------------------------------------
 	 */
-	SET_8821AE_H2CCMD_AOAC_RSVDPAGE_LOC_REMOTE_WAKE_CTRL_INFO(u1RsvdPageLoc2,
+	SET_8821AE_H2CCMD_AOAC_RSVDPAGE_LOC_REMOTE_WAKE_CTRL_INFO(u1rsvdpageloc2,
 								REMOTE_PG);
 
 	/*---------------------------------------------------------
 	 *			(8) GTK Ext Memory
 	 *----------------------------------------------------------
 	 */
-	SET_8821AE_H2CCMD_AOAC_RSVDPAGE_LOC_GTK_EXT_MEM(u1RsvdPageLoc2, GTKEXT_PG);
+	SET_8821AE_H2CCMD_AOAC_RSVDPAGE_LOC_GTK_EXT_MEM(u1rsvdpageloc2, GTKEXT_PG);
 
 	totalpacketlen = TOTAL_RESERVED_PKT_LEN_8812 - 40;
 
@@ -1632,14 +1632,14 @@ void rtl8812ae_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 
 	if (!b_dl_finished && b_dlok) {
 		RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_DMESG,
-			      "H2C_RSVDPAGE:\n", u1RsvdPageLoc, 5);
+			      "H2C_RSVDPAGE:\n", u1rsvdpageloc, 5);
 		rtl8821ae_fill_h2c_cmd(hw, H2C_8821AE_RSVDPAGE,
-				       sizeof(u1RsvdPageLoc), u1RsvdPageLoc);
+				       sizeof(u1rsvdpageloc), u1rsvdpageloc);
 		if (dl_whole_packets) {
 			RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_DMESG,
-				      "wowlan H2C_RSVDPAGE:\n", u1RsvdPageLoc2, 7);
+				      "wowlan H2C_RSVDPAGE:\n", u1rsvdpageloc2, 7);
 			rtl8821ae_fill_h2c_cmd(hw, H2C_8821AE_AOAC_RSVDPAGE,
-					       sizeof(u1RsvdPageLoc2), u1RsvdPageLoc2);
+					       sizeof(u1rsvdpageloc2), u1rsvdpageloc2);
 		}
 	}
 
@@ -1656,8 +1656,8 @@ void rtl8821ae_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 	struct sk_buff *skb = NULL;
 	u32 totalpacketlen;
 	bool rtstatus;
-	u8 u1RsvdPageLoc[5] = { 0 };
-	u8 u1RsvdPageLoc2[7] = { 0 };
+	u8 u1rsvdpageloc[5] = { 0 };
+	u8 u1rsvdpageloc2[7] = { 0 };
 	bool b_dlok = false;
 	u8 *beacon;
 	u8 *p_pspoll;
@@ -1687,7 +1687,7 @@ void rtl8821ae_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 	SET_80211_PS_POLL_BSSID(p_pspoll, mac->bssid);
 	SET_80211_PS_POLL_TA(p_pspoll, mac->mac_addr);
 
-	SET_H2CCMD_RSVDPAGE_LOC_PSPOLL(u1RsvdPageLoc, PSPOLL_PG);
+	SET_H2CCMD_RSVDPAGE_LOC_PSPOLL(u1rsvdpageloc, PSPOLL_PG);
 
 	/*--------------------------------------------------------
 	 *			(3) null data
@@ -1698,7 +1698,7 @@ void rtl8821ae_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 	SET_80211_HDR_ADDRESS2(nullfunc, mac->mac_addr);
 	SET_80211_HDR_ADDRESS3(nullfunc, mac->bssid);
 
-	SET_H2CCMD_RSVDPAGE_LOC_NULL_DATA(u1RsvdPageLoc, NULL_PG);
+	SET_H2CCMD_RSVDPAGE_LOC_NULL_DATA(u1rsvdpageloc, NULL_PG);
 
 	/*---------------------------------------------------------
 	 *			(4) Qos null data
@@ -1709,7 +1709,7 @@ void rtl8821ae_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 	SET_80211_HDR_ADDRESS2(qosnull, mac->mac_addr);
 	SET_80211_HDR_ADDRESS3(qosnull, mac->bssid);
 
-	SET_H2CCMD_RSVDPAGE_LOC_QOS_NULL_DATA(u1RsvdPageLoc, QOSNULL_PG);
+	SET_H2CCMD_RSVDPAGE_LOC_QOS_NULL_DATA(u1rsvdpageloc, QOSNULL_PG);
 
 	/*---------------------------------------------------------
 	 *			(5) Qos null data
@@ -1720,7 +1720,7 @@ void rtl8821ae_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 	SET_80211_HDR_ADDRESS2(btqosnull, mac->mac_addr);
 	SET_80211_HDR_ADDRESS3(btqosnull, mac->bssid);
 
-	SET_H2CCMD_RSVDPAGE_LOC_BT_QOS_NULL_DATA(u1RsvdPageLoc, BT_QOSNULL_PG);
+	SET_H2CCMD_RSVDPAGE_LOC_BT_QOS_NULL_DATA(u1rsvdpageloc, BT_QOSNULL_PG);
 
 	if (!dl_whole_packets) {
 		totalpacketlen = 256 * (BT_QOSNULL_PG + 1) - 40;
@@ -1735,20 +1735,20 @@ void rtl8821ae_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 	SET_80211_HDR_ADDRESS2(arpresp, mac->mac_addr);
 	SET_80211_HDR_ADDRESS3(arpresp, mac->bssid);
 
-	SET_8821AE_H2CCMD_AOAC_RSVDPAGE_LOC_ARP_RSP(u1RsvdPageLoc2, ARPRESP_PG);
+	SET_8821AE_H2CCMD_AOAC_RSVDPAGE_LOC_ARP_RSP(u1rsvdpageloc2, ARPRESP_PG);
 
 	/*---------------------------------------------------------
 	 *			(7) Remote Wake Ctrl
 	 *----------------------------------------------------------
 	 */
-	SET_8821AE_H2CCMD_AOAC_RSVDPAGE_LOC_REMOTE_WAKE_CTRL_INFO(u1RsvdPageLoc2,
+	SET_8821AE_H2CCMD_AOAC_RSVDPAGE_LOC_REMOTE_WAKE_CTRL_INFO(u1rsvdpageloc2,
 									REMOTE_PG);
 
 	/*---------------------------------------------------------
 	 *			(8) GTK Ext Memory
 	 *----------------------------------------------------------
 	 */
-	SET_8821AE_H2CCMD_AOAC_RSVDPAGE_LOC_GTK_EXT_MEM(u1RsvdPageLoc2, GTKEXT_PG);
+	SET_8821AE_H2CCMD_AOAC_RSVDPAGE_LOC_GTK_EXT_MEM(u1rsvdpageloc2, GTKEXT_PG);
 
 	totalpacketlen = TOTAL_RESERVED_PKT_LEN_8821 - 40;
 
@@ -1770,16 +1770,16 @@ void rtl8821ae_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
 			 "Set RSVD page location to Fw.\n");
 		RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_DMESG,
-				"H2C_RSVDPAGE:\n", u1RsvdPageLoc, 5);
+				"H2C_RSVDPAGE:\n", u1rsvdpageloc, 5);
 		rtl8821ae_fill_h2c_cmd(hw, H2C_8821AE_RSVDPAGE,
-				       sizeof(u1RsvdPageLoc), u1RsvdPageLoc);
+				       sizeof(u1rsvdpageloc), u1rsvdpageloc);
 		if (dl_whole_packets) {
 			RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_DMESG,
 				      "wowlan H2C_RSVDPAGE:\n",
-				      u1RsvdPageLoc2, 7);
+				      u1rsvdpageloc2, 7);
 			rtl8821ae_fill_h2c_cmd(hw, H2C_8821AE_AOAC_RSVDPAGE,
-					       sizeof(u1RsvdPageLoc2),
-					       u1RsvdPageLoc2);
+					       sizeof(u1rsvdpageloc2),
+					       u1rsvdpageloc2);
 		}
 	}
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index dbc16da10eb2..84bc13461240 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -2584,50 +2584,50 @@ static void _rtl8821ae_read_power_value_fromprom(struct ieee80211_hw *hw,
 	u8 *hwinfo)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u32 rfPath, eeAddr = EEPROM_TX_PWR_INX, group, TxCount = 0;
+	u32 rfpath, eeaddr = EEPROM_TX_PWR_INX, group, txcount = 0;
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
 		 "hal_ReadPowerValueFromPROM8821ae(): hwinfo[0x%x]=0x%x\n",
-		 (eeAddr+1), hwinfo[eeAddr+1]);
-	if (0xFF == hwinfo[eeAddr+1])  /*YJ,add,120316*/
+		 (eeaddr + 1), hwinfo[eeaddr + 1]);
+	if (hwinfo[eeaddr + 1] == 0xFF)  /*YJ,add,120316*/
 		autoload_fail = true;
 
 	if (autoload_fail) {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
 			 "auto load fail : Use Default value!\n");
-		for (rfPath = 0 ; rfPath < MAX_RF_PATH ; rfPath++) {
+		for (rfpath = 0 ; rfpath < MAX_RF_PATH ; rfpath++) {
 			/*2.4G default value*/
 			for (group = 0 ; group < MAX_CHNL_GROUP_24G; group++) {
-				pwrinfo24g->index_cck_base[rfPath][group] =	0x2D;
-				pwrinfo24g->index_bw40_base[rfPath][group] = 0x2D;
+				pwrinfo24g->index_cck_base[rfpath][group] = 0x2D;
+				pwrinfo24g->index_bw40_base[rfpath][group] = 0x2D;
 			}
-			for (TxCount = 0; TxCount < MAX_TX_COUNT; TxCount++) {
-				if (TxCount == 0) {
-					pwrinfo24g->bw20_diff[rfPath][0] = 0x02;
-					pwrinfo24g->ofdm_diff[rfPath][0] = 0x04;
+			for (txcount = 0; txcount < MAX_TX_COUNT; txcount++) {
+				if (txcount == 0) {
+					pwrinfo24g->bw20_diff[rfpath][0] = 0x02;
+					pwrinfo24g->ofdm_diff[rfpath][0] = 0x04;
 				} else {
-					pwrinfo24g->bw20_diff[rfPath][TxCount] = 0xFE;
-					pwrinfo24g->bw40_diff[rfPath][TxCount] = 0xFE;
-					pwrinfo24g->cck_diff[rfPath][TxCount] =	0xFE;
-					pwrinfo24g->ofdm_diff[rfPath][TxCount] = 0xFE;
+					pwrinfo24g->bw20_diff[rfpath][txcount] = 0xFE;
+					pwrinfo24g->bw40_diff[rfpath][txcount] = 0xFE;
+					pwrinfo24g->cck_diff[rfpath][txcount] =	0xFE;
+					pwrinfo24g->ofdm_diff[rfpath][txcount] = 0xFE;
 				}
 			}
 			/*5G default value*/
 			for (group = 0 ; group < MAX_CHNL_GROUP_5G; group++)
-				pwrinfo5g->index_bw40_base[rfPath][group] = 0x2A;
-
-			for (TxCount = 0; TxCount < MAX_TX_COUNT; TxCount++) {
-				if (TxCount == 0) {
-					pwrinfo5g->ofdm_diff[rfPath][0] = 0x04;
-					pwrinfo5g->bw20_diff[rfPath][0] = 0x00;
-					pwrinfo5g->bw80_diff[rfPath][0] = 0xFE;
-					pwrinfo5g->bw160_diff[rfPath][0] = 0xFE;
+				pwrinfo5g->index_bw40_base[rfpath][group] = 0x2A;
+
+			for (txcount = 0; txcount < MAX_TX_COUNT; txcount++) {
+				if (txcount == 0) {
+					pwrinfo5g->ofdm_diff[rfpath][0] = 0x04;
+					pwrinfo5g->bw20_diff[rfpath][0] = 0x00;
+					pwrinfo5g->bw80_diff[rfpath][0] = 0xFE;
+					pwrinfo5g->bw160_diff[rfpath][0] = 0xFE;
 				} else {
-					pwrinfo5g->ofdm_diff[rfPath][0] = 0xFE;
-					pwrinfo5g->bw20_diff[rfPath][0] = 0xFE;
-					pwrinfo5g->bw40_diff[rfPath][0] = 0xFE;
-					pwrinfo5g->bw80_diff[rfPath][0] = 0xFE;
-					pwrinfo5g->bw160_diff[rfPath][0] = 0xFE;
+					pwrinfo5g->ofdm_diff[rfpath][0] = 0xFE;
+					pwrinfo5g->bw20_diff[rfpath][0] = 0xFE;
+					pwrinfo5g->bw40_diff[rfpath][0] = 0xFE;
+					pwrinfo5g->bw80_diff[rfpath][0] = 0xFE;
+					pwrinfo5g->bw160_diff[rfpath][0] = 0xFE;
 				}
 			}
 		}
@@ -2636,112 +2636,112 @@ static void _rtl8821ae_read_power_value_fromprom(struct ieee80211_hw *hw,
 
 	rtl_priv(hw)->efuse.txpwr_fromeprom = true;
 
-	for (rfPath = 0 ; rfPath < MAX_RF_PATH ; rfPath++) {
+	for (rfpath = 0 ; rfpath < MAX_RF_PATH ; rfpath++) {
 		/*2.4G default value*/
 		for (group = 0 ; group < MAX_CHNL_GROUP_24G; group++) {
-			pwrinfo24g->index_cck_base[rfPath][group] = hwinfo[eeAddr++];
-			if (pwrinfo24g->index_cck_base[rfPath][group] == 0xFF)
-				pwrinfo24g->index_cck_base[rfPath][group] = 0x2D;
+			pwrinfo24g->index_cck_base[rfpath][group] = hwinfo[eeaddr++];
+			if (pwrinfo24g->index_cck_base[rfpath][group] == 0xFF)
+				pwrinfo24g->index_cck_base[rfpath][group] = 0x2D;
 		}
 		for (group = 0 ; group < MAX_CHNL_GROUP_24G - 1; group++) {
-			pwrinfo24g->index_bw40_base[rfPath][group] = hwinfo[eeAddr++];
-			if (pwrinfo24g->index_bw40_base[rfPath][group] == 0xFF)
-				pwrinfo24g->index_bw40_base[rfPath][group] = 0x2D;
+			pwrinfo24g->index_bw40_base[rfpath][group] = hwinfo[eeaddr++];
+			if (pwrinfo24g->index_bw40_base[rfpath][group] == 0xFF)
+				pwrinfo24g->index_bw40_base[rfpath][group] = 0x2D;
 		}
-		for (TxCount = 0; TxCount < MAX_TX_COUNT; TxCount++) {
-			if (TxCount == 0) {
-				pwrinfo24g->bw40_diff[rfPath][TxCount] = 0;
+		for (txcount = 0; txcount < MAX_TX_COUNT; txcount++) {
+			if (txcount == 0) {
+				pwrinfo24g->bw40_diff[rfpath][txcount] = 0;
 				/*bit sign number to 8 bit sign number*/
-				pwrinfo24g->bw20_diff[rfPath][TxCount] = (hwinfo[eeAddr] & 0xf0) >> 4;
-				if (pwrinfo24g->bw20_diff[rfPath][TxCount] & BIT(3))
-					pwrinfo24g->bw20_diff[rfPath][TxCount] |= 0xF0;
+				pwrinfo24g->bw20_diff[rfpath][txcount] = (hwinfo[eeaddr] & 0xf0) >> 4;
+				if (pwrinfo24g->bw20_diff[rfpath][txcount] & BIT(3))
+					pwrinfo24g->bw20_diff[rfpath][txcount] |= 0xF0;
 				/*bit sign number to 8 bit sign number*/
-				pwrinfo24g->ofdm_diff[rfPath][TxCount] = (hwinfo[eeAddr] & 0x0f);
-				if (pwrinfo24g->ofdm_diff[rfPath][TxCount] & BIT(3))
-					pwrinfo24g->ofdm_diff[rfPath][TxCount] |= 0xF0;
+				pwrinfo24g->ofdm_diff[rfpath][txcount] = (hwinfo[eeaddr] & 0x0f);
+				if (pwrinfo24g->ofdm_diff[rfpath][txcount] & BIT(3))
+					pwrinfo24g->ofdm_diff[rfpath][txcount] |= 0xF0;
 
-				pwrinfo24g->cck_diff[rfPath][TxCount] = 0;
-				eeAddr++;
+				pwrinfo24g->cck_diff[rfpath][txcount] = 0;
+				eeaddr++;
 			} else {
-				pwrinfo24g->bw40_diff[rfPath][TxCount] = (hwinfo[eeAddr]&0xf0) >> 4;
-				if (pwrinfo24g->bw40_diff[rfPath][TxCount] & BIT(3))
-					pwrinfo24g->bw40_diff[rfPath][TxCount] |= 0xF0;
+				pwrinfo24g->bw40_diff[rfpath][txcount] = (hwinfo[eeaddr] & 0xf0) >> 4;
+				if (pwrinfo24g->bw40_diff[rfpath][txcount] & BIT(3))
+					pwrinfo24g->bw40_diff[rfpath][txcount] |= 0xF0;
 
-				pwrinfo24g->bw20_diff[rfPath][TxCount] = (hwinfo[eeAddr] & 0x0f);
-				if (pwrinfo24g->bw20_diff[rfPath][TxCount] & BIT(3))
-					pwrinfo24g->bw20_diff[rfPath][TxCount] |= 0xF0;
+				pwrinfo24g->bw20_diff[rfpath][txcount] = (hwinfo[eeaddr] & 0x0f);
+				if (pwrinfo24g->bw20_diff[rfpath][txcount] & BIT(3))
+					pwrinfo24g->bw20_diff[rfpath][txcount] |= 0xF0;
 
-				eeAddr++;
+				eeaddr++;
 
-				pwrinfo24g->ofdm_diff[rfPath][TxCount] = (hwinfo[eeAddr] & 0xf0) >> 4;
-				if (pwrinfo24g->ofdm_diff[rfPath][TxCount] & BIT(3))
-					pwrinfo24g->ofdm_diff[rfPath][TxCount] |= 0xF0;
+				pwrinfo24g->ofdm_diff[rfpath][txcount] = (hwinfo[eeaddr] & 0xf0) >> 4;
+				if (pwrinfo24g->ofdm_diff[rfpath][txcount] & BIT(3))
+					pwrinfo24g->ofdm_diff[rfpath][txcount] |= 0xF0;
 
-				pwrinfo24g->cck_diff[rfPath][TxCount] =	(hwinfo[eeAddr] & 0x0f);
-				if (pwrinfo24g->cck_diff[rfPath][TxCount] & BIT(3))
-					pwrinfo24g->cck_diff[rfPath][TxCount] |= 0xF0;
+				pwrinfo24g->cck_diff[rfpath][txcount] =	(hwinfo[eeaddr] & 0x0f);
+				if (pwrinfo24g->cck_diff[rfpath][txcount] & BIT(3))
+					pwrinfo24g->cck_diff[rfpath][txcount] |= 0xF0;
 
-				eeAddr++;
+				eeaddr++;
 			}
 		}
 
 		/*5G default value*/
 		for (group = 0 ; group < MAX_CHNL_GROUP_5G; group++) {
-			pwrinfo5g->index_bw40_base[rfPath][group] = hwinfo[eeAddr++];
-			if (pwrinfo5g->index_bw40_base[rfPath][group] == 0xFF)
-				pwrinfo5g->index_bw40_base[rfPath][group] = 0xFE;
+			pwrinfo5g->index_bw40_base[rfpath][group] = hwinfo[eeaddr++];
+			if (pwrinfo5g->index_bw40_base[rfpath][group] == 0xFF)
+				pwrinfo5g->index_bw40_base[rfpath][group] = 0xFE;
 		}
 
-		for (TxCount = 0; TxCount < MAX_TX_COUNT; TxCount++) {
-			if (TxCount == 0) {
-				pwrinfo5g->bw40_diff[rfPath][TxCount] = 0;
+		for (txcount = 0; txcount < MAX_TX_COUNT; txcount++) {
+			if (txcount == 0) {
+				pwrinfo5g->bw40_diff[rfpath][txcount] = 0;
 
-				pwrinfo5g->bw20_diff[rfPath][0] = (hwinfo[eeAddr] & 0xf0) >> 4;
-				if (pwrinfo5g->bw20_diff[rfPath][TxCount] & BIT(3))
-					pwrinfo5g->bw20_diff[rfPath][TxCount] |= 0xF0;
+				pwrinfo5g->bw20_diff[rfpath][0] = (hwinfo[eeaddr] & 0xf0) >> 4;
+				if (pwrinfo5g->bw20_diff[rfpath][txcount] & BIT(3))
+					pwrinfo5g->bw20_diff[rfpath][txcount] |= 0xF0;
 
-				pwrinfo5g->ofdm_diff[rfPath][0] = (hwinfo[eeAddr] & 0x0f);
-				if (pwrinfo5g->ofdm_diff[rfPath][TxCount] & BIT(3))
-					pwrinfo5g->ofdm_diff[rfPath][TxCount] |= 0xF0;
+				pwrinfo5g->ofdm_diff[rfpath][0] = (hwinfo[eeaddr] & 0x0f);
+				if (pwrinfo5g->ofdm_diff[rfpath][txcount] & BIT(3))
+					pwrinfo5g->ofdm_diff[rfpath][txcount] |= 0xF0;
 
-				eeAddr++;
+				eeaddr++;
 			} else {
-				pwrinfo5g->bw40_diff[rfPath][TxCount] = (hwinfo[eeAddr] & 0xf0) >> 4;
-				if (pwrinfo5g->bw40_diff[rfPath][TxCount] & BIT(3))
-					pwrinfo5g->bw40_diff[rfPath][TxCount] |= 0xF0;
+				pwrinfo5g->bw40_diff[rfpath][txcount] = (hwinfo[eeaddr] & 0xf0) >> 4;
+				if (pwrinfo5g->bw40_diff[rfpath][txcount] & BIT(3))
+					pwrinfo5g->bw40_diff[rfpath][txcount] |= 0xF0;
 
-				pwrinfo5g->bw20_diff[rfPath][TxCount] = (hwinfo[eeAddr] & 0x0f);
-				if (pwrinfo5g->bw20_diff[rfPath][TxCount] & BIT(3))
-					pwrinfo5g->bw20_diff[rfPath][TxCount] |= 0xF0;
+				pwrinfo5g->bw20_diff[rfpath][txcount] = (hwinfo[eeaddr] & 0x0f);
+				if (pwrinfo5g->bw20_diff[rfpath][txcount] & BIT(3))
+					pwrinfo5g->bw20_diff[rfpath][txcount] |= 0xF0;
 
-				eeAddr++;
+				eeaddr++;
 			}
 		}
 
-		pwrinfo5g->ofdm_diff[rfPath][1] =	(hwinfo[eeAddr] & 0xf0) >> 4;
-		pwrinfo5g->ofdm_diff[rfPath][2] =	(hwinfo[eeAddr] & 0x0f);
+		pwrinfo5g->ofdm_diff[rfpath][1] =	(hwinfo[eeaddr] & 0xf0) >> 4;
+		pwrinfo5g->ofdm_diff[rfpath][2] =	(hwinfo[eeaddr] & 0x0f);
 
-		eeAddr++;
+		eeaddr++;
 
-		pwrinfo5g->ofdm_diff[rfPath][3] = (hwinfo[eeAddr] & 0x0f);
+		pwrinfo5g->ofdm_diff[rfpath][3] = (hwinfo[eeaddr] & 0x0f);
 
-		eeAddr++;
+		eeaddr++;
 
-		for (TxCount = 1; TxCount < MAX_TX_COUNT; TxCount++) {
-			if (pwrinfo5g->ofdm_diff[rfPath][TxCount] & BIT(3))
-				pwrinfo5g->ofdm_diff[rfPath][TxCount] |= 0xF0;
+		for (txcount = 1; txcount < MAX_TX_COUNT; txcount++) {
+			if (pwrinfo5g->ofdm_diff[rfpath][txcount] & BIT(3))
+				pwrinfo5g->ofdm_diff[rfpath][txcount] |= 0xF0;
 		}
-		for (TxCount = 0; TxCount < MAX_TX_COUNT; TxCount++) {
-			pwrinfo5g->bw80_diff[rfPath][TxCount] =	(hwinfo[eeAddr] & 0xf0) >> 4;
+		for (txcount = 0; txcount < MAX_TX_COUNT; txcount++) {
+			pwrinfo5g->bw80_diff[rfpath][txcount] =	(hwinfo[eeaddr] & 0xf0) >> 4;
 			/* 4bit sign number to 8 bit sign number */
-			if (pwrinfo5g->bw80_diff[rfPath][TxCount] & BIT(3))
-				pwrinfo5g->bw80_diff[rfPath][TxCount] |= 0xF0;
+			if (pwrinfo5g->bw80_diff[rfpath][txcount] & BIT(3))
+				pwrinfo5g->bw80_diff[rfpath][txcount] |= 0xF0;
 			/* 4bit sign number to 8 bit sign number */
-			pwrinfo5g->bw160_diff[rfPath][TxCount] = (hwinfo[eeAddr] & 0x0f);
-			if (pwrinfo5g->bw160_diff[rfPath][TxCount] & BIT(3))
-				pwrinfo5g->bw160_diff[rfPath][TxCount] |= 0xF0;
+			pwrinfo5g->bw160_diff[rfpath][txcount] = (hwinfo[eeaddr] & 0x0f);
+			if (pwrinfo5g->bw160_diff[rfpath][txcount] & BIT(3))
+				pwrinfo5g->bw160_diff[rfpath][txcount] |= 0xF0;
 
-			eeAddr++;
+			eeaddr++;
 		}
 	}
 }
@@ -2908,8 +2908,8 @@ static void _rtl8812ae_read_pa_type(struct ieee80211_hw *hw, u8 *hwinfo,
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 
 	if (!autoload_fail) {
-		rtlhal->pa_type_2g = hwinfo[0xBC];
-		rtlhal->lna_type_2g = hwinfo[0xBD];
+		rtlhal->pa_type_2g = hwinfo[0XBC];
+		rtlhal->lna_type_2g = hwinfo[0XBD];
 		if (rtlhal->pa_type_2g == 0xFF && rtlhal->lna_type_2g == 0xFF) {
 			rtlhal->pa_type_2g = 0;
 			rtlhal->lna_type_2g = 0;
@@ -2921,8 +2921,8 @@ static void _rtl8812ae_read_pa_type(struct ieee80211_hw *hw, u8 *hwinfo,
 					   (rtlhal->lna_type_2g & BIT(3))) ?
 					  1 : 0;
 
-		rtlhal->pa_type_5g = hwinfo[0xBC];
-		rtlhal->lna_type_5g = hwinfo[0xBF];
+		rtlhal->pa_type_5g = hwinfo[0XBC];
+		rtlhal->lna_type_5g = hwinfo[0XBF];
 		if (rtlhal->pa_type_5g == 0xFF && rtlhal->lna_type_5g == 0xFF) {
 			rtlhal->pa_type_5g = 0;
 			rtlhal->lna_type_5g = 0;
@@ -2947,18 +2947,18 @@ static void _rtl8812ae_read_amplifier_type(struct ieee80211_hw *hw, u8 *hwinfo,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 
-	u8 ext_type_pa_2g_a  = (hwinfo[0xBD] & BIT(2))      >> 2; /* 0xBD[2] */
-	u8 ext_type_pa_2g_b  = (hwinfo[0xBD] & BIT(6))      >> 6; /* 0xBD[6] */
-	u8 ext_type_pa_5g_a  = (hwinfo[0xBF] & BIT(2))      >> 2; /* 0xBF[2] */
-	u8 ext_type_pa_5g_b  = (hwinfo[0xBF] & BIT(6))      >> 6; /* 0xBF[6] */
-	/* 0xBD[1:0] */
-	u8 ext_type_lna_2g_a = (hwinfo[0xBD] & (BIT(1) | BIT(0))) >> 0;
-	/* 0xBD[5:4] */
-	u8 ext_type_lna_2g_b = (hwinfo[0xBD] & (BIT(5) | BIT(4))) >> 4;
-	/* 0xBF[1:0] */
-	u8 ext_type_lna_5g_a = (hwinfo[0xBF] & (BIT(1) | BIT(0))) >> 0;
-	/* 0xBF[5:4] */
-	u8 ext_type_lna_5g_b = (hwinfo[0xBF] & (BIT(5) | BIT(4))) >> 4;
+	u8 ext_type_pa_2g_a  = (hwinfo[0XBD] & BIT(2))      >> 2; /* 0XBD[2] */
+	u8 ext_type_pa_2g_b  = (hwinfo[0XBD] & BIT(6))      >> 6; /* 0XBD[6] */
+	u8 ext_type_pa_5g_a  = (hwinfo[0XBF] & BIT(2))      >> 2; /* 0XBF[2] */
+	u8 ext_type_pa_5g_b  = (hwinfo[0XBF] & BIT(6))      >> 6; /* 0XBF[6] */
+	/* 0XBD[1:0] */
+	u8 ext_type_lna_2g_a = (hwinfo[0XBD] & (BIT(1) | BIT(0))) >> 0;
+	/* 0XBD[5:4] */
+	u8 ext_type_lna_2g_b = (hwinfo[0XBD] & (BIT(5) | BIT(4))) >> 4;
+	/* 0XBF[1:0] */
+	u8 ext_type_lna_5g_a = (hwinfo[0XBF] & (BIT(1) | BIT(0))) >> 0;
+	/* 0XBF[5:4] */
+	u8 ext_type_lna_5g_b = (hwinfo[0XBF] & (BIT(5) | BIT(4))) >> 4;
 
 	_rtl8812ae_read_pa_type(hw, hwinfo, autoload_fail);
 
@@ -2986,8 +2986,8 @@ static void _rtl8821ae_read_pa_type(struct ieee80211_hw *hw, u8 *hwinfo,
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 
 	if (!autoload_fail) {
-		rtlhal->pa_type_2g = hwinfo[0xBC];
-		rtlhal->lna_type_2g = hwinfo[0xBD];
+		rtlhal->pa_type_2g = hwinfo[0XBC];
+		rtlhal->lna_type_2g = hwinfo[0XBD];
 		if (rtlhal->pa_type_2g == 0xFF && rtlhal->lna_type_2g == 0xFF) {
 			rtlhal->pa_type_2g = 0;
 			rtlhal->lna_type_2g = 0;
@@ -2995,8 +2995,8 @@ static void _rtl8821ae_read_pa_type(struct ieee80211_hw *hw, u8 *hwinfo,
 		rtlhal->external_pa_2g = (rtlhal->pa_type_2g & BIT(5)) ? 1 : 0;
 		rtlhal->external_lna_2g = (rtlhal->lna_type_2g & BIT(7)) ? 1 : 0;
 
-		rtlhal->pa_type_5g = hwinfo[0xBC];
-		rtlhal->lna_type_5g = hwinfo[0xBF];
+		rtlhal->pa_type_5g = hwinfo[0XBC];
+		rtlhal->lna_type_5g = hwinfo[0XBF];
 		if (rtlhal->pa_type_5g == 0xFF && rtlhal->lna_type_5g == 0xFF) {
 			rtlhal->pa_type_5g = 0;
 			rtlhal->lna_type_5g = 0;
@@ -4011,10 +4011,10 @@ void rtl8821ae_add_wowlan_pattern(struct ieee80211_hw *hw,
 	rtl_write_byte(rtlpriv, REG_PKT_BUFF_ACCESS_CTRL, RXPKT_BUF_SELECT);
 	for (addr = 0; addr < WKFMCAM_ADDR_NUM; addr++) {
 		/* Set Rx packet buffer offset.
-		 * RxBufer pointer increases 1,
+		 * RXBufer pointer increases 1,
 		 * we can access 8 bytes in Rx packet buffer.
 		 * CAM start offset (unit: 1 byte) =  index*WKFMCAM_SIZE
-		 * RxBufer addr = (CAM start offset +
+		 * RXBufer addr = (CAM start offset +
 		 *                 per entry offset of a WKFM CAM)/8
 		 *	* index: The index of the wake up frame mask
 		 *	* WKFMCAM_SIZE: the total size of one WKFM CAM
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 7524aad020f4..b0b1dad95dbe 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -453,7 +453,7 @@ u32 phy_get_tx_swing_8812A(struct ieee80211_hw *hw, u8	band,
 	const s8 auto_temp = -1;
 
 	RT_TRACE(rtlpriv, COMP_SCAN, DBG_LOUD,
-		 "===> PHY_GetTxBBSwing_8812A, bbSwing_2G: %d, bbSwing_5G: %d,autoload_failflag=%d.\n",
+		 "===> PHY_GetTXBBSwing_8812A, bbSwing_2G: %d, bbSwing_5G: %d,autoload_failflag=%d.\n",
 		 (int)swing_2g, (int)swing_5g,
 		 (int)rtlefuse->autoload_failflag);
 
@@ -534,7 +534,7 @@ u32 phy_get_tx_swing_8812A(struct ieee80211_hw *hw, u8	band,
 		swing_a = (swing & 0x3) >> 0; /* 0xC6/C7[1:0] */
 		swing_b = (swing & 0xC) >> 2; /* 0xC6/C7[3:2] */
 		RT_TRACE(rtlpriv, COMP_SCAN, DBG_LOUD,
-			 "===> PHY_GetTxBBSwing_8812A, swingA: 0x%X, swingB: 0x%X\n",
+			 "===> PHY_GetTXBBSwing_8812A, swingA: 0x%X, swingB: 0x%X\n",
 			 swing_a, swing_b);
 
 		/* 3 Path-A */
@@ -592,7 +592,7 @@ u32 phy_get_tx_swing_8812A(struct ieee80211_hw *hw, u8	band,
 	}
 
 	RT_TRACE(rtlpriv, COMP_SCAN, DBG_LOUD,
-		 "<=== PHY_GetTxBBSwing_8812A, out = 0x%X\n", out);
+		 "<=== PHY_GetTXBBSwing_8812A, out = 0x%X\n", out);
 	return out;
 }
 
@@ -1056,52 +1056,52 @@ static void _rtl8821ae_phy_store_txpower_by_rate_base(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &rtlpriv->phy;
-	u16 rawValue = 0;
+	u16 rawvalue = 0;
 	u8 base = 0, path = 0;
 
 	for (path = RF90_PATH_A; path <= RF90_PATH_B; ++path) {
-		rawValue = (u16)(rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][path][RF_1TX][0] >> 24) & 0xFF;
-		base = (rawValue >> 4) * 10 + (rawValue & 0xF);
+		rawvalue = (u16)(rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][path][RF_1TX][0] >> 24) & 0xFF;
+		base = (rawvalue >> 4) * 10 + (rawvalue & 0xF);
 		_rtl8821ae_phy_set_txpower_by_rate_base(hw, BAND_ON_2_4G, path, CCK, RF_1TX, base);
 
-		rawValue = (u16)(rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][path][RF_1TX][2] >> 24) & 0xFF;
-		base = (rawValue >> 4) * 10 + (rawValue & 0xF);
+		rawvalue = (u16)(rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][path][RF_1TX][2] >> 24) & 0xFF;
+		base = (rawvalue >> 4) * 10 + (rawvalue & 0xF);
 		_rtl8821ae_phy_set_txpower_by_rate_base(hw, BAND_ON_2_4G, path, OFDM, RF_1TX, base);
 
-		rawValue = (u16)(rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][path][RF_1TX][4] >> 24) & 0xFF;
-		base = (rawValue >> 4) * 10 + (rawValue & 0xF);
+		rawvalue = (u16)(rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][path][RF_1TX][4] >> 24) & 0xFF;
+		base = (rawvalue >> 4) * 10 + (rawvalue & 0xF);
 		_rtl8821ae_phy_set_txpower_by_rate_base(hw, BAND_ON_2_4G, path, HT_MCS0_MCS7, RF_1TX, base);
 
-		rawValue = (u16)(rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][path][RF_2TX][6] >> 24) & 0xFF;
-		base = (rawValue >> 4) * 10 + (rawValue & 0xF);
+		rawvalue = (u16)(rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][path][RF_2TX][6] >> 24) & 0xFF;
+		base = (rawvalue >> 4) * 10 + (rawvalue & 0xF);
 		_rtl8821ae_phy_set_txpower_by_rate_base(hw, BAND_ON_2_4G, path, HT_MCS8_MCS15, RF_2TX, base);
 
-		rawValue = (u16)(rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][path][RF_1TX][8] >> 24) & 0xFF;
-		base = (rawValue >> 4) * 10 + (rawValue & 0xF);
+		rawvalue = (u16)(rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][path][RF_1TX][8] >> 24) & 0xFF;
+		base = (rawvalue >> 4) * 10 + (rawvalue & 0xF);
 		_rtl8821ae_phy_set_txpower_by_rate_base(hw, BAND_ON_2_4G, path, VHT_1SSMCS0_1SSMCS9, RF_1TX, base);
 
-		rawValue = (u16)(rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][path][RF_2TX][11] >> 8) & 0xFF;
-		base = (rawValue >> 4) * 10 + (rawValue & 0xF);
+		rawvalue = (u16)(rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][path][RF_2TX][11] >> 8) & 0xFF;
+		base = (rawvalue >> 4) * 10 + (rawvalue & 0xF);
 		_rtl8821ae_phy_set_txpower_by_rate_base(hw, BAND_ON_2_4G, path, VHT_2SSMCS0_2SSMCS9, RF_2TX, base);
 
-		rawValue = (u16)(rtlphy->tx_power_by_rate_offset[BAND_ON_5G][path][RF_1TX][2] >> 24) & 0xFF;
-		base = (rawValue >> 4) * 10 + (rawValue & 0xF);
+		rawvalue = (u16)(rtlphy->tx_power_by_rate_offset[BAND_ON_5G][path][RF_1TX][2] >> 24) & 0xFF;
+		base = (rawvalue >> 4) * 10 + (rawvalue & 0xF);
 		_rtl8821ae_phy_set_txpower_by_rate_base(hw, BAND_ON_5G, path, OFDM, RF_1TX, base);
 
-		rawValue = (u16)(rtlphy->tx_power_by_rate_offset[BAND_ON_5G][path][RF_1TX][4] >> 24) & 0xFF;
-		base = (rawValue >> 4) * 10 + (rawValue & 0xF);
+		rawvalue = (u16)(rtlphy->tx_power_by_rate_offset[BAND_ON_5G][path][RF_1TX][4] >> 24) & 0xFF;
+		base = (rawvalue >> 4) * 10 + (rawvalue & 0xF);
 		_rtl8821ae_phy_set_txpower_by_rate_base(hw, BAND_ON_5G, path, HT_MCS0_MCS7, RF_1TX, base);
 
-		rawValue = (u16)(rtlphy->tx_power_by_rate_offset[BAND_ON_5G][path][RF_2TX][6] >> 24) & 0xFF;
-		base = (rawValue >> 4) * 10 + (rawValue & 0xF);
+		rawvalue = (u16)(rtlphy->tx_power_by_rate_offset[BAND_ON_5G][path][RF_2TX][6] >> 24) & 0xFF;
+		base = (rawvalue >> 4) * 10 + (rawvalue & 0xF);
 		_rtl8821ae_phy_set_txpower_by_rate_base(hw, BAND_ON_5G, path, HT_MCS8_MCS15, RF_2TX, base);
 
-		rawValue = (u16)(rtlphy->tx_power_by_rate_offset[BAND_ON_5G][path][RF_1TX][8] >> 24) & 0xFF;
-		base = (rawValue >> 4) * 10 + (rawValue & 0xF);
+		rawvalue = (u16)(rtlphy->tx_power_by_rate_offset[BAND_ON_5G][path][RF_1TX][8] >> 24) & 0xFF;
+		base = (rawvalue >> 4) * 10 + (rawvalue & 0xF);
 		_rtl8821ae_phy_set_txpower_by_rate_base(hw, BAND_ON_5G, path, VHT_1SSMCS0_1SSMCS9, RF_1TX, base);
 
-		rawValue = (u16)(rtlphy->tx_power_by_rate_offset[BAND_ON_5G][path][RF_2TX][11] >> 8) & 0xFF;
-		base = (rawValue >> 4) * 10 + (rawValue & 0xF);
+		rawvalue = (u16)(rtlphy->tx_power_by_rate_offset[BAND_ON_5G][path][RF_2TX][11] >> 8) & 0xFF;
+		base = (rawvalue >> 4) * 10 + (rawvalue & 0xF);
 		_rtl8821ae_phy_set_txpower_by_rate_base(hw, BAND_ON_5G, path, VHT_2SSMCS0_2SSMCS9, RF_2TX, base);
 	}
 }
@@ -1358,7 +1358,7 @@ static void _rtl8812ae_phy_convert_txpower_limit_to_power_index(struct ieee80211
 						}
 
 						RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-							"TxPwrLimit_2_4G[regulation %d][bw %d][rateSection %d][channel %d] = %d\n(TxPwrLimit in dBm %d - BW40PwrLmt2_4G[channel %d][rfPath %d] %d)\n",
+							"TxPwrLimit_2_4G[regulation %d][bw %d][rateSection %d][channel %d] = %d\n(TxPwrLimit in dBm %d - BW40PwrLmt2_4G[channel %d][rfpath %d] %d)\n",
 							regulation, bw, rate_section, channel,
 							rtlphy->txpwr_limit_2_4g[regulation][bw]
 							[rate_section][channel][rf_path], (temp_pwrlmt == 63)
@@ -1423,7 +1423,7 @@ static void _rtl8812ae_phy_convert_txpower_limit_to_power_index(struct ieee80211
 						}
 
 						RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-							"TxPwrLimit_5G[regulation %d][bw %d][rateSection %d][channel %d] =%d\n(TxPwrLimit in dBm %d - BW40PwrLmt5G[chnl group %d][rfPath %d] %d)\n",
+							"TxPwrLimit_5G[regulation %d][bw %d][rateSection %d][channel %d] =%d\n(TxPwrLimit in dBm %d - BW40PwrLmt5G[chnl group %d][rfpath %d] %d)\n",
 							regulation, bw, rate_section,
 							channel, rtlphy->txpwr_limit_5g[regulation]
 							[bw][rate_section][channel][rf_path],
@@ -1473,106 +1473,106 @@ static void _rtl8821ae_phy_convert_txpower_dbm_to_relative_value(struct ieee8021
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &rtlpriv->phy;
-	u8 base = 0, rfPath = 0;
+	u8 base = 0, rfpath = 0;
 
-	for (rfPath = RF90_PATH_A; rfPath <= RF90_PATH_B; ++rfPath) {
-		base = _rtl8821ae_phy_get_txpower_by_rate_base(hw, BAND_ON_2_4G, rfPath, RF_1TX, CCK);
+	for (rfpath = RF90_PATH_A; rfpath <= RF90_PATH_B; ++rfpath) {
+		base = _rtl8821ae_phy_get_txpower_by_rate_base(hw, BAND_ON_2_4G, rfpath, RF_1TX, CCK);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfPath][RF_1TX][0],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfpath][RF_1TX][0],
 			0, 3, base);
 
-		base = _rtl8821ae_phy_get_txpower_by_rate_base(hw, BAND_ON_2_4G, rfPath, RF_1TX, OFDM);
+		base = _rtl8821ae_phy_get_txpower_by_rate_base(hw, BAND_ON_2_4G, rfpath, RF_1TX, OFDM);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfPath][RF_1TX][1],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfpath][RF_1TX][1],
 			0, 3, base);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfPath][RF_1TX][2],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfpath][RF_1TX][2],
 			0, 3, base);
 
-		base = _rtl8821ae_phy_get_txpower_by_rate_base(hw, BAND_ON_2_4G, rfPath, RF_1TX, HT_MCS0_MCS7);
+		base = _rtl8821ae_phy_get_txpower_by_rate_base(hw, BAND_ON_2_4G, rfpath, RF_1TX, HT_MCS0_MCS7);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfPath][RF_1TX][3],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfpath][RF_1TX][3],
 			0, 3, base);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfPath][RF_1TX][4],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfpath][RF_1TX][4],
 			0, 3, base);
 
-		base = _rtl8821ae_phy_get_txpower_by_rate_base(hw, BAND_ON_2_4G, rfPath, RF_2TX, HT_MCS8_MCS15);
+		base = _rtl8821ae_phy_get_txpower_by_rate_base(hw, BAND_ON_2_4G, rfpath, RF_2TX, HT_MCS8_MCS15);
 
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfPath][RF_2TX][5],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfpath][RF_2TX][5],
 			0, 3, base);
 
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfPath][RF_2TX][6],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfpath][RF_2TX][6],
 			0, 3, base);
 
-		base = _rtl8821ae_phy_get_txpower_by_rate_base(hw, BAND_ON_2_4G, rfPath, RF_1TX, VHT_1SSMCS0_1SSMCS9);
+		base = _rtl8821ae_phy_get_txpower_by_rate_base(hw, BAND_ON_2_4G, rfpath, RF_1TX, VHT_1SSMCS0_1SSMCS9);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfPath][RF_1TX][7],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfpath][RF_1TX][7],
 			0, 3, base);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfPath][RF_1TX][8],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfpath][RF_1TX][8],
 			0, 3, base);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfPath][RF_1TX][9],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfpath][RF_1TX][9],
 			0, 1, base);
 
-		base = _rtl8821ae_phy_get_txpower_by_rate_base(hw, BAND_ON_2_4G, rfPath, RF_2TX, VHT_2SSMCS0_2SSMCS9);
+		base = _rtl8821ae_phy_get_txpower_by_rate_base(hw, BAND_ON_2_4G, rfpath, RF_2TX, VHT_2SSMCS0_2SSMCS9);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfPath][RF_1TX][9],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfpath][RF_1TX][9],
 			2, 3, base);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfPath][RF_2TX][10],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfpath][RF_2TX][10],
 			0, 3, base);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfPath][RF_2TX][11],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfpath][RF_2TX][11],
 			0, 3, base);
 
-		base = _rtl8821ae_phy_get_txpower_by_rate_base(hw, BAND_ON_5G, rfPath, RF_1TX, OFDM);
+		base = _rtl8821ae_phy_get_txpower_by_rate_base(hw, BAND_ON_5G, rfpath, RF_1TX, OFDM);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfPath][RF_1TX][1],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfpath][RF_1TX][1],
 			0, 3, base);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfPath][RF_1TX][2],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfpath][RF_1TX][2],
 			0, 3, base);
 
-		base = _rtl8821ae_phy_get_txpower_by_rate_base(hw, BAND_ON_5G, rfPath, RF_1TX, HT_MCS0_MCS7);
+		base = _rtl8821ae_phy_get_txpower_by_rate_base(hw, BAND_ON_5G, rfpath, RF_1TX, HT_MCS0_MCS7);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfPath][RF_1TX][3],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfpath][RF_1TX][3],
 			0, 3, base);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfPath][RF_1TX][4],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfpath][RF_1TX][4],
 			0, 3, base);
 
-		base = _rtl8821ae_phy_get_txpower_by_rate_base(hw, BAND_ON_5G, rfPath, RF_2TX, HT_MCS8_MCS15);
+		base = _rtl8821ae_phy_get_txpower_by_rate_base(hw, BAND_ON_5G, rfpath, RF_2TX, HT_MCS8_MCS15);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfPath][RF_2TX][5],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfpath][RF_2TX][5],
 			0, 3, base);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfPath][RF_2TX][6],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfpath][RF_2TX][6],
 			0, 3, base);
 
-		base = _rtl8821ae_phy_get_txpower_by_rate_base(hw, BAND_ON_5G, rfPath, RF_1TX, VHT_1SSMCS0_1SSMCS9);
+		base = _rtl8821ae_phy_get_txpower_by_rate_base(hw, BAND_ON_5G, rfpath, RF_1TX, VHT_1SSMCS0_1SSMCS9);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfPath][RF_1TX][7],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfpath][RF_1TX][7],
 			0, 3, base);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfPath][RF_1TX][8],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfpath][RF_1TX][8],
 			0, 3, base);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfPath][RF_1TX][9],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfpath][RF_1TX][9],
 			0, 1, base);
 
-		base = _rtl8821ae_phy_get_txpower_by_rate_base(hw, BAND_ON_5G, rfPath, RF_2TX, VHT_2SSMCS0_2SSMCS9);
+		base = _rtl8821ae_phy_get_txpower_by_rate_base(hw, BAND_ON_5G, rfpath, RF_2TX, VHT_2SSMCS0_2SSMCS9);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfPath][RF_1TX][9],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfpath][RF_1TX][9],
 			2, 3, base);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfPath][RF_2TX][10],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfpath][RF_2TX][10],
 			0, 3, base);
 		_phy_convert_txpower_dbm_to_relative_value(
-			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfPath][RF_2TX][11],
+			&rtlphy->tx_power_by_rate_offset[BAND_ON_5G][rfpath][RF_2TX][11],
 			0, 3, base);
 	}
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.h
index e68bd8af4a01..0b087b3b9966 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.h
@@ -37,9 +37,9 @@
 
 #define LOOP_LIMIT				5
 #define MAX_STALL_TIME				50
-#define AntennaDiversityValue			0x80
+#define ANTENNADIVERSITYVALUE			0x80
 #define MAX_TXPWR_IDX_NMODE_92S			63
-#define Reset_Cnt_Limit				3
+#define RESET_CNT_LIMIT				3
 
 #define IQK_ADDA_REG_NUM			16
 #define IQK_MAC_REG_NUM				4
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h
index 3798791626c1..4068b5bae1f7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h
@@ -674,7 +674,7 @@
 #define	EEPROM_CHANNEL_PLAN_TELEC		0x8
 #define	EEPROM_CHANNEL_PLAN_GLOBAL_DOMAIN	0x9
 #define	EEPROM_CHANNEL_PLAN_WORLD_WIDE_13	0xA
-#define	EEPROM_CHANNEL_PLAN_NCC			0xB
+#define	EEPROM_CHANNEL_PLAN_NCC			0XB
 #define	EEPROM_CHANNEL_PLAN_BY_HW_MASK		0x80
 
 #define EEPROM_CID_DEFAULT			0x0
@@ -696,10 +696,10 @@
 
 #define	EEPROM_TX_PWR_INX			0x10
 
-#define	EEPROM_CHANNELPLAN			0xB8
-#define	EEPROM_XTAL_8821AE			0xB9
-#define	EEPROM_THERMAL_METER			0xBA
-#define	EEPROM_IQK_LCK_88E			0xBB
+#define	EEPROM_CHANNELPLAN			0XB8
+#define	EEPROM_XTAL_8821AE			0XB9
+#define	EEPROM_THERMAL_METER			0XBA
+#define	EEPROM_IQK_LCK_88E			0XBB
 
 #define	EEPROM_RF_BOARD_OPTION			0xC1
 #define	EEPROM_RF_FEATURE_OPTION_88E		0xC2
@@ -993,7 +993,7 @@
 #define _LBMODE(x)				(((x) & 0xF) << 24)
 #define MASK_LBMODE				0xF000000
 #define LOOPBACK_NORMAL				0x0
-#define LOOPBACK_IMMEDIATELY			0xB
+#define LOOPBACK_IMMEDIATELY			0XB
 #define LOOPBACK_MAC_DELAY			0x3
 #define LOOPBACK_PHY				0x1
 #define LOOPBACK_DMA				0x7
@@ -1408,7 +1408,7 @@
 #define	RCCK0_FACOUNTERUPPER		0xa58
 #define	RCCK0_CCA_CNT			0xa60
 
-/* PageB(0xB00) */
+/* PageB(0XB00) */
 #define	RPDP_ANTA			0xb00
 #define	RPDP_ANTA_4			0xb04
 #define	RPDP_ANTA_8			0xb08
@@ -1455,16 +1455,16 @@
 #define	RPM_RX3_ANTB			0xbf8
 
 /*RSSI Dump*/
-#define		RA_RSSI_DUMP		0xBF0
-#define		RB_RSSI_DUMP		0xBF1
-#define		RS1_RX_EVM_DUMP		0xBF4
-#define		RS2_RX_EVM_DUMP		0xBF5
-#define		RA_RX_SNR_DUMP		0xBF6
-#define		RB_RX_SNR_DUMP		0xBF7
-#define		RA_CFO_SHORT_DUMP	0xBF8
-#define		RB_CFO_SHORT_DUMP	0xBFA
-#define		RA_CFO_LONG_DUMP	0xBEC
-#define		RB_CFO_LONG_DUMP	0xBEE
+#define		RA_RSSI_DUMP		0XBF0
+#define		RB_RSSI_DUMP		0XBF1
+#define		RS1_RX_EVM_DUMP		0XBF4
+#define		RS2_RX_EVM_DUMP		0XBF5
+#define		RA_RX_SNR_DUMP		0XBF6
+#define		RB_RX_SNR_DUMP		0XBF7
+#define		RA_CFO_SHORT_DUMP	0XBF8
+#define		RB_CFO_SHORT_DUMP	0XBFA
+#define		RA_CFO_LONG_DUMP	0XBEC
+#define		RB_CFO_LONG_DUMP	0XBEE
 
 /*Page C*/
 #define	ROFDM0_LSTF			0xc00
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c
index c9e3adf19e4b..de0d19a9dda1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c
@@ -111,30 +111,30 @@ u32 RTL8812AE_PHY_REG_ARRAY[] = {
 		0xA7C, 0x225B0606,
 		0xA80, 0x218075B2,
 		0xA84, 0x001F8C80,
-		0xB00, 0x03100000,
-		0xB04, 0x0000B000,
-		0xB08, 0xAE0201EB,
-		0xB0C, 0x01003207,
-		0xB10, 0x00009807,
-		0xB14, 0x01000000,
-		0xB18, 0x00000002,
-		0xB1C, 0x00000002,
-		0xB20, 0x0000001F,
-		0xB24, 0x03020100,
-		0xB28, 0x07060504,
-		0xB2C, 0x0B0A0908,
-		0xB30, 0x0F0E0D0C,
-		0xB34, 0x13121110,
-		0xB38, 0x17161514,
-		0xB3C, 0x0000003A,
-		0xB40, 0x00000000,
-		0xB44, 0x00000000,
-		0xB48, 0x13000032,
-		0xB4C, 0x48080000,
-		0xB50, 0x00000000,
-		0xB54, 0x00000000,
-		0xB58, 0x00000000,
-		0xB5C, 0x00000000,
+		0XB00, 0x03100000,
+		0XB04, 0x0000B000,
+		0XB08, 0xAE0201EB,
+		0XB0C, 0x01003207,
+		0XB10, 0x00009807,
+		0XB14, 0x01000000,
+		0XB18, 0x00000002,
+		0XB1C, 0x00000002,
+		0XB20, 0x0000001F,
+		0XB24, 0x03020100,
+		0XB28, 0x07060504,
+		0XB2C, 0x0B0A0908,
+		0XB30, 0x0F0E0D0C,
+		0XB34, 0x13121110,
+		0XB38, 0x17161514,
+		0XB3C, 0x0000003A,
+		0XB40, 0x00000000,
+		0XB44, 0x00000000,
+		0XB48, 0x13000032,
+		0XB4C, 0x48080000,
+		0XB50, 0x00000000,
+		0XB54, 0x00000000,
+		0XB58, 0x00000000,
+		0XB5C, 0x00000000,
 		0xC00, 0x00000007,
 		0xC04, 0x00042020,
 		0xC08, 0x80410231,
@@ -174,7 +174,7 @@ u32 RTL8812AE_PHY_REG_ARRAY[] = {
 		0xC68, 0x59791979,
 	0xA0000000, 0x00000000,
 		0xC68, 0x59799979,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 		0xC6C, 0x59795979,
 		0xC70, 0x19795979,
 		0xC74, 0x19795979,
@@ -344,30 +344,30 @@ u32 RTL8821AE_PHY_REG_ARRAY[] = {
 	0xA7C, 0x225B0606,
 	0xA80, 0x21805490,
 	0xA84, 0x001F0000,
-	0xB00, 0x03100040,
-	0xB04, 0x0000B000,
-	0xB08, 0xAE0201EB,
-	0xB0C, 0x01003207,
-	0xB10, 0x00009807,
-	0xB14, 0x01000000,
-	0xB18, 0x00000002,
-	0xB1C, 0x00000002,
-	0xB20, 0x0000001F,
-	0xB24, 0x03020100,
-	0xB28, 0x07060504,
-	0xB2C, 0x0B0A0908,
-	0xB30, 0x0F0E0D0C,
-	0xB34, 0x13121110,
-	0xB38, 0x17161514,
-	0xB3C, 0x0000003A,
-	0xB40, 0x00000000,
-	0xB44, 0x00000000,
-	0xB48, 0x13000032,
-	0xB4C, 0x48080000,
-	0xB50, 0x00000000,
-	0xB54, 0x00000000,
-	0xB58, 0x00000000,
-	0xB5C, 0x00000000,
+	0XB00, 0x03100040,
+	0XB04, 0x0000B000,
+	0XB08, 0xAE0201EB,
+	0XB0C, 0x01003207,
+	0XB10, 0x00009807,
+	0XB14, 0x01000000,
+	0XB18, 0x00000002,
+	0XB1C, 0x00000002,
+	0XB20, 0x0000001F,
+	0XB24, 0x03020100,
+	0XB28, 0x07060504,
+	0XB2C, 0x0B0A0908,
+	0XB30, 0x0F0E0D0C,
+	0XB34, 0x13121110,
+	0XB38, 0x17161514,
+	0XB3C, 0x0000003A,
+	0XB40, 0x00000000,
+	0XB44, 0x00000000,
+	0XB48, 0x13000032,
+	0XB4C, 0x48080000,
+	0XB50, 0x00000000,
+	0XB54, 0x00000000,
+	0XB58, 0x00000000,
+	0XB5C, 0x00000000,
 	0xC00, 0x00000007,
 	0xC04, 0x00042020,
 	0xC08, 0x80410231,
@@ -498,12 +498,12 @@ u32 RTL8812AE_RADIOA_ARRAY[] = {
 		0x086, 0x00014B3A,
 	0xA0000000, 0x00000000,
 		0x086, 0x00014B38,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 	0x80000004, 0x00000000, 0x40000000, 0x00000000,
 		0x08B, 0x00080180,
 	0xA0000000, 0x00000000,
 		0x08B, 0x00087180,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 		0x0B1, 0x0001FC1A,
 		0x0B3, 0x000F0810,
 		0x0B4, 0x0001A78D,
@@ -534,7 +534,7 @@ u32 RTL8812AE_RADIOA_ARRAY[] = {
 		0x03B, 0x00018248,
 		0x03B, 0x00010240,
 		0x03B, 0x00008240,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 		0x0EF, 0x00000100,
 	0x80000002, 0x00000000, 0x40000000, 0x00000000,
 		0x034, 0x0000A4EE,
@@ -560,7 +560,7 @@ u32 RTL8812AE_RADIOA_ARRAY[] = {
 		0x034, 0x000024E7,
 		0x034, 0x0000146B,
 		0x034, 0x0000006D,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 		0x0EF, 0x00000000,
 		0x0EF, 0x000020A2,
 		0x0DF, 0x00000080,
@@ -689,7 +689,7 @@ u32 RTL8812AE_RADIOA_ARRAY[] = {
 		0x034, 0x000428C5,
 		0x034, 0x000418C2,
 		0x034, 0x000408C0,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 	0x80000008, 0x00000000, 0x40000000, 0x00000000,
 		0x034, 0x0002A0B2,
 		0x034, 0x000290AF,
@@ -726,7 +726,7 @@ u32 RTL8812AE_RADIOA_ARRAY[] = {
 		0x034, 0x000228C5,
 		0x034, 0x000218C2,
 		0x034, 0x000208C0,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 	0x80000008, 0x00000000, 0x40000000, 0x00000000,
 		0x034, 0x0000A0B2,
 		0x034, 0x000090AF,
@@ -763,7 +763,7 @@ u32 RTL8812AE_RADIOA_ARRAY[] = {
 		0x034, 0x000028C9,
 		0x034, 0x000018C6,
 		0x034, 0x000008C3,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 		0x0EF, 0x00000000,
 	0x80000008, 0x00000000, 0x40000000, 0x00000000,
 		0x018, 0x0001712A,
@@ -801,7 +801,7 @@ u32 RTL8812AE_RADIOA_ARRAY[] = {
 		0x035, 0x000401D8,
 		0x035, 0x000481D8,
 		0x035, 0x000501D8,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 		0x0EF, 0x00000000,
 	0x80000008, 0x00000000, 0x40000000, 0x00000000,
 		0x018, 0x0001712A,
@@ -848,7 +848,7 @@ u32 RTL8812AE_RADIOA_ARRAY[] = {
 		0x036, 0x000CCC35,
 		0x036, 0x000D4C35,
 		0x036, 0x000DCC35,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 		0x0EF, 0x00000000,
 		0x0EF, 0x00000008,
 	0x80000008, 0x00000000, 0x40000000, 0x00000000,
@@ -863,7 +863,7 @@ u32 RTL8812AE_RADIOA_ARRAY[] = {
 		0x03C, 0x000002A8,
 		0x03C, 0x000005A2,
 		0x03C, 0x00000880,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 		0x0EF, 0x00000000,
 		0x018, 0x0001712A,
 		0x0EF, 0x00000002,
@@ -887,7 +887,7 @@ u32 RTL8812AE_RADIOA_ARRAY[] = {
 		0x063, 0x000114EB,
 		0x064, 0x000196AC,
 		0x065, 0x000911D7,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 		0x008, 0x00008400,
 		0x01C, 0x000739D2,
 		0x0B4, 0x0001E78D,
@@ -912,12 +912,12 @@ u32 RTL8812AE_RADIOB_ARRAY[] = {
 		0x086, 0x00014B3A,
 	0xA0000000, 0x00000000,
 		0x086, 0x00014B38,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 	0x80000004, 0x00000000, 0x40000000, 0x00000000,
 		0x08B, 0x00080180,
 	0xA0000000, 0x00000000,
 		0x08B, 0x00087180,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 		0x018, 0x00000006,
 		0x0EF, 0x00002000,
 	0x80000001, 0x00000000, 0x40000000, 0x00000000,
@@ -944,7 +944,7 @@ u32 RTL8812AE_RADIOB_ARRAY[] = {
 		0x03B, 0x00018248,
 		0x03B, 0x00010240,
 		0x03B, 0x00008240,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 		0x0EF, 0x00000100,
 	0x80000002, 0x00000000, 0x40000000, 0x00000000,
 		0x034, 0x0000A4EE,
@@ -970,7 +970,7 @@ u32 RTL8812AE_RADIOB_ARRAY[] = {
 		0x034, 0x000024E7,
 		0x034, 0x0000146B,
 		0x034, 0x0000006D,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 		0x0EF, 0x00000000,
 		0x0EF, 0x000020A2,
 		0x0DF, 0x00000080,
@@ -1099,7 +1099,7 @@ u32 RTL8812AE_RADIOB_ARRAY[] = {
 		0x034, 0x000428C5,
 		0x034, 0x000418C2,
 		0x034, 0x000408C0,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 	0x80000008, 0x00000000, 0x40000000, 0x00000000,
 		0x034, 0x0002A0B2,
 		0x034, 0x000290AF,
@@ -1136,7 +1136,7 @@ u32 RTL8812AE_RADIOB_ARRAY[] = {
 		0x034, 0x000228C5,
 		0x034, 0x000218C2,
 		0x034, 0x000208C0,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 	0x80000008, 0x00000000, 0x40000000, 0x00000000,
 		0x034, 0x0000A0B2,
 		0x034, 0x000090AF,
@@ -1173,7 +1173,7 @@ u32 RTL8812AE_RADIOB_ARRAY[] = {
 		0x034, 0x000028C9,
 		0x034, 0x000018C6,
 		0x034, 0x000008C3,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 		0x0EF, 0x00000000,
 	0x80000008, 0x00000000, 0x40000000, 0x00000000,
 		0x018, 0x0001712A,
@@ -1214,7 +1214,7 @@ u32 RTL8812AE_RADIOB_ARRAY[] = {
 		0x035, 0x000481D8,
 		0x035, 0x000501D8,
 		0x0EF, 0x00000000,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 	0x80000008, 0x00000000, 0x40000000, 0x00000000,
 		0x018, 0x0001712A,
 		0x0EF, 0x00000010,
@@ -1260,7 +1260,7 @@ u32 RTL8812AE_RADIOB_ARRAY[] = {
 		0x036, 0x000CCC35,
 		0x036, 0x000D4C35,
 		0x036, 0x000DCC35,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 		0x0EF, 0x00000000,
 		0x0EF, 0x00000008,
 	0x80000008, 0x00000000, 0x40000000, 0x00000000,
@@ -1275,7 +1275,7 @@ u32 RTL8812AE_RADIOB_ARRAY[] = {
 		0x03C, 0x000002A8,
 		0x03C, 0x000005A2,
 		0x03C, 0x00000880,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 		0x0EF, 0x00000000,
 		0x018, 0x0001712A,
 		0x0EF, 0x00000002,
@@ -1304,7 +1304,7 @@ u32 RTL8812AE_RADIOB_ARRAY[] = {
 		0x063, 0x000114EB,
 		0x064, 0x000196AC,
 		0x065, 0x000911D7,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 		0x008, 0x00008400,
 };
 
@@ -1910,7 +1910,7 @@ u32 RTL8812AE_MAC_REG_ARRAY[] = {
 		0x011, 0x00000066,
 	0xA0000000, 0x00000000,
 		0x011, 0x0000005A,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 		0x025, 0x0000000F,
 		0x072, 0x00000000,
 		0x420, 0x00000080,
@@ -2314,7 +2314,7 @@ u32 RTL8812AE_AGC_TAB_ARRAY[] = {
 		0x81C, 0x417A0001,
 		0x81C, 0x417C0001,
 		0x81C, 0x417E0001,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 	0x80000004, 0x00000000, 0x40000000, 0x00000000,
 		0x81C, 0xFC800001,
 		0x81C, 0xFB820001,
@@ -2445,7 +2445,7 @@ u32 RTL8812AE_AGC_TAB_ARRAY[] = {
 		0x81C, 0x01FA0001,
 		0x81C, 0x01FC0001,
 		0x81C, 0x01FE0001,
-	0xB0000000, 0x00000000,
+	0XB0000000, 0x00000000,
 		0xC50, 0x00000022,
 		0xC50, 0x00000020,
 		0xE50, 0x00000022,
@@ -2455,24 +2455,24 @@ u32 RTL8812AE_AGC_TAB_ARRAY[] = {
 u32 RTL8812AE_AGC_TAB_1TARRAYLEN = ARRAY_SIZE(RTL8812AE_AGC_TAB_ARRAY);
 
 u32 RTL8821AE_AGC_TAB_ARRAY[] = {
-		0x81C, 0xBF000001,
-		0x81C, 0xBF020001,
-		0x81C, 0xBF040001,
-		0x81C, 0xBF060001,
-		0x81C, 0xBE080001,
-		0x81C, 0xBD0A0001,
-		0x81C, 0xBC0C0001,
-		0x81C, 0xBA0E0001,
-		0x81C, 0xB9100001,
-		0x81C, 0xB8120001,
-		0x81C, 0xB7140001,
-		0x81C, 0xB6160001,
-		0x81C, 0xB5180001,
-		0x81C, 0xB41A0001,
-		0x81C, 0xB31C0001,
-		0x81C, 0xB21E0001,
-		0x81C, 0xB1200001,
-		0x81C, 0xB0220001,
+		0x81C, 0XBF000001,
+		0x81C, 0XBF020001,
+		0x81C, 0XBF040001,
+		0x81C, 0XBF060001,
+		0x81C, 0XBE080001,
+		0x81C, 0XBD0A0001,
+		0x81C, 0XBC0C0001,
+		0x81C, 0XBA0E0001,
+		0x81C, 0XB9100001,
+		0x81C, 0XB8120001,
+		0x81C, 0XB7140001,
+		0x81C, 0XB6160001,
+		0x81C, 0XB5180001,
+		0x81C, 0XB41A0001,
+		0x81C, 0XB31C0001,
+		0x81C, 0XB21E0001,
+		0x81C, 0XB1200001,
+		0x81C, 0XB0220001,
 		0x81C, 0xAF240001,
 		0x81C, 0xAE260001,
 		0x81C, 0xAD280001,
-- 
2.20.1

