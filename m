Return-Path: <SRS0=0wPU=BP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC46C433DF
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Aug 2020 19:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A7E322D01
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Aug 2020 19:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgHEQmL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Aug 2020 12:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727104AbgHEQkG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Aug 2020 12:40:06 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89AEC0A54DA
        for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2020 06:36:45 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k3Jan-00GoHg-1s; Wed, 05 Aug 2020 15:36:29 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: fix NL80211_ATTR_HE_6GHZ_CAPABILITY usage
Date:   Wed,  5 Aug 2020 15:35:18 +0200
Message-Id: <20200805153516.310cef625955.I0abc04dc8abb2c7c005c88ef8fa2d0e3c9fb95c4@changeid>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In nl80211_set_station(), we check NL80211_ATTR_HE_6GHZ_CAPABILITY
and then use NL80211_ATTR_HE_CAPABILITY, which is clearly wrong.
Fix this to use NL80211_ATTR_HE_6GHZ_CAPABILITY as well.

Fixes: 43e64bf301fd ("cfg80211: handle 6 GHz capability of new station")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 19281d0c8c9d..bfda09d24146 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6008,7 +6008,7 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 
 	if (info->attrs[NL80211_ATTR_HE_6GHZ_CAPABILITY])
 		params.he_6ghz_capa =
-			nla_data(info->attrs[NL80211_ATTR_HE_CAPABILITY]);
+			nla_data(info->attrs[NL80211_ATTR_HE_6GHZ_CAPABILITY]);
 
 	if (info->attrs[NL80211_ATTR_AIRTIME_WEIGHT])
 		params.airtime_weight =
-- 
2.26.2

