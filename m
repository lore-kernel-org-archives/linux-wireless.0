Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E155C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C21220868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:53:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C21220868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbeJLSZI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 14:25:08 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:47552 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbeJLSZH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 14:25:07 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gAv4D-0001Td-Ut; Fri, 12 Oct 2018 12:53:14 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     John Garry <john.garry@huawei.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2] netlink: replace __NLA_ENSURE implementation
Date:   Fri, 12 Oct 2018 12:53:00 +0200
Message-Id: <20181012105300.25747-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.14.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

We already have BUILD_BUG_ON_ZERO() which I just hadn't found
before, so we should use it here instead of open-coding another
implementation thereof.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: remove all the language about -Wvla, I misunderstood John
    and he was just referring to *other* VLA warnings in the
    wifi stack (which we know about and are being fixed by the
    crypto tree)
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

