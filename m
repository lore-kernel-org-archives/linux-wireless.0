Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 565D5C433E0
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Feb 2021 09:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C5FA64E38
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Feb 2021 09:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhBLJvN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Feb 2021 04:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhBLJvM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Feb 2021 04:51:12 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB110C061574
        for <linux-wireless@vger.kernel.org>; Fri, 12 Feb 2021 01:50:31 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lAV5p-001nS2-HL; Fri, 12 Feb 2021 10:50:29 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: add documentation for HT/VHT/HE disable attributes
Date:   Fri, 12 Feb 2021 10:50:23 +0100
Message-Id: <20210212105023.895c3389f063.I46dea3bfc64385bc6f600c50d294007510994f8f@changeid>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

These were missed earlier, add the necessary documentation
and, while at it, clarify it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/nl80211.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 5188fe581efc..ac78da99fccd 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1963,8 +1963,15 @@ enum nl80211_commands {
  * @NL80211_ATTR_PROBE_RESP: Probe Response template data. Contains the entire
  *	probe-response frame. The DA field in the 802.11 header is zero-ed out,
  *	to be filled by the FW.
- * @NL80211_ATTR_DISABLE_HT:  Force HT capable interfaces to disable
- *      this feature.  Currently, only supported in mac80211 drivers.
+ * @NL80211_ATTR_DISABLE_HT: Force HT capable interfaces to disable
+ *      this feature during association. This is a flag attribute.
+ *	Currently only supported in mac80211 drivers.
+ * @NL80211_ATTR_DISABLE_VHT: Force VHT capable interfaces to disable
+ *      this feature during association. This is a flag attribute.
+ *	Currently only supported in mac80211 drivers.
+ * @NL80211_ATTR_DISABLE_HE: Force HE capable interfaces to disable
+ *      this feature during association. This is a flag attribute.
+ *	Currently only supported in mac80211 drivers.
  * @NL80211_ATTR_HT_CAPABILITY_MASK: Specify which bits of the
  *      ATTR_HT_CAPABILITY to which attention should be paid.
  *      Currently, only mac80211 NICs support this feature.
-- 
2.26.2

