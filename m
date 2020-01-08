Return-Path: <SRS0=curT=25=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7558DC282DD
	for <linux-wireless@archiver.kernel.org>; Wed,  8 Jan 2020 13:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5546D20705
	for <linux-wireless@archiver.kernel.org>; Wed,  8 Jan 2020 13:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgAHN6F (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 8 Jan 2020 08:58:05 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:58532 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727206AbgAHN6F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Jan 2020 08:58:05 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DB3D44FDA4190C1CA6DA;
        Wed,  8 Jan 2020 21:58:02 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Wed, 8 Jan 2020
 21:57:55 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <kvalo@codeaurora.org>, <arend.vanspriel@broadcom.com>
CC:     <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, yuehaibing <yuehaibing@huawei.com>
Subject: [PATCH] brcmfmac: Remove always false 'idx < 0' statement
Date:   Wed, 8 Jan 2020 21:57:48 +0800
Message-ID: <20200108135748.46096-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: yuehaibing <yuehaibing@huawei.com>

idx is declared as u32, it will never less than 0.

Signed-off-by: yuehaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index e3dd862..8bb4f1f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -365,7 +365,7 @@ brcmf_msgbuf_get_pktid(struct device *dev, struct brcmf_msgbuf_pktids *pktids,
 	struct brcmf_msgbuf_pktid *pktid;
 	struct sk_buff *skb;
 
-	if (idx < 0 || idx >= pktids->array_size) {
+	if (idx >= pktids->array_size) {
 		brcmf_err("Invalid packet id %d (max %d)\n", idx,
 			  pktids->array_size);
 		return NULL;
-- 
2.7.4


