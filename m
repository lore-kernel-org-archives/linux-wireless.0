Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759000Ab3APKpk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 05:45:40 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3.8] iwlegacy: fix IBSS cleanup
Date: Wed, 16 Jan 2013 11:45:15 +0100
Message-Id: <1358333115-2489-1-git-send-email-sgruszka@redhat.com> (sfid-20130116_114554_937220_902BA750)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do not correctly change interface type when switching from
IBSS mode to STA mode, that results in microcode errors. 

Resolves:
https://bugzilla.redhat.com/show_bug.cgi?id=886946

Reported-by: Jaroslav Skarvada <jskarvad@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.c | 35 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 7e16d10..90b8970 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -3958,17 +3958,21 @@ il_connection_init_rx_config(struct il_priv *il)
 
 	memset(&il->staging, 0, sizeof(il->staging));
 
-	if (!il->vif) {
+	switch (il->iw_mode) {
+	case NL80211_IFTYPE_UNSPECIFIED:
 		il->staging.dev_type = RXON_DEV_TYPE_ESS;
-	} else if (il->vif->type == NL80211_IFTYPE_STATION) {
+		break;
+	case NL80211_IFTYPE_STATION:
 		il->staging.dev_type = RXON_DEV_TYPE_ESS;
 		il->staging.filter_flags = RXON_FILTER_ACCEPT_GRP_MSK;
-	} else if (il->vif->type == NL80211_IFTYPE_ADHOC) {
+		break;
+	case NL80211_IFTYPE_ADHOC:
 		il->staging.dev_type = RXON_DEV_TYPE_IBSS;
 		il->staging.flags = RXON_FLG_SHORT_PREAMBLE_MSK;
 		il->staging.filter_flags =
 		    RXON_FILTER_BCON_AWARE_MSK | RXON_FILTER_ACCEPT_GRP_MSK;
-	} else {
+		break;
+	default:
 		IL_ERR("Unsupported interface type %d\n", il->vif->type);
 		return;
 	}
@@ -4550,8 +4554,7 @@ out:
 EXPORT_SYMBOL(il_mac_add_interface);
 
 static void
-il_teardown_interface(struct il_priv *il, struct ieee80211_vif *vif,
-		      bool mode_change)
+il_teardown_interface(struct il_priv *il, struct ieee80211_vif *vif)
 {
 	lockdep_assert_held(&il->mutex);
 
@@ -4560,9 +4563,7 @@ il_teardown_interface(struct il_priv *il, struct ieee80211_vif *vif,
 		il_force_scan_end(il);
 	}
 
-	if (!mode_change)
-		il_set_mode(il);
-
+	il_set_mode(il);
 }
 
 void
@@ -4575,8 +4576,8 @@ il_mac_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	WARN_ON(il->vif != vif);
 	il->vif = NULL;
-
-	il_teardown_interface(il, vif, false);
+	il->iw_mode = NL80211_IFTYPE_UNSPECIFIED;
+	il_teardown_interface(il, vif);
 	memset(il->bssid, 0, ETH_ALEN);
 
 	D_MAC80211("leave\n");
@@ -4685,18 +4686,10 @@ il_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	}
 
 	/* success */
-	il_teardown_interface(il, vif, true);
 	vif->type = newtype;
 	vif->p2p = false;
-	err = il_set_mode(il);
-	WARN_ON(err);
-	/*
-	 * We've switched internally, but submitting to the
-	 * device may have failed for some reason. Mask this
-	 * error, because otherwise mac80211 will not switch
-	 * (and set the interface type back) and we'll be
-	 * out of sync with it.
-	 */
+	il->iw_mode = newtype;
+	il_teardown_interface(il, vif);
 	err = 0;
 
 out:
-- 
1.8.0.2

