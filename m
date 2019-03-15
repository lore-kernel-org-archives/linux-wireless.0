Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07007C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 15:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5386205C9
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 15:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbfCOPjV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 11:39:21 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44136 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729361AbfCOPjU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 11:39:20 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h4ovW-0004n1-QQ; Fri, 15 Mar 2019 17:39:19 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Mar 2019 17:39:03 +0200
Message-Id: <20190315153907.16192-8-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315153907.16192-1-luca@coelho.fi>
References: <20190315153907.16192-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 07/11] cfg80211: support non-inheritance element
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Subelement profile may specify element IDs it doesn't inherit
from the management frame. Support it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/linux/ieee80211.h |  1 +
 include/net/cfg80211.h    |  8 +++++
 net/wireless/scan.c       | 61 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 48703ec60d06..522881f31938 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2487,6 +2487,7 @@ enum ieee80211_eid_ext {
 	WLAN_EID_EXT_HE_MU_EDCA = 38,
 	WLAN_EID_EXT_MAX_CHANNEL_SWITCH_TIME = 52,
 	WLAN_EID_EXT_MULTIPLE_BSSID_CONFIGURATION = 55,
+	WLAN_EID_EXT_NON_INHERITANCE = 56,
 };
 
 /* Action category code */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bb307a11ee63..cd47b7085f59 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5491,6 +5491,14 @@ static inline void cfg80211_gen_new_bssid(const u8 *bssid, u8 max_bssid,
 	u64_to_ether_addr(new_bssid_u64, new_bssid);
 }
 
+/**
+ * cfg80211_is_element_inherited - returns if element ID should be inherited
+ * @element: element to check
+ * @non_inherit_element: non inheritance element
+ */
+bool cfg80211_is_element_inherited(const struct element *element,
+				   const struct element *non_inherit_element);
+
 /**
  * enum cfg80211_bss_frame_type - frame type that the BSS data came from
  * @CFG80211_BSS_FTYPE_UNKNOWN: driver doesn't know whether the data is
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 49f700a1460b..bda9114ded77 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -179,12 +179,63 @@ static bool __cfg80211_unlink_bss(struct cfg80211_registered_device *rdev,
 	return true;
 }
 
+bool cfg80211_is_element_inherited(const struct element *elem,
+				   const struct element *non_inherit_elem)
+{
+	u8 id_len, ext_id_len, i, loop_len, id;
+	const u8 *list;
+
+	if (elem->id == WLAN_EID_MULTIPLE_BSSID)
+		return false;
+
+	if (!non_inherit_elem || non_inherit_elem->datalen < 2)
+		return true;
+
+	/*
+	 * non inheritance element format is:
+	 * ext ID (56) | IDs list len | list | extension IDs list len | list
+	 * Both lists are optional. Both lengths are mandatory.
+	 * This means valid length is:
+	 * elem_len = 1 (extension ID) + 2 (list len fields) + list lengths
+	 */
+	id_len = non_inherit_elem->data[1];
+	if (non_inherit_elem->datalen < 3 + id_len)
+		return true;
+
+	ext_id_len = non_inherit_elem->data[2 + id_len];
+	if (non_inherit_elem->datalen < 3 + id_len + ext_id_len)
+		return true;
+
+	if (elem->id == WLAN_EID_EXTENSION) {
+		if (!ext_id_len)
+			return true;
+		loop_len = ext_id_len;
+		list = &non_inherit_elem->data[3 + id_len];
+		id = elem->data[0];
+	} else {
+		if (!id_len)
+			return true;
+		loop_len = id_len;
+		list = &non_inherit_elem->data[2];
+		id = elem->id;
+	}
+
+	for (i = 0; i < loop_len; i++) {
+		if (list[i] == id)
+			return false;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(cfg80211_is_element_inherited);
+
 static size_t cfg80211_gen_new_ie(const u8 *ie, size_t ielen,
 				  const u8 *subelement, size_t subie_len,
 				  u8 *new_ie, gfp_t gfp)
 {
 	u8 *pos, *tmp;
 	const u8 *tmp_old, *tmp_new;
+	const struct element *non_inherit_elem;
 	u8 *sub_copy;
 
 	/* copy subelement as we need to change its content to
@@ -204,6 +255,11 @@ static size_t cfg80211_gen_new_ie(const u8 *ie, size_t ielen,
 		pos += (tmp_new[1] + 2);
 	}
 
+	/* get non inheritance list if exists */
+	non_inherit_elem =
+		cfg80211_find_ext_elem(WLAN_EID_EXT_NON_INHERITANCE,
+				       sub_copy, subie_len);
+
 	/* go through IEs in ie (skip SSID) and subelement,
 	 * merge them into new_ie
 	 */
@@ -224,8 +280,11 @@ static size_t cfg80211_gen_new_ie(const u8 *ie, size_t ielen,
 						     subie_len);
 
 		if (!tmp) {
+			const struct element *old_elem = (void *)tmp_old;
+
 			/* ie in old ie but not in subelement */
-			if (tmp_old[0] != WLAN_EID_MULTIPLE_BSSID) {
+			if (cfg80211_is_element_inherited(old_elem,
+							  non_inherit_elem)) {
 				memcpy(pos, tmp_old, tmp_old[1] + 2);
 				pos += tmp_old[1] + 2;
 			}
-- 
2.20.1

