Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35647 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab0BSSIW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 13:08:22 -0500
Message-Id: <20100219180737.156138399@sipsolutions.net>
Date: Fri, 19 Feb 2010 19:06:56 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] ath9k: convert to new station add/remove callbacks
References: <20100219180652.409890561@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This converts ath9k to use the new station
add/remove callbacks instead of using the
old sta_notify callback.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/ath/ath9k/main.c |   35 +++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2010-02-19 18:58:12.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2010-02-19 18:59:53.000000000 +0100
@@ -1684,24 +1684,28 @@ static void ath9k_configure_filter(struc
 		  "Set HW RX filter: 0x%x\n", rfilt);
 }
 
-static void ath9k_sta_notify(struct ieee80211_hw *hw,
-			     struct ieee80211_vif *vif,
-			     enum sta_notify_cmd cmd,
-			     struct ieee80211_sta *sta)
+static int ath9k_sta_add(struct ieee80211_hw *hw,
+			 struct ieee80211_vif *vif,
+			 struct ieee80211_sta *sta)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 
-	switch (cmd) {
-	case STA_NOTIFY_ADD:
-		ath_node_attach(sc, sta);
-		break;
-	case STA_NOTIFY_REMOVE:
-		ath_node_detach(sc, sta);
-		break;
-	default:
-		break;
-	}
+	ath_node_attach(sc, sta);
+
+	return 0;
+}
+
+static int ath9k_sta_remove(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif,
+			    struct ieee80211_sta *sta)
+{
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
+
+	ath_node_detach(sc, sta);
+
+	return 0;
 }
 
 static int ath9k_conf_tx(struct ieee80211_hw *hw, u16 queue,
@@ -2045,7 +2049,8 @@ struct ieee80211_ops ath9k_ops = {
 	.remove_interface   = ath9k_remove_interface,
 	.config 	    = ath9k_config,
 	.configure_filter   = ath9k_configure_filter,
-	.sta_notify         = ath9k_sta_notify,
+	.sta_add	    = ath9k_sta_add,
+	.sta_remove	    = ath9k_sta_remove,
 	.conf_tx 	    = ath9k_conf_tx,
 	.bss_info_changed   = ath9k_bss_info_changed,
 	.set_key            = ath9k_set_key,


