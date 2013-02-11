Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43651 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405Ab3BKP0F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 10:26:05 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: advertise operating mode notification capability
Date: Mon, 11 Feb 2013 16:26:00 +0100
Message-Id: <1360596360-13422-2-git-send-email-johannes@sipsolutions.net> (sfid-20130211_162610_952879_2E2604CC)
In-Reply-To: <1360596360-13422-1-git-send-email-johannes@sipsolutions.net>
References: <1360596360-13422-1-git-send-email-johannes@sipsolutions.net>
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

