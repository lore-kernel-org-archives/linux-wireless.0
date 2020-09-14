Return-Path: <SRS0=QEcO=CX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74779C43461
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Sep 2020 03:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B4DE206DC
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Sep 2020 03:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgINDzj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 13 Sep 2020 23:55:39 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45110 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726010AbgINDzV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 13 Sep 2020 23:55:21 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6A42718915B87E4F904A;
        Mon, 14 Sep 2020 11:55:17 +0800 (CST)
Received: from huawei.com (10.175.113.32) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Mon, 14 Sep 2020
 11:55:11 +0800
From:   Liu Shixin <liushixin2@huawei.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "Matthias Brugger" <matthias.bgg@gmail.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH -next] mt76: mt7915: convert to use le16_add_cpu()
Date:   Mon, 14 Sep 2020 12:17:50 +0800
Message-ID: <20200914041750.3702052-1-liushixin2@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.32]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Convert cpu_to_le16(le16_to_cpu(E1) + E2) to use le16_add_cpu().

Signed-off-by: Liu Shixin <liushixin2@huawei.com>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index ac8ec257da03..8f0b67d0e93e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -714,8 +714,8 @@ mt7915_mcu_add_nested_subtlv(struct sk_buff *skb, int sub_tag, int sub_len,
 	ptlv = skb_put(skb, sub_len);
 	memcpy(ptlv, &tlv, sizeof(tlv));
 
-	*sub_ntlv = cpu_to_le16(le16_to_cpu(*sub_ntlv) + 1);
-	*len = cpu_to_le16(le16_to_cpu(*len) + sub_len);
+	le16_add_cpu(sub_ntlv, 1);
+	le16_add_cpu(len, sub_len);
 
 	return ptlv;
 }
-- 
2.25.1

