Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5777C10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEC9320857
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfDILhc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 07:37:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49070 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727255AbfDILhc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 07:37:32 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5BEDB308626F;
        Tue,  9 Apr 2019 11:37:32 +0000 (UTC)
Received: from localhost (ovpn-204-224.brq.redhat.com [10.40.204.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F146D5DA2A;
        Tue,  9 Apr 2019 11:37:31 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>,
        Gabor Juhos <juhosg@openwrt.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 06/21] rt2x00: rt2800lib: add MAC register initialization for RT3883
Date:   Tue,  9 Apr 2019 13:36:53 +0200
Message-Id: <1554809828-13500-7-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
References: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 09 Apr 2019 11:37:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800.h    | 14 ++++++++++++++
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 11 +++++++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800.h b/drivers/net/wireless/ralink/rt2x00/rt2800.h
index ddd4b0be04ee..5bfcd48aedab 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800.h
@@ -1728,6 +1728,20 @@
 #define TX_PWR_CFG_9B_STBC_MCS7		FIELD32(0x000000ff)
 
 /*
+ * TX_TXBF_CFG:
+ */
+#define TX_TXBF_CFG_0			0x138c
+#define TX_TXBF_CFG_1			0x13a4
+#define TX_TXBF_CFG_2			0x13a8
+#define TX_TXBF_CFG_3			0x13ac
+
+/*
+ * TX_FBK_CFG_3S:
+ */
+#define TX_FBK_CFG_3S_0			0x13c4
+#define TX_FBK_CFG_3S_1			0x13c8
+
+/*
  * RX_FILTER_CFG: RX configuration register.
  */
 #define RX_FILTER_CFG			0x1400
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 7cebbd2fa044..671b4fec4144 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -5671,6 +5671,12 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 			rt2800_register_write(rt2x00dev, TX_SW_CFG2,
 					      0x00000000);
 		}
+	} else if (rt2x00_rt(rt2x00dev, RT3883)) {
+		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000402);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00040000);
+		rt2800_register_write(rt2x00dev, TX_TXBF_CFG_0, 0x8000fc21);
+		rt2800_register_write(rt2x00dev, TX_TXBF_CFG_3, 0x00009c40);
 	} else if (rt2x00_rt(rt2x00dev, RT5390) ||
 		   rt2x00_rt(rt2x00dev, RT5392) ||
 		   rt2x00_rt(rt2x00dev, RT6352)) {
@@ -5884,6 +5890,11 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	reg = rt2x00_rt(rt2x00dev, RT5592) ? 0x00000082 : 0x00000002;
 	rt2800_register_write(rt2x00dev, TXOP_HLDR_ET, reg);
 
+	if (rt2x00_rt(rt2x00dev, RT3883)) {
+		rt2800_register_write(rt2x00dev, TX_FBK_CFG_3S_0, 0x12111008);
+		rt2800_register_write(rt2x00dev, TX_FBK_CFG_3S_1, 0x16151413);
+	}
+
 	reg = rt2800_register_read(rt2x00dev, TX_RTS_CFG);
 	rt2x00_set_field32(&reg, TX_RTS_CFG_AUTO_RTS_RETRY_LIMIT, 7);
 	rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_THRES,
-- 
2.7.5

