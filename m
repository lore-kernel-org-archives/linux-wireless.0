Return-Path: <SRS0=l+aR=RA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42444C10F16
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 12:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1983021734
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 12:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfBYMZi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Feb 2019 07:25:38 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:4164 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726701AbfBYMZi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Feb 2019 07:25:38 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7DB38D4321004B327591;
        Mon, 25 Feb 2019 20:25:33 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.408.0; Mon, 25 Feb 2019 20:25:24 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Johannes Berg <johannes@sipsolutions.net>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH] cfg80211: Use kmemdup in cfg80211_gen_new_ie()
Date:   Mon, 25 Feb 2019 12:38:49 +0000
Message-ID: <20190225123849.50574-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use kmemdup rather than duplicating its implementation

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/wireless/scan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 287518c6caa4..04d888628f29 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -190,10 +190,9 @@ static size_t cfg80211_gen_new_ie(const u8 *ie, size_t ielen,
 	/* copy subelement as we need to change its content to
 	 * mark an ie after it is processed.
 	 */
-	sub_copy = kmalloc(subie_len, gfp);
+	sub_copy = kmemdup(subelement, subie_len, gfp);
 	if (!sub_copy)
 		return 0;
-	memcpy(sub_copy, subelement, subie_len);
 
 	pos = &new_ie[0];



