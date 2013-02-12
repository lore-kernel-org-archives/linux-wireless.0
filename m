Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47344 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759093Ab3BLOB3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 09:01:29 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: advertise operating mode notification capability
Date: Tue, 12 Feb 2013 15:01:22 +0100
Message-Id: <1360677682-3694-2-git-send-email-johannes@sipsolutions.net> (sfid-20130212_150133_173774_2580BAA0)
In-Reply-To: <1360677682-3694-1-git-send-email-johannes@sipsolutions.net>
References: <1360677682-3694-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Use the new extended capabilities advertising to advertise
the fact that operating mode notification is supported.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 2 ++
 net/mac80211/main.c       | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 4aed928..9164c45 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1788,6 +1788,8 @@ enum ieee80211_tdls_actioncode {
 #define WLAN_EXT_CAPA5_TDLS_ENABLED	BIT(5)
 #define WLAN_EXT_CAPA5_TDLS_PROHIBITED	BIT(6)
 
+#define WLAN_EXT_CAPA8_OPMODE_NOTIF	BIT(6)
+
 /* TDLS specific payload type in the LLC/SNAP header */
 #define WLAN_TDLS_SNAP_RFTYPE	0x2
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 38b3468..26531a3 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -501,6 +501,11 @@ static const struct ieee80211_ht_cap mac80211_ht_capa_mod_mask = {
 	},
 };
 
+static const u8 extended_capabilities[] = {
+	0, 0, 0, 0, 0, 0, 0,
+	WLAN_EXT_CAPA8_OPMODE_NOTIF,
+};
+
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					const struct ieee80211_ops *ops)
 {
@@ -557,6 +562,10 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 			WIPHY_FLAG_REPORTS_OBSS |
 			WIPHY_FLAG_OFFCHAN_TX;
 
+	wiphy->extended_capabilities = extended_capabilities;
+	wiphy->extended_capabilities_mask = extended_capabilities;
+	wiphy->extended_capabilities_len = ARRAY_SIZE(extended_capabilities);
+
 	if (ops->remain_on_channel)
 		wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 
-- 
1.8.0

