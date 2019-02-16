Return-Path: <SRS0=K8Xh=QX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18CC4C10F00
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Feb 2019 09:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E260A222DD
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Feb 2019 09:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731875AbfBPJdd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Feb 2019 04:33:33 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:34598 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727354AbfBPJdc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Feb 2019 04:33:32 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A91D219B0674F6E5AD39;
        Sat, 16 Feb 2019 17:33:25 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.408.0; Sat, 16 Feb 2019 17:33:21 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH net-next] cfg80211: pmsr: use eth_broadcast_addr() to assign broadcast address
Date:   Sat, 16 Feb 2019 17:47:10 +0800
Message-ID: <20190216094710.127182-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch is to use eth_broadcast_addr() to assign broadcast address
insetad of memset().

Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 net/wireless/pmsr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index de9286703280..21139b82749f 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -258,7 +258,7 @@ int nl80211_pmsr_start(struct sk_buff *skb, struct genl_info *info)
 	} else {
 		memcpy(req->mac_addr, nla_data(info->attrs[NL80211_ATTR_MAC]),
 		       ETH_ALEN);
-		memset(req->mac_addr_mask, 0xff, ETH_ALEN);
+		eth_broadcast_addr(req->mac_addr_mask);
 	}
 
 	idx = 0;
-- 
2.20.1

