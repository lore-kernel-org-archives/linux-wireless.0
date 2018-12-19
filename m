Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00248C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 03:00:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC6F721850
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 03:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbeLSDAs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 22:00:48 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:16602 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726631AbeLSDAr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 22:00:47 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 714AAC57FC73F;
        Wed, 19 Dec 2018 11:00:44 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.408.0; Wed, 19 Dec 2018
 11:00:36 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <stas.yakovlev@gmail.com>,
        <kvalo@codeaurora.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] ipw2x00: cleanup dead code
Date:   Wed, 19 Dec 2018 11:00:13 +0800
Message-ID: <20181219030013.13736-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix smatch warning:

drivers/net/wireless/intel/ipw2x00/ipw2100.c:5606
 shim__set_security() warn: always true condition '(sec->active_key <= 3) => (0-3 <= 3)'
drivers/net/wireless/intel/ipw2x00/ipw2200.c:10725
 shim__set_security() warn: always true condition '(sec->active_key <= 3) => (0-3 <= 3)'

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 8 ++------
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 7 ++-----
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 6e31687..52e5ed2 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -5603,12 +5603,8 @@ static void shim__set_security(struct net_device *dev,
 
 	if ((sec->flags & SEC_ACTIVE_KEY) &&
 	    priv->ieee->sec.active_key != sec->active_key) {
-		if (sec->active_key <= 3) {
-			priv->ieee->sec.active_key = sec->active_key;
-			priv->ieee->sec.flags |= SEC_ACTIVE_KEY;
-		} else
-			priv->ieee->sec.flags &= ~SEC_ACTIVE_KEY;
-
+		priv->ieee->sec.active_key = sec->active_key;
+		priv->ieee->sec.flags |= SEC_ACTIVE_KEY;
 		priv->status |= STATUS_SECURITY_UPDATED;
 	}
 
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index bbdca13..fa400f9 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -10722,11 +10722,8 @@ static void shim__set_security(struct net_device *dev,
 	}
 
 	if (sec->flags & SEC_ACTIVE_KEY) {
-		if (sec->active_key <= 3) {
-			priv->ieee->sec.active_key = sec->active_key;
-			priv->ieee->sec.flags |= SEC_ACTIVE_KEY;
-		} else
-			priv->ieee->sec.flags &= ~SEC_ACTIVE_KEY;
+		priv->ieee->sec.active_key = sec->active_key;
+		priv->ieee->sec.flags |= SEC_ACTIVE_KEY;
 		priv->status |= STATUS_SECURITY_UPDATED;
 	} else
 		priv->ieee->sec.flags &= ~SEC_ACTIVE_KEY;
-- 
2.7.0


