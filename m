Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C024BC282CB
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:24:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AD2E20869
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:24:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbfBHNYY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:24:24 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:48872 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbfBHNYY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 08:24:24 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gs60P-0008Jb-FV; Fri, 08 Feb 2019 14:15:45 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>
Subject: [PATCH v8 11/15] mac80211: indicate support for multiple BSSID
Date:   Fri,  8 Feb 2019 14:15:35 +0100
Message-Id: <20190208131539.6813-11-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190208131539.6813-1-johannes@sipsolutions.net>
References: <20190208131539.6813-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Set multi-bssid support flags according to driver support.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h |  5 +++++
 include/net/mac80211.h    |  7 +++++++
 net/mac80211/debugfs.c    |  4 +++-
 net/mac80211/main.c       | 13 ++++++++++++-
 net/mac80211/mlme.c       | 15 +++++++++++++++
 5 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 7479f0bd50e1..8da5ba97328f 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2657,6 +2657,11 @@ enum ieee80211_tdls_actioncode {
  */
 #define WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING	BIT(2)
 
+/* Multiple BSSID capability is set in the 6th bit of 3rd byte of the
+ * @WLAN_EID_EXT_CAPABILITY information element
+ */
+#define WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT	BIT(6)
+
 /* TDLS capabilities in the the 4th byte of @WLAN_EID_EXT_CAPABILITY */
 #define WLAN_EXT_CAPA4_TDLS_BUFFER_STA		BIT(4)
 #define WLAN_EXT_CAPA4_TDLS_PEER_PSM		BIT(5)
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b0e364f50285..97aed7b1ba5d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2234,6 +2234,11 @@ struct ieee80211_txq {
  * @IEEE80211_HW_TX_STATUS_NO_AMPDU_LEN: Driver does not report accurate A-MPDU
  *	length in tx status information
  *
+ * @IEEE80211_HW_SUPPORTS_MULTI_BSSID: Hardware supports multi BSSID
+ *
+ * @IEEE80211_HW_SUPPORTS_ONLY_HE_MULTI_BSSID: Hardware supports multi BSSID
+ *	only for HE APs. Applies if @IEEE80211_HW_SUPPORTS_MULTI_BSSID is set.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2283,6 +2288,8 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_VHT_EXT_NSS_BW,
 	IEEE80211_HW_STA_MMPDU_TXQ,
 	IEEE80211_HW_TX_STATUS_NO_AMPDU_LEN,
+	IEEE80211_HW_SUPPORTS_MULTI_BSSID,
+	IEEE80211_HW_SUPPORTS_ONLY_HE_MULTI_BSSID,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 343ad0a915e4..2d43bc127043 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -3,7 +3,7 @@
  *
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  *
  * GPLv2
  *
@@ -219,6 +219,8 @@ static const char *hw_flag_names[] = {
 	FLAG(SUPPORTS_VHT_EXT_NSS_BW),
 	FLAG(STA_MMPDU_TXQ),
 	FLAG(TX_STATUS_NO_AMPDU_LEN),
+	FLAG(SUPPORTS_MULTI_BSSID),
+	FLAG(SUPPORTS_ONLY_HE_MULTI_BSSID),
 #undef FLAG
 };
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 71005b6dfcd1..5055aeba5c5a 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -4,7 +4,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright (C) 2017     Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1112,6 +1112,17 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (ieee80211_hw_check(&local->hw, CHANCTX_STA_CSA))
 		local->ext_capa[0] |= WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING;
 
+	/* mac80211 supports multi BSSID, if the driver supports it */
+	if (ieee80211_hw_check(&local->hw, SUPPORTS_MULTI_BSSID)) {
+		local->hw.wiphy->support_mbssid = true;
+		if (ieee80211_hw_check(&local->hw,
+				       SUPPORTS_ONLY_HE_MULTI_BSSID))
+			local->hw.wiphy->support_only_he_mbssid = true;
+		else
+			local->ext_capa[2] |=
+				WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT;
+	}
+
 	local->hw.wiphy->max_num_csa_counters = IEEE80211_MAX_CSA_COUNTERS_NUM;
 
 	result = wiphy_register(local->hw.wiphy);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 64b6ddb67456..a49fbb3f3ed7 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -813,6 +813,21 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		}
 	}
 
+	/* Set MBSSID support for HE AP if needed */
+	if (ieee80211_hw_check(&local->hw, SUPPORTS_ONLY_HE_MULTI_BSSID) &&
+	    !(ifmgd->flags & IEEE80211_STA_DISABLE_HE) && assoc_data->ie_len) {
+		struct element *elem;
+
+		/* we know it's writable, cast away the const */
+		elem = (void *)cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY,
+						  assoc_data->ie,
+						  assoc_data->ie_len);
+
+		/* We can probably assume both always true */
+		if (elem && elem->datalen >= 3)
+			elem->data[2] |= WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT;
+	}
+
 	/* if present, add any custom IEs that go before HT */
 	if (assoc_data->ie_len) {
 		static const u8 before_ht[] = {
-- 
2.17.2

