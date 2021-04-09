Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F373C43461
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Apr 2021 09:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAAF961106
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Apr 2021 09:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbhDIJkr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Apr 2021 05:40:47 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44230 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230181AbhDIJkq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Apr 2021 05:40:46 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1lUncs-000ELR-VL; Fri, 09 Apr 2021 12:40:32 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org
Date:   Fri,  9 Apr 2021 12:40:15 +0300
Message-Id: <iwlwifi.20210409123755.8280e31d8091.Ifcb29f84f432290338f80c8378aa5c9e0a390c93@changeid>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210409094028.356611-1-luca@coelho.fi>
References: <20210409094028.356611-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 02/15] nl80211: Add new RSNXE related nl80211 extended features
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

Draft P802.11ax_D2.5 defines the following capabilities that
can be negotiated using RSNXE capabilities:

- Secure LTF measurement exchange protocol.
- Secure RTT measurement exchange protocol.
- Management frame protection for all management frames exchanged
  during the negotiation and range measurement procedure.

Extend the nl80211 API to allow drivers to declare support for
these new capabilities as part of extended feature.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/uapi/linux/nl80211.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index ac78da99fccd..325f2c621840 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -5937,6 +5937,16 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_BEACON_RATE_HE: Driver supports beacon rate
  *	configuration (AP/mesh) with HE rates.
  *
+ * @NL80211_EXT_FEATURE_SECURE_LTF: Device supports secure LTF measurement
+ *      exchange protocol.
+ *
+ * @NL80211_EXT_FEATURE_SECURE_RTT: Device supports secure RTT measurement
+ *      exchange protocol.
+ *
+ * @NL80211_EXT_FEATURE_PROT_RANGE_NEGO_AND_MEASURE: Device supports management
+ *      frame protection for all management frames exchanged during the
+ *      negotiation and range measurement procedure.
+ *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
@@ -5998,6 +6008,9 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_FILS_DISCOVERY,
 	NL80211_EXT_FEATURE_UNSOL_BCAST_PROBE_RESP,
 	NL80211_EXT_FEATURE_BEACON_RATE_HE,
+	NL80211_EXT_FEATURE_SECURE_LTF,
+	NL80211_EXT_FEATURE_SECURE_RTT,
+	NL80211_EXT_FEATURE_PROT_RANGE_NEGO_AND_MEASURE,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
-- 
2.31.0

