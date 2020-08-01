Return-Path: <SRS0=tmyr=BL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88534C433DF
	for <linux-wireless@archiver.kernel.org>; Sat,  1 Aug 2020 09:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 720432076A
	for <linux-wireless@archiver.kernel.org>; Sat,  1 Aug 2020 09:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbgHAJN0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 1 Aug 2020 05:13:26 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:54410 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725876AbgHAJN0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Aug 2020 05:13:26 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D4254CCF6278C7BA1681;
        Sat,  1 Aug 2020 17:13:19 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Sat, 1 Aug 2020
 17:13:13 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: [PATCH] nl80211: use eth_zero_addr() to clear mac address
Date:   Sat, 1 Aug 2020 17:15:49 +0800
Message-ID: <1596273349-24333-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

Use eth_zero_addr() to clear mac address instead of memset().

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/wireless/nl80211.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7fbca0854265..c88f9d09cb25 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10394,8 +10394,7 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 			memcpy(dev->ieee80211_ptr->disconnect_bssid,
 			       connect.bssid, ETH_ALEN);
 		else
-			memset(dev->ieee80211_ptr->disconnect_bssid,
-			       0, ETH_ALEN);
+			eth_zero_addr(dev->ieee80211_ptr->disconnect_bssid);
 	}
 
 	wdev_unlock(dev->ieee80211_ptr);
-- 
2.19.1

