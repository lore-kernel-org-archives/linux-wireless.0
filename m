Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:32913 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760503Ab0JGNEO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 09:04:14 -0400
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH 03/03] wl1271: BA Initiator support, active BA ability
Date: Thu,  7 Oct 2010 15:06:02 +0200
Message-Id: <1286456762-17480-4-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1286456762-17480-1-git-send-email-shahar_levi@ti.com>
References: <1286456762-17480-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add calling to BA policies after join and connect new ops.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   10 +++-------
 drivers/net/wireless/wl12xx/wl1271_main.c |   14 ++++++++++++--
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index f82656e..18ac48f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -1328,11 +1328,6 @@ int wl1271_acx_set_ba_session(struct wl1271 *wl,
 {
 	struct wl1271_acx_ba_session_policy *acx;
 	int ret = 0;
-	/*
-	* Note, currently this value will be set to FFFFFFFFFFFF to indicate
-	* it is relevant for all peers.
-	*/
-	u8 mac_address[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
 	wl1271_debug(DEBUG_ACX, "acx ba session setting");
 
@@ -1342,14 +1337,14 @@ int wl1271_acx_set_ba_session(struct wl1271 *wl,
 		goto out;
 	}
 
-	memcpy(acx->mac_address, mac_address, ETH_ALEN);
+	memcpy(acx->mac_address, wl->bssid, ETH_ALEN);
 	acx->tid = tid_index;
 	acx->policy = policy;
 	acx->win_size = BA_RECEIVER_WIN_SIZE;
 
 	if (ACX_BA_SESSION_INITIATOR_POLICY == id)
 		acx->inactivity_timeout = BA_INACTIVITY_TIMEOUT;
-	else
+	else {
 		if (ACX_BA_SESSION_RESPONDER_POLICY == id)
 			acx->inactivity_timeout = 0;
 		else {
@@ -1357,6 +1352,7 @@ int wl1271_acx_set_ba_session(struct wl1271 *wl,
 			ret = -EINVAL;
 			goto out;
 		}
+	}
 
 	ret = wl1271_cmd_configure(wl,
 				   id,
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 53c03e5..b4e3b02 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1725,6 +1725,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	enum wl1271_cmd_ps_mode mode;
 	struct wl1271 *wl = hw->priv;
 	struct ieee80211_sta *sta = ieee80211_find_sta(vif, bss_conf->bssid);
+	bool set_ba = false;
 	bool do_join = false;
 	bool set_assoc = false;
 	int ret;
@@ -1950,7 +1951,9 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 							     true);
 			ret = wl1271_acx_set_ht_information(wl,
 						bss_conf->ht_operation_mode);
-			}
+
+			set_ba = true;
+		}
 		else
 			if (changed & BSS_CHANGED_ASSOC)
 				ret = wl1271_acx_set_ht_capabilities(wl,
@@ -1977,6 +1980,9 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			wl1271_warning("cmd join failed %d", ret);
 			goto out_sleep;
 		}
+
+		if (set_ba)
+			wl1271_set_ba_policies(wl);
 	}
 
 out_sleep:
@@ -2080,10 +2086,13 @@ int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
 		int ret;
 
 		switch (action) {
+		/* Falling break here on purpose until we add BA receiver support */
 		case IEEE80211_AMPDU_RX_START:
 		case IEEE80211_AMPDU_RX_STOP:
 
-		/* The BA initiator session management in FW independently */
+		/* The BA initiator session management in FW independently.
+		 * Falling break here on purpose for all TX APDU commands.
+		 */
 		case IEEE80211_AMPDU_TX_START:
 		case IEEE80211_AMPDU_TX_STOP:
 		case IEEE80211_AMPDU_TX_OPERATIONAL:
@@ -2351,6 +2360,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.conf_tx = wl1271_op_conf_tx,
 	.get_tsf = wl1271_op_get_tsf,
 	.get_survey = wl1271_op_get_survey,
+	.ampdu_action = wl1271_op_ampdu_action,
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
-- 
1.6.0.4

