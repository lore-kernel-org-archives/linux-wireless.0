Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C14C10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9056C20857
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbfDILhm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 07:37:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43358 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfDILhm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 07:37:42 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0A1808552A;
        Tue,  9 Apr 2019 11:37:42 +0000 (UTC)
Received: from localhost (ovpn-204-224.brq.redhat.com [10.40.204.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BFD35D71E;
        Tue,  9 Apr 2019 11:37:41 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>,
        Gabor Juhos <juhosg@openwrt.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 12/21] rt2x00: rt2800lib: add channel configuration code for RT3883
Date:   Tue,  9 Apr 2019 13:36:59 +0200
Message-Id: <1554809828-13500-13-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
References: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 09 Apr 2019 11:37:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 72 ++++++++++++++++++++++++--
 1 file changed, 69 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index d95cb89309b4..216f5c87b084 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -3894,6 +3894,36 @@ static char rt2800_txpower_to_dev(struct rt2x00_dev *rt2x00dev,
 		return clamp_t(char, txpower, MIN_A_TXPOWER, MAX_A_TXPOWER);
 }
 
+static void rt3883_bbp_adjust(struct rt2x00_dev *rt2x00dev,
+			      struct rf_channel *rf)
+{
+	u8 bbp;
+
+	bbp = (rf->channel > 14) ? 0x48 : 0x38;
+	rt2800_bbp_write_with_rx_chain(rt2x00dev, 66, bbp);
+
+	rt2800_bbp_write(rt2x00dev, 69, 0x12);
+
+	if (rf->channel <= 14) {
+		rt2800_bbp_write(rt2x00dev, 70, 0x0a);
+	} else {
+		/* Disable CCK packet detection */
+		rt2800_bbp_write(rt2x00dev, 70, 0x00);
+	}
+
+	rt2800_bbp_write(rt2x00dev, 73, 0x10);
+
+	if (rf->channel > 14) {
+		rt2800_bbp_write(rt2x00dev, 62, 0x1d);
+		rt2800_bbp_write(rt2x00dev, 63, 0x1d);
+		rt2800_bbp_write(rt2x00dev, 64, 0x1d);
+	} else {
+		rt2800_bbp_write(rt2x00dev, 62, 0x2d);
+		rt2800_bbp_write(rt2x00dev, 63, 0x2d);
+		rt2800_bbp_write(rt2x00dev, 64, 0x2d);
+	}
+}
+
 static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 				  struct ieee80211_conf *conf,
 				  struct rf_channel *rf,
@@ -3912,6 +3942,12 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 			rt2800_txpower_to_dev(rt2x00dev, rf->channel,
 					      info->default_power3);
 
+	switch (rt2x00dev->chip.rt) {
+	case RT3883:
+		rt3883_bbp_adjust(rt2x00dev, rf);
+		break;
+	}
+
 	switch (rt2x00dev->chip.rf) {
 	case RF2020:
 	case RF3020:
@@ -4016,6 +4052,15 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		rt2800_bbp_write(rt2x00dev, 63, 0x37 - rt2x00dev->lna_gain);
 		rt2800_bbp_write(rt2x00dev, 64, 0x37 - rt2x00dev->lna_gain);
 		rt2800_bbp_write(rt2x00dev, 77, 0x98);
+	} else if (rt2x00_rt(rt2x00dev, RT3883)) {
+		rt2800_bbp_write(rt2x00dev, 62, 0x37 - rt2x00dev->lna_gain);
+		rt2800_bbp_write(rt2x00dev, 63, 0x37 - rt2x00dev->lna_gain);
+		rt2800_bbp_write(rt2x00dev, 64, 0x37 - rt2x00dev->lna_gain);
+
+		if (rt2x00dev->default_ant.rx_chain_num > 1)
+			rt2800_bbp_write(rt2x00dev, 86, 0x46);
+		else
+			rt2800_bbp_write(rt2x00dev, 86, 0);
 	} else {
 		rt2800_bbp_write(rt2x00dev, 62, 0x37 - rt2x00dev->lna_gain);
 		rt2800_bbp_write(rt2x00dev, 63, 0x37 - rt2x00dev->lna_gain);
@@ -4029,6 +4074,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		    !rt2x00_rt(rt2x00dev, RT6352)) {
 			if (rt2x00_has_cap_external_lna_bg(rt2x00dev)) {
 				rt2800_bbp_write(rt2x00dev, 82, 0x62);
+				rt2800_bbp_write(rt2x00dev, 82, 0x62);
 				rt2800_bbp_write(rt2x00dev, 75, 0x46);
 			} else {
 				if (rt2x00_rt(rt2x00dev, RT3593))
@@ -4037,19 +4083,22 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 					rt2800_bbp_write(rt2x00dev, 82, 0x84);
 				rt2800_bbp_write(rt2x00dev, 75, 0x50);
 			}
-			if (rt2x00_rt(rt2x00dev, RT3593))
+			if (rt2x00_rt(rt2x00dev, RT3593) ||
+			    rt2x00_rt(rt2x00dev, RT3883))
 				rt2800_bbp_write(rt2x00dev, 83, 0x8a);
 		}
 
 	} else {
 		if (rt2x00_rt(rt2x00dev, RT3572))
 			rt2800_bbp_write(rt2x00dev, 82, 0x94);
-		else if (rt2x00_rt(rt2x00dev, RT3593))
+		else if (rt2x00_rt(rt2x00dev, RT3593) ||
+			 rt2x00_rt(rt2x00dev, RT3883))
 			rt2800_bbp_write(rt2x00dev, 82, 0x82);
 		else if (!rt2x00_rt(rt2x00dev, RT6352))
 			rt2800_bbp_write(rt2x00dev, 82, 0xf2);
 
-		if (rt2x00_rt(rt2x00dev, RT3593))
+		if (rt2x00_rt(rt2x00dev, RT3593) ||
+		    rt2x00_rt(rt2x00dev, RT3883))
 			rt2800_bbp_write(rt2x00dev, 83, 0x9a);
 
 		if (rt2x00_has_cap_external_lna_a(rt2x00dev))
@@ -4185,6 +4234,23 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		usleep_range(1000, 1500);
 	}
 
+	if (rt2x00_rt(rt2x00dev, RT3883)) {
+		if (!conf_is_ht40(conf))
+			rt2800_bbp_write(rt2x00dev, 105, 0x34);
+		else
+			rt2800_bbp_write(rt2x00dev, 105, 0x04);
+
+		/* AGC init */
+		if (rf->channel <= 14)
+			reg = 0x2e + rt2x00dev->lna_gain;
+		else
+			reg = 0x20 + ((rt2x00dev->lna_gain * 5) / 3);
+
+		rt2800_bbp_write_with_rx_chain(rt2x00dev, 66, reg);
+
+		usleep_range(1000, 1500);
+	}
+
 	if (rt2x00_rt(rt2x00dev, RT5592) || rt2x00_rt(rt2x00dev, RT6352)) {
 		reg = 0x10;
 		if (!conf_is_ht40(conf)) {
-- 
2.7.5

