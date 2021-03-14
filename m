Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8E2C43619
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Mar 2021 20:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB73964E6B
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Mar 2021 20:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbhCNUTA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 14 Mar 2021 16:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234118AbhCNUSs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Mar 2021 16:18:48 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99CDC061574;
        Sun, 14 Mar 2021 13:18:47 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id nh23-20020a17090b3657b02900c0d5e235a8so13629052pjb.0;
        Sun, 14 Mar 2021 13:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LMOZ5bqQ3Szyc7EP1T4fNl5+jni0DiT4SGvTYn0pp0Y=;
        b=Cyu/NbUhH0j5I44WU5uciWYm6U9iYSllJJt+Ku6eJ05wGic8HnHUnNGMSxNLsnONYY
         NJeWcq9LnLAVpURX+qCJqhnq6bSrGrw+GcPA8OmFEg4DKrzNpY4XmYNEDaCi62RYrsDL
         Stj0aiEAMaUXZ0cxoE2KDe0oUFsqHOIjZ7NyLEDFZT20OJwz3qlYrCLTr4upjhR0oPJn
         rT/s0Q2hmPeiihFxE1+B+0HJ7lvWmSzMkE5hK7eFBjZlfe1OA85uoQKRlmAnFB4NQ1jr
         HhyV6sVTd+wrz2cZvyjKGfAhZep6KZDcmYjEFr0om6szy3KisNPvSFOlo+mGQ1mioLBF
         wNww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LMOZ5bqQ3Szyc7EP1T4fNl5+jni0DiT4SGvTYn0pp0Y=;
        b=MCsta+xGYEm44ERjJywEw9+Sdm2Qst7CX1gZGPgsa7zbflcqLanqC0wAABFtFSlz+9
         GOfTN8FG/O+1lSKwPnFvRDpQnIpJ13STd7RKvyT5keIG8E+a6+Rzi2Q3T84rFNrzh1K+
         LDsGOHkIEebNPLo0V9W5S5rN9qUcYyOVehOGpS/zyneskXGSBEZBX464F4edPofdRyNL
         o+qFt5rdfD2lFSzRxddPvsYtiHvMBi5Tym2Td6f1BDJ+NmnnIiVoQP6tN7UDOxCUf4r8
         jx6Hw29Tkj572xKH0KZJmjCFmJun1K/7OVxrSFcfQTcBFHHOl7/6oN6Sx8u7jeO3TUwu
         diMA==
X-Gm-Message-State: AOAM531HbQPi3XtMaE2SVhfq+RyAQASmHjXyrfddzqwS5ePxOxQ6Mlb7
        wJhhmcDEDeYIBEtwTZlgC4g=
X-Google-Smtp-Source: ABdhPJwtOw9V0Yu40j87PGSatoAiFOu24FzdmKgHWEVlV64fg4+fSJYdbekbImh4eOl/QV+8+Xs2pA==
X-Received: by 2002:a17:90a:5b0b:: with SMTP id o11mr9310975pji.18.1615753127338;
        Sun, 14 Mar 2021 13:18:47 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:600d:a089:acdc:a5a5:c438:c1e3])
        by smtp.googlemail.com with ESMTPSA id n10sm10943793pgk.91.2021.03.14.13.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 13:18:47 -0700 (PDT)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     siva8118@gmail.com
Cc:     yashsri421@gmail.com, lukas.bulwahn@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        amitkarwar@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] rsi: rsi_common: fix file header comment syntax
Date:   Mon, 15 Mar 2021 01:48:12 +0530
Message-Id: <20210314201818.27380-5-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210314201818.27380-1-yashsri421@gmail.com>
References: <20210314201818.27380-1-yashsri421@gmail.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The opening comment mark '/**' is used for highlighting the beginning of
kernel-doc comments.

The header comment used in drivers/net/wireless/rsi/rsi_common.h
follows kernel-doc syntax, i.e. starts with '/**'. But the content
inside the comment does not comply with kernel-doc specifications (i.e.,
function, struct, etc).

This causes unwelcomed warning from kernel-doc:
"warning: wrong kernel-doc identifier on line:
 * Copyright (c) 2014 Redpine Signals Inc."

Replace this comment syntax with general comment format, i.e. '/*' to
prevent kernel-doc from parsing it.

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
 drivers/net/wireless/rsi/rsi_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_common.h b/drivers/net/wireless/rsi/rsi_common.h
index 60f1f286b030..7aa5124575cf 100644
--- a/drivers/net/wireless/rsi/rsi_common.h
+++ b/drivers/net/wireless/rsi/rsi_common.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2014 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
-- 
2.17.1

