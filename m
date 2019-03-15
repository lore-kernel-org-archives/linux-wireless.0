Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4CE8C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 15:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EC5121872
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 15:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbfCOPyt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 11:54:49 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44188 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727826AbfCOPyt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 11:54:49 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h4ovZ-0004n1-L1; Fri, 15 Mar 2019 17:39:22 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Mar 2019 17:39:06 +0200
Message-Id: <20190315153907.16192-11-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315153907.16192-1-luca@coelho.fi>
References: <20190315153907.16192-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 10/11] mac80211: support profile split between elements
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Since an element is limited to 255 octets, a profile may be split
split to several elements. Support the split as defined in the 11ax
draft 3.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/ieee80211_i.h |  1 -
 net/mac80211/util.c        | 56 +++++++++++++++++++++++++-------------
 2 files changed, 37 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e170f986d226..c5708f8a7401 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1505,7 +1505,6 @@ struct ieee802_11_elems {
 	const struct ieee80211_bss_max_idle_period_ie *max_idle_period_ie;
 	const struct ieee80211_multiple_bssid_configuration *mbssid_config_ie;
 	const struct ieee80211_bssid_index *bssid_index;
-	const u8 *nontransmitted_bssid_profile;
 	u8 max_bssid_indicator;
 	u8 dtim_count;
 	u8 dtim_period;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 08197afdb7b3..99dd58454592 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1254,15 +1254,18 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 	return crc;
 }
 
-static void ieee802_11_find_bssid_profile(const u8 *start, size_t len,
-					  struct ieee802_11_elems *elems,
-					  u8 *transmitter_bssid,
-					  u8 *bss_bssid)
+static size_t ieee802_11_find_bssid_profile(const u8 *start, size_t len,
+					    struct ieee802_11_elems *elems,
+					    u8 *transmitter_bssid,
+					    u8 *bss_bssid,
+					    u8 **nontransmitted_profile)
 {
 	const struct element *elem, *sub;
+	size_t profile_len = 0;
+	bool found = false;
 
 	if (!bss_bssid || !transmitter_bssid)
-		return;
+		return profile_len;
 
 	for_each_element_id(elem, WLAN_EID_MULTIPLE_BSSID, start, len) {
 		if (elem->datalen < 2)
@@ -1287,9 +1290,17 @@ static void ieee802_11_find_bssid_profile(const u8 *start, size_t len,
 				continue;
 			}
 
+			memset(*nontransmitted_profile, 0, len);
+			profile_len = cfg80211_merge_profile(start, len,
+							     elem,
+							     sub,
+							     nontransmitted_profile,
+							     len);
+
 			/* found a Nontransmitted BSSID Profile */
 			index = cfg80211_find_ie(WLAN_EID_MULTI_BSSID_IDX,
-						 sub->data, sub->datalen);
+						 *nontransmitted_profile,
+						 profile_len);
 			if (!index || index[1] < 1 || index[2] == 0) {
 				/* Invalid MBSSID Index element */
 				continue;
@@ -1300,14 +1311,15 @@ static void ieee802_11_find_bssid_profile(const u8 *start, size_t len,
 					       index[2],
 					       new_bssid);
 			if (ether_addr_equal(new_bssid, bss_bssid)) {
-				elems->nontransmitted_bssid_profile =
-					elem->data;
+				found = true;
 				elems->bssid_index_len = index[1];
 				elems->bssid_index = (void *)&index[2];
 				break;
 			}
 		}
 	}
+
+	return found ? profile_len : 0;
 }
 
 u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
@@ -1316,30 +1328,34 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			       u8 *bss_bssid)
 {
 	const struct element *non_inherit = NULL;
+	u8 *nontransmitted_profile;
+	int nontransmitted_profile_len = 0;
 
 	memset(elems, 0, sizeof(*elems));
 	elems->ie_start = start;
 	elems->total_len = len;
 
-	ieee802_11_find_bssid_profile(start, len, elems, transmitter_bssid,
-				      bss_bssid);
-
-	if (elems->nontransmitted_bssid_profile)
+	nontransmitted_profile = kmalloc(len, GFP_ATOMIC);
+	if (nontransmitted_profile) {
+		nontransmitted_profile_len =
+			ieee802_11_find_bssid_profile(start, len, elems,
+						      transmitter_bssid,
+						      bss_bssid,
+						      &nontransmitted_profile);
 		non_inherit =
 			cfg80211_find_ext_elem(WLAN_EID_EXT_NON_INHERITANCE,
-					       &elems->nontransmitted_bssid_profile[2],
-					       elems->nontransmitted_bssid_profile[1]);
+					       nontransmitted_profile,
+					       nontransmitted_profile_len);
+	}
 
 	crc = _ieee802_11_parse_elems_crc(start, len, action, elems, filter,
 					  crc, non_inherit);
 
 	/* Override with nontransmitted profile, if found */
-	if (transmitter_bssid && elems->nontransmitted_bssid_profile) {
-		const u8 *profile = elems->nontransmitted_bssid_profile;
-
-		_ieee802_11_parse_elems_crc(&profile[2], profile[1],
+	if (nontransmitted_profile_len)
+		_ieee802_11_parse_elems_crc(nontransmitted_profile,
+					    nontransmitted_profile_len,
 					    action, elems, 0, 0, NULL);
-	}
 
 	if (elems->tim && !elems->parse_error) {
 		const struct ieee80211_tim_ie *tim_ie = elems->tim;
@@ -1359,6 +1375,8 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 	    offsetofend(struct ieee80211_bssid_index, dtim_count))
 		elems->dtim_count = elems->bssid_index->dtim_count;
 
+	kfree(nontransmitted_profile);
+
 	return crc;
 }
 
-- 
2.20.1

