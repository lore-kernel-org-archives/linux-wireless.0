Return-Path: <SRS0=Edxh=DP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEAEEC04EBE
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Oct 2020 15:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8513A206F7
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Oct 2020 15:54:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LpZkpZ2t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731606AbgJHPyO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Oct 2020 11:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730398AbgJHPyH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Oct 2020 11:54:07 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B19C061755;
        Thu,  8 Oct 2020 08:54:07 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id y14so4316681pfp.13;
        Thu, 08 Oct 2020 08:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RnKHHS78J0saEmG0sVvwGKvFq7qZf5SdKx5R1k+dQbo=;
        b=LpZkpZ2tNaRXu9D0z3lHwsvdaPoX+ewUUt1gSAjxW1cqZp4b0x4tTXt6l3Du2zaR4a
         Qgq2mqpw5FZUDqUUyT4P0zRVBg7NJDPow3ctPQZYfpE4ckFiOFTBs7jsEAoMYF62Rzqg
         u6/kAfHgPKxnTtZ7ivIEvA4vterxCGymeowBjhXclOpD1e1qj95ke7bXLOhOcf3pKrkX
         v2o8B9SooRqoRoW9c2koIMfmoNNzTspOW/J8tU8oAv5y6+DjyWZ6ossORKEdqBRVqNVO
         gLPa8xpS1cZxAIzhXDJDTWvGMJCKeU50RwF493HkI7SFRp7OAMJ63fykI1FSjbWXLkEV
         KBbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RnKHHS78J0saEmG0sVvwGKvFq7qZf5SdKx5R1k+dQbo=;
        b=iFQOYOArFSd7qj9SxRaACAqyB9HDXjAkj0hMRDVleEn8SJncaRxvnWJ8+EyAeCoby8
         /Y+d7OJW4VgnktuXLoZoTwHQdFiHTYDdgfwcLIa65mEY+6A9Tgrdf9urQJ/67+/7B3bL
         Q1hPiZydgBBy4SsuSR2Bn5g+zv/j0mP2wi3fdE5oBiWhESoDYfiKDTXUmXpYckqIyl/c
         ogIMibvgCiI81uFkR5tZLH83BQ2XjxR/wt0Vff3Px2TJXfOgqhl9tSlkZgS/+L9jHjzq
         S8rrgtl9ZP/0JpTfiZHRyEckL44TUKwoIgWtbyjAf5xLtNfuyR+yeR1mKxizj1yznm1i
         45wg==
X-Gm-Message-State: AOAM533NgLGBrxs3xJqvDSt0IeWSEy5dv6R8TbvInb62uWVty5TP0vna
        gKwVFIaX/aQmyswiBsJ+YIA=
X-Google-Smtp-Source: ABdhPJyCt8fguL6zVgbRt+BARXsMdx909/mIC/GLvJgSuUHIzAEnWdUETkaWLcINPbzjprJnVdg9wg==
X-Received: by 2002:a17:90a:1702:: with SMTP id z2mr8976493pjd.88.1602172447070;
        Thu, 08 Oct 2020 08:54:07 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:54:06 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 034/117] wlcore: set DEBUGFS_FWSTATS_FILE_ARRAY.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:46 +0000
Message-Id: <20201008155209.18025-34-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: bcca1bbdd412 ("wlcore: add debugfs macro to help print fw statistics arrays")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ti/wlcore/debugfs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.h b/drivers/net/wireless/ti/wlcore/debugfs.h
index 681dead95e0c..2889cf0bcfb7 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.h
+++ b/drivers/net/wireless/ti/wlcore/debugfs.h
@@ -95,6 +95,7 @@ static const struct file_operations sub## _ ##name## _ops = {		\
 	.read = sub## _ ##name## _read,					\
 	.open = simple_open,						\
 	.llseek	= generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 #define DEBUGFS_FWSTATS_ADD(sub, name)					\
-- 
2.17.1

