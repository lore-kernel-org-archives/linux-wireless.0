Return-Path: <SRS0=qkCK=NK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCECBC2BC61
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 08:18:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F8DC2080A
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 08:18:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F8DC2080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbeJ3RKf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 13:10:35 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53858 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbeJ3RKf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 13:10:35 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gHPDz-00079d-8y; Tue, 30 Oct 2018 09:18:07 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] cfg80211/mac80211: fix FTM settings across CSA
Date:   Tue, 30 Oct 2018 09:17:44 +0100
Message-Id: <20181030081745.15771-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

When FTM is enabled, doing a CSA will unexpectedly lose it since
the value of ftm_responder may be initialized to 0 instead of -1,
so fix that.

Fixes: 81e54d08d9d8 ("cfg80211: support FTM responder configuration/statistics")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 744b5851bbf9..8d763725498c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7870,6 +7870,7 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	memset(&params, 0, sizeof(params));
+	params.beacon_csa.ftm_responder = -1;
 
 	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ] ||
 	    !info->attrs[NL80211_ATTR_CH_SWITCH_COUNT])
-- 
2.17.2

