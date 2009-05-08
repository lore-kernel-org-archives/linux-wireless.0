Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47649 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179AbZEHSrl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 14:47:41 -0400
Subject: [PATCH] mac80211: move HT operation mode BSS info
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 08 May 2009 20:47:39 +0200
Message-Id: <1241808459.32747.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There really is no need to have a separate struct for a
single variable. The fact that it exists is due to the
code legacy, but we can remove that now. Very simple.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    4 ++--
 drivers/net/wireless/mac80211_hwsim.c   |    2 +-
 drivers/net/wireless/mwl8k.c            |    2 +-
 include/net/mac80211.h                  |   12 +++---------
 net/mac80211/mlme.c                     |   11 ++++-------
 5 files changed, 11 insertions(+), 20 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-05-08 20:10:06.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-05-08 20:15:13.000000000 +0200
@@ -171,14 +171,6 @@ enum ieee80211_bss_change {
 };
 
 /**
- * struct ieee80211_bss_ht_conf - BSS's changing HT configuration
- * @operation_mode: HT operation mode (like in &struct ieee80211_ht_info)
- */
-struct ieee80211_bss_ht_conf {
-	u16 operation_mode;
-};
-
-/**
  * struct ieee80211_bss_conf - holds the BSS's changing parameters
  *
  * This structure keeps information about a BSS (and an association
@@ -203,6 +195,8 @@ struct ieee80211_bss_ht_conf {
  *	the current band.
  * @bssid: The BSSID for this BSS
  * @enable_beacon: whether beaconing should be enabled or not
+ * @ht_operation_mode: HT operation mode (like in &struct ieee80211_ht_info).
+ *	This field is only valid when the channel type is one of the HT types.
  */
 struct ieee80211_bss_conf {
 	const u8 *bssid;
@@ -219,7 +213,7 @@ struct ieee80211_bss_conf {
 	u16 assoc_capability;
 	u64 timestamp;
 	u32 basic_rates;
-	struct ieee80211_bss_ht_conf ht;
+	u16 ht_operation_mode;
 };
 
 /**
--- wireless-testing.orig/net/mac80211/mlme.c	2009-05-08 20:08:29.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-05-08 20:15:57.000000000 +0200
@@ -95,16 +95,14 @@ static u32 ieee80211_enable_ht(struct ie
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct ieee80211_bss_ht_conf ht;
 	struct sta_info *sta;
 	u32 changed = 0;
+	u16 ht_opmode;
 	bool enable_ht = true, ht_changed;
 	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
-	memset(&ht, 0, sizeof(ht));
-
 	/* HT is not supported */
 	if (!sband->ht_cap.ht_supported)
 		enable_ht = false;
@@ -148,19 +146,18 @@ static u32 ieee80211_enable_ht(struct ie
 						 IEEE80211_RC_HT_CHANGED);
 
 		rcu_read_unlock();
-
         }
 
 	/* disable HT */
 	if (!enable_ht)
 		return 0;
 
-	ht.operation_mode = le16_to_cpu(hti->operation_mode);
+	ht_opmode = le16_to_cpu(hti->operation_mode);
 
 	/* if bss configuration changed store the new one */
-	if (memcmp(&sdata->vif.bss_conf.ht, &ht, sizeof(ht))) {
+	if (sdata->vif.bss_conf.ht_operation_mode != ht_opmode) {
 		changed |= BSS_CHANGED_HT;
-		sdata->vif.bss_conf.ht = ht;
+		sdata->vif.bss_conf.ht_operation_mode = ht_opmode;
 	}
 
 	return changed;
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2009-05-08 20:39:14.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.c	2009-05-08 20:39:30.000000000 +0200
@@ -2226,9 +2226,9 @@ static void iwl_ht_conf(struct iwl_priv 
 
 	iwl_conf->tx_chan_width = iwl_conf->supported_chan_width != 0;
 	iwl_conf->ht_protection =
-		bss_conf->ht.operation_mode & IEEE80211_HT_OP_MODE_PROTECTION;
+		bss_conf->ht_operation_mode & IEEE80211_HT_OP_MODE_PROTECTION;
 	iwl_conf->non_GF_STA_present =
-		!!(bss_conf->ht.operation_mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
+		!!(bss_conf->ht_operation_mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
 
 	rcu_read_unlock();
 
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-05-08 20:39:14.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-05-08 20:39:28.000000000 +0200
@@ -643,7 +643,7 @@ static void mac80211_hwsim_bss_info_chan
 	if (changed & BSS_CHANGED_HT) {
 		printk(KERN_DEBUG "  %s: HT: op_mode=0x%x\n",
 		       wiphy_name(hw->wiphy),
-		       info->ht.operation_mode);
+		       info->ht_operation_mode);
 	}
 
 	if (changed & BSS_CHANGED_BASIC_RATES) {
--- wireless-testing.orig/drivers/net/wireless/mwl8k.c	2009-05-08 20:39:14.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mwl8k.c	2009-05-08 20:39:23.000000000 +0200
@@ -2369,7 +2369,7 @@ static int mwl8k_cmd_set_aid(struct ieee
 	if (info->use_cts_prot) {
 		prot_mode = MWL8K_FRAME_PROT_11G;
 	} else {
-		switch (info->ht.operation_mode &
+		switch (info->ht_operation_mode &
 			IEEE80211_HT_OP_MODE_PROTECTION) {
 		case IEEE80211_HT_OP_MODE_PROTECTION_20MHZ:
 			prot_mode = MWL8K_FRAME_PROT_11N_HT_40MHZ_ONLY;


