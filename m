Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47728 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab3A2Vdc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 16:33:32 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove last_probe_resp from bss
Date: Tue, 29 Jan 2013 22:33:52 +0100
Message-Id: <1359495232-32092-1-git-send-email-johannes@sipsolutions.net> (sfid-20130129_223340_996761_8B99FD0B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We track this, but never use it, so we can
just remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 2 --
 net/mac80211/scan.c        | 3 ---
 2 files changed, 5 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4b71477..e2eecf2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -95,8 +95,6 @@ struct ieee80211_bss {
 	bool wmm_used;
 	bool uapsd_supported;
 
-	unsigned long last_probe_resp;
-
 #ifdef CONFIG_MAC80211_MESH
 	u8 *mesh_id;
 	size_t mesh_id_len;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 607684c..f69a1b9 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -146,9 +146,6 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 			bss->valid_data |= IEEE80211_BSS_VALID_WMM;
 	}
 
-	if (!beacon)
-		bss->last_probe_resp = jiffies;
-
 	return bss;
 }
 
-- 
1.8.0

