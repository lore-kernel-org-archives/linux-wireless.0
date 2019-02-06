Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6541DC282CC
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42D2F2080D
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbfBFLRg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 06:17:36 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55738 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729833AbfBFLRf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 06:17:35 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grLCv-0001ED-6q; Wed, 06 Feb 2019 13:17:33 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  6 Feb 2019 13:17:14 +0200
Message-Id: <20190206111721.29283-9-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206111721.29283-1-luca@coelho.fi>
References: <20190206111721.29283-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/15] cfg80211: prevent speculation on cfg80211_classify8021d() return
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

It's possible that the caller of cfg80211_classify8021d() uses the
value to index an array, like mac80211 in ieee80211_downgrade_queue().
Prevent speculation on the return value.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/wireless/util.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index cd48cdd582c0..ec30e3732c7b 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -5,7 +5,7 @@
  * Copyright 2007-2009	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright 2017	Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018-2019 Intel Corporation
  */
 #include <linux/export.h>
 #include <linux/bitops.h>
@@ -19,6 +19,7 @@
 #include <linux/mpls.h>
 #include <linux/gcd.h>
 #include <linux/bitfield.h>
+#include <linux/nospec.h>
 #include "core.h"
 #include "rdev-ops.h"
 
@@ -715,20 +716,25 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb,
 {
 	unsigned int dscp;
 	unsigned char vlan_priority;
+	unsigned int ret;
 
 	/* skb->priority values from 256->263 are magic values to
 	 * directly indicate a specific 802.1d priority.  This is used
 	 * to allow 802.1d priority to be passed directly in from VLAN
 	 * tags, etc.
 	 */
-	if (skb->priority >= 256 && skb->priority <= 263)
-		return skb->priority - 256;
+	if (skb->priority >= 256 && skb->priority <= 263) {
+		ret = skb->priority - 256;
+		goto out;
+	}
 
 	if (skb_vlan_tag_present(skb)) {
 		vlan_priority = (skb_vlan_tag_get(skb) & VLAN_PRIO_MASK)
 			>> VLAN_PRIO_SHIFT;
-		if (vlan_priority > 0)
-			return vlan_priority;
+		if (vlan_priority > 0) {
+			ret = vlan_priority;
+			goto out;
+		}
 	}
 
 	switch (skb->protocol) {
@@ -747,8 +753,9 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb,
 		if (!mpls)
 			return 0;
 
-		return (ntohl(mpls->entry) & MPLS_LS_TC_MASK)
+		ret = (ntohl(mpls->entry) & MPLS_LS_TC_MASK)
 			>> MPLS_LS_TC_SHIFT;
+		goto out;
 	}
 	case htons(ETH_P_80221):
 		/* 802.21 is always network control traffic */
@@ -761,18 +768,24 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb,
 		unsigned int i, tmp_dscp = dscp >> 2;
 
 		for (i = 0; i < qos_map->num_des; i++) {
-			if (tmp_dscp == qos_map->dscp_exception[i].dscp)
-				return qos_map->dscp_exception[i].up;
+			if (tmp_dscp == qos_map->dscp_exception[i].dscp) {
+				ret = qos_map->dscp_exception[i].up;
+				goto out;
+			}
 		}
 
 		for (i = 0; i < 8; i++) {
 			if (tmp_dscp >= qos_map->up[i].low &&
-			    tmp_dscp <= qos_map->up[i].high)
-				return i;
+			    tmp_dscp <= qos_map->up[i].high) {
+				ret = i;
+				goto out;
+			}
 		}
 	}
 
-	return dscp >> 5;
+	ret = dscp >> 5;
+out:
+	return array_index_nospec(ret, IEEE80211_NUM_TIDS);
 }
 EXPORT_SYMBOL(cfg80211_classify8021d);
 
-- 
2.20.1

