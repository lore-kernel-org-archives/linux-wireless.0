Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEEF5C10F05
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 06:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5AA120855
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 06:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfDDGyW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 02:54:22 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55752 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbfDDGyU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 02:54:20 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hBwGP-0003Pn-DK; Thu, 04 Apr 2019 08:54:17 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6/6] nl80211: tag policies with strict_start_type
Date:   Thu,  4 Apr 2019 08:54:08 +0200
Message-Id: <20190404065408.5864-7-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190404065408.5864-1-johannes@sipsolutions.net>
References: <20190404065408.5864-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Tag all the nl80211 policies with strict_start_type so that
strict validation is done for all types that we have a policy
for.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d8eaa161c308..5bad1d19c905 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -221,6 +221,7 @@ static int validate_ie_attr(const struct nlattr *attr,
 /* policy for the attributes */
 static const struct nla_policy
 nl80211_ftm_responder_policy[NL80211_FTM_RESP_ATTR_MAX + 1] = {
+	[0] = { .strict_start_type = NL80211_FTM_RESP_ATTR_CIVICLOC + 1 },
 	[NL80211_FTM_RESP_ATTR_ENABLED] = { .type = NLA_FLAG, },
 	[NL80211_FTM_RESP_ATTR_LCI] = { .type = NLA_BINARY,
 					.len = U8_MAX },
@@ -230,6 +231,10 @@ nl80211_ftm_responder_policy[NL80211_FTM_RESP_ATTR_MAX + 1] = {
 
 static const struct nla_policy
 nl80211_pmsr_ftm_req_attr_policy[NL80211_PMSR_FTM_REQ_ATTR_MAX + 1] = {
+	[0] = {
+		.strict_start_type =
+			NL80211_PMSR_FTM_REQ_ATTR_REQUEST_CIVICLOC + 1
+	},
 	[NL80211_PMSR_FTM_REQ_ATTR_ASAP] = { .type = NLA_FLAG },
 	[NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE] = { .type = NLA_U32 },
 	[NL80211_PMSR_FTM_REQ_ATTR_NUM_BURSTS_EXP] =
@@ -246,12 +251,14 @@ nl80211_pmsr_ftm_req_attr_policy[NL80211_PMSR_FTM_REQ_ATTR_MAX + 1] = {
 
 static const struct nla_policy
 nl80211_pmsr_req_data_policy[NL80211_PMSR_TYPE_MAX + 1] = {
+	[0] = { .strict_start_type = NL80211_PMSR_TYPE_FTM + 1 },
 	[NL80211_PMSR_TYPE_FTM] =
 		NLA_POLICY_NESTED(nl80211_pmsr_ftm_req_attr_policy),
 };
 
 static const struct nla_policy
 nl80211_pmsr_req_attr_policy[NL80211_PMSR_REQ_ATTR_MAX + 1] = {
+	[0] = { .strict_start_type = NL80211_PMSR_REQ_ATTR_GET_AP_TSF + 1 },
 	[NL80211_PMSR_REQ_ATTR_DATA] =
 		NLA_POLICY_NESTED(nl80211_pmsr_req_data_policy),
 	[NL80211_PMSR_REQ_ATTR_GET_AP_TSF] = { .type = NLA_FLAG },
@@ -259,6 +266,7 @@ nl80211_pmsr_req_attr_policy[NL80211_PMSR_REQ_ATTR_MAX + 1] = {
 
 static const struct nla_policy
 nl80211_psmr_peer_attr_policy[NL80211_PMSR_PEER_ATTR_MAX + 1] = {
+	[0] = { .strict_start_type = NL80211_PMSR_PEER_ATTR_RESP + 1 },
 	[NL80211_PMSR_PEER_ATTR_ADDR] = NLA_POLICY_ETH_ADDR,
 	/*
 	 * we could specify this again to be the top-level policy,
@@ -272,6 +280,7 @@ nl80211_psmr_peer_attr_policy[NL80211_PMSR_PEER_ATTR_MAX + 1] = {
 
 static const struct nla_policy
 nl80211_pmsr_attr_policy[NL80211_PMSR_ATTR_MAX + 1] = {
+	[0] { .strict_start_type = NL80211_PMSR_ATTR_PEERS + 1 },
 	[NL80211_PMSR_ATTR_MAX_PEERS] = { .type = NLA_REJECT },
 	[NL80211_PMSR_ATTR_REPORT_AP_TSF] = { .type = NLA_REJECT },
 	[NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR] = { .type = NLA_REJECT },
@@ -281,6 +290,7 @@ nl80211_pmsr_attr_policy[NL80211_PMSR_ATTR_MAX + 1] = {
 };
 
 const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
+	[0] = { .strict_start_type = NL80211_ATTR_AIRTIME_WEIGHT + 1 },
 	[NL80211_ATTR_WIPHY] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_NAME] = { .type = NLA_NUL_STRING,
 				      .len = 20-1 },
@@ -545,6 +555,7 @@ const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 
 /* policy for the key attributes */
 static const struct nla_policy nl80211_key_policy[NL80211_KEY_MAX + 1] = {
+	[0] = { .strict_start_type = NL80211_KEY_DEFAULT_TYPES + 1 },
 	[NL80211_KEY_DATA] = { .type = NLA_BINARY, .len = WLAN_MAX_KEY_LEN },
 	[NL80211_KEY_IDX] = { .type = NLA_U8 },
 	[NL80211_KEY_CIPHER] = { .type = NLA_U32 },
@@ -558,6 +569,7 @@ static const struct nla_policy nl80211_key_policy[NL80211_KEY_MAX + 1] = {
 /* policy for the key default flags */
 static const struct nla_policy
 nl80211_key_default_policy[NUM_NL80211_KEY_DEFAULT_TYPES] = {
+	[0] = { .strict_start_type = NL80211_KEY_DEFAULT_TYPE_MULTICAST + 1 },
 	[NL80211_KEY_DEFAULT_TYPE_UNICAST] = { .type = NLA_FLAG },
 	[NL80211_KEY_DEFAULT_TYPE_MULTICAST] = { .type = NLA_FLAG },
 };
@@ -566,6 +578,7 @@ nl80211_key_default_policy[NUM_NL80211_KEY_DEFAULT_TYPES] = {
 /* policy for WoWLAN attributes */
 static const struct nla_policy
 nl80211_wowlan_policy[NUM_NL80211_WOWLAN_TRIG] = {
+	[0] = { .strict_start_type = NL80211_WOWLAN_TRIG_NET_DETECT + 1 },
 	[NL80211_WOWLAN_TRIG_ANY] = { .type = NLA_FLAG },
 	[NL80211_WOWLAN_TRIG_DISCONNECT] = { .type = NLA_FLAG },
 	[NL80211_WOWLAN_TRIG_MAGIC_PKT] = { .type = NLA_FLAG },
@@ -580,6 +593,7 @@ nl80211_wowlan_policy[NUM_NL80211_WOWLAN_TRIG] = {
 
 static const struct nla_policy
 nl80211_wowlan_tcp_policy[NUM_NL80211_WOWLAN_TCP] = {
+	[0] = { .strict_start_type = NL80211_WOWLAN_TCP_WAKE_MASK + 1 },
 	[NL80211_WOWLAN_TCP_SRC_IPV4] = { .type = NLA_U32 },
 	[NL80211_WOWLAN_TCP_DST_IPV4] = { .type = NLA_U32 },
 	[NL80211_WOWLAN_TCP_DST_MAC] = { .len = ETH_ALEN },
@@ -601,6 +615,7 @@ nl80211_wowlan_tcp_policy[NUM_NL80211_WOWLAN_TCP] = {
 /* policy for coalesce rule attributes */
 static const struct nla_policy
 nl80211_coalesce_policy[NUM_NL80211_ATTR_COALESCE_RULE] = {
+	[0] = { .strict_start_type = NL80211_ATTR_COALESCE_RULE_PKT_PATTERN + 1 },
 	[NL80211_ATTR_COALESCE_RULE_DELAY] = { .type = NLA_U32 },
 	[NL80211_ATTR_COALESCE_RULE_CONDITION] =
 		NLA_POLICY_RANGE(NLA_U32,
@@ -612,6 +627,7 @@ nl80211_coalesce_policy[NUM_NL80211_ATTR_COALESCE_RULE] = {
 /* policy for GTK rekey offload attributes */
 static const struct nla_policy
 nl80211_rekey_policy[NUM_NL80211_REKEY_DATA] = {
+	[0] = { .strict_start_type = NL80211_REKEY_DATA_REPLAY_CTR + 1 },
 	[NL80211_REKEY_DATA_KEK] = { .len = NL80211_KEK_LEN },
 	[NL80211_REKEY_DATA_KCK] = { .len = NL80211_KCK_LEN },
 	[NL80211_REKEY_DATA_REPLAY_CTR] = { .len = NL80211_REPLAY_CTR_LEN },
@@ -619,6 +635,7 @@ nl80211_rekey_policy[NUM_NL80211_REKEY_DATA] = {
 
 static const struct nla_policy
 nl80211_match_policy[NL80211_SCHED_SCAN_MATCH_ATTR_MAX + 1] = {
+	[0] = { .strict_start_type = NL80211_SCHED_SCAN_MATCH_ATTR_BSSID + 1 },
 	[NL80211_SCHED_SCAN_MATCH_ATTR_SSID] = { .type = NLA_BINARY,
 						 .len = IEEE80211_MAX_SSID_LEN },
 	[NL80211_SCHED_SCAN_MATCH_ATTR_BSSID] = { .len = ETH_ALEN },
@@ -627,12 +644,14 @@ nl80211_match_policy[NL80211_SCHED_SCAN_MATCH_ATTR_MAX + 1] = {
 
 static const struct nla_policy
 nl80211_plan_policy[NL80211_SCHED_SCAN_PLAN_MAX + 1] = {
+	[0] = { .strict_start_type = NL80211_SCHED_SCAN_PLAN_ITERATIONS + 1 },
 	[NL80211_SCHED_SCAN_PLAN_INTERVAL] = { .type = NLA_U32 },
 	[NL80211_SCHED_SCAN_PLAN_ITERATIONS] = { .type = NLA_U32 },
 };
 
 static const struct nla_policy
 nl80211_bss_select_policy[NL80211_BSS_SELECT_ATTR_MAX + 1] = {
+	[0] = { .strict_start_type = NL80211_BSS_SELECT_ATTR_RSSI_ADJUST + 1 },
 	[NL80211_BSS_SELECT_ATTR_RSSI] = { .type = NLA_FLAG },
 	[NL80211_BSS_SELECT_ATTR_BAND_PREF] = { .type = NLA_U32 },
 	[NL80211_BSS_SELECT_ATTR_RSSI_ADJUST] = {
@@ -643,6 +662,7 @@ nl80211_bss_select_policy[NL80211_BSS_SELECT_ATTR_MAX + 1] = {
 /* policy for NAN function attributes */
 static const struct nla_policy
 nl80211_nan_func_policy[NL80211_NAN_FUNC_ATTR_MAX + 1] = {
+	[0] = { .strict_start_type = NL80211_NAN_FUNC_TERM_REASON + 1 },
 	[NL80211_NAN_FUNC_TYPE] = { .type = NLA_U8 },
 	[NL80211_NAN_FUNC_SERVICE_ID] = {
 				    .len = NL80211_NAN_FUNC_SERVICE_ID_LEN },
@@ -666,6 +686,7 @@ nl80211_nan_func_policy[NL80211_NAN_FUNC_ATTR_MAX + 1] = {
 /* policy for Service Response Filter attributes */
 static const struct nla_policy
 nl80211_nan_srf_policy[NL80211_NAN_SRF_ATTR_MAX + 1] = {
+	[0] = { .strict_start_type = NL80211_NAN_SRF_MAC_ADDRS + 1 },
 	[NL80211_NAN_SRF_INCLUDE] = { .type = NLA_FLAG },
 	[NL80211_NAN_SRF_BF] = { .type = NLA_BINARY,
 				 .len =  NL80211_NAN_FUNC_SRF_MAX_LEN },
@@ -676,6 +697,7 @@ nl80211_nan_srf_policy[NL80211_NAN_SRF_ATTR_MAX + 1] = {
 /* policy for packet pattern attributes */
 static const struct nla_policy
 nl80211_packet_pattern_policy[MAX_NL80211_PKTPAT + 1] = {
+	[0] = { .strict_start_type = NL80211_PKTPAT_OFFSET + 1 },
 	[NL80211_PKTPAT_MASK] = { .type = NLA_BINARY, },
 	[NL80211_PKTPAT_PATTERN] = { .type = NLA_BINARY, },
 	[NL80211_PKTPAT_OFFSET] = { .type = NLA_U32 },
-- 
2.17.2

