Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A10C7C43387
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:08:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C1832084D
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729966AbeLOJIy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 04:08:54 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42326 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726030AbeLOJIy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 04:08:54 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gY5rP-0002oc-1V; Sat, 15 Dec 2018 11:03:47 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date:   Sat, 15 Dec 2018 11:03:23 +0200
Message-Id: <20181215090325.31604-23-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181215090325.31604-1-luca@coelho.fi>
References: <20181215090325.31604-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 22/24] cfg80211: clarify LCI/civic location documentation
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

The older code and current userspace assumed that this data
is the content of the Measurement Report element, starting
with the Measurement Token. Clarify this in the documentation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       |  6 ++++--
 include/uapi/linux/nl80211.h | 16 ++++++++++++----
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 30618afab657..36f829b75428 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -777,8 +777,10 @@ struct cfg80211_crypto_settings {
  * @probe_resp: probe response template (AP mode only)
  * @ftm_responder: enable FTM responder functionality; -1 for no change
  *	(which also implies no change in LCI/civic location data)
- * @lci: LCI subelement content
- * @civicloc: Civic location subelement content
+ * @lci: Measurement Report element content, starting with Measurement Token
+ *	(measurement type 8)
+ * @civicloc: Measurement Report element content, starting with Measurement
+ *	Token (measurement type 11)
  * @lci_len: LCI data length
  * @civicloc_len: Civic location data length
  */
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 3843214ec7ee..81a1e83c589c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -5895,9 +5895,11 @@ enum nl80211_external_auth_action {
  * @__NL80211_FTM_RESP_ATTR_INVALID: Invalid
  * @NL80211_FTM_RESP_ATTR_ENABLED: FTM responder is enabled
  * @NL80211_FTM_RESP_ATTR_LCI: The content of Measurement Report Element
- *	(9.4.2.22 in 802.11-2016) with type 8 - LCI (9.4.2.22.10)
+ *	(9.4.2.22 in 802.11-2016) with type 8 - LCI (9.4.2.22.10),
+ *	i.e. starting with the measurement token
  * @NL80211_FTM_RESP_ATTR_CIVIC: The content of Measurement Report Element
- *	(9.4.2.22 in 802.11-2016) with type 11 - Civic (Section 9.4.2.22.13)
+ *	(9.4.2.22 in 802.11-2016) with type 11 - Civic (Section 9.4.2.22.13),
+ *	i.e. starting with the measurement token
  * @__NL80211_FTM_RESP_ATTR_LAST: Internal
  * @NL80211_FTM_RESP_ATTR_MAX: highest FTM responder attribute.
  */
@@ -6297,9 +6299,15 @@ enum nl80211_peer_measurement_ftm_failure_reasons {
  * @NL80211_PMSR_FTM_RESP_ATTR_DIST_VARIANCE: distance variance (u64, mm^2, note
  *	that standard deviation is the square root of variance, optional)
  * @NL80211_PMSR_FTM_RESP_ATTR_DIST_SPREAD: distance spread (u64, mm, optional)
- * @NL80211_PMSR_FTM_RESP_ATTR_LCI: LCI data from peer (binary, optional)
+ * @NL80211_PMSR_FTM_RESP_ATTR_LCI: LCI data from peer (binary, optional);
+ *	this is the contents of the Measurement Report Element (802.11-2016
+ *	9.4.2.22.1) starting with the Measurement Token, with Measurement
+ *	Type 8.
  * @NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC: civic location data from peer
- *	(binary, optional)
+ *	(binary, optional);
+ *	this is the contents of the Measurement Report Element (802.11-2016
+ *	9.4.2.22.1) starting with the Measurement Token, with Measurement
+ *	Type 11.
  * @NL80211_PMSR_FTM_RESP_ATTR_PAD: ignore, for u64/s64 padding only
  *
  * @NUM_NL80211_PMSR_FTM_RESP_ATTR: internal
-- 
2.19.2

