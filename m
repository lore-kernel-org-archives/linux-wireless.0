Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF7AC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 09:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D55A2086A
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 09:09:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D55A2086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbeJLQks (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 12:40:48 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:45856 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727808AbeJLQkr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 12:40:47 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gAtRd-0007zJ-BK; Fri, 12 Oct 2018 11:09:17 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     John Garry <john.garry@huawei.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] netlink: replace __NLA_ENSURE implementation
Date:   Fri, 12 Oct 2018 11:09:04 +0200
Message-Id: <20181012090904.24547-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.14.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

John Garry reported that when we actually use the current
implementation of __NLA_ENSURE, he gets compiler warnings
from -Wvla since there's an array in there, and for some
reason the compiler cannot immediately prove that its size
is constant. It must eventually be able to prove it as we
can use this inside an initializer for a constant, but the
warning still shows up for him.

I haven't been able to reproduce the warning on gcc in any
case that actually should compile, though in the case that
a non-constant value is actually passed I do see both the
VLA warning as well as the non-constant initializer error.
This was with both gcc 7.3.1 (which John also reported to
be using) and 8.1.

However, since we already have BUILD_BUG_ON_ZERO() and I
just missed it when implementing this, just use it, which
avoids this whole issue because it uses the bitfield trick
to force compilation errors, rather than the array trick.

Reported-by: John Garry <john.garry@huawei.com>
Fixes: 3e48be05f3c7 ("netlink: add attribute range validation to policy")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 589683091f16..094012174b6f 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -311,7 +311,7 @@ struct nla_policy {
 #define NLA_POLICY_NESTED_ARRAY(maxattr, policy) \
 	{ .type = NLA_NESTED_ARRAY, .validation_data = policy, .len = maxattr }
 
-#define __NLA_ENSURE(condition) (sizeof(char[1 - 2*!(condition)]) - 1)
+#define __NLA_ENSURE(condition) BUILD_BUG_ON_ZERO(!(condition))
 #define NLA_ENSURE_INT_TYPE(tp)				\
 	(__NLA_ENSURE(tp == NLA_S8 || tp == NLA_U8 ||	\
 		      tp == NLA_S16 || tp == NLA_U16 ||	\
-- 
2.14.4

