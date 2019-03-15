Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36384C10F00
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 15:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11488205C9
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 15:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbfCOPjW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 11:39:22 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44148 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727619AbfCOPjW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 11:39:22 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h4ovX-0004n1-Ll; Fri, 15 Mar 2019 17:39:20 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Mar 2019 17:39:04 +0200
Message-Id: <20190315153907.16192-9-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315153907.16192-1-luca@coelho.fi>
References: <20190315153907.16192-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/11] mac80211: support non-inheritance element
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
 net/mac80211/util.c | 134 +++++++++++++++++++++++++-------------------
 1 file changed, 77 insertions(+), 57 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 4c1655972565..08197afdb7b3 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -894,10 +894,10 @@ EXPORT_SYMBOL(ieee80211_queue_delayed_work);
 static u32
 _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			    struct ieee802_11_elems *elems,
-			    u64 filter, u32 crc, u8 *transmitter_bssid,
-			    u8 *bss_bssid)
+			    u64 filter, u32 crc,
+			    const struct element *check_inherit)
 {
-	const struct element *elem, *sub;
+	const struct element *elem;
 	bool calc_crc = filter != 0;
 	DECLARE_BITMAP(seen_elems, 256);
 	const u8 *ie;
@@ -910,6 +910,11 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 		u8 elen = elem->datalen;
 		const u8 *pos = elem->data;
 
+		if (check_inherit &&
+		    !cfg80211_is_element_inherited(elem,
+						   check_inherit))
+			continue;
+
 		switch (id) {
 		case WLAN_EID_SSID:
 		case WLAN_EID_SUPP_RATES:
@@ -1208,57 +1213,6 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			if (elen >= sizeof(*elems->max_idle_period_ie))
 				elems->max_idle_period_ie = (void *)pos;
 			break;
-		case WLAN_EID_MULTIPLE_BSSID:
-			if (!bss_bssid || !transmitter_bssid || elen < 4)
-				break;
-
-			elems->max_bssid_indicator = pos[0];
-
-			for_each_element(sub, pos + 1, elen - 1) {
-				u8 sub_len = sub->datalen;
-				u8 new_bssid[ETH_ALEN];
-				const u8 *index;
-
-				/*
-				 * we only expect the "non-transmitted BSSID
-				 * profile" subelement (subelement id 0)
-				 */
-				if (sub->id != 0 || sub->datalen < 4) {
-					/* not a valid BSS profile */
-					continue;
-				}
-
-				if (sub->data[0] != WLAN_EID_NON_TX_BSSID_CAP ||
-				    sub->data[1] != 2) {
-					/* The first element of the
-					 * Nontransmitted BSSID Profile is not
-					 * the Nontransmitted BSSID Capability
-					 * element.
-					 */
-					continue;
-				}
-
-				/* found a Nontransmitted BSSID Profile */
-				index = cfg80211_find_ie(WLAN_EID_MULTI_BSSID_IDX,
-							 sub->data, sub_len);
-				if (!index || index[1] < 1 || index[2] == 0) {
-					/* Invalid MBSSID Index element */
-					continue;
-				}
-
-				cfg80211_gen_new_bssid(transmitter_bssid,
-						       pos[0],
-						       index[2],
-						       new_bssid);
-				if (ether_addr_equal(new_bssid, bss_bssid)) {
-					elems->nontransmitted_bssid_profile =
-						(void *)sub;
-					elems->bssid_index_len = index[1];
-					elems->bssid_index = (void *)&index[2];
-					break;
-				}
-			}
-			break;
 		case WLAN_EID_EXTENSION:
 			if (pos[0] == WLAN_EID_EXT_HE_MU_EDCA &&
 			    elen >= (sizeof(*elems->mu_edca_param_set) + 1)) {
@@ -1300,25 +1254,91 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 	return crc;
 }
 
+static void ieee802_11_find_bssid_profile(const u8 *start, size_t len,
+					  struct ieee802_11_elems *elems,
+					  u8 *transmitter_bssid,
+					  u8 *bss_bssid)
+{
+	const struct element *elem, *sub;
+
+	if (!bss_bssid || !transmitter_bssid)
+		return;
+
+	for_each_element_id(elem, WLAN_EID_MULTIPLE_BSSID, start, len) {
+		if (elem->datalen < 2)
+			continue;
+
+		for_each_element(sub, elem->data + 1, elem->datalen - 1) {
+			u8 new_bssid[ETH_ALEN];
+			const u8 *index;
+
+			if (sub->id != 0 || sub->datalen < 4) {
+				/* not a valid BSS profile */
+				continue;
+			}
+
+			if (sub->data[0] != WLAN_EID_NON_TX_BSSID_CAP ||
+			    sub->data[1] != 2) {
+				/* The first element of the
+				 * Nontransmitted BSSID Profile is not
+				 * the Nontransmitted BSSID Capability
+				 * element.
+				 */
+				continue;
+			}
+
+			/* found a Nontransmitted BSSID Profile */
+			index = cfg80211_find_ie(WLAN_EID_MULTI_BSSID_IDX,
+						 sub->data, sub->datalen);
+			if (!index || index[1] < 1 || index[2] == 0) {
+				/* Invalid MBSSID Index element */
+				continue;
+			}
+
+			cfg80211_gen_new_bssid(transmitter_bssid,
+					       elem->data[0],
+					       index[2],
+					       new_bssid);
+			if (ether_addr_equal(new_bssid, bss_bssid)) {
+				elems->nontransmitted_bssid_profile =
+					elem->data;
+				elems->bssid_index_len = index[1];
+				elems->bssid_index = (void *)&index[2];
+				break;
+			}
+		}
+	}
+}
+
 u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			       struct ieee802_11_elems *elems,
 			       u64 filter, u32 crc, u8 *transmitter_bssid,
 			       u8 *bss_bssid)
 {
+	const struct element *non_inherit = NULL;
+
 	memset(elems, 0, sizeof(*elems));
 	elems->ie_start = start;
 	elems->total_len = len;
 
+	ieee802_11_find_bssid_profile(start, len, elems, transmitter_bssid,
+				      bss_bssid);
+
+	if (elems->nontransmitted_bssid_profile)
+		non_inherit =
+			cfg80211_find_ext_elem(WLAN_EID_EXT_NON_INHERITANCE,
+					       &elems->nontransmitted_bssid_profile[2],
+					       elems->nontransmitted_bssid_profile[1]);
+
 	crc = _ieee802_11_parse_elems_crc(start, len, action, elems, filter,
-					  crc, transmitter_bssid, bss_bssid);
+					  crc, non_inherit);
 
 	/* Override with nontransmitted profile, if found */
 	if (transmitter_bssid && elems->nontransmitted_bssid_profile) {
 		const u8 *profile = elems->nontransmitted_bssid_profile;
 
 		_ieee802_11_parse_elems_crc(&profile[2], profile[1],
-					    action, elems, 0, 0,
-					    transmitter_bssid, bss_bssid);
+					    action, elems, 0, 0, NULL);
 	}
 
 	if (elems->tim && !elems->parse_error) {
-- 
2.20.1

