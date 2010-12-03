Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758602Ab0LCOlz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 09:41:55 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/2] iwl3945: prevent too frequent firmware resets
Date: Fri,  3 Dec 2010 15:41:47 +0100
Message-Id: <1291387308-5829-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Similarly like on iwlagn, initialize reset duration on iwl3945 to prevent
too frequent firmware resets.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 8eb1393..cc282aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3861,6 +3861,13 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	priv->iw_mode = NL80211_IFTYPE_STATION;
 	priv->missed_beacon_threshold = IWL_MISSED_BEACON_THRESHOLD_DEF;
 
+	/* initialize force reset */
+	priv->force_reset[IWL_RF_RESET].reset_duration =
+		IWL_DELAY_NEXT_FORCE_RF_RESET;
+	priv->force_reset[IWL_FW_RESET].reset_duration =
+		IWL_DELAY_NEXT_FORCE_FW_RELOAD;
+
+
 	priv->tx_power_user_lmt = IWL_DEFAULT_TX_POWER;
 	priv->tx_power_next = IWL_DEFAULT_TX_POWER;
 
-- 
1.7.1

