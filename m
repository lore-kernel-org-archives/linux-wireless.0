Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6EF6C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 13:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B72C218AC
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 13:05:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bJmYfP69";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nkZ+xSsD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbfBANFK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 08:05:10 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38076 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727690AbfBANFK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 08:05:10 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 90E7F60A5F; Fri,  1 Feb 2019 13:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549026308;
        bh=GUuhRI1kwUc1yBGdKBD4yglfhVxg5w2Hm+MWkajTTRU=;
        h=From:To:Cc:Subject:Date:From;
        b=bJmYfP69xGGcjGHin27eDE22T+0kY4kEGJQ2HH7leKjOKE79UP/pNdOT2juKtDb3L
         KDjp7d6+K/qaR//AARGXjEw0xAvrcnSSW52AWG96byfhNNtF/+WPJrwxnJhqT7twCs
         SExXCtAG8WKgqHz5ZLhA6hxC2IcjsR2gDZe+cfbs=
Received: from dasaris-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dasaris@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8125E609C3;
        Fri,  1 Feb 2019 13:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549026307;
        bh=GUuhRI1kwUc1yBGdKBD4yglfhVxg5w2Hm+MWkajTTRU=;
        h=From:To:Cc:Subject:Date:From;
        b=nkZ+xSsDDd9qTSre80UcI2Z7oJgQYzQPvzPuYTJCuUl9FetlvVvF+0KgbA8VCx2s/
         oba28M70Vq7HgSlJrGfwNuGcTMKHWVtFezhJm0XlURLWqPGHZ2eCioS+zCOFBO1dUk
         4TXn3bPo/f9n99Mj9Vm5l2cH9BsIdT/5akdGVIAU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8125E609C3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=dasaris@codeaurora.org
From:   Srinivas Dasari <dasaris@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        vamsi krishna <vamsin@codeaurora.org>,
        Srinivas Dasari <dasaris@codeaurora.org>
Subject: [v2] nl80211/cfg80211: Specify band specific min RSSI thresholds with sched scan
Date:   Fri,  1 Feb 2019 18:34:51 +0530
Message-Id: <1549026291-19805-1-git-send-email-dasaris@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: vamsi krishna <vamsin@codeaurora.org>

This commit adds the support to specify the RSSI thresholds per
band for each match set. This enhances the current behavior which
specifies a single rssi_threshold across all the bands by
introducing the rssi_threshold_per_band. These per band rssi
thresholds are referred through NL80211_BAND_* (enum nl80211_band)
variables  as attribute types. Such attributes/values per each
band are nested through NL80211_ATTR_SCHED_SCAN_MIN_RSSI.
These band specific rssi thresholds shall take precedence over
the current rssi_thold per match set.
Drivers indicate this support through
%NL80211_EXT_FEATURE_SCHED_SCAN_BAND_SPECIFIC_RSSI_THOLD.
These per band rssi attributes/values does not specify
"default RSSI filter" as done by
NL80211_SCHED_SCAN_MATCH_ATTR_RSSI to stay backward compatible.
That said, these per band rssi values have to be specified for
the corresponding matchset.

Signed-off-by: vamsi krishna <vamsin@codeaurora.org>
Signed-off-by: Srinivas Dasari <dasaris@codeaurora.org>

---
v2:
Per band rssi thresholds were defined as global for all the
matchsets in v1. This version moves them to represent
each matchset.
---
 include/net/cfg80211.h       |  8 ++++++++
 include/uapi/linux/nl80211.h | 13 +++++++++++++
 net/wireless/nl80211.c       | 45 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7033c90..e151ac9 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1831,11 +1831,19 @@ static inline void get_random_mask_addr(u8 *buf, const u8 *addr, const u8 *mask)
  * @bssid: BSSID to be matched; may be all-zero BSSID in case of SSID match
  *	or no match (RSSI only)
  * @rssi_thold: don't report scan results below this threshold (in s32 dBm)
+ * @per_band_rssi_thold: Minimum rssi threshold for each band to be applied
+ *	for filtering out scan results received. Drivers advertize this support
+ *	of band specific rssi based filtering through the feature capability
+ *	%NL80211_EXT_FEATURE_SCHED_SCAN_BAND_SPECIFIC_RSSI_THOLD. These band
+ *	specific rssi thresholds take precedence over rssi_thold, if specified.
+ *	If not specified for any band, it will be assigned with rssi_thold of
+ *	corresponding matchset.
  */
 struct cfg80211_match_set {
 	struct cfg80211_ssid ssid;
 	u8 bssid[ETH_ALEN];
 	s32 rssi_thold;
+	s32 per_band_rssi_thold[NUM_NL80211_BANDS];
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index dd4f86e..4a94049 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3638,6 +3638,14 @@ enum nl80211_reg_rule_attr {
  *	value as specified by &struct nl80211_bss_select_rssi_adjust.
  * @NL80211_SCHED_SCAN_MATCH_ATTR_BSSID: BSSID to be used for matching
  *	(this cannot be used together with SSID).
+ * @NL80211_SCHED_SCAN_MATCH_PER_BAND_RSSI: Nested attribute that carries the
+ *	band specific minimum rssi thresholds for the bands defined in
+ *	enum nl80211_band. The minimum rssi threshold value(s32) specific to a
+ *	band shall be encapsulated in attribute with type value equals to one
+ *	of the NL80211_BAND_* defined in enum nl80211_band. For example, the
+ *	minimum rssi threshold value for 2.4GHZ band shall be encapsulated
+ *	within an attribute of type NL80211_BAND_2GHZ. And one or more of such
+ *	attributes will be nested within this attribute.
  * @NL80211_SCHED_SCAN_MATCH_ATTR_MAX: highest scheduled scan filter
  *	attribute number currently defined
  * @__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST: internal use
@@ -3650,6 +3658,7 @@ enum nl80211_sched_scan_match_attr {
 	NL80211_SCHED_SCAN_MATCH_ATTR_RELATIVE_RSSI,
 	NL80211_SCHED_SCAN_MATCH_ATTR_RSSI_ADJUST,
 	NL80211_SCHED_SCAN_MATCH_ATTR_BSSID,
+	NL80211_SCHED_SCAN_MATCH_PER_BAND_RSSI,
 
 	/* keep last */
 	__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST,
@@ -5343,6 +5352,9 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_AP_PMKSA_CACHING: Driver/device supports PMKSA caching
  *	(set/del PMKSA operations) in AP mode.
  *
+ * @NL80211_EXT_FEATURE_SCHED_SCAN_BAND_SPECIFIC_RSSI_THOLD: Driver supports
+ *	filtering of sched scan results using band specific RSSI thresholds.
+ *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
@@ -5384,6 +5396,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER,
 	NL80211_EXT_FEATURE_AIRTIME_FAIRNESS,
 	NL80211_EXT_FEATURE_AP_PMKSA_CACHING,
+	NL80211_EXT_FEATURE_SCHED_SCAN_BAND_SPECIFIC_RSSI_THOLD,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index af89e5c..640a812 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -640,6 +640,7 @@ static int validate_ie_attr(const struct nlattr *attr,
 						 .len = IEEE80211_MAX_SSID_LEN },
 	[NL80211_SCHED_SCAN_MATCH_ATTR_BSSID] = { .len = ETH_ALEN },
 	[NL80211_SCHED_SCAN_MATCH_ATTR_RSSI] = { .type = NLA_U32 },
+	[NL80211_SCHED_SCAN_MATCH_PER_BAND_RSSI] = { .type = NLA_NESTED },
 };
 
 static const struct nla_policy
@@ -7554,6 +7555,41 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
+static int
+nl80211_parse_sched_scan_per_band_rssi(struct wiphy *wiphy,
+				       struct cfg80211_match_set *match_sets,
+				       struct nlattr *tb_band_rssi,
+				       s32 rssi_thold)
+{
+	struct nlattr *attr;
+	int i, tmp, ret = 0;
+
+	if (!wiphy_ext_feature_isset(wiphy,
+		    NL80211_EXT_FEATURE_SCHED_SCAN_BAND_SPECIFIC_RSSI_THOLD)) {
+		if (tb_band_rssi)
+			ret = -EOPNOTSUPP;
+		else
+			for (i = 0; i < NUM_NL80211_BANDS; i++)
+				match_sets->per_band_rssi_thold[i] =
+					NL80211_SCAN_RSSI_THOLD_OFF;
+		return ret;
+	}
+
+	for (i = 0; i < NUM_NL80211_BANDS; i++)
+		match_sets->per_band_rssi_thold[i] = rssi_thold;
+
+	nla_for_each_nested(attr, tb_band_rssi, tmp) {
+		enum nl80211_band band = nla_type(attr);
+
+		if (band < 0 || band >= NUM_NL80211_BANDS)
+			return -EINVAL;
+
+		match_sets->per_band_rssi_thold[band] =	nla_get_s32(attr);
+	}
+
+	return 0;
+}
+
 static struct cfg80211_sched_scan_request *
 nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 			 struct nlattr **attrs, int max_match_sets)
@@ -7829,6 +7865,15 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
 				if (rssi)
 					request->match_sets[i].rssi_thold =
 						nla_get_s32(rssi);
+
+				/* Parse per band RSSI attribute */
+				err =
+				nl80211_parse_sched_scan_per_band_rssi(wiphy,
+				    &request->match_sets[i],
+				    tb[NL80211_SCHED_SCAN_MATCH_PER_BAND_RSSI],
+				    request->match_sets[i].rssi_thold);
+				if (err)
+					goto out_free;
 			}
 			i++;
 		}
-- 
1.9.1

