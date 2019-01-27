Return-Path: <SRS0=DVo7=QD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D122DC282C0
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 11:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A248D2148D
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 11:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfA0LQV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Jan 2019 06:16:21 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42453 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfA0LQV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Jan 2019 06:16:21 -0500
Received: by mail-wr1-f67.google.com with SMTP id q18so14765347wrx.9
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jan 2019 03:16:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DF2l1m1Y6Bjc7DM4HbE1tac1/bXhQr5WJcOZcu0e0m0=;
        b=ojZz8Ir2TTm6M6RNEBhD8iTCwxhsqDsQjCwLd9za2Hn4BhAzGF14mcDTYIbXF56Nv8
         PYiiRKF+zSxrDfH4CbEb2UpL7DoI5VIRi4etmBN7Jr360kWSvZmw95d93iBL301t9JHS
         thU6ioCo0NGQtTtrnMk5tcAS1Yehemgqz7V/n6TlQcs4Q+Eqj4thbq7zWg/RLvW4Onhp
         yjo0CDdq3CTf9hRH/WNopc3A5VCq87/zETmokBcvOvKFCz8l9A3HToz/3RZ5UHNI/b8+
         Q6LPB9oSfFBOnoGpsry1FrVl4czpr1aN6sM/RfIjordi9n8BMg4bASLI25/i0+8HrcWQ
         OUbw==
X-Gm-Message-State: AJcUukfWIVrFAWOdzISgrjleuw7Gc6A0wVoOfFfslsnDn4xropkfprsQ
        pAz1dh3nSFfrc2TIJxHGRsSnqp3RFIahAw==
X-Google-Smtp-Source: ALg8bN5MAyOCaDAqxvcVL/vseIKBW5eYqrxaGV8iPkqh8M6PSQ03JWMZmZzIJtXiMe8c7RAxdjEHbA==
X-Received: by 2002:a5d:4f10:: with SMTP id c16mr18438933wru.177.1548587778565;
        Sun, 27 Jan 2019 03:16:18 -0800 (PST)
Received: from p1372.fit.wifi.vutbr.cz ([147.229.117.36])
        by smtp.gmail.com with ESMTPSA id s16sm95898193wrt.77.2019.01.27.03.16.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 27 Jan 2019 03:16:17 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     nbd@nbd.name, sgruszka@redhat.com
Subject: [PATCH wireless-drivers] mt76x0: eeprom: fix chan_vs_power map in mt76x0_get_power_info
Date:   Sun, 27 Jan 2019 12:15:49 +0100
Message-Id: <44789d3d0dee6e2e0bb7d75f755927d415aa56d4.1548587542.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1548587542.git.lorenzo.bianconi@redhat.com>
References: <cover.1548587542.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Report correct eeprom per channel power value.
Fix chan_vs_power map in mt76x0_get_power_info routine

Fixes: f2a2e819d672 ("mt76x0: remove eeprom dependency from mt76x0_get_power_info")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    | 40 +++++++++----------
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    |  2 +-
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 10 ++---
 3 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 497e762978cc..b2cabce1d74d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -212,24 +212,24 @@ void mt76x0_get_tx_power_per_rate(struct mt76x02_dev *dev)
 	mt76x02_add_rate_power_offset(t, delta);
 }
 
-void mt76x0_get_power_info(struct mt76x02_dev *dev, u8 *info)
+void mt76x0_get_power_info(struct mt76x02_dev *dev, s8 *tp)
 {
 	struct mt76x0_chan_map {
 		u8 chan;
 		u8 offset;
 	} chan_map[] = {
-		{   2,  0 }, {   4,  1 }, {   6,  2 }, {   8,  3 },
-		{  10,  4 }, {  12,  5 }, {  14,  6 }, {  38,  0 },
-		{  44,  1 }, {  48,  2 }, {  54,  3 }, {  60,  4 },
-		{  64,  5 }, { 102,  6 }, { 108,  7 }, { 112,  8 },
-		{ 118,  9 }, { 124, 10 }, { 128, 11 }, { 134, 12 },
-		{ 140, 13 }, { 151, 14 }, { 157, 15 }, { 161, 16 },
-		{ 167, 17 }, { 171, 18 }, { 173, 19 },
+		{   2,  0 }, {   4,  2 }, {   6,  4 }, {   8,  6 },
+		{  10,  8 }, {  12, 10 }, {  14, 12 }, {  38,  0 },
+		{  44,  2 }, {  48,  4 }, {  54,  6 }, {  60,  8 },
+		{  64, 10 }, { 102, 12 }, { 108, 14 }, { 112, 16 },
+		{ 118, 18 }, { 124, 20 }, { 128, 22 }, { 134, 24 },
+		{ 140, 26 }, { 151, 28 }, { 157, 30 }, { 161, 32 },
+		{ 167, 34 }, { 171, 36 }, { 175, 38 },
 	};
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 	u8 offset, addr;
+	int i, idx = 0;
 	u16 data;
-	int i;
 
 	if (mt76x0_tssi_enabled(dev)) {
 		s8 target_power;
@@ -239,14 +239,14 @@ void mt76x0_get_power_info(struct mt76x02_dev *dev, u8 *info)
 		else
 			data = mt76x02_eeprom_get(dev, MT_EE_2G_TARGET_POWER);
 		target_power = (data & 0xff) - dev->mt76.rate_power.ofdm[7];
-		info[0] = target_power + mt76x0_get_delta(dev);
-		info[1] = 0;
+		*tp = target_power + mt76x0_get_delta(dev);
 
 		return;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(chan_map); i++) {
-		if (chan_map[i].chan <= chan->hw_value) {
+		if (chan->hw_value <= chan_map[i].chan) {
+			idx = (chan->hw_value == chan_map[i].chan);
 			offset = chan_map[i].offset;
 			break;
 		}
@@ -258,13 +258,16 @@ void mt76x0_get_power_info(struct mt76x02_dev *dev, u8 *info)
 		addr = MT_EE_TX_POWER_DELTA_BW80 + offset;
 	} else {
 		switch (chan->hw_value) {
+		case 42:
+			offset = 2;
+			break;
 		case 58:
 			offset = 8;
 			break;
 		case 106:
 			offset = 14;
 			break;
-		case 112:
+		case 122:
 			offset = 20;
 			break;
 		case 155:
@@ -277,14 +280,9 @@ void mt76x0_get_power_info(struct mt76x02_dev *dev, u8 *info)
 	}
 
 	data = mt76x02_eeprom_get(dev, addr);
-
-	info[0] = data;
-	if (!info[0] || info[0] > 0x3f)
-		info[0] = 5;
-
-	info[1] = data >> 8;
-	if (!info[1] || info[1] > 0x3f)
-		info[1] = 5;
+	*tp = data >> (8 * idx);
+	if (*tp < 0 || *tp > 0x3f)
+		*tp = 5;
 }
 
 static int mt76x0_check_eeprom(struct mt76x02_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
index ee9ade9f3c8b..42b259f90b6d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
@@ -26,7 +26,7 @@ struct mt76x02_dev;
 int mt76x0_eeprom_init(struct mt76x02_dev *dev);
 void mt76x0_read_rx_gain(struct mt76x02_dev *dev);
 void mt76x0_get_tx_power_per_rate(struct mt76x02_dev *dev);
-void mt76x0_get_power_info(struct mt76x02_dev *dev, u8 *info);
+void mt76x0_get_power_info(struct mt76x02_dev *dev, s8 *tp);
 
 static inline s8 s6_to_s8(u32 val)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 1eb1a802ed20..b6166703ad76 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -845,17 +845,17 @@ static void mt76x0_phy_tssi_calibrate(struct mt76x02_dev *dev)
 void mt76x0_phy_set_txpower(struct mt76x02_dev *dev)
 {
 	struct mt76_rate_power *t = &dev->mt76.rate_power;
-	u8 info[2];
+	s8 info;
 
 	mt76x0_get_tx_power_per_rate(dev);
-	mt76x0_get_power_info(dev, info);
+	mt76x0_get_power_info(dev, &info);
 
-	mt76x02_add_rate_power_offset(t, info[0]);
+	mt76x02_add_rate_power_offset(t, info);
 	mt76x02_limit_rate_power(t, dev->mt76.txpower_conf);
 	dev->mt76.txpower_cur = mt76x02_get_max_rate_power(t);
-	mt76x02_add_rate_power_offset(t, -info[0]);
+	mt76x02_add_rate_power_offset(t, -info);
 
-	mt76x02_phy_set_txpower(dev, info[0], info[1]);
+	mt76x02_phy_set_txpower(dev, info, info);
 }
 
 void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on)
-- 
2.20.1

