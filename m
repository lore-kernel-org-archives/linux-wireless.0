Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5604BC4360F
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 08:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D68B2082F
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 08:02:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="LH/V2UBS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfCDICk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 03:02:40 -0500
Received: from nbd.name ([46.4.11.11]:40444 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725982AbfCDICk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 03:02:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wUxJiinVZUyjDaz0HKE0zkHSjIa1dTVl7A3f1Dlaprg=; b=LH/V2UBSR/kS08knbSSSjdrFsf
        HrA/3v7MGxxsXP011rE6ykbiECjcE28PBr5+1kXehPQtvHpM7EX69QjhkMcEfuRceRJvhOuQpEwVC
        gkAyRm0JDkQT2U/C1RFydHL5XlaIs6C/A8WPpt2zyhN1lPWt84Utz9f45PCnrg9xUsHY=;
Received: by maeck.lan (Postfix, from userid 501)
        id 1826650E540E; Mon,  4 Mar 2019 09:02:34 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 04/11] mt76: mt76x2: fix 2.4 GHz channel gain settings
Date:   Mon,  4 Mar 2019 09:02:27 +0100
Message-Id: <20190304080234.3221-4-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190304080234.3221-1-nbd@nbd.name>
References: <20190304080234.3221-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

AGC register 35, 37 override for the low gain setting should only be done
on 5 GHz. Also, 2.4 GHz needs a different value for register 35

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt76x2/phy.c   | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
index c7e71f2ba2a7..769a9b972044 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
@@ -285,6 +285,7 @@ void mt76x2_phy_update_channel_gain(struct mt76x02_dev *dev)
 {
 	u8 *gain = dev->cal.agc_gain_init;
 	u8 low_gain_delta, gain_delta;
+	u32 agc_35, agc_37;
 	bool gain_change;
 	int low_gain;
 	u32 val;
@@ -323,6 +324,16 @@ void mt76x2_phy_update_channel_gain(struct mt76x02_dev *dev)
 	else
 		low_gain_delta = 14;
 
+	agc_37 = 0x2121262c;
+	if (dev->mt76.chandef.chan->band == NL80211_BAND_2GHZ)
+		agc_35 = 0x11111516;
+	else if (low_gain == 2)
+		agc_35 = agc_37 = 0x08080808;
+	else if (dev->mt76.chandef.width == NL80211_CHAN_WIDTH_80)
+		agc_35 = 0x10101014;
+	else
+		agc_35 = 0x11111116;
+
 	if (low_gain == 2) {
 		mt76_wr(dev, MT_BBP(RXO, 18), 0xf000a990);
 		mt76_wr(dev, MT_BBP(AGC, 35), 0x08080808);
@@ -331,15 +342,13 @@ void mt76x2_phy_update_channel_gain(struct mt76x02_dev *dev)
 		dev->cal.agc_gain_adjust = 0;
 	} else {
 		mt76_wr(dev, MT_BBP(RXO, 18), 0xf000a991);
-		if (dev->mt76.chandef.width == NL80211_CHAN_WIDTH_80)
-			mt76_wr(dev, MT_BBP(AGC, 35), 0x10101014);
-		else
-			mt76_wr(dev, MT_BBP(AGC, 35), 0x11111116);
-		mt76_wr(dev, MT_BBP(AGC, 37), 0x2121262C);
 		gain_delta = 0;
 		dev->cal.agc_gain_adjust = low_gain_delta;
 	}
 
+	mt76_wr(dev, MT_BBP(AGC, 35), agc_35);
+	mt76_wr(dev, MT_BBP(AGC, 37), agc_37);
+
 	dev->cal.agc_gain_cur[0] = gain[0] - gain_delta;
 	dev->cal.agc_gain_cur[1] = gain[1] - gain_delta;
 	mt76x2_phy_set_gain_val(dev);
-- 
2.17.0

