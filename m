Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E86B1C282CE
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDD2F20857
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbfDILhi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 07:37:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40788 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfDILhh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 07:37:37 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 521422D7F6;
        Tue,  9 Apr 2019 11:37:37 +0000 (UTC)
Received: from localhost (ovpn-204-224.brq.redhat.com [10.40.204.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E6D5B5C73E;
        Tue,  9 Apr 2019 11:37:36 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>,
        Gabor Juhos <juhosg@openwrt.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 09/21] rt2x00: rt2800lib: add RFCSR initialization for RT3883
Date:   Tue,  9 Apr 2019 13:36:56 +0200
Message-Id: <1554809828-13500-10-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
References: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 09 Apr 2019 11:37:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800.h    |   1 +
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 141 +++++++++++++++++++++++++
 2 files changed, 142 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800.h b/drivers/net/wireless/ralink/rt2x00/rt2800.h
index 5bfcd48aedab..06c38bafd2ca 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800.h
@@ -2312,6 +2312,7 @@ struct mac_iveiv_entry {
 /*
  * RFCSR 2:
  */
+#define RFCSR2_RESCAL_BP		FIELD8(0x40)
 #define RFCSR2_RESCAL_EN		FIELD8(0x80)
 #define RFCSR2_RX2_EN_MT7620		FIELD8(0x02)
 #define RFCSR2_TX2_EN_MT7620		FIELD8(0x20)
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index c6a3e02cd6dd..02f74ace217d 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -7870,6 +7870,144 @@ static void rt2800_init_rfcsr_5350(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
 }
 
+static void rt2800_init_rfcsr_3883(struct rt2x00_dev *rt2x00dev)
+{
+	u8 rfcsr;
+
+	/* TODO: get the actual ECO value from the SoC */
+	const unsigned int eco = 5;
+
+	rt2800_rf_init_calibration(rt2x00dev, 2);
+
+	rt2800_rfcsr_write(rt2x00dev, 0, 0xe0);
+	rt2800_rfcsr_write(rt2x00dev, 1, 0x03);
+	rt2800_rfcsr_write(rt2x00dev, 2, 0x50);
+	rt2800_rfcsr_write(rt2x00dev, 3, 0x20);
+	rt2800_rfcsr_write(rt2x00dev, 4, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 5, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 6, 0x40);
+	rt2800_rfcsr_write(rt2x00dev, 7, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 8, 0x5b);
+	rt2800_rfcsr_write(rt2x00dev, 9, 0x08);
+	rt2800_rfcsr_write(rt2x00dev, 10, 0xd3);
+	rt2800_rfcsr_write(rt2x00dev, 11, 0x48);
+	rt2800_rfcsr_write(rt2x00dev, 12, 0x1a);
+	rt2800_rfcsr_write(rt2x00dev, 13, 0x12);
+	rt2800_rfcsr_write(rt2x00dev, 14, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 15, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 16, 0x00);
+
+	/* RFCSR 17 will be initialized later based on the
+	 * frequency offset stored in the EEPROM
+	 */
+
+	rt2800_rfcsr_write(rt2x00dev, 18, 0x40);
+	rt2800_rfcsr_write(rt2x00dev, 19, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 20, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 21, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 22, 0x20);
+	rt2800_rfcsr_write(rt2x00dev, 23, 0xc0);
+	rt2800_rfcsr_write(rt2x00dev, 24, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 25, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 26, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 27, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 28, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 29, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 30, 0x10);
+	rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 32, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 33, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 34, 0x20);
+	rt2800_rfcsr_write(rt2x00dev, 35, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 36, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 37, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 38, 0x86);
+	rt2800_rfcsr_write(rt2x00dev, 39, 0x23);
+	rt2800_rfcsr_write(rt2x00dev, 40, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 41, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 42, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 43, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 44, 0x93);
+	rt2800_rfcsr_write(rt2x00dev, 45, 0xbb);
+	rt2800_rfcsr_write(rt2x00dev, 46, 0x60);
+	rt2800_rfcsr_write(rt2x00dev, 47, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 48, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 49, 0x8e);
+	rt2800_rfcsr_write(rt2x00dev, 50, 0x86);
+	rt2800_rfcsr_write(rt2x00dev, 51, 0x51);
+	rt2800_rfcsr_write(rt2x00dev, 52, 0x05);
+	rt2800_rfcsr_write(rt2x00dev, 53, 0x76);
+	rt2800_rfcsr_write(rt2x00dev, 54, 0x76);
+	rt2800_rfcsr_write(rt2x00dev, 55, 0x76);
+	rt2800_rfcsr_write(rt2x00dev, 56, 0xdb);
+	rt2800_rfcsr_write(rt2x00dev, 57, 0x3e);
+	rt2800_rfcsr_write(rt2x00dev, 58, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 59, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 60, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 61, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 62, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
+
+	/* TODO: rx filter calibration? */
+
+	rt2800_bbp_write(rt2x00dev, 137, 0x0f);
+
+	rt2800_bbp_write(rt2x00dev, 163, 0x9d);
+
+	rt2800_bbp_write(rt2x00dev, 105, 0x05);
+
+	rt2800_bbp_write(rt2x00dev, 179, 0x02);
+	rt2800_bbp_write(rt2x00dev, 180, 0x00);
+	rt2800_bbp_write(rt2x00dev, 182, 0x40);
+	rt2800_bbp_write(rt2x00dev, 180, 0x01);
+	rt2800_bbp_write(rt2x00dev, 182, 0x9c);
+
+	rt2800_bbp_write(rt2x00dev, 179, 0x00);
+
+	rt2800_bbp_write(rt2x00dev, 142, 0x04);
+	rt2800_bbp_write(rt2x00dev, 143, 0x3b);
+	rt2800_bbp_write(rt2x00dev, 142, 0x06);
+	rt2800_bbp_write(rt2x00dev, 143, 0xa0);
+	rt2800_bbp_write(rt2x00dev, 142, 0x07);
+	rt2800_bbp_write(rt2x00dev, 143, 0xa1);
+	rt2800_bbp_write(rt2x00dev, 142, 0x08);
+	rt2800_bbp_write(rt2x00dev, 143, 0xa2);
+	rt2800_bbp_write(rt2x00dev, 148, 0xc8);
+
+	if (eco == 5) {
+		rt2800_rfcsr_write(rt2x00dev, 32, 0xd8);
+		rt2800_rfcsr_write(rt2x00dev, 33, 0x32);
+	}
+
+	rfcsr = rt2800_rfcsr_read(rt2x00dev, 2);
+	rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_BP, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 1);
+	rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
+	msleep(1);
+	rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 0);
+	rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
+
+	rfcsr = rt2800_rfcsr_read(rt2x00dev, 1);
+	rt2x00_set_field8(&rfcsr, RFCSR1_RF_BLOCK_EN, 1);
+	rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
+
+	rfcsr = rt2800_rfcsr_read(rt2x00dev, 6);
+	rfcsr |= 0xc0;
+	rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
+
+	rfcsr = rt2800_rfcsr_read(rt2x00dev, 22);
+	rfcsr |= 0x20;
+	rt2800_rfcsr_write(rt2x00dev, 22, rfcsr);
+
+	rfcsr = rt2800_rfcsr_read(rt2x00dev, 46);
+	rfcsr |= 0x20;
+	rt2800_rfcsr_write(rt2x00dev, 46, rfcsr);
+
+	rfcsr = rt2800_rfcsr_read(rt2x00dev, 20);
+	rfcsr &= ~0xee;
+	rt2800_rfcsr_write(rt2x00dev, 20, rfcsr);
+}
+
 static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
 {
 	rt2800_rf_init_calibration(rt2x00dev, 2);
@@ -8712,6 +8850,9 @@ static void rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	case RT3390:
 		rt2800_init_rfcsr_3390(rt2x00dev);
 		break;
+	case RT3883:
+		rt2800_init_rfcsr_3883(rt2x00dev);
+		break;
 	case RT3572:
 		rt2800_init_rfcsr_3572(rt2x00dev);
 		break;
-- 
2.7.5

