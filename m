Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D822C432BE
	for <linux-wireless@archiver.kernel.org>; Wed,  1 Sep 2021 02:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17B7260F12
	for <linux-wireless@archiver.kernel.org>; Wed,  1 Sep 2021 02:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbhIAC4Q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 31 Aug 2021 22:56:16 -0400
Received: from mail-m17644.qiye.163.com ([59.111.176.44]:40410 "EHLO
        mail-m17644.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbhIAC4Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Aug 2021 22:56:16 -0400
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Aug 2021 22:56:15 EDT
Received: from wanjb-virtual-machine.localdomain (unknown [58.213.83.158])
        by mail-m17644.qiye.163.com (Hmail) with ESMTPA id 6F3D03201D2;
        Wed,  1 Sep 2021 10:47:54 +0800 (CST)
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] p54: Remove obsolete comment
Date:   Wed,  1 Sep 2021 10:47:44 +0800
Message-Id: <20210901024744.7013-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUhPN1dZLVlBSVdZDwkaFQgSH1lBWRlCS0xWS0xJSklKGE5CHU
        weVRMBExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkNVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nz46Txw4Mj9WVkgOTkg4PCsU
        SBRPCj5VSlVKTUhLT01PT0xPQk1CVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlO
        Q1VJSkhVQ0hVSk5DWVdZCAFZQUpCSkg3Bg++
X-HM-Tid: 0a7b9f417debd99akuws6f3d03201d2
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In commit d249ff28b1d8 ("intersil: remove obsolete prism54 wireless driver"),
prism54/isl_oid.h is deleted. The comment here is obsolete.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/wireless/intersil/p54/fwio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/p54/fwio.c b/drivers/net/wireless/intersil/p54/fwio.c
index bece14e4ff0d..1fe072de3e63 100644
--- a/drivers/net/wireless/intersil/p54/fwio.c
+++ b/drivers/net/wireless/intersil/p54/fwio.c
@@ -583,7 +583,6 @@ int p54_set_edcf(struct p54_common *priv)
 	rtd = 3 * priv->coverage_class;
 	edcf->slottime += rtd;
 	edcf->round_trip_delay = cpu_to_le16(rtd);
-	/* (see prism54/isl_oid.h for further details) */
 	edcf->frameburst = cpu_to_le16(0);
 	edcf->flags = 0;
 	memset(edcf->mapping, 0, sizeof(edcf->mapping));
-- 
2.25.1

