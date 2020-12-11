Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D3FAC2BB9A
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Dec 2020 08:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA8C723FB2
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Dec 2020 08:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405568AbgLKIyV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 11 Dec 2020 03:54:21 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9187 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403956AbgLKIx7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Dec 2020 03:53:59 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Csl0d2jmxzkmT9;
        Fri, 11 Dec 2020 16:52:33 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Fri, 11 Dec 2020 16:53:10 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <nbd@nbd.name>, <lorenzo.bianconi83@gmail.com>,
        <kvalo@codeaurora.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <matthias.bgg@gmail.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH wireless -next] wireless: mt76: mt7915: convert comma to semicolon
Date:   Fri, 11 Dec 2020 16:53:38 +0800
Message-ID: <20201211085338.2817-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Replace a comma between expression statements by a semicolon.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 0fd3a16f736a..a2c655c4021f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1676,7 +1676,7 @@ mt7915_mcu_wtbl_ht_tlv(struct sk_buff *skb, struct ieee80211_sta *sta,
 		tlv = mt7915_mcu_add_nested_tlv(skb, WTBL_VHT, sizeof(*vht),
 						wtbl_tlv, sta_wtbl);
 		vht = (struct wtbl_vht *)tlv;
-		vht->ldpc = sta->vht_cap.cap & IEEE80211_VHT_CAP_RXLDPC,
+		vht->ldpc = sta->vht_cap.cap & IEEE80211_VHT_CAP_RXLDPC;
 		vht->vht = true;
 
 		af = FIELD_GET(IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK,
-- 
2.22.0

