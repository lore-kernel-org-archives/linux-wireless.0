Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE785C433ED
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Apr 2021 11:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A969361244
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Apr 2021 11:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhDMLjf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 13 Apr 2021 07:39:35 -0400
Received: from mga06.intel.com ([134.134.136.31]:45471 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229831AbhDMLje (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Apr 2021 07:39:34 -0400
IronPort-SDR: QgFSu+L4NnNVnvaHfvpVzXeT7sHWc1cvjGEe6UnFQsSzcOt+bS3EHF66qmUPPL1o27f8VSdZE7
 Frq//1uD+HZA==
X-IronPort-AV: E=McAfee;i="6200,9189,9952"; a="255715586"
X-IronPort-AV: E=Sophos;i="5.82,219,1613462400"; 
   d="scan'208";a="255715586"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 04:38:59 -0700
IronPort-SDR: 8hHL61XFihn4+MSKebQ/80cRV7Efy374eKrf4SyCHqrkWhk17ZynIPUJ+HcvvvTdxEyhVuO0Ih
 VD0sGNKS6nmg==
X-IronPort-AV: E=Sophos;i="5.82,219,1613462400"; 
   d="scan'208";a="460551224"
Received: from sharush-mobl2.ger.corp.intel.com (HELO egrumbac-mobl1.intel.com) ([10.214.198.165])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 04:38:58 -0700
From:   Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] cfg80211: fix an htmldoc warning
Date:   Tue, 13 Apr 2021 14:38:50 +0300
Message-Id: <20210413113850.59098-1-emmanuel.grumbach@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The htmldoc produces this warning which was introduced
bu the commit below.

include/net/cfg80211.h:6643: warning: expecting prototype for wiphy_rfkill_set_hw_state().
Prototype was for wiphy_rfkill_set_hw_state_reason() instead

Fixes: 6f779a66dc84 ("cfg80211: allow specifying a reason for hw_rfkill")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/cfg80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3b296f2b7a2c..c6134220dd8f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -6634,7 +6634,7 @@ void cfg80211_notify_new_peer_candidate(struct net_device *dev,
  */
 
 /**
- * wiphy_rfkill_set_hw_state - notify cfg80211 about hw block state
+ * wiphy_rfkill_set_hw_state_reason - notify cfg80211 about hw block state
  * @wiphy: the wiphy
  * @blocked: block status
  * @reason: one of reasons in &enum rfkill_hard_block_reasons
-- 
2.25.1

