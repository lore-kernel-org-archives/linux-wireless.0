Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC4A9C43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 03:36:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7682206DD
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 03:36:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfDZDgY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 23:36:24 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:48776 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726006AbfDZDgY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 23:36:24 -0400
X-UUID: a0a9655f5e2349229fe7fa1c18ef80da-20190426
X-UUID: a0a9655f5e2349229fe7fa1c18ef80da-20190426
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw01.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 648824900; Fri, 26 Apr 2019 11:36:20 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 26 Apr 2019 11:36:18 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 26 Apr 2019 11:36:18 +0800
From:   Ryder Lee <ryder.lee@mediatek.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>
CC:     Roy Luo <royluo@google.com>, YF Luo <yf.luo@mediatek.com>,
        Yiwei Chung <yiwei.chung@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH] mt7615: add TX/RX antenna pattern capabilities
Date:   Fri, 26 Apr 2019 11:36:17 +0800
Message-ID: <4f0780666982b3e935f46abcfe434bc68c232fb0.1556249572.git.ryder.lee@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Announce antenna pattern cap to adapt PHY and baseband settings.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7615/init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index 3ab3ff553ef2..122f7a565540 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -190,6 +190,8 @@ int mt7615_register_device(struct mt7615_dev *dev)
 			IEEE80211_VHT_CAP_SHORT_GI_160 |
 			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
 			IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK |
+			IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN |
+			IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN |
 			IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ;
 	dev->mt76.chainmask = 0x404;
 	dev->mt76.antenna_mask = 0xf;
-- 
2.18.0

