Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45408 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab1EQHNp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 03:13:45 -0400
Received: by pzk9 with SMTP id 9so109978pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 00:13:44 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19922.8142.105988.381076@gargle.gargle.HOWL> (sfid-20110517_091348_352245_AA5F853E)
Date: Tue, 17 May 2011 12:42:14 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 6/8] ath9k_htc: Fix max subframe handling
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Commit "ath9k_htc: Fix AMPDU subframe handling" registered the maximum
subframe limit of the driver with mac80211, which was used in ADDBA
negotiation. While technically correct, this causes inter-operability issues
with a few APs. Revert to the older behavior to fix this.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    5 -----
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    2 +-
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index bfdc8a8..d222456 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -769,11 +769,6 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 	hw->channel_change_time = 5000;
 	hw->max_listen_interval = 10;
 
-	if (AR_SREV_9271(priv->ah))
-		hw->max_tx_aggregation_subframes = MAX_TX_AMPDU_SUBFRAMES_9271;
-	else
-		hw->max_tx_aggregation_subframes = MAX_TX_AMPDU_SUBFRAMES_7010;
-
 	hw->vif_data_size = sizeof(struct ath9k_htc_vif);
 	hw->sta_data_size = sizeof(struct ath9k_htc_sta);
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 6eedabb..bee100e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -581,7 +581,7 @@ int ath9k_htc_update_cap_target(struct ath9k_htc_priv *priv,
 	memset(&tcap, 0, sizeof(struct ath9k_htc_cap_target));
 
 	tcap.ampdu_limit = cpu_to_be32(0xffff);
-	tcap.ampdu_subframes = priv->hw->max_tx_aggregation_subframes;
+	tcap.ampdu_subframes = 0xff;
 	tcap.enable_coex = enable_coex;
 	tcap.tx_chainmask = priv->ah->caps.tx_chainmask;
 
-- 
1.7.5.1

