Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C91B2C07E95
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Jul 2021 06:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8CE9613ED
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Jul 2021 06:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbhGPGyF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Jul 2021 02:54:05 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:59670 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S234855AbhGPGyE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jul 2021 02:54:04 -0400
X-UUID: 8449c35c3a0243deba0c0e4d390be4ee-20210716
X-UUID: 8449c35c3a0243deba0c0e4d390be4ee-20210716
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 656483265; Fri, 16 Jul 2021 14:51:07 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 16 Jul 2021 14:51:05 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 16 Jul 2021 14:51:05 +0800
From:   Ryder Lee <ryder.lee@mediatek.com>
To:     Felix Fietkau <nbd@nbd.name>
CC:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Evelyn Tsai <evelyn.tsai@mediatek.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH] mt76: mt7915: add a missing HT flag for GI parsing
Date:   Fri, 16 Jul 2021 14:51:04 +0800
Message-ID: <33b73201d9444cbea54ca527e2c7910e8d32a177.1626417924.git.ryder.lee@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The previous commit missed a HT flag.

Fixes: 14b220c07188 ("mt76: mt7915: report tx rate directly from tx status")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
@Felix, please help to fold this into the previous commit. Sorry for the inconvenience.
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index b74db3e61098..4c17d1169108 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -205,7 +205,8 @@ static void mt7915_mac_sta_poll(struct mt7915_dev *dev)
 			u8 offs = 24 + 2 * bw;
 
 			rate->he_gi = (val & (0x3 << offs)) >> offs;
-		} else if (rate->flags & RATE_INFO_FLAGS_VHT_MCS) {
+		} else if (rate->flags &
+			   (RATE_INFO_FLAGS_VHT_MCS | RATE_INFO_FLAGS_MCS)) {
 			if (val & BIT(12 + bw))
 				rate->flags |= RATE_INFO_FLAGS_SHORT_GI;
 			else
-- 
2.29.2

