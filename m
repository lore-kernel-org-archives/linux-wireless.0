Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8901 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754163AbcJYWrW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Oct 2016 18:47:22 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 3/8] cfg80211: Add feature flag for Fast Initial Link Setup (FILS)
Date: Wed, 26 Oct 2016 01:42:32 +0300
Message-ID: <1477435357-8495-4-git-send-email-jouni@qca.qualcomm.com> (sfid-20161026_004726_369613_F74C17D2)
In-Reply-To: <1477435357-8495-1-git-send-email-jouni@qca.qualcomm.com>
References: <1477435357-8495-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This defines a feature flag that drivers can use to indicate that they
support (IEEE 802.11ai) when using user space SME
(NL80211_CMD_AUTHENTICATE) in station mode.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/uapi/linux/nl80211.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 528aa48..39e1647 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4641,6 +4641,8 @@ enum nl80211_feature_flags {
  *	configuration (AP/mesh) with HT rates.
  * @NL80211_EXT_FEATURE_BEACON_RATE_VHT: Driver supports beacon rate
  *	configuration (AP/mesh) with VHT rates.
+ * @NL80211_EXT_FEATURE_FILS: This driver supports Fast Initial Link Setup with
+ *	user space SME (NL80211_CMD_AUTHENTICATE) in station mode.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4655,6 +4657,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_BEACON_RATE_LEGACY,
 	NL80211_EXT_FEATURE_BEACON_RATE_HT,
 	NL80211_EXT_FEATURE_BEACON_RATE_VHT,
+	NL80211_EXT_FEATURE_FILS,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
-- 
1.9.1
