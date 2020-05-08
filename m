Return-Path: <SRS0=6+7Q=6W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B374C4724C
	for <linux-wireless@archiver.kernel.org>; Fri,  8 May 2020 14:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CA642083B
	for <linux-wireless@archiver.kernel.org>; Fri,  8 May 2020 14:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgEHOmW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 May 2020 10:42:22 -0400
Received: from smail.rz.tu-ilmenau.de ([141.24.186.67]:54269 "EHLO
        smail.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbgEHOmV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 May 2020 10:42:21 -0400
Received: from legolas.fritz.box (unknown [87.147.56.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smail.rz.tu-ilmenau.de (Postfix) with ESMTPSA id 04A8658024A;
        Fri,  8 May 2020 16:42:19 +0200 (CEST)
From:   Markus Theil <markus.theil@tu-ilmenau.de>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Markus Theil <markus.theil@tu-ilmenau.de>
Subject: [PATCH 3/3] nl80211: add feature flag for control port tx status capability
Date:   Fri,  8 May 2020 16:42:02 +0200
Message-Id: <20200508144202.7678-4-markus.theil@tu-ilmenau.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508144202.7678-1-markus.theil@tu-ilmenau.de>
References: <20200508144202.7678-1-markus.theil@tu-ilmenau.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch adds a feature flag in order to detect control port tx
status capability.

Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
---
 include/uapi/linux/nl80211.h | 4 ++++
 net/mac80211/main.c          | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index e3b7a911b35c..02e1aa10f9a2 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -5713,6 +5713,9 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_MULTICAST_REGISTRATIONS: management frame registrations
  *	are possible for multicast frames and those will be reported properly.
  *
+ * @NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211_TX_STATUS: The driver
+ *	can report tx status for control port over nl80211 tx operations.
+ *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
@@ -5766,6 +5769,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_DEL_IBSS_STA,
 	NL80211_EXT_FEATURE_MULTICAST_REGISTRATIONS,
 	NL80211_EXT_FEATURE_BEACON_PROTECTION_CLIENT,
+	NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211_TX_STATUS,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index dfcee5e462da..6381e6c1f58b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -596,6 +596,8 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 			      NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211);
 	wiphy_ext_feature_set(wiphy,
 			      NL80211_EXT_FEATURE_CONTROL_PORT_NO_PREAUTH);
+	wiphy_ext_feature_set(wiphy,
+			      NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211_TX_STATUS);
 
 	if (!ops->hw_scan) {
 		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN |
-- 
2.26.2

