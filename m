Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50CF5C169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 12:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F82A2073D
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 12:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfBHMcB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 07:32:01 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:47444 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726624AbfBHMcA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 07:32:00 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gs5K2-0007Gh-8y; Fri, 08 Feb 2019 13:31:58 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/4] nl80211: use for_each_element() in validate_ie_attr()
Date:   Fri,  8 Feb 2019 13:31:54 +0100
Message-Id: <20190208123154.22414-4-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190208123154.22414-1-johannes@sipsolutions.net>
References: <20190208123154.22414-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

This makes for much simpler code, simply walk through all
the elements and check that the last one found ends with
the end of the data. This works because if any element is
malformed the walk is aborted, we end up with a mismatch.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a3cc039b9f55..5d85f6032f84 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -203,29 +203,17 @@ cfg80211_get_dev_from_info(struct net *netns, struct genl_info *info)
 static int validate_ie_attr(const struct nlattr *attr,
 			    struct netlink_ext_ack *extack)
 {
-	const u8 *pos;
-	int len;
+	const u8 *data = nla_data(attr);
+	unsigned int len = nla_len(attr);
+	struct element *elem;
 
-	pos = nla_data(attr);
-	len = nla_len(attr);
-
-	while (len) {
-		u8 elemlen;
-
-		if (len < 2)
-			goto error;
-		len -= 2;
-
-		elemlen = pos[1];
-		if (elemlen > len)
-			goto error;
-
-		len -= elemlen;
-		pos += 2 + elemlen;
+	for_each_element(elem, data, len) {
+		/* nothing */
 	}
 
-	return 0;
-error:
+	if (for_each_element_completed(elem, data, len))
+		return 0;
+
 	NL_SET_ERR_MSG_ATTR(extack, attr, "malformed information elements");
 	return -EINVAL;
 }
-- 
2.17.2

