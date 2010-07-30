Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57792 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588Ab0G3MKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 08:10:40 -0400
Message-Id: <20100730113152.151224384@sipsolutions.net>
Date: Fri, 30 Jul 2010 13:30:46 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: wey-yi.w.guy@intel.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] iwlwifi: fix possible recursive locking deadlock
References: <20100730113045.923567583@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

commit f84b29ec0a1ab767679d3f2428877b65f94bc3ff
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Tue May 18 02:29:13 2010 -0700

    iwlwifi: queue user-initiated scan when doing internal scan

introduced a potential deadlock because it calls
ieee80211_scan_completed() with the priv->mutex
held, but mac80211 may call back into iwlwifi
which would lead to recursive locking. Move this
out from under the mutex.

Cc: stable@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2010-07-30 13:27:51.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.c	2010-07-30 13:27:53.000000000 +0200
@@ -2000,6 +2000,7 @@ void iwl_mac_remove_interface(struct iee
 			      struct ieee80211_vif *vif)
 {
 	struct iwl_priv *priv = hw->priv;
+	bool scan_completed = false;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
@@ -2013,7 +2014,7 @@ void iwl_mac_remove_interface(struct iee
 	if (priv->vif == vif) {
 		priv->vif = NULL;
 		if (priv->scan_vif == vif) {
-			ieee80211_scan_completed(priv->hw, true);
+			scan_completed = true;
 			priv->scan_vif = NULL;
 			priv->scan_request = NULL;
 		}
@@ -2021,6 +2022,9 @@ void iwl_mac_remove_interface(struct iee
 	}
 	mutex_unlock(&priv->mutex);
 
+	if (scan_completed)
+		ieee80211_scan_completed(priv->hw, true);
+
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 }


