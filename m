Return-Path: <SRS0=M0/e=RK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 846C8C43381
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 23:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5317B2081B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 23:57:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VFq06R3P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfCGX5t (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Mar 2019 18:57:49 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41181 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfCGX5t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Mar 2019 18:57:49 -0500
Received: by mail-ed1-f67.google.com with SMTP id x7so14973248eds.8;
        Thu, 07 Mar 2019 15:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N0ITOVoBW8yrlydVGEyQDwAmxvx+WvHkFp1+HzwOxiE=;
        b=VFq06R3P2KP4io+KrC42ZTXtQzjfR4l8EcikCu4fUVhl8bExVT5Fq7KvDjG1h62mGX
         CFcWeKa0JM/KfwW6HEXuVYZd22D+on3JlfM2eh5xc/dRLul3pxOdAwEhhWOPJWfhkSMm
         Zb0/EArjeoV3hdGGouQf7XoAmrEFfF7B+lAIfxzMFcCBsI1ZgJfV6b9xNCQfaltJfazc
         cCM5hiYAnJ9HjWW37Kffq71luaIaBynxStrQVe6ySND1UVCk//XmwkqmijzI9QgaBMGm
         /llJPNSgB0aMVeJJAkjyxey79mU6GAHzZnkrJ+JezdCwYmsLYzWF0+96RXVZ0SCXC6h4
         Dg4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N0ITOVoBW8yrlydVGEyQDwAmxvx+WvHkFp1+HzwOxiE=;
        b=CxrdfvWBpjR7yfzk10b8zRGnYZpIlifnpbcU3MhBvqQcAegeN0JZFQ1eqE4Ofs6WqW
         XKdgqX037iDYGyeWWQlgjPRAJ908MSjVV7SXjHEtFmAkDHdbYUnmLwQ13uaGAFPhDAuH
         ZOGUo2xhlniMI47o8DfWzg4XooPfYcIZfjaGfylYr0hZzCl/WY38wo3pzuoOFUP3gM5B
         TvlnWRPG6TBuESPR3kMSBDDmA44RB/R9emj5tnZe3j9wrxiTDejket8I5BxqP2IbivqF
         Rvq6HSbMJiRGsTXanMHeEGp1JgoDe+tlBPDAxrkdXFlpSkC/c9fBwPuaO8//qzObDYUq
         96Kg==
X-Gm-Message-State: APjAAAXk3bdSAPcrMvhYoNkTiMYq7PZ7ArrWfTSCga+YK7irtEJrbdzZ
        lJiLWMfnr1n3C1eU0GIoHodoTZZRApvOgw==
X-Google-Smtp-Source: APXvYqyvS/tp3wg+FrWOdlDw1LimnCqWHzwGaE1VKQbK7KuELBMSlxEikOVm7nQ83hGRzI+GZPOnOw==
X-Received: by 2002:a17:906:561a:: with SMTP id f26mr9700580ejq.167.1552003067276;
        Thu, 07 Mar 2019 15:57:47 -0800 (PST)
Received: from localhost.localdomain ([2a01:4f9:2a:1fae::2])
        by smtp.gmail.com with ESMTPSA id x34sm1749692edm.70.2019.03.07.15.57.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 15:57:46 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] cfg80211: Change an 'else if' into an 'else' in cfg80211_calculate_bitrate_he
Date:   Thu,  7 Mar 2019 16:57:35 -0700
Message-Id: <20190307235735.31487-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When building with -Wsometimes-uninitialized, Clang warns:

net/wireless/util.c:1223:11: warning: variable 'result' is used
uninitialized whenever 'if' condition is false
[-Wsometimes-uninitialized]

Clang can't evaluate at this point that WARN(1, ...) always returns true
because __ret_warn_on is defined as !!(condition), which isn't
immediately evaluated as 1. Change this branch to else so that it's
clear to Clang that we intend to bail out here.

Link: https://github.com/ClangBuiltLinux/linux/issues/382
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 net/wireless/util.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index e4b8db5e81ec..75899b62bdc9 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1220,9 +1220,11 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
 	else if (rate->bw == RATE_INFO_BW_HE_RU &&
 		 rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_26)
 		result = rates_26[rate->he_gi];
-	else if (WARN(1, "invalid HE MCS: bw:%d, ru:%d\n",
-		      rate->bw, rate->he_ru_alloc))
+	else {
+		WARN(1, "invalid HE MCS: bw:%d, ru:%d\n",
+		     rate->bw, rate->he_ru_alloc);
 		return 0;
+	}
 
 	/* now scale to the appropriate MCS */
 	tmp = result;
-- 
2.21.0

