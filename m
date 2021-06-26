Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5636C49EA6
	for <linux-wireless@archiver.kernel.org>; Sat, 26 Jun 2021 10:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA6986192F
	for <linux-wireless@archiver.kernel.org>; Sat, 26 Jun 2021 10:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhFZKoo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 26 Jun 2021 06:44:44 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12031 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhFZKoo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 26 Jun 2021 06:44:44 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GBr2q6CbRzZjyt;
        Sat, 26 Jun 2021 18:39:15 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 26 Jun 2021 18:42:19 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 26
 Jun 2021 18:42:18 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <kuba@kernel.org>, <periyasa@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] mac80211: Reject zero MAC address in sta_info_insert_check()
Date:   Sat, 26 Jun 2021 18:38:56 +0800
Message-ID: <20210626103856.19816-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

As commit 52dba8d7d5ab ("mac80211: reject zero MAC address in add station")
said, we don't consider all-zeroes to be a valid MAC address in most places,
so also reject it here.

Reported-by: syzbot+ef4ca92d9d6f5ba2f880@syzkaller.appspotmail.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/mac80211/sta_info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f2fb69da9b6e..3a6887fc9160 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -547,7 +547,7 @@ static int sta_info_insert_check(struct sta_info *sta)
 		return -ENETDOWN;
 
 	if (WARN_ON(ether_addr_equal(sta->sta.addr, sdata->vif.addr) ||
-		    is_multicast_ether_addr(sta->sta.addr)))
+		    is_valid_ether_addr(sta->sta.addr)))
 		return -EINVAL;
 
 	/* The RCU read lock is required by rhashtable due to
-- 
2.17.1

