Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F20F2C282C6
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 09:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA9C6217D7
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 09:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbfAYJIe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 04:08:34 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:53776 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfAYJIe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 04:08:34 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gmxTT-0003Il-1U; Fri, 25 Jan 2019 10:08:31 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH net-next] netlink: reduce NLA_POLICY_NESTED{,_ARRAY} arguments
Date:   Fri, 25 Jan 2019 10:08:28 +0100
Message-Id: <20190125090828.26361-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In typical cases, there's no need to pass both the maxattr
and the policy array pointer, as the maxattr should just be
ARRAY_SIZE(policy) - 1. Therefore, to be less error prone,
just remove the maxattr argument from the default macros
and deduce the size accordingly.

Leave the original macros with a leading underscore to use
here and in case somebody needs to pass a policy pointer
where the policy isn't declared in the same place and thus
ARRAY_SIZE() cannot be used.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Dave, it looks like we're the only users of this right now,
so let me know if you'd prefer I take it through my tree.
Also, this conflicts with the fix I just made to the place
where I got it wrong, but obviously the resolution is to
just take the version without the maxattr argument.
---
 include/net/netlink.h  |  8 ++++++--
 net/wireless/nl80211.c | 15 +++++----------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 4c1e99303b5a..23f27b0b3cef 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -306,10 +306,14 @@ struct nla_policy {
 #define NLA_POLICY_ETH_ADDR		NLA_POLICY_EXACT_LEN(ETH_ALEN)
 #define NLA_POLICY_ETH_ADDR_COMPAT	NLA_POLICY_EXACT_LEN_WARN(ETH_ALEN)
 
-#define NLA_POLICY_NESTED(maxattr, policy) \
+#define _NLA_POLICY_NESTED(maxattr, policy) \
 	{ .type = NLA_NESTED, .validation_data = policy, .len = maxattr }
-#define NLA_POLICY_NESTED_ARRAY(maxattr, policy) \
+#define _NLA_POLICY_NESTED_ARRAY(maxattr, policy) \
 	{ .type = NLA_NESTED_ARRAY, .validation_data = policy, .len = maxattr }
+#define NLA_POLICY_NESTED(policy) \
+	_NLA_POLICY_NESTED(ARRAY_SIZE(policy) - 1, policy)
+#define NLA_POLICY_NESTED_ARRAY(policy) \
+	_NLA_POLICY_NESTED_ARRAY(ARRAY_SIZE(policy) - 1, policy)
 
 #define __NLA_ENSURE(condition) BUILD_BUG_ON_ZERO(!(condition))
 #define NLA_ENSURE_INT_TYPE(tp)				\
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e5f9c9ceb6c9..dde03ec279e6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -259,15 +259,13 @@ nl80211_pmsr_ftm_req_attr_policy[NL80211_PMSR_FTM_REQ_ATTR_MAX + 1] = {
 static const struct nla_policy
 nl80211_pmsr_req_data_policy[NL80211_PMSR_TYPE_MAX + 1] = {
 	[NL80211_PMSR_TYPE_FTM] =
-		NLA_POLICY_NESTED(NL80211_PMSR_FTM_REQ_ATTR_MAX,
-				  nl80211_pmsr_ftm_req_attr_policy),
+		NLA_POLICY_NESTED(nl80211_pmsr_ftm_req_attr_policy),
 };
 
 static const struct nla_policy
 nl80211_pmsr_req_attr_policy[NL80211_PMSR_REQ_ATTR_MAX + 1] = {
 	[NL80211_PMSR_REQ_ATTR_DATA] =
-		NLA_POLICY_NESTED(NL80211_PMSR_TYPE_MAX,
-				  nl80211_pmsr_req_data_policy),
+		NLA_POLICY_NESTED(nl80211_pmsr_req_data_policy),
 	[NL80211_PMSR_REQ_ATTR_GET_AP_TSF] = { .type = NLA_FLAG },
 };
 
@@ -280,8 +278,7 @@ nl80211_psmr_peer_attr_policy[NL80211_PMSR_PEER_ATTR_MAX + 1] = {
 	 */
 	[NL80211_PMSR_PEER_ATTR_CHAN] = { .type = NLA_NESTED },
 	[NL80211_PMSR_PEER_ATTR_REQ] =
-		NLA_POLICY_NESTED(NL80211_PMSR_REQ_ATTR_MAX,
-				  nl80211_pmsr_req_attr_policy),
+		NLA_POLICY_NESTED(nl80211_pmsr_req_attr_policy),
 	[NL80211_PMSR_PEER_ATTR_RESP] = { .type = NLA_REJECT },
 };
 
@@ -292,8 +289,7 @@ nl80211_pmsr_attr_policy[NL80211_PMSR_ATTR_MAX + 1] = {
 	[NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR] = { .type = NLA_REJECT },
 	[NL80211_PMSR_ATTR_TYPE_CAPA] = { .type = NLA_REJECT },
 	[NL80211_PMSR_ATTR_PEERS] =
-		NLA_POLICY_NESTED_ARRAY(NL80211_PMSR_PEER_ATTR_MAX,
-					nl80211_psmr_peer_attr_policy),
+		NLA_POLICY_NESTED_ARRAY(nl80211_psmr_peer_attr_policy),
 };
 
 const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
@@ -555,8 +551,7 @@ const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	},
 	[NL80211_ATTR_TIMEOUT] = NLA_POLICY_MIN(NLA_U32, 1),
 	[NL80211_ATTR_PEER_MEASUREMENTS] =
-		NLA_POLICY_NESTED(NL80211_PMSR_FTM_REQ_ATTR_MAX,
-				  nl80211_pmsr_attr_policy),
+		NLA_POLICY_NESTED(nl80211_pmsr_attr_policy),
 	[NL80211_ATTR_AIRTIME_WEIGHT] = NLA_POLICY_MIN(NLA_U16, 1),
 };
 
-- 
2.17.2

