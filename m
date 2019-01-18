Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75510C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 11:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DFB0204EC
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 11:27:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KvODTVwY";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bMK/Sbbw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbfARL1X (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 06:27:23 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57424 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727343AbfARL1X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 06:27:23 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5A8B660851; Fri, 18 Jan 2019 11:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547810842;
        bh=sQAjgbuJrWUCX77WnQjI7an7kk0Qyx3vZbZiCirmb00=;
        h=From:To:Cc:Subject:Date:From;
        b=KvODTVwYXKqOBQ6jI6MzxT8XKQzF76uPD1KK11QJdSGNsBux4jsIRfu0I6mr2EAm6
         JZ++5MMk0UXscEnicYmTFuXCL0bGS8mXe2h7C5jYtp4yvbmcC6Z0VCzX9bJ3xSxfuy
         ot7jL9Q0DRyEKAHbanjJpbO96zC8d7x8CuWDzKi0=
Received: from dasaris-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dasaris@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D1D0D602FC;
        Fri, 18 Jan 2019 11:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547810841;
        bh=sQAjgbuJrWUCX77WnQjI7an7kk0Qyx3vZbZiCirmb00=;
        h=From:To:Cc:Subject:Date:From;
        b=bMK/SbbwvmHn03KN+RjQm8aGMvhMr5Ywwd4DUjSUwFE2jans/dr508oG+0J+Gn12A
         UNgviX/6kQ3yqSk8PM+sNMwLlu57IlIaP1bbvJWIqYmDYJzy0bzjNIqtIjmNPXQHc0
         LaraqdlkHJ0fqsOYYmCV3b9EAa8+6NnYJnYIwLCk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D1D0D602FC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=dasaris@codeaurora.org
From:   Srinivas Dasari <dasaris@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Liangwei Dong <liangwei@codeaurora.org>,
        Srinivas Dasari <dasaris@codeaurora.org>
Subject: [PATCH] nl80211: Allow set/del pmksa operations for AP
Date:   Fri, 18 Jan 2019 16:54:38 +0530
Message-Id: <1547810678-30664-1-git-send-email-dasaris@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Liangwei Dong <liangwei@codeaurora.org>

Host drivers may offload authentication to the user space
through the commit ("cfg80211: Authentication offload to
user space in AP mode").

This interface can be used to implement SAE by having the
userspace do authentication/PMKID key derivation and driver
handle the association.

A step ahead, this interface can get further optimized if the
PMKID is passed to the host driver and also have it respond to
the association request by the STA on a valid PMKID.

This commit enables the userspace to pass the PMKID to the host
drivers through the set/del pmksa operations in AP mode.

Set/Del pmksa is now restricted to STA/P2P client mode only and
thus the drivers might not expect them in any other(AP) mode.

This commit also introduces a feature flag
NL80211_EXT_FEATURE_SET_DEL_PMKSA_AP to maintain the backward
compatibility of such an expectation by the host drivers.
These operations are allowed in AP mode only when the drivers
advertize the capability through this flag.

Signed-off-by: Liangwei Dong <liangwei@codeaurora.org>
Signed-off-by: Srinivas Dasari <dasaris@codeaurora.org>
---
 include/uapi/linux/nl80211.h | 6 ++++++
 net/wireless/nl80211.c       | 5 ++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 30e1bb6..5553ae6 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -5318,6 +5318,11 @@ enum nl80211_feature_flags {
  *      if this flag is not set. Ignoring this can leak clear text packets and/or
  *      freeze the connection.
  *
+ * @NL80211_EXT_FEATURE_SET_DEL_PMKSA_AP: Driver/device support set/del pmksa in
+ *	AP mode. Initial implementation of nl80211_setdel_pmksa does not allow
+ *	pmksa configuration in AP mode. This flag allows the set/del pmksa to
+ *	the drivers only when set, thus ensuring the backward compatibility.
+ *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
@@ -5357,6 +5362,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT,
 	NL80211_EXT_FEATURE_CAN_REPLACE_PTK0,
 	NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER,
+	NL80211_EXT_FEATURE_SET_DEL_PMKSA_AP,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0af5db3..686da9f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9858,7 +9858,10 @@ static int nl80211_setdel_pmksa(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT)
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT &&
+	    !(dev->ieee80211_ptr->iftype == NL80211_IFTYPE_AP &&
+	      wiphy_ext_feature_isset(&rdev->wiphy,
+				      NL80211_EXT_FEATURE_SET_DEL_PMKSA_AP)))
 		return -EOPNOTSUPP;
 
 	switch (info->genlhdr->cmd) {
-- 
1.9.1

