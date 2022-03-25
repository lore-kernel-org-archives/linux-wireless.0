Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B36C433FE
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Mar 2022 10:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356264AbiCYKSw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Mar 2022 06:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238206AbiCYKSv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Mar 2022 06:18:51 -0400
Received: from mail.meizu.com (edge05.meizu.com [157.122.146.251])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AE379380;
        Fri, 25 Mar 2022 03:17:17 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail12.meizu.com
 (172.16.1.108) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 25 Mar
 2022 18:17:16 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Fri, 25 Mar
 2022 18:17:14 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     <kvalo@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <linux-wireless@vger.kernel.org>, <b43-dev@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Haowen Bai <baihaowen@meizu.com>
Subject: [PATCH V3] b43legacy: Fix assigning negative value to unsigned variable
Date:   Fri, 25 Mar 2022 18:17:13 +0800
Message-ID: <1648203433-8736-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-125.meizu.com (172.16.1.125) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

fix warning reported by smatch:
drivers/net/wireless/broadcom/b43legacy/phy.c:1181 b43legacy_phy_lo_b_measure()
warn: assigning (-772) to unsigned variable 'fval'

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
V1->V2: modify title of this patch
V2->V3: modify prefix of title b43legacy

 drivers/net/wireless/broadcom/b43legacy/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/phy.c b/drivers/net/wireless/broadcom/b43legacy/phy.c
index 05404fb..c1395e6 100644
--- a/drivers/net/wireless/broadcom/b43legacy/phy.c
+++ b/drivers/net/wireless/broadcom/b43legacy/phy.c
@@ -1123,7 +1123,7 @@ void b43legacy_phy_lo_b_measure(struct b43legacy_wldev *dev)
 	struct b43legacy_phy *phy = &dev->phy;
 	u16 regstack[12] = { 0 };
 	u16 mls;
-	u16 fval;
+	s16 fval;
 	int i;
 	int j;
 
-- 
2.7.4

