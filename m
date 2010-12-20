Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932676Ab0LTRGF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 12:06:05 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwlagn: fix scan tx antenna setting on 5Ghz band
Date: Mon, 20 Dec 2010 18:05:13 +0100
Message-Id: <1292864713-2756-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks that we do not set correctly antennas when scanning
on 5Ghz band and when bluetooth is enabled, because
priv->cfg->scan_tx_antennas[band] is only defined for
IEEE80211_BAND_2GHZ. This fix choose first valid antenna.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 4bc82fc..099039c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1499,8 +1499,7 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	    priv->cfg->bt_params->advanced_bt_coexist &&
 	    priv->bt_full_concurrent) {
 		/* operated as 1x1 in full concurrency mode */
-		scan_tx_antennas = first_antenna(
-			priv->cfg->scan_tx_antennas[band]);
+		scan_tx_antennas = first_antenna(scan_tx_antennas);
 	}
 
 	priv->scan_tx_ant[band] = iwl_toggle_tx_ant(priv, priv->scan_tx_ant[band],
-- 
1.7.1

