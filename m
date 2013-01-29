Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47750 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab3A2VlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 16:41:09 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove unused mesh data from bss
Date: Tue, 29 Jan 2013 22:41:27 +0100
Message-Id: <1359495687-31995-1-git-send-email-johannes@sipsolutions.net> (sfid-20130129_224134_787285_2F1E1840)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

These pointers/values are never used, remove them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 31 -------------------------------
 net/mac80211/scan.c        |  9 ---------
 2 files changed, 40 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e2eecf2..ae92c47 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -95,12 +95,6 @@ struct ieee80211_bss {
 	bool wmm_used;
 	bool uapsd_supported;
 
-#ifdef CONFIG_MAC80211_MESH
-	u8 *mesh_id;
-	size_t mesh_id_len;
-	u8 *mesh_cfg;
-#endif
-
 #define IEEE80211_MAX_SUPP_RATES 32
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 	size_t supp_rates_len;
@@ -151,31 +145,6 @@ enum ieee80211_bss_valid_data_flags {
 	IEEE80211_BSS_VALID_ERP			= BIT(3)
 };
 
-static inline u8 *bss_mesh_cfg(struct ieee80211_bss *bss)
-{
-#ifdef CONFIG_MAC80211_MESH
-	return bss->mesh_cfg;
-#endif
-	return NULL;
-}
-
-static inline u8 *bss_mesh_id(struct ieee80211_bss *bss)
-{
-#ifdef CONFIG_MAC80211_MESH
-	return bss->mesh_id;
-#endif
-	return NULL;
-}
-
-static inline u8 bss_mesh_id_len(struct ieee80211_bss *bss)
-{
-#ifdef CONFIG_MAC80211_MESH
-	return bss->mesh_id_len;
-#endif
-	return 0;
-}
-
-
 typedef unsigned __bitwise__ ieee80211_tx_result;
 #define TX_CONTINUE	((__force ieee80211_tx_result) 0u)
 #define TX_DROP		((__force ieee80211_tx_result) 1u)
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index f69a1b9..061595a 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -29,14 +29,6 @@
 #define IEEE80211_CHANNEL_TIME (HZ / 33)
 #define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 8)
 
-static void ieee80211_rx_bss_free(struct cfg80211_bss *cbss)
-{
-	struct ieee80211_bss *bss = (void *)cbss->priv;
-
-	kfree(bss_mesh_id(bss));
-	kfree(bss_mesh_cfg(bss));
-}
-
 void ieee80211_rx_bss_put(struct ieee80211_local *local,
 			  struct ieee80211_bss *bss)
 {
@@ -85,7 +77,6 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	if (!cbss)
 		return NULL;
 
-	cbss->free_priv = ieee80211_rx_bss_free;
 	bss = (void *)cbss->priv;
 
 	bss->device_ts = rx_status->device_timestamp;
-- 
1.8.0

