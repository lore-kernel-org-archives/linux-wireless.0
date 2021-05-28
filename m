Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B830AC4707F
	for <linux-wireless@archiver.kernel.org>; Fri, 28 May 2021 01:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93D136100C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 May 2021 01:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234398AbhE1Bse (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 May 2021 21:48:34 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5120 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbhE1Bse (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 May 2021 21:48:34 -0400
Received: from dggeml759-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FrnXy3mlmzYnqS;
        Fri, 28 May 2021 09:44:18 +0800 (CST)
Received: from dggemi762-chm.china.huawei.com (10.1.198.148) by
 dggeml759-chm.china.huawei.com (10.1.199.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 09:46:58 +0800
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 dggemi762-chm.china.huawei.com (10.1.198.148) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 09:46:57 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <nbd@nbd.name>, <lorenzo.bianconi83@gmail.com>,
        <ryder.lee@mediatek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <matthias.bgg@gmail.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] mt76: mt7915: Fix unsigned comparison to zero
Date:   Fri, 28 May 2021 10:05:37 +0800
Message-ID: <1622167537-74981-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi762-chm.china.huawei.com (10.1.198.148)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes coccicheck warnings:

./drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:3450:5-8: WARNING: Unsigned expression compared with zero: idx < 0

Fixes: 495184ac91bb ("mt76: mt7915: add support for applying pre-calibration data")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index b3f14ff..764f25a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -3440,8 +3440,9 @@ int mt7915_mcu_apply_tx_dpd(struct mt7915_phy *phy)
 {
 	struct mt7915_dev *dev = phy->dev;
 	struct cfg80211_chan_def *chandef = &phy->mt76->chandef;
-	u16 total = 2, idx, center_freq = chandef->center_freq1;
+	u16 total = 2, center_freq = chandef->center_freq1;
 	u8 *cal = dev->cal, *eep = dev->mt76.eeprom.data;
+	int idx;
 
 	if (!(eep[MT_EE_DO_PRE_CAL] & MT_EE_WIFI_CAL_DPD))
 		return 0;
-- 
2.6.2

