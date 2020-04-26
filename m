Return-Path: <SRS0=0qMy=6K=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77FFCC55191
	for <linux-wireless@archiver.kernel.org>; Sun, 26 Apr 2020 10:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C5002070A
	for <linux-wireless@archiver.kernel.org>; Sun, 26 Apr 2020 10:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgDZKh4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 26 Apr 2020 06:37:56 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38558 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726116AbgDZKh4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 26 Apr 2020 06:37:56 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7F8975337546B9EE2985;
        Sun, 26 Apr 2020 18:37:53 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Sun, 26 Apr 2020
 18:37:43 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <adobriyan@gmail.com>, <tglx@linutronix.de>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <sergei.shtylyov@cogentembedded.com>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v2] ray_cs: use true,false for bool variable
Date:   Sun, 26 Apr 2020 18:37:09 +0800
Message-ID: <20200426103709.6730-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/wireless/ray_cs.c:2797:5-14: WARNING: Comparison of 0/1 to
bool variable
drivers/net/wireless/ray_cs.c:2798:2-11: WARNING: Assignment of 0/1 to
bool variable

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 v2: Fix wrong logic of v1 which made 'translate != 0' to '!translate'.

 drivers/net/wireless/ray_cs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index c1d542bfa530..bf3fbd14eda3 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2794,8 +2794,7 @@ static int __init init_ray_cs(void)
 	proc_create_data("driver/ray_cs/translate", 0200, NULL, &int_proc_ops,
 			 &translate);
 #endif
-	if (translate != 0)
-		translate = 1;
+	translate = !!translate;
 	return 0;
 } /* init_ray_cs */
 
-- 
2.21.1

