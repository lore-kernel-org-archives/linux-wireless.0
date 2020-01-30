Return-Path: <SRS0=/tVN=3T=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 288ACC2D0DB
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Jan 2020 14:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4B2E206F0
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Jan 2020 14:47:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="mZxFmSX9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgA3Or0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 30 Jan 2020 09:47:26 -0500
Received: from nbd.name ([46.4.11.11]:57444 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727240AbgA3OrW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Jan 2020 09:47:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xvL4Hnoc7Z9n+1o5fDi0PDHmJcWkBY+tOtvloOlnfKw=; b=mZxFmSX9WUWY2yBv2SWnq4oXPx
        FApGIMlqwmfEiSIkS+UAitqb+5Rh/lESlMgmS5Swp/qDw1u2monqol2IGR3lugk8OJ5w7QG/Cbw1J
        s/26fDIXmcKQwaNfB/w/eNXyPyin6oinZ70WubWJeOg+PdItIjNYcTwnSTsU9I6MkstM=;
Received: from [178.162.209.135] (helo=maeck.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1ixB6G-0001Ve-Gw
        for linux-wireless@vger.kernel.org; Thu, 30 Jan 2020 15:47:20 +0100
Received: by maeck.local (Postfix, from userid 501)
        id ECE3B7AE468F; Thu, 30 Jan 2020 15:47:18 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 09/15] mt76: mt7615: add calibration free support for MT7622
Date:   Thu, 30 Jan 2020 15:47:12 +0100
Message-Id: <20200130144718.14298-9-nbd@nbd.name>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200130144718.14298-1-nbd@nbd.name>
References: <20200130144718.14298-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

MT7622 uses fewer efuse overrides than MT7615

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../wireless/mediatek/mt76/mt7615/eeprom.c    | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
index 3c3570332366..0008e4584537 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
@@ -210,6 +210,26 @@ static void mt7615_apply_cal_free_data(struct mt7615_dev *dev)
 		eeprom[ical_nocheck[i]] = otp[ical_nocheck[i]];
 }
 
+static void mt7622_apply_cal_free_data(struct mt7615_dev *dev)
+{
+	static const u16 ical[] = {
+		0x53, 0x54, 0x55, 0x56, 0xf4, 0xf7, 0x144, 0x156, 0x15b
+	};
+	u8 *eeprom = dev->mt76.eeprom.data;
+	u8 *otp = dev->mt76.otp.data;
+	int i;
+
+	if (!otp)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(ical); i++) {
+		if (!otp[ical[i]])
+			continue;
+
+		eeprom[ical[i]] = otp[ical[i]];
+	}
+}
+
 int mt7615_eeprom_init(struct mt7615_dev *dev)
 {
 	int ret;
@@ -222,6 +242,8 @@ int mt7615_eeprom_init(struct mt7615_dev *dev)
 	if (ret && dev->mt76.otp.data)
 		memcpy(dev->mt76.eeprom.data, dev->mt76.otp.data,
 		       MT7615_EEPROM_SIZE);
+	else if (is_mt7622(&dev->mt76))
+		mt7622_apply_cal_free_data(dev);
 	else
 		mt7615_apply_cal_free_data(dev);
 
-- 
2.24.0

