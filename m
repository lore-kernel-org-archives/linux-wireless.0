Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 241F0C4320E
	for <linux-wireless@archiver.kernel.org>; Wed,  1 Sep 2021 17:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11A0D610A2
	for <linux-wireless@archiver.kernel.org>; Wed,  1 Sep 2021 17:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346720AbhIARvh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 1 Sep 2021 13:51:37 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:32830 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1347245AbhIARuf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Sep 2021 13:50:35 -0400
X-UUID: 1855732033c247dc9f36526994bfad6f-20210902
X-UUID: 1855732033c247dc9f36526994bfad6f-20210902
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 375468517; Thu, 02 Sep 2021 01:49:36 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 2 Sep 2021 01:49:35 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 2 Sep 2021 01:49:35 +0800
From:   Ryder Lee <ryder.lee@mediatek.com>
To:     Felix Fietkau <nbd@nbd.name>
CC:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Evelyn Tsai <evelyn.tsai@mediatek.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH v5 2/2] mt76: mt7615: fix hwmon temp sensor mem use-after-free
Date:   Thu, 2 Sep 2021 01:49:31 +0800
Message-ID: <650546c0dee92042fc019941786cfdbce2424812.1630515790.git.ryder.lee@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <d72e872e7fdb5c04e890b978575f4d86bc61ad36.1630515789.git.ryder.lee@mediatek.com>
References: <d72e872e7fdb5c04e890b978575f4d86bc61ad36.1630515789.git.ryder.lee@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Without this change, garbage is seen in the hwmon name and sensors output
for mt7615 is garbled.

Fixes: 109e505ad944 ("mt76: mt7615: add thermal sensor device support")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
v5:  Use devm_kstrdup on the wiphy name as suggested.
---
 drivers/net/wireless/mediatek/mt76/mt7615/init.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index 05235a60d413..7c584ca43b2d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -49,12 +49,13 @@ int mt7615_thermal_init(struct mt7615_dev *dev)
 {
 	struct wiphy *wiphy = mt76_hw(dev)->wiphy;
 	struct device *hwmon;
+	const char *name;
 
 	if (!IS_REACHABLE(CONFIG_HWMON))
 		return 0;
 
-	hwmon = devm_hwmon_device_register_with_groups(&wiphy->dev,
-						       wiphy_name(wiphy), dev,
+	name = devm_kstrdup(&wiphy->dev, wiphy_name(wiphy), GFP_KERNEL);
+	hwmon = devm_hwmon_device_register_with_groups(&wiphy->dev, name, dev,
 						       mt7615_hwmon_groups);
 	if (IS_ERR(hwmon))
 		return PTR_ERR(hwmon);
-- 
2.29.2

