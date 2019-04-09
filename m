Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67CE1C282CE
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43D8B20857
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfDILh3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 07:37:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51714 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfDILh3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 07:37:29 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5A8A5306C9E6;
        Tue,  9 Apr 2019 11:37:28 +0000 (UTC)
Received: from localhost (ovpn-204-224.brq.redhat.com [10.40.204.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EEFBF18228;
        Tue,  9 Apr 2019 11:37:27 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>,
        Gabor Juhos <juhosg@openwrt.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 04/21] rt2x00: rt2800lib: add channel configuration function for RF3853
Date:   Tue,  9 Apr 2019 13:36:51 +0200
Message-Id: <1554809828-13500-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
References: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 09 Apr 2019 11:37:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 208 +++++++++++++++++++++++++
 1 file changed, 208 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 7e0b2a9631fc..10ea91d45918 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -2872,6 +2872,211 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 	}
 }
 
+static void rt2800_config_channel_rf3853(struct rt2x00_dev *rt2x00dev,
+					 struct ieee80211_conf *conf,
+					 struct rf_channel *rf,
+					 struct channel_info *info)
+{
+	u8 rfcsr;
+	u8 bbp;
+	u8 pwr1, pwr2, pwr3;
+
+	const bool txbf_enabled = false; /* TODO */
+
+	/* TODO: add band selection */
+
+	if (rf->channel <= 14)
+		rt2800_rfcsr_write(rt2x00dev, 6, 0x40);
+	else if (rf->channel < 132)
+		rt2800_rfcsr_write(rt2x00dev, 6, 0x80);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 6, 0x40);
+
+	rt2800_rfcsr_write(rt2x00dev, 8, rf->rf1);
+	rt2800_rfcsr_write(rt2x00dev, 9, rf->rf3);
+
+	if (rf->channel <= 14)
+		rt2800_rfcsr_write(rt2x00dev, 11, 0x46);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 11, 0x48);
+
+	if (rf->channel <= 14)
+		rt2800_rfcsr_write(rt2x00dev, 12, 0x1a);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 12, 0x52);
+
+	rt2800_rfcsr_write(rt2x00dev, 13, 0x12);
+
+	rfcsr = rt2800_rfcsr_read(rt2x00dev, 1);
+	rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR1_RF_BLOCK_EN, 1);
+	rt2x00_set_field8(&rfcsr, RFCSR1_PLL_PD, 1);
+
+	switch (rt2x00dev->default_ant.tx_chain_num) {
+	case 3:
+		rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 1);
+		/* fallthrough */
+	case 2:
+		rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 1);
+		/* fallthrough */
+	case 1:
+		rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 1);
+		break;
+	}
+
+	switch (rt2x00dev->default_ant.rx_chain_num) {
+	case 3:
+		rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 1);
+		/* fallthrough */
+	case 2:
+		rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 1);
+		/* fallthrough */
+	case 1:
+		rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 1);
+		break;
+	}
+	rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
+
+	rt2800_freq_cal_mode1(rt2x00dev);
+
+	rfcsr = rt2800_rfcsr_read(rt2x00dev, 30);
+	if (!conf_is_ht40(conf))
+		rfcsr &= ~(0x06);
+	else
+		rfcsr |= 0x06;
+	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
+
+	if (rf->channel <= 14)
+		rt2800_rfcsr_write(rt2x00dev, 31, 0xa0);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
+
+	if (conf_is_ht40(conf))
+		rt2800_rfcsr_write(rt2x00dev, 32, 0x80);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 32, 0xd8);
+
+	if (rf->channel <= 14)
+		rt2800_rfcsr_write(rt2x00dev, 34, 0x3c);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 34, 0x20);
+
+	/* loopback RF_BS */
+	rfcsr = rt2800_rfcsr_read(rt2x00dev, 36);
+	if (rf->channel <= 14)
+		rt2x00_set_field8(&rfcsr, RFCSR36_RF_BS, 1);
+	else
+		rt2x00_set_field8(&rfcsr, RFCSR36_RF_BS, 0);
+	rt2800_rfcsr_write(rt2x00dev, 36, rfcsr);
+
+	if (rf->channel <= 14)
+		rfcsr = 0x23;
+	else if (rf->channel < 100)
+		rfcsr = 0x36;
+	else if (rf->channel < 132)
+		rfcsr = 0x32;
+	else
+		rfcsr = 0x30;
+
+	if (txbf_enabled)
+		rfcsr |= 0x40;
+
+	rt2800_rfcsr_write(rt2x00dev, 39, rfcsr);
+
+	if (rf->channel <= 14)
+		rt2800_rfcsr_write(rt2x00dev, 44, 0x93);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 44, 0x9b);
+
+	if (rf->channel <= 14)
+		rfcsr = 0xbb;
+	else if (rf->channel < 100)
+		rfcsr = 0xeb;
+	else if (rf->channel < 132)
+		rfcsr = 0xb3;
+	else
+		rfcsr = 0x9b;
+	rt2800_rfcsr_write(rt2x00dev, 45, rfcsr);
+
+	if (rf->channel <= 14)
+		rfcsr = 0x8e;
+	else
+		rfcsr = 0x8a;
+
+	if (txbf_enabled)
+		rfcsr |= 0x20;
+
+	rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
+
+	rt2800_rfcsr_write(rt2x00dev, 50, 0x86);
+
+	rfcsr = rt2800_rfcsr_read(rt2x00dev, 51);
+	if (rf->channel <= 14)
+		rt2800_rfcsr_write(rt2x00dev, 51, 0x75);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 51, 0x51);
+
+	rfcsr = rt2800_rfcsr_read(rt2x00dev, 52);
+	if (rf->channel <= 14)
+		rt2800_rfcsr_write(rt2x00dev, 52, 0x45);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 52, 0x05);
+
+	if (rf->channel <= 14) {
+		pwr1 = info->default_power1 & 0x1f;
+		pwr2 = info->default_power2 & 0x1f;
+		pwr3 = info->default_power3 & 0x1f;
+	} else {
+		pwr1 = 0x48 | ((info->default_power1 & 0x18) << 1) |
+			(info->default_power1 & 0x7);
+		pwr2 = 0x48 | ((info->default_power2 & 0x18) << 1) |
+			(info->default_power2 & 0x7);
+		pwr3 = 0x48 | ((info->default_power3 & 0x18) << 1) |
+			(info->default_power3 & 0x7);
+	}
+
+	rt2800_rfcsr_write(rt2x00dev, 53, pwr1);
+	rt2800_rfcsr_write(rt2x00dev, 54, pwr2);
+	rt2800_rfcsr_write(rt2x00dev, 55, pwr3);
+
+	rt2x00_dbg(rt2x00dev, "Channel:%d, pwr1:%02x, pwr2:%02x, pwr3:%02x\n",
+		   rf->channel, pwr1, pwr2, pwr3);
+
+	bbp = (info->default_power1 >> 5) |
+	      ((info->default_power2 & 0xe0) >> 1);
+	rt2800_bbp_write(rt2x00dev, 109, bbp);
+
+	bbp = rt2800_bbp_read(rt2x00dev, 110);
+	bbp &= 0x0f;
+	bbp |= (info->default_power3 & 0xe0) >> 1;
+	rt2800_bbp_write(rt2x00dev, 110, bbp);
+
+	rfcsr = rt2800_rfcsr_read(rt2x00dev, 57);
+	if (rf->channel <= 14)
+		rt2800_rfcsr_write(rt2x00dev, 57, 0x6e);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 57, 0x3e);
+
+	/* Enable RF tuning */
+	rfcsr = rt2800_rfcsr_read(rt2x00dev, 3);
+	rt2x00_set_field8(&rfcsr, RFCSR3_VCOCAL_EN, 1);
+	rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
+
+	udelay(2000);
+
+	bbp = rt2800_bbp_read(rt2x00dev, 49);
+	/* clear update flag */
+	rt2800_bbp_write(rt2x00dev, 49, bbp & 0xfe);
+	rt2800_bbp_write(rt2x00dev, 49, bbp);
+
+	/* TODO: add calibration for TxBF */
+}
+
 #define POWER_BOUND		0x27
 #define POWER_BOUND_5G		0x2b
 
@@ -3726,6 +3931,9 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	case RF3322:
 		rt2800_config_channel_rf3322(rt2x00dev, conf, rf, info);
 		break;
+	case RF3853:
+		rt2800_config_channel_rf3853(rt2x00dev, conf, rf, info);
+		break;
 	case RF3070:
 	case RF5350:
 	case RF5360:
-- 
2.7.5

