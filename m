Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:51607 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaJGEnw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 00:43:52 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 4/6] ath9k: Use sta_state() callback
Date: Tue,  7 Oct 2014 10:14:39 +0530
Message-Id: <1412657081-3202-5-git-send-email-sujith@msujith.org> (sfid-20141007_064407_928633_3F9C961A)
In-Reply-To: <1412657081-3202-1-git-send-email-sujith@msujith.org>
References: <1412657081-3202-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Instead of using the sta_add()/sta_remove() callbacks,
use the sta_state() callback since this gives
more fine-grained control.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6f6a974..902807e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1547,6 +1547,31 @@ static int ath9k_sta_remove(struct ieee80211_hw *hw,
 	return 0;
 }
 
+static int ath9k_sta_state(struct ieee80211_hw *hw,
+			   struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta,
+			   enum ieee80211_sta_state old_state,
+			   enum ieee80211_sta_state new_state)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	int ret = 0;
+
+	if (old_state == IEEE80211_STA_AUTH &&
+	    new_state == IEEE80211_STA_ASSOC) {
+		ret = ath9k_sta_add(hw, vif, sta);
+		ath_dbg(common, CONFIG,
+			"Add station: %pM\n", sta->addr);
+	} else if (old_state == IEEE80211_STA_ASSOC &&
+		   new_state == IEEE80211_STA_AUTH) {
+		ret = ath9k_sta_remove(hw, vif, sta);
+		ath_dbg(common, CONFIG,
+			"Remove station: %pM\n", sta->addr);
+	}
+
+	return ret;
+}
+
 static void ath9k_sta_set_tx_filter(struct ath_hw *ah,
 				    struct ath_node *an,
 				    bool set)
@@ -2471,8 +2496,7 @@ struct ieee80211_ops ath9k_ops = {
 	.remove_interface   = ath9k_remove_interface,
 	.config 	    = ath9k_config,
 	.configure_filter   = ath9k_configure_filter,
-	.sta_add	    = ath9k_sta_add,
-	.sta_remove	    = ath9k_sta_remove,
+	.sta_state          = ath9k_sta_state,
 	.sta_notify         = ath9k_sta_notify,
 	.conf_tx 	    = ath9k_conf_tx,
 	.bss_info_changed   = ath9k_bss_info_changed,
-- 
2.1.2

