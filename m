Return-Path: <SRS0=vui6=4J=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225AEC35640
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Feb 2020 09:41:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F13EF207FD
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Feb 2020 09:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgBUJlu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 21 Feb 2020 04:41:50 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:55386 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgBUJlu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Feb 2020 04:41:50 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j54oe-00EtWM-54; Fri, 21 Feb 2020 10:41:48 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: fix potential leak in AP start
Date:   Fri, 21 Feb 2020 10:41:43 +0100
Message-Id: <20200221104142.835aba4cdd14.I1923b55ba9989c57e13978f91f40bfdc45e60cbd@changeid>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

If nl80211_parse_he_obss_pd() fails, we leak the previously
allocated ACL memory. Free it in this case.

Fixes: 796e90f42b7e ("cfg80211: add support for parsing OBBS_PD attributes")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cedf17d4933f..46be40e19e7f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4800,8 +4800,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		err = nl80211_parse_he_obss_pd(
 					info->attrs[NL80211_ATTR_HE_OBSS_PD],
 					&params.he_obss_pd);
-		if (err)
-			return err;
+		goto out;
 	}
 
 	nl80211_calculate_ap_params(&params);
@@ -4823,6 +4822,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	}
 	wdev_unlock(wdev);
 
+out:
 	kfree(params.acl);
 
 	return err;
-- 
2.24.1

