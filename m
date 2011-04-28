Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758592Ab1D1Jwx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 05:52:53 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 06/10] iwlegacy: remove scan_tx_antennas
Date: Thu, 28 Apr 2011 11:51:29 +0200
Message-Id: <1303984293-6601-6-git-send-email-sgruszka@redhat.com> (sfid-20110428_115300_176854_05D64292)
In-Reply-To: <1303984293-6601-1-git-send-email-sgruszka@redhat.com>
References: <1303984293-6601-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c |    3 ---
 drivers/net/wireless/iwlegacy/iwl-core.h     |    1 -
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
index 5a8a3cc..7e5e85a 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
@@ -955,9 +955,6 @@ int iwl4965_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	if (priv->cfg->scan_rx_antennas[band])
 		rx_ant = priv->cfg->scan_rx_antennas[band];
 
-	if (priv->cfg->scan_tx_antennas[band])
-		scan_tx_antennas = priv->cfg->scan_tx_antennas[band];
-
 	priv->scan_tx_ant[band] = iwl4965_toggle_tx_ant(priv,
 						priv->scan_tx_ant[band],
 						    scan_tx_antennas);
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.h b/drivers/net/wireless/iwlegacy/iwl-core.h
index f03b463..bc66c60 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.h
+++ b/drivers/net/wireless/iwlegacy/iwl-core.h
@@ -287,7 +287,6 @@ struct iwl_cfg {
 	struct iwl_base_params *base_params;
 	/* params likely to change within a device family */
 	u8 scan_rx_antennas[IEEE80211_NUM_BANDS];
-	u8 scan_tx_antennas[IEEE80211_NUM_BANDS];
 	enum iwl_led_mode led_mode;
 };
 
-- 
1.7.1

