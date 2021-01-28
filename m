Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B346C433E0
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Jan 2021 11:59:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA92B60235
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Jan 2021 11:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhA1L65 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Jan 2021 06:58:57 -0500
Received: from m12-14.163.com ([220.181.12.14]:40790 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231277AbhA1L6t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Jan 2021 06:58:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=otN7IfI2auM6c0wAEd
        6hACXJoifBWMuiImQyMfCVNuw=; b=cyk14zuccFKgmS0YdOg9SZ0YOef57qRF6Y
        rEIQPEY2wWO9G+Atb1a9EnfBE33p3zdEF89rL70qEtMWssIcGh9Oept4B76NdVH1
        3oKQ4odY1kwueJVeSLngF9OUA1v6LDHKc0+FAyedkPh2kQqyv1s0D5uuAbQnHp+0
        km5QXeqhI=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp10 (Coremail) with SMTP id DsCowAA3KAR6phJgKQgLiQ--.2729S2;
        Thu, 28 Jan 2021 19:56:43 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] nl80211: ignore the length of hide ssid is zero in scan
Date:   Thu, 28 Jan 2021 19:56:52 +0800
Message-Id: <20210128115652.8564-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: DsCowAA3KAR6phJgKQgLiQ--.2729S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrW3GF1UGry3tw4Utry8Grg_yoW3CrX_ur
        4v9F1vgFyxJ3WUWFW8ua17XrsYk348WFs3C3sIkFy5C3s0qFWDCwn5JF95Jr17Gr1q9Fy8
        G3Z8u34YqF1UujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUYGtCUUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbirBwosVr7sDtEBwAAsA
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

If the length of hide ssid is zero in scan, don't pass
it to driver, which doesn't make any sense.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 net/wireless/nl80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 775d0c4..d62e2aa 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8727,6 +8727,9 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
 				err = -EINVAL;
 				goto out_free;
 			}
+			/* ignore the length of hide ssid is zero */
+			if (nla_len(attr) == 0)
+				continue;
 			request->ssids[i].ssid_len = nla_len(attr);
 			memcpy(request->ssids[i].ssid, nla_data(attr),
 			       nla_len(attr));
-- 
1.9.1


