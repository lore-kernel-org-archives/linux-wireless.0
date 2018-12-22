Return-Path: <SRS0=36rf=O7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D3AC43387
	for <linux-wireless@archiver.kernel.org>; Sat, 22 Dec 2018 18:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 907E22080D
	for <linux-wireless@archiver.kernel.org>; Sat, 22 Dec 2018 18:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390613AbeLVSNC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 22 Dec 2018 13:13:02 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:16649 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731181AbeLVSNC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Dec 2018 13:13:02 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BA5C6AECD71F;
        Sat, 22 Dec 2018 18:27:35 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.408.0; Sat, 22 Dec 2018 18:27:30 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Solomon Peachy <pizza@shaftnet.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-wireless@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] cw1200: fix missing unlock on error in cw1200_hw_scan()
Date:   Sat, 22 Dec 2018 10:34:54 +0000
Message-ID: <1545474894-124328-1-git-send-email-weiyongjun1@huawei.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add the missing unlock before return from function cw1200_hw_scan()
in the error handling case.

Fixes: 4f68ef64cd7f ("cw1200: Fix concurrency use-after-free bugs in cw1200_hw_scan()")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/wireless/st/cw1200/scan.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/st/cw1200/scan.c b/drivers/net/wireless/st/cw1200/scan.c
index 0a9eac9..71e9b91 100644
--- a/drivers/net/wireless/st/cw1200/scan.c
+++ b/drivers/net/wireless/st/cw1200/scan.c
@@ -84,8 +84,11 @@ int cw1200_hw_scan(struct ieee80211_hw *hw,
 
 	frame.skb = ieee80211_probereq_get(hw, priv->vif->addr, NULL, 0,
 		req->ie_len);
-	if (!frame.skb)
+	if (!frame.skb) {
+		mutex_unlock(&priv->conf_mutex);
+		up(&priv->scan.lock);
 		return -ENOMEM;
+	}
 
 	if (req->ie_len)
 		skb_put_data(frame.skb, req->ie, req->ie_len);



