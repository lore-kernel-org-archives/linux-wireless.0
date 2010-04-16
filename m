Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22966 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754097Ab0DPGY2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 02:24:28 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 15 Apr 2010 23:24:28 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19400.628.309675.409046@gargle.gargle.HOWL>
Date: Fri, 16 Apr 2010 11:53:48 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 01/10] ath9k_htc: Cleanup beacon configuration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch cleans up beacon configuration,
removing a redundant interface type check
and updating beacon interval in the correct place.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |   23 +++++++++--------------
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |    2 +-
 2 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 5e21f4d..d104028 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -244,25 +244,20 @@ void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 			     struct ieee80211_vif *vif)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
-	enum nl80211_iftype iftype;
 	struct htc_beacon_config *cur_conf = &priv->cur_beacon_conf;
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 
-	if (vif) {
-		struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
-		iftype = vif->type;
-		cur_conf->beacon_interval = bss_conf->beacon_int;
-		cur_conf->dtim_period = bss_conf->dtim_period;
-		cur_conf->listen_interval = 1;
-		cur_conf->dtim_count = 1;
-		cur_conf->bmiss_timeout =
-			ATH_DEFAULT_BMISS_LIMIT * cur_conf->beacon_interval;
-	} else
-		iftype = priv->ah->opmode;
-
+	cur_conf->beacon_interval = bss_conf->beacon_int;
 	if (cur_conf->beacon_interval == 0)
 		cur_conf->beacon_interval = 100;
 
-	switch (iftype) {
+	cur_conf->dtim_period = bss_conf->dtim_period;
+	cur_conf->listen_interval = 1;
+	cur_conf->dtim_count = 1;
+	cur_conf->bmiss_timeout =
+		ATH_DEFAULT_BMISS_LIMIT * cur_conf->beacon_interval;
+
+	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		ath9k_htc_beacon_config_sta(priv, cur_conf);
 		break;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index eb7722b..08a4a58 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1687,7 +1687,7 @@ static void ath9k_htc_sw_scan_complete(struct ieee80211_hw *hw)
 	spin_unlock_bh(&priv->beacon_lock);
 	priv->op_flags |= OP_FULL_RESET;
 	if (priv->op_flags & OP_ASSOCIATED)
-		ath9k_htc_beacon_config(priv, NULL);
+		ath9k_htc_beacon_config(priv, priv->vif);
 	ath_start_ani(priv);
 	mutex_unlock(&priv->mutex);
 	ath9k_htc_ps_restore(priv);
-- 
1.7.0.5

