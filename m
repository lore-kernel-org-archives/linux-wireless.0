Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA26C282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 08:53:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45DA521872
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 08:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbfAYIxE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 03:53:04 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:53676 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfAYIxE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 03:53:04 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gmxEU-0002vI-31; Fri, 25 Jan 2019 09:53:02 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: fix NLA_POLICY_NESTED() arguments
Date:   Fri, 25 Jan 2019 09:52:55 +0100
Message-Id: <20190125085255.14198-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

syzbot reported an out-of-bounds read when passing certain
malformed messages into nl80211. The specific place where
this happened isn't interesting, the problem is that nested
policy parsing was referring to the wrong maximum attribute
and thus the policy wasn't long enough.

Fix this by referring to the correct attribute. Since this
is really not necessary, I'll come up with a separate patch
to just pass the policy instead of both, in the common case
we can infer the maxattr from the size of the policy array.

Reported-by: syzbot+4157b036c5f4713b1f2f@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Fixes: 9bb7e0f24e7e ("cfg80211: add peer measurement with FTM initiator API")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5e49492d5911..74150ad95823 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -555,7 +555,7 @@ const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	},
 	[NL80211_ATTR_TIMEOUT] = NLA_POLICY_MIN(NLA_U32, 1),
 	[NL80211_ATTR_PEER_MEASUREMENTS] =
-		NLA_POLICY_NESTED(NL80211_PMSR_FTM_REQ_ATTR_MAX,
+		NLA_POLICY_NESTED(NL80211_PMSR_ATTR_MAX,
 				  nl80211_pmsr_attr_policy),
 };
 
-- 
2.17.2

