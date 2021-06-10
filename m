Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FROM_LOCAL_DIGITS,FROM_LOCAL_HEX,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B0FC48BCF
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jun 2021 00:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85034613E4
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jun 2021 00:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhFJAIW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jun 2021 20:08:22 -0400
Received: from m12-18.163.com ([220.181.12.18]:49288 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229557AbhFJAIW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jun 2021 20:08:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=CyN9y
        auZ9A10j7+vRszAOPbzX0M3IqT0uJAzoEoUjPs=; b=lz74xfUOaMK54XCVclVvj
        v5Wcv0PGwdXDEZHAy1S0bMU7TrpBEFNGGqK+Q5zr2Tdq7BDJQmXi7i7CFfYpT9BD
        7XOPtDVeB6PSJ1nMadEAPEdH7UkCsEga8P3CJ7gyfRzgBZXpAHGQV1fMTJ3+dtdG
        luj7bM222dHwx6GBeBS+cU=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp14 (Coremail) with SMTP id EsCowAC3uOBzV8Fg+LUuog--.29299S2;
        Thu, 10 Jun 2021 08:06:12 +0800 (CST)
From:   13145886936@163.com
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>
Subject: [PATCH] wext: fix a misspelling
Date:   Wed,  9 Jun 2021 17:06:09 -0700
Message-Id: <20210610000609.32579-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowAC3uOBzV8Fg+LUuog--.29299S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtryrtw15trWkKw1rtr15twb_yoW3CrX_Gr
        WxJw1kKFW8JrnavayUuw4xur4jy3y0qa1Fga9xtrySyw4DA3yDt3s5Cr4Utw429w4jyrWf
        C3Z5Jr45tF4fZjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUefcTJUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/xtbBRwitg1PADAr4kwAAsf
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

Fix a misspelling.

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 net/wireless/wext-compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index a8320dc59af7..7ef6fd26450c 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1183,7 +1183,7 @@ static int cfg80211_wext_siwpower(struct net_device *dev,
 		switch (wrq->flags & IW_POWER_MODE) {
 		case IW_POWER_ON:       /* If not specified */
 		case IW_POWER_MODE:     /* If set all mask */
-		case IW_POWER_ALL_R:    /* If explicitely state all */
+		case IW_POWER_ALL_R:    /* If explicitly state all */
 			ps = true;
 			break;
 		default:                /* Otherwise we ignore */
-- 
2.25.1


