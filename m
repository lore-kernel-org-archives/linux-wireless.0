Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:41418 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbZFHTRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 15:17:51 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 2/3] Staging: stlc45xx: update mac80211 bss_info_changed() API
	change
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 08 Jun 2009 22:09:09 +0300
Message-ID: <20090608190909.25081.11339.stgit@tikku>
In-Reply-To: <20090608190901.25081.26264.stgit@tikku>
References: <20090608190901.25081.26264.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

config_interface() is now gone and the functionality needs go to
bss_info_changed().

Compile-tested only.

Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 drivers/staging/stlc45xx/stlc45xx.c |   40 +++++++++++------------------------
 1 files changed, 12 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/stlc45xx/stlc45xx.c b/drivers/staging/stlc45xx/stlc45xx.c
index 172eb54..f449256 100644
--- a/drivers/staging/stlc45xx/stlc45xx.c
+++ b/drivers/staging/stlc45xx/stlc45xx.c
@@ -2216,33 +2216,6 @@ static void stlc45xx_op_remove_interface(struct ieee80211_hw *hw,
 	mutex_unlock(&stlc->mutex);
 }
 
-static int stlc45xx_op_config_interface(struct ieee80211_hw *hw,
-					struct ieee80211_vif *vif,
-					struct ieee80211_if_conf *conf)
-{
-	struct stlc45xx *stlc = hw->priv;
-
-	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
-
-	mutex_lock(&stlc->mutex);
-
-	if (conf->changed & IEEE80211_IFCC_BSSID) {
-		memcpy(stlc->bssid, conf->bssid, ETH_ALEN);
-		stlc45xx_tx_setup(stlc);
-	}
-
-	if (conf->changed & IEEE80211_IFCC_BEACON) {
-		stlc45xx_debug(DEBUG_FUNC, "BEACON!");
-		stlc45xx_tx_scan(stlc);
-		stlc45xx_tx_beacon(hw,vif);
-		stlc45xx_tx_edcf(stlc);
-	}
-
-	mutex_unlock(&stlc->mutex);
-
-	return 0;
-}
-
 static int stlc45xx_op_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct stlc45xx *stlc = hw->priv;
@@ -2284,6 +2257,18 @@ static void stlc45xx_op_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct stlc45xx *stlc = hw->priv;
 
+	if (changed & BSS_CHANGED_BSSID) {
+		memcpy(stlc->bssid, info->bssid, ETH_ALEN);
+		stlc45xx_tx_setup(stlc);
+	}
+
+	if (changed & BSS_CHANGED_BEACON) {
+		stlc45xx_debug(DEBUG_FUNC, "BEACON!");
+		stlc45xx_tx_scan(stlc);
+		stlc45xx_tx_beacon(hw,vif);
+		stlc45xx_tx_edcf(stlc);
+	}
+
 	if (changed & BSS_CHANGED_ASSOC) {
 		stlc->associated = info->assoc;
 		if (info->assoc)
@@ -2353,7 +2338,6 @@ static const struct ieee80211_ops stlc45xx_ops = {
 	.add_interface = stlc45xx_op_add_interface,
 	.remove_interface = stlc45xx_op_remove_interface,
 	.config = stlc45xx_op_config,
-	.config_interface = stlc45xx_op_config_interface,
 	.configure_filter = stlc45xx_op_configure_filter,
 	.tx = stlc45xx_op_tx,
 	.bss_info_changed = stlc45xx_op_bss_info_changed,

