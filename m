Return-Path: <SRS0=8CYu=OJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F8F0C04EB8
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 08:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF72720868
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 08:34:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KC2f/mU7";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Vq4lr7oB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF72720868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbeK3TnC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 30 Nov 2018 14:43:02 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51074 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726459AbeK3TnB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Nov 2018 14:43:01 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6DCEC60B62; Fri, 30 Nov 2018 08:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543566868;
        bh=SibwuEymz9HKL9gb9BlTHl+x1ykFcJp6rx7fThzvYGA=;
        h=From:To:Cc:Subject:Date:From;
        b=KC2f/mU7mMnAr+QpPullYaD96HbTUonBhrhqaV1nVNl0n54oHHb9Cyo5RWimjTdFf
         DWZvXC3ZY+w4NXH8GvRzkDLDavdKl7wouPA9CXG5K471wl1F6QE0bKGed4PI+bI+eI
         Ls/RwffXsm1xKNzKQNXHV5oA458r1CobhsR6KtuI=
Received: from vamsin-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: vamsin@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BFEC860ADD;
        Fri, 30 Nov 2018 08:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543566867;
        bh=SibwuEymz9HKL9gb9BlTHl+x1ykFcJp6rx7fThzvYGA=;
        h=From:To:Cc:Subject:Date:From;
        b=Vq4lr7oBSebWK1OuDW7Xf67UcFqm8vIfefxTyL0Rm7mKgSczEkvN05I4X4w6/Ea7A
         XcvxuRVp03y80CIMcJv2lBYrYxMIe1rOhhWe6bMMISxN+hcqsBHv+PNmIAXN4iklxd
         piAN8kcF621GcXdie/ala5Zna2hPrggED+SsRojU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BFEC860ADD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=vamsin@codeaurora.org
From:   vamsi krishna <vamsin@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, jouni@codeaurora.org,
        vamsi krishna <vamsin@codeaurora.org>
Subject: [PATCH] nl80211/cfg80211: Add support to specify band specific min rssi thresholds with sched scan
Date:   Fri, 30 Nov 2018 14:04:08 +0530
Message-Id: <1543566848-14819-1-git-send-email-vamsin@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Earlier, we have provision to specify a single minimum rssi threshold
min_rssi_thold to drivers which is band agnostic. Add support to configure
drivers with different minimum rssi thresholds for different bands used for
scan results filtering. User space tools shall use NL80211_BAND_* variables
defined in enum nl80211_band as attribute types and the rssi thresholds as
values to form each of the band specific attributes. Such attributes shall
be nested in NL80211_ATTR_SCHED_SCAN_MIN_RSSI attribute.

Also, use new attributes and variables to move away from the earlier design
which has the confusion created by match_set with
NL80211_SCHED_SCAN_MATCH_ATTR_RSSI attribute alone to
be considered as minimum rssi threshold for all matchsets that doesn't have
NL80211_SCHED_SCAN_MATCH_ATTR_RSSI attribute. With this commit, for the
matchsets which doesn't have NL80211_SCHED_SCAN_MATCH_ATTR_RSSI attribute
alone to will use @band_specific_min_rssi_thold as minimum rssi threshold.

For the matchsets that user space configures with some rssi threshold, the
rssi threshold that is configured within matchset will have higher
precedence compared to the band specific rssi thresholds configured with
%NL80211_ATTR_SCHED_SCAN_MIN_RSSI attribute. In other words, if the rssi
value configured with a specific match set(match_set[x].rssi_thold) is not
equal to %NL80211_SCAN_RSSI_THOLD_OFF then match_set[x].rssi_thold value
shall be used scan results filtering that belong to the match set.
Otherwise, if match_set[x].rssi_thold is equals to
%NL80211_SCAN_RSSI_THOLD_OFF then the rssi threshold values configured with
@band_specific_min_rssi_thold shall be used for filtering scan results that
belong to such match set.

The drivers with capability to filter scan results with different rssi
thresholds for different bands shall indicate the support to user space by
setting %NL80211_EXT_FEATURE_SCHED_SCAN_BAND_SPECIFIC_RSSI_THOLD in
wiphy->ext_features. The drivers that support this feature shall use rssi
values from @band_specific_min_rssi_thold for scan results filtering and
shall not use min_rssi_thold anymore.

This commit adds support to specify band specific minimum rssi thresholds
applicable for all scan results but not different band specific rssi
thresholds for individual matchsets. This support can be added later when
needed.

Signed-off-by: vamsi krishna <vamsin@codeaurora.org>

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1fa41b7..c032375 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1848,7 +1848,10 @@ struct cfg80211_bss_select_adjust {
  * @scan_start: start time of the scheduled scan
  * @channels: channels to scan
  * @min_rssi_thold: for drivers only supporting a single threshold, this
- *	contains the minimum over all matchsets
+ *	contains the minimum over all matchsets. This parameter is obsolete for
+ *	the drivers that support scan results filtering with band specific rssi
+ *	thresholds feature associated with
+ *	%NL80211_EXT_FEATURE_SCHED_SCAN_BAND_SPECIFIC_RSSI_THOLD capability.
  * @mac_addr: MAC address used with randomisation
  * @mac_addr_mask: MAC address mask used with randomisation, bits that
  *	are 0 in the mask should be randomised, bits that are 1 should
@@ -1875,6 +1878,12 @@ struct cfg80211_bss_select_adjust {
  *	using @relative_rssi. If delta is a negative number, the BSSs that
  *	belong to the specified band will be penalized by delta dB in relative
  *	comparisions.
+ * @band_specific_min_rssi_thold: Minimum rssi threshold for each band to be
+ *	applied to filter out scan results received. Drivers that support band
+ *	specific rssi based filtering and sets the corresponding capability bit
+ *	%NL80211_EXT_FEATURE_SCHED_SCAN_BAND_SPECIFIC_RSSI_THOLD will use these
+ *	rssi thresholds for filtering scan results and will ignore rssi value
+ *	provided in @min_rssi_thold.
  */
 struct cfg80211_sched_scan_request {
 	u64 reqid;
@@ -1908,6 +1917,7 @@ struct cfg80211_sched_scan_request {
 	u32 owner_nlportid;
 	bool nl_owner_dead;
 	struct list_head list;
+	s32 band_specific_min_rssi_thold[NUM_NL80211_BANDS];
 
 	/* keep last */
 	struct ieee80211_channel *channels[0];
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 6d610ba..0d4dd14 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2254,6 +2254,22 @@ enum nl80211_commands {
  * @NL80211_ATTR_FTM_RESPONDER_STATS: Nested attribute with FTM responder
  *	statistics, see &enum nl80211_ftm_responder_stats.
  *
+ * @NL80211_ATTR_SCHED_SCAN_MIN_RSSI: Nested attribute that carries the band
+ *	specific minimum rssi thresholds for the bands defined in enum
+ *	nl80211_band. The minimum rssi threshold value(s32) specific to a band
+ *	shall be encapsulated in attribute with type value equals to one of the
+ *	NL80211_BAND_* defined in enum nl80211_band. For example, the minimum
+ *	rssi threshold value for 2.4GHz band shall be encapsulated within an
+ *	attribute of type NL80211_BAND_2GHz. And one or more of such attributes
+ *	will be nested within this attribute. If min rssi sub attribute is not
+ *	included for any band, then %NL80211_SCAN_RSSI_THOLD_OFF will be used
+ *	as minimum rssi threshold for scan result filtering.
+ *	If a scan result received in a particular band has lesser rssi than the
+ *	rssi threshold specified for that band, then the scan result shall be
+ *	filtered out. The rssi thresholds specified in matchsets along with ssid
+ *	or bssid attribute will have higher precedence than the thresholds
+ *	mentioned in this attribute while checking rssi.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2699,6 +2715,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_FTM_RESPONDER_STATS,
 
+	NL80211_ATTR_SCHED_SCAN_MIN_RSSI,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -5257,6 +5275,9 @@ enum nl80211_feature_flags {
  *      able to rekey an in-use key correctly. Userspace must not rekey PTK keys
  *      if this flag is not set. Ignoring this can leak clear text packets and/or
  *      freeze the connection.
+ * @NL80211_EXT_FEATURE_SCHED_SCAN_BAND_SPECIFIC_RSSI_THOLD: The driver supports
+ *	filtering scan results with band specific rssi thresholds that are
+ *	specified within %NL80211_ATTR_SCHED_SCAN_MIN_RSSI.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5297,6 +5318,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT,
 	NL80211_EXT_FEATURE_CAN_REPLACE_PTK0,
 	NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER,
+	NL80211_EXT_FEATURE_SCHED_SCAN_BAND_SPECIFIC_RSSI_THOLD,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 744b585..4fc0bfc 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -497,6 +497,7 @@ static int validate_ie_attr(const struct nlattr *attr,
 		.type = NLA_NESTED,
 		.validation_data = nl80211_ftm_responder_policy,
 	},
+	[NL80211_ATTR_SCHED_SCAN_MIN_RSSI] = { .type = NLA_NESTED },
 };
 
 /* policy for the key attributes */
@@ -7344,6 +7345,37 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
+static int
+nl80211_parse_sched_scan_min_rssi(struct wiphy *wiphy,
+				  struct cfg80211_sched_scan_request *request,
+				  struct nlattr **attrs)
+{
+	struct nlattr *attr;
+	int i, tmp;
+
+	if (!attrs[NL80211_ATTR_SCHED_SCAN_MIN_RSSI]) {
+		for (i = 0; i < NUM_NL80211_BANDS; i++)
+			request->band_specific_min_rssi_thold[i] =
+							request->min_rssi_thold;
+		return 0;
+	}
+
+	for (i = 0; i < NUM_NL80211_BANDS; i++)
+		request->band_specific_min_rssi_thold[i] =
+						NL80211_SCAN_RSSI_THOLD_OFF;
+
+	nla_for_each_nested(attr, attrs[NL80211_ATTR_SCHED_SCAN_MIN_RSSI],
+			    tmp) {
+		enum nl80211_band band = nla_type(attr);
+
+		if (band < 0 || band >= NUM_NL80211_BANDS)
+			return -EINVAL;
+
+		request->band_specific_min_rssi_thold[band] = nla_get_s32(attr);
+	}
+	return 0;
+}
+
 static struct cfg80211_sched_scan_request *
 nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 			 struct nlattr **attrs, int max_match_sets)
@@ -7460,6 +7492,11 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
 	     attrs[NL80211_ATTR_SCHED_SCAN_RSSI_ADJUST]))
 		return ERR_PTR(-EINVAL);
 
+	if (!wiphy_ext_feature_isset(wiphy,
+		    NL80211_EXT_FEATURE_SCHED_SCAN_BAND_SPECIFIC_RSSI_THOLD) &&
+	    attrs[NL80211_ATTR_SCHED_SCAN_MIN_RSSI])
+		return ERR_PTR(-EINVAL);
+
 	request = kzalloc(sizeof(*request)
 			+ sizeof(*request->ssids) * n_ssids
 			+ sizeof(*request->match_sets) * n_match_sets
@@ -7636,6 +7673,10 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
 		request->min_rssi_thold = NL80211_SCAN_RSSI_THOLD_OFF;
 	}
 
+	err = nl80211_parse_sched_scan_min_rssi(wiphy, request, attrs);
+	if (err)
+		goto out_free;
+
 	if (ie_len) {
 		request->ie_len = ie_len;
 		memcpy((void *)request->ie,
-- 
1.9.1

