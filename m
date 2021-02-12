Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E58F6C433E0
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Feb 2021 23:30:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD58A64E02
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Feb 2021 23:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbhBLXaT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Feb 2021 18:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbhBLXaO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Feb 2021 18:30:14 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E741C061793
        for <linux-wireless@vger.kernel.org>; Fri, 12 Feb 2021 15:28:51 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id n201so880987iod.12
        for <linux-wireless@vger.kernel.org>; Fri, 12 Feb 2021 15:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8w8XQdxn9R0vTUUYKwbH7//7X6JrjWFRUImHZ2qHCEA=;
        b=MsK4Yp5tiWM/fulpatrxLLYBqeCGXaamHRMCb6oq63sXWcNUVVP2iuH/EpRTU/P71N
         U5wVLxv4rRqyBLWYgo0h0gt5H8QyMeMDAyvdeKpgYBwlKGWxkRM7vtC8dzVJXzNqIv/F
         go9UPLuCyA4cdM5ZZwhtXWdBYV1CGlDpw4UV8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8w8XQdxn9R0vTUUYKwbH7//7X6JrjWFRUImHZ2qHCEA=;
        b=KGl/B2lFW0aeo6cKmtyeS6SLio6M8FpcHCPdhGWUv7imhFky9+zS6xpySU1NHE3wIw
         rC0K/CzxeGZtaTTIekkVxeVU8O+G0WCbCwx4mdvoqAByf3T2TSN202n7apzq0MMdkRmy
         58Cjkj4GD3kz4f4PvRW9AbvE7RnYeGln7ycHFWN7dFebi/2x/ajivioHMnszWDeQmI+V
         vRbpizAiqUo8RlJRhNZNZbLD1PqIWeJcjFrBQlV4nSkLH4c83IBpzES2YFD7x9d/yjbS
         MIrDZdFkgNDfiBwlPz8JhiP89wdo9G/+u2LhxiXcoONfjP9uh/jzAT96B+g4UIvQSrQ2
         DUJQ==
X-Gm-Message-State: AOAM531xj8b0ydgqRLmJSWinF3STesTCzsY2q6derEmxaBH2JbQx2Inh
        1QNBVYlEn+NZspXl2TatX9Csug==
X-Google-Smtp-Source: ABdhPJyflu0RNWiIV3nbQa149G0hby7tBp9QoVfXWvAf6vhrbVm0ZDp9jsGcpqvP08a3LAahnffRrg==
X-Received: by 2002:a05:6638:3c6:: with SMTP id r6mr4761929jaq.115.1613172530821;
        Fri, 12 Feb 2021 15:28:50 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i20sm5180328ilc.2.2021.02.12.15.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 15:28:50 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ath10k: detect conf_mutex held ath10k_drain_tx() calls
Date:   Fri, 12 Feb 2021 16:28:43 -0700
Message-Id: <0686097db95ae32ce6805e5163798d912b394f37.1613171185.git.skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1613171185.git.skhan@linuxfoundation.org>
References: <cover.1613171185.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ath10k_drain_tx() must not be called with conf_mutex held as workers can
use that also. Add call to lockdep_assert_not_held() on conf_mutex to
detect if conf_mutex is held by the caller.

The idea for this patch stemmed from coming across the comment block
above the ath10k_drain_tx() while reviewing the conf_mutex holds during
to debug the conf_mutex lock assert in ath10k_debug_fw_stats_request().

Adding detection to assert on conf_mutex hold will help detect incorrect
usages that could lead to locking problems when async worker routines try
to call this routine.

Link: https://lore.kernel.org/linux-wireless/871rdmu9z9.fsf@codeaurora.org/
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c202b167d8c6..7de05b679ad2 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4728,6 +4728,8 @@ static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
 /* Must not be called with conf_mutex held as workers can use that also. */
 void ath10k_drain_tx(struct ath10k *ar)
 {
+	lockdep_assert_not_held(&ar->conf_mutex);
+
 	/* make sure rcu-protected mac80211 tx path itself is drained */
 	synchronize_net();
 
-- 
2.27.0

