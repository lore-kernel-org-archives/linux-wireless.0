Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80686C4338F
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Aug 2021 02:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F8E560E78
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Aug 2021 02:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbhHDCDz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Aug 2021 22:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234126AbhHDCDy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Aug 2021 22:03:54 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169D7C06175F;
        Tue,  3 Aug 2021 19:03:42 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso1420423pjf.4;
        Tue, 03 Aug 2021 19:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9YU5h2Vun8MQkwnTAnfIYkUUTnWKnq1n3xEdd7fVbmg=;
        b=dI6/sBh1r+4aj3KqmzBSLdxiYCUIK3p6AwJ9P23RNBsthgQN9An/AZxxfQIxKHZhdE
         fGRhwYMLxeIo5PBya94+i8M4zJZ/SOcZBerZR4ImCUoH5xPCZn9I+mmmSHa7ZG/TlbD6
         rRKKm3O8CY5SisVNCT93qaVhbhl8j44NntHgJXA+O6dSxPtBDB04DYAY0mwxQrlbEDwR
         LJmAuLXXWNlsojtTdtM2+T12+qAF2zXePTImkVTKt5S+Hm2JehM65Y2SsWCV+w/HYP1k
         k+O+hFqb6AVJwKmFcZA4rx2QakmIYhrlhtI+r/I/rrVyDt95aUyVJbOScfQ4j+27F+Yt
         sAVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9YU5h2Vun8MQkwnTAnfIYkUUTnWKnq1n3xEdd7fVbmg=;
        b=dId2daDgJ3I1ObKZV1rktq+1QcvTZIzgk9BbMua75FgvRw19Y2g8lHNVfSz1MtE0Yr
         QPqKTS1cdWhj++h17UIrvSHK4mTWDqs3ZaLof+1B9wbV+jRez+5KTQY5aOD8DcIp/ha9
         9DLin8Ac0tNUCjKBPqdT+Ugd4XN+LdXT3n+eJh2OwjjEIRz7UexBuk2hEZmoKSAJuT4J
         Pko0JuQyzDxA1Ze652RTJhFlwtwFNqBFshjd1o6x7Bx7zAgBE1LmyDgChMLL0HbdM5UN
         8iPPAjYFdZrYC2xmGvxbn1Ps15yQT5zlX4KLfKpqPkR3e/vQbpIu4zT06M77lN0ui95x
         UP+g==
X-Gm-Message-State: AOAM532YHxAWeVuwV3hOhKu/R4Dq1YcPETOXdkkJY/WfvOTbxySIltkX
        6uGOXFx5LHDqbtElUz02aCA=
X-Google-Smtp-Source: ABdhPJwKWsjDTBUFLSXtW5FxaACuFxArM+2NsoI2csc8IIkeaWPr2plHaaCG+4okwaoj19CrHWXn7Q==
X-Received: by 2002:a17:90a:1348:: with SMTP id y8mr25792949pjf.110.1628042621622;
        Tue, 03 Aug 2021 19:03:41 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.49])
        by smtp.gmail.com with ESMTPSA id z16sm496818pgu.21.2021.08.03.19.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 19:03:40 -0700 (PDT)
From:   Tuo Li <islituo@gmail.com>
To:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH] mwifiex: drop redundant null-pointer check in mwifiex_dnld_cmd_to_fw()
Date:   Tue,  3 Aug 2021 19:03:05 -0700
Message-Id: <20210804020305.29812-1-islituo@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There is no case in which the variable cmd_node->cmd_skb has no ->data,
and thus the variable host_cmd is guaranteed to be not NULL. Therefore,
the null-pointer check is redundant and can be dropped.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 3a11342a6bde..171a25742600 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -187,7 +187,7 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	host_cmd = (struct host_cmd_ds_command *) (cmd_node->cmd_skb->data);
 
 	/* Sanity test */
-	if (host_cmd == NULL || host_cmd->size == 0) {
+	if (host_cmd->size == 0) {
 		mwifiex_dbg(adapter, ERROR,
 			    "DNLD_CMD: host_cmd is null\t"
 			    "or cmd size is 0, not sending\n");
-- 
2.25.1

