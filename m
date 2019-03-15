Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD20C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 15:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F7CA205C9
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 15:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbfCOPjX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 11:39:23 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44160 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729361AbfCOPjW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 11:39:22 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h4ovY-0004n1-Nq; Fri, 15 Mar 2019 17:39:21 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Mar 2019 17:39:05 +0200
Message-Id: <20190315153907.16192-10-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315153907.16192-1-luca@coelho.fi>
References: <20190315153907.16192-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 09/11] cfg80211: support profile split between elements
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Since an element is limited to 255 octets, a profile may be split
split to several elements. Support the split as defined in the 11ax
draft 3. Detect legacy split and print a net-rate limited warning,
since there is no ROI in supporting this probably non-existent
split.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h |  14 ++++++
 net/wireless/scan.c    | 109 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 117 insertions(+), 6 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index cd47b7085f59..f192c65fe9b4 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5499,6 +5499,20 @@ static inline void cfg80211_gen_new_bssid(const u8 *bssid, u8 max_bssid,
 bool cfg80211_is_element_inherited(const struct element *element,
 				   const struct element *non_inherit_element);
 
+/**
+ * cfg80211_merge_profile - merges a MBSSID profile if it is split between IEs
+ * @ie: ies
+ * @ielen: length of IEs
+ * @mbssid_elem: current MBSSID element
+ * @sub_elem: current MBSSID subelement (profile)
+ * @merged_ie: location of the merged profile
+ * @max_copy_len: max merged profile length
+ */
+size_t cfg80211_merge_profile(const u8 *ie, size_t ielen,
+			      const struct element *mbssid_elem,
+			      const struct element *sub_elem,
+			      u8 **merged_ie, size_t max_copy_len);
+
 /**
  * enum cfg80211_bss_frame_type - frame type that the BSS data came from
  * @CFG80211_BSS_FTYPE_UNKNOWN: driver doesn't know whether the data is
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index bda9114ded77..878c867f3f7d 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1456,6 +1456,78 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 	return &res->pub;
 }
 
+static const struct element
+*cfg80211_get_profile_continuation(const u8 *ie, size_t ielen,
+				   const struct element *mbssid_elem,
+				   const struct element *sub_elem)
+{
+	const u8 *mbssid_end = mbssid_elem->data + mbssid_elem->datalen;
+	const struct element *next_mbssid;
+	const struct element *next_sub;
+
+	next_mbssid = cfg80211_find_elem(WLAN_EID_MULTIPLE_BSSID,
+					 mbssid_end,
+					 ielen - (mbssid_end - ie));
+
+	/*
+	 * If is is not the last subelement in current MBSSID IE or there isn't
+	 * a next MBSSID IE - profile is complete.
+	*/
+	if ((sub_elem->data + sub_elem->datalen < mbssid_end - 1) ||
+	    !next_mbssid)
+		return NULL;
+
+	/* For any length error, just return NULL */
+
+	if (next_mbssid->datalen < 4)
+		return NULL;
+
+	next_sub = (void *)&next_mbssid->data[1];
+
+	if (next_mbssid->data + next_mbssid->datalen <
+	    next_sub->data + next_sub->datalen)
+		return NULL;
+
+	if (next_sub->id != 0 || next_sub->datalen < 2)
+		return NULL;
+
+	/*
+	 * Check if the first element in the next sub element is a start
+	 * of a new profile
+	 */
+	return next_sub->data[0] == WLAN_EID_NON_TX_BSSID_CAP ?
+	       NULL : next_mbssid;
+}
+
+size_t cfg80211_merge_profile(const u8 *ie, size_t ielen,
+			      const struct element *mbssid_elem,
+			      const struct element *sub_elem,
+			      u8 **merged_ie, size_t max_copy_len)
+{
+	size_t copied_len = sub_elem->datalen;
+	const struct element *next_mbssid;
+
+	if (sub_elem->datalen > max_copy_len)
+		return 0;
+
+	memcpy(*merged_ie, sub_elem->data, sub_elem->datalen);
+
+	while ((next_mbssid = cfg80211_get_profile_continuation(ie, ielen,
+								mbssid_elem,
+								sub_elem))) {
+		const struct element *next_sub = (void *)&next_mbssid->data[1];
+
+		if (copied_len + next_sub->datalen > max_copy_len)
+			break;
+		memcpy(*merged_ie + copied_len, next_sub->data,
+		       next_sub->datalen);
+		copied_len += next_sub->datalen;
+	}
+
+	return copied_len;
+}
+EXPORT_SYMBOL(cfg80211_merge_profile);
+
 static void cfg80211_parse_mbssid_data(struct wiphy *wiphy,
 				       struct cfg80211_inform_bss *data,
 				       enum cfg80211_bss_frame_type ftype,
@@ -1469,7 +1541,8 @@ static void cfg80211_parse_mbssid_data(struct wiphy *wiphy,
 	const struct element *elem, *sub;
 	size_t new_ie_len;
 	u8 new_bssid[ETH_ALEN];
-	u8 *new_ie;
+	u8 *new_ie, *profile;
+	u64 seen_indices = 0;
 	u16 capability;
 	struct cfg80211_bss *bss;
 
@@ -1487,10 +1560,16 @@ static void cfg80211_parse_mbssid_data(struct wiphy *wiphy,
 	if (!new_ie)
 		return;
 
+	profile = kmalloc(ielen, gfp);
+	if (!profile)
+		goto out;
+
 	for_each_element_id(elem, WLAN_EID_MULTIPLE_BSSID, ie, ielen) {
 		if (elem->datalen < 4)
 			continue;
 		for_each_element(sub, elem->data + 1, elem->datalen - 1) {
+			u8 profile_len;
+
 			if (sub->id != 0 || sub->datalen < 4) {
 				/* not a valid BSS profile */
 				continue;
@@ -1505,16 +1584,31 @@ static void cfg80211_parse_mbssid_data(struct wiphy *wiphy,
 				continue;
 			}
 
+			memset(profile, 0, ielen);
+			profile_len = cfg80211_merge_profile(ie, ielen,
+							     elem,
+							     sub,
+							     &profile,
+							     ielen);
+
 			/* found a Nontransmitted BSSID Profile */
 			mbssid_index_ie = cfg80211_find_ie
 				(WLAN_EID_MULTI_BSSID_IDX,
-				 sub->data, sub->datalen);
+				 profile, profile_len);
 			if (!mbssid_index_ie || mbssid_index_ie[1] < 1 ||
-			    mbssid_index_ie[2] == 0) {
+			    mbssid_index_ie[2] == 0 ||
+			    mbssid_index_ie[2] > 46) {
 				/* No valid Multiple BSSID-Index element */
 				continue;
 			}
 
+			if (seen_indices & BIT(mbssid_index_ie[2]))
+				/* We don't support legacy split of a profile */
+				net_dbg_ratelimited("Partial info for BSSID index %d\n",
+						    mbssid_index_ie[2]);
+
+			seen_indices |= BIT(mbssid_index_ie[2]);
+
 			non_tx_data->bssid_index = mbssid_index_ie[2];
 			non_tx_data->max_bssid_indicator = elem->data[0];
 
@@ -1523,13 +1617,14 @@ static void cfg80211_parse_mbssid_data(struct wiphy *wiphy,
 					       non_tx_data->bssid_index,
 					       new_bssid);
 			memset(new_ie, 0, IEEE80211_MAX_DATA_LEN);
-			new_ie_len = cfg80211_gen_new_ie(ie, ielen, sub->data,
-							 sub->datalen, new_ie,
+			new_ie_len = cfg80211_gen_new_ie(ie, ielen,
+							 profile,
+							 profile_len, new_ie,
 							 gfp);
 			if (!new_ie_len)
 				continue;
 
-			capability = get_unaligned_le16(sub->data + 2);
+			capability = get_unaligned_le16(profile + 2);
 			bss = cfg80211_inform_single_bss_data(wiphy, data,
 							      ftype,
 							      new_bssid, tsf,
@@ -1545,7 +1640,9 @@ static void cfg80211_parse_mbssid_data(struct wiphy *wiphy,
 		}
 	}
 
+out:
 	kfree(new_ie);
+	kfree(profile);
 }
 
 struct cfg80211_bss *
-- 
2.20.1

