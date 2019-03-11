Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85380C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 20:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 543012064A
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 20:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552335126;
	bh=1qc6AvIxnwuXD9TmCLZFwLIcNpe3n/znD6Nwl5bj13A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=DLg3RPY0nncBdOJM+1UWYN6UePN1pctigrsjxfn1Uf6qExo3dOeJkPjeALzvsJNho
	 hO7BFQT0QxYfW2TI/MJK284icLFSrsRWE7b6B1oYYd30ORzeeaEAMZqY6G1f5EuRwf
	 b+cDjOCXTFry+zAu0OFYFKJIT2xB2h1GmkNodOuE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbfCKT4P (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 15:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728555AbfCKT4M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 15:56:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 203D62087C;
        Mon, 11 Mar 2019 19:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552334171;
        bh=1qc6AvIxnwuXD9TmCLZFwLIcNpe3n/znD6Nwl5bj13A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZXGNE3eSh3TjN1bGFmC2N7GFogo9tjPfKkBxdP5o0XhQLAB13x5Yn6/brvXArMKY
         qPM53KQtHkVVGcG5TqyY/Qe/8AMXRsar2rXobw/zeHAWj2aeKD3pFo1K4jZnwH2n/c
         CdUwEzqA2osAqklJokgaOb0SiYUsORNaJgIBp/gw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 29/52] cfg80211: prevent speculation on cfg80211_classify8021d() return
Date:   Mon, 11 Mar 2019 15:54:53 -0400
Message-Id: <20190311195516.137772-29-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190311195516.137772-1-sashal@kernel.org>
References: <20190311195516.137772-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 1fc9b7253382ce1a83d9a3e63e88d656eb63f263 ]

It's possible that the caller of cfg80211_classify8021d() uses the
value to index an array, like mac80211 in ieee80211_downgrade_queue().
Prevent speculation on the return value.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index d473bd135da8..d8b7eb75bade 100644
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
2.19.1

