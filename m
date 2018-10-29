Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2672C0044C
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 21:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 823CE2082D
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 21:31:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 823CE2082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbeJ3GWL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 02:22:11 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36635 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbeJ3GWK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 02:22:10 -0400
Received: by mail-wr1-f68.google.com with SMTP id y16so10318791wrw.3
        for <linux-wireless@vger.kernel.org>; Mon, 29 Oct 2018 14:31:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wu8TzZvJf1QHxSHL5idUObDhWPvENlh5aZTBKWN5f1g=;
        b=nYlhJrgmYFNDpyBDPNNERnHlGzl0tsGsVAK0rX0CZSqZCqeOOvpPaSSQQQMrJRhIdW
         V7OKxl3ON4iCqFANhpKDTaVtDk+LqJJ/SIzR11+CYGVVjXu1Unekvn00dgOusmveMjju
         RWsu7Jb3MWTizDe5uv5avOGlhavSCcnelXSQu016PwZ6gWR8V8CVyAJiSw5SdIMUMNvy
         FQDcwpPTWOFkge9nSatWYCx7sosRz8uDVMmLxWggFeSVyTZjGUmRRbi5sW70gLCghmCZ
         Ux71M2En3rwJW12iu7VJyE3b5Hx+MevLvr2Q7RU3RnM8Exqxq6NSyknqe2tpgovp0wH0
         OfrA==
X-Gm-Message-State: AGRZ1gIqOD8HCSEH1wIyb+QaLlJb5awrPYGI7oQ5Hg4eGWeDrgOA+Nv6
        WJNxtvoLGg3G6NdZJe4VyoAUFw==
X-Google-Smtp-Source: AJdET5c7khi9cSEuMY11xgnMRQJwvukowqJMMqXPi4FMaLMp7TEWMb/3PZtkWecLz2Fnh7CTS0U07Q==
X-Received: by 2002:a5d:514c:: with SMTP id u12-v6mr15542976wrt.299.1540848699924;
        Mon, 29 Oct 2018 14:31:39 -0700 (PDT)
Received: from localhost.localdomain ([151.66.3.112])
        by smtp.gmail.com with ESMTPSA id c18-v6sm14814981wrr.74.2018.10.29.14.31.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Oct 2018 14:31:39 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] mt76x0: phy: use tssi reported value to configure tx power if available
Date:   Mon, 29 Oct 2018 22:31:25 +0100
Message-Id: <c37c368f443b9f784239f11f81eff0b58602d9fd.1540848411.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1540848411.git.lorenzo.bianconi@redhat.com>
References: <cover.1540848411.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use tssi calibrated value to configure tx power gain if tssi is enabled
in eeprom data

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    | 20 +++++++++++++++----
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  2 +-
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 275d77c90624..497e762978cc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -135,9 +135,6 @@ static s8 mt76x0_get_delta(struct mt76x02_dev *dev)
 	struct cfg80211_chan_def *chandef = &dev->mt76.chandef;
 	u8 val;
 
-	if (mt76x0_tssi_enabled(dev))
-		return 0;
-
 	if (chandef->width == NL80211_CHAN_WIDTH_80) {
 		val = mt76x02_eeprom_get(dev, MT_EE_5G_TARGET_POWER) >> 8;
 	} else if (chandef->width == NL80211_CHAN_WIDTH_40) {
@@ -160,8 +157,8 @@ void mt76x0_get_tx_power_per_rate(struct mt76x02_dev *dev)
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 	bool is_2ghz = chan->band == NL80211_BAND_2GHZ;
 	struct mt76_rate_power *t = &dev->mt76.rate_power;
-	s8 delta = mt76x0_get_delta(dev);
 	u16 val, addr;
+	s8 delta;
 
 	memset(t, 0, sizeof(*t));
 
@@ -211,6 +208,7 @@ void mt76x0_get_tx_power_per_rate(struct mt76x02_dev *dev)
 	t->vht[7] = s6_to_s8(val);
 	t->vht[8] = s6_to_s8(val >> 8);
 
+	delta = mt76x0_tssi_enabled(dev) ? 0 : mt76x0_get_delta(dev);
 	mt76x02_add_rate_power_offset(t, delta);
 }
 
@@ -233,6 +231,20 @@ void mt76x0_get_power_info(struct mt76x02_dev *dev, u8 *info)
 	u16 data;
 	int i;
 
+	if (mt76x0_tssi_enabled(dev)) {
+		s8 target_power;
+
+		if (chan->band == NL80211_BAND_5GHZ)
+			data = mt76x02_eeprom_get(dev, MT_EE_5G_TARGET_POWER);
+		else
+			data = mt76x02_eeprom_get(dev, MT_EE_2G_TARGET_POWER);
+		target_power = (data & 0xff) - dev->mt76.rate_power.ofdm[7];
+		info[0] = target_power + mt76x0_get_delta(dev);
+		info[1] = 0;
+
+		return;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(chan_map); i++) {
 		if (chan_map[i].chan <= chan->hw_value) {
 			offset = chan_map[i].offset;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index f0d46e7bb76a..a4d08655be61 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -847,8 +847,8 @@ void mt76x0_phy_set_txpower(struct mt76x02_dev *dev)
 	struct mt76_rate_power *t = &dev->mt76.rate_power;
 	u8 info[2];
 
-	mt76x0_get_power_info(dev, info);
 	mt76x0_get_tx_power_per_rate(dev);
+	mt76x0_get_power_info(dev, info);
 
 	mt76x02_add_rate_power_offset(t, info[0]);
 	mt76x02_limit_rate_power(t, dev->mt76.txpower_conf);
-- 
2.19.1

