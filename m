Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4758 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab1I0Rpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 13:45:52 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 13/26] staging: brcm80211: remove unnecessary
 mac80211 callbacks
Date: Tue, 27 Sep 2011 10:45:17 -0700
Message-ID: <1317145530-18839-14-git-send-email-frankyl@broadcom.com> (sfid-20110927_194605_961492_B3A23E4C)
In-Reply-To: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Several callback were implemented without executing any further
function calls into the driver. Review feedback indicated that
these could be removed.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |   61 ----------------------
 1 files changed, 0 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 9bd4b83..11ba061 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -580,12 +580,6 @@ brcms_ops_configure_filter(struct ieee80211_hw *hw,
 	return;
 }
 
-static int
-brcms_ops_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta, bool set)
-{
-	return 0;
-}
-
 static void brcms_ops_sw_scan_start(struct ieee80211_hw *hw)
 {
 	struct brcms_info *wl = hw->priv;
@@ -604,42 +598,6 @@ static void brcms_ops_sw_scan_complete(struct ieee80211_hw *hw)
 	return;
 }
 
-static void brcms_ops_set_tsf(struct ieee80211_hw *hw, u64 tsf)
-{
-	wiphy_err(hw->wiphy, "%s: Enter\n", __func__);
-	return;
-}
-
-static int
-brcms_ops_get_stats(struct ieee80211_hw *hw,
-		 struct ieee80211_low_level_stats *stats)
-{
-	struct brcms_info *wl = hw->priv;
-	struct wl_cnt *cnt;
-
-	LOCK(wl);
-	cnt = wl->pub->_cnt;
-	stats->dot11ACKFailureCount = 0;
-	stats->dot11RTSFailureCount = 0;
-	stats->dot11FCSErrorCount = 0;
-	stats->dot11RTSSuccessCount = 0;
-	UNLOCK(wl);
-	return 0;
-}
-
-static void
-brcms_ops_sta_notify(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		  enum sta_notify_cmd cmd, struct ieee80211_sta *sta)
-{
-	switch (cmd) {
-	default:
-		wiphy_err(hw->wiphy, "%s: Unknown cmd = %d\n", __func__,
-			  cmd);
-		break;
-	}
-	return;
-}
-
 static int
 brcms_ops_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	       const struct ieee80211_tx_queue_params *params)
@@ -653,12 +611,6 @@ brcms_ops_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	return 0;
 }
 
-static u64 brcms_ops_get_tsf(struct ieee80211_hw *hw)
-{
-	wiphy_err(hw->wiphy, "%s: Enter\n", __func__);
-	return 0;
-}
-
 static int
 brcms_ops_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	       struct ieee80211_sta *sta)
@@ -698,13 +650,6 @@ brcms_ops_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 }
 
 static int
-brcms_ops_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		  struct ieee80211_sta *sta)
-{
-	return 0;
-}
-
-static int
 brcms_ops_ampdu_action(struct ieee80211_hw *hw,
 		    struct ieee80211_vif *vif,
 		    enum ieee80211_ampdu_mlme_action action,
@@ -800,16 +745,10 @@ static const struct ieee80211_ops brcms_ops = {
 	.config = brcms_ops_config,
 	.bss_info_changed = brcms_ops_bss_info_changed,
 	.configure_filter = brcms_ops_configure_filter,
-	.set_tim = brcms_ops_set_tim,
 	.sw_scan_start = brcms_ops_sw_scan_start,
 	.sw_scan_complete = brcms_ops_sw_scan_complete,
-	.set_tsf = brcms_ops_set_tsf,
-	.get_stats = brcms_ops_get_stats,
-	.sta_notify = brcms_ops_sta_notify,
 	.conf_tx = brcms_ops_conf_tx,
-	.get_tsf = brcms_ops_get_tsf,
 	.sta_add = brcms_ops_sta_add,
-	.sta_remove = brcms_ops_sta_remove,
 	.ampdu_action = brcms_ops_ampdu_action,
 	.rfkill_poll = brcms_ops_rfkill_poll,
 	.flush = brcms_ops_flush,
-- 
1.7.1


