Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab0JMNhi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 09:37:38 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/2] iwlwifi: fix set_tx_power vs scan
Date: Wed, 13 Oct 2010 15:39:52 +0200
Message-Id: <1286977193-12144-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In scan code completion send set TX power command again, as according
to comment it can be deferred during scan. Currently this comment is
only partially true - on 4965 device iwl4965_send_tx_power will fail
when scanning, but the new tx power value is lost. On other device
we do not defer setting tx power.

This patch change code to:
- save newly requested tx power value
- defer sending command to firmware when scanning on all devices
- add WARN_ONCE in all *_send_tx_power methods
- on 5xxx and 6xxx change to send command synchronously, to not
  start other commands when setting tx is pending, like we do for older
  devices

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    8 ++------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    9 ++++++---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c     |    8 ++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
 8 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 176e525..6fd79f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1451,6 +1451,10 @@ static int iwl3945_send_tx_power(struct iwl_priv *priv)
 	};
 	u16 chan;
 
+	if (WARN_ONCE(test_bit(STATUS_SCANNING, &priv->status),
+		      "TX Power requested while scanning!\n"))
+		return -EAGAIN;
+
 	chan = le16_to_cpu(priv->contexts[IWL_RXON_CTX_BSS].active.channel);
 
 	txpower.band = (priv->band == IEEE80211_BAND_5GHZ) ? 0 : 1;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index b207e3e..93e1696 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1377,13 +1377,9 @@ static int iwl4965_send_tx_power(struct iwl_priv *priv)
 	u8 ctrl_chan_high = 0;
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
-	if (test_bit(STATUS_SCANNING, &priv->status)) {
-		/* If this gets hit a lot, switch it to a BUG() and catch
-		 * the stack trace to find out who is calling this during
-		 * a scan. */
-		IWL_WARN(priv, "TX Power requested while scanning!\n");
+	if (WARN_ONCE(test_bit(STATUS_SCANNING, &priv->status),
+		      "TX Power requested while scanning!\n"))
 		return -EAGAIN;
-	}
 
 	band = priv->band == IEEE80211_BAND_2GHZ;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index c1a3898..b717ac0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -496,6 +496,10 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 	struct iwlagn_tx_power_dbm_cmd tx_power_cmd;
 	u8 tx_ant_cfg_cmd;
 
+	if (WARN_ONCE(test_bit(STATUS_SCANNING, &priv->status),
+		      "TX Power requested while scanning!\n"))
+		return -EAGAIN;
+
 	/* half dBm need to multiply */
 	tx_power_cmd.global_lmt = (s8)(2 * priv->tx_power_user_lmt);
 
@@ -522,9 +526,8 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 	else
 		tx_ant_cfg_cmd = REPLY_TX_POWER_DBM_CMD;
 
-	return  iwl_send_cmd_pdu_async(priv, tx_ant_cfg_cmd,
-				       sizeof(tx_power_cmd), &tx_power_cmd,
-				       NULL);
+	return iwl_send_cmd_pdu(priv, tx_ant_cfg_cmd, sizeof(tx_power_cmd),
+				&tx_power_cmd);
 }
 
 void iwlagn_temperature(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6771c40..0881452 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4179,6 +4179,7 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	 * this value will get overwritten by channel max power avg
 	 * from eeprom */
 	priv->tx_power_user_lmt = IWLAGN_TX_POWER_TARGET_POWER_MIN;
+	priv->tx_power_next = IWLAGN_TX_POWER_TARGET_POWER_MIN;
 
 	ret = iwl_init_channel_map(priv);
 	if (ret) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index b3efbe0..2a5d57f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1211,6 +1211,8 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 	int ret = 0;
 	s8 prev_tx_power = priv->tx_power_user_lmt;
 
+	lockdep_assert_held(&priv->mutex);
+
 	if (tx_power < IWLAGN_TX_POWER_TARGET_POWER_MIN) {
 		IWL_WARN(priv,
 			 "Requested user TXPOWER %d below lower limit %d.\n",
@@ -1226,6 +1228,12 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 		return -EINVAL;
 	}
 
+	if (test_bit(STATUS_SCANNING, &priv->status)) {
+		priv->tx_power_next = tx_power;
+		IWL_DEBUG_INFO(priv, "Deferring tx power set while scanning\n");
+		return 0;
+	}
+
 	if (priv->tx_power_user_lmt != tx_power)
 		force = true;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index de43e13..4c09d21 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1517,6 +1517,7 @@ struct iwl_priv {
 	s8 tx_power_user_lmt;
 	s8 tx_power_device_lmt;
 	s8 tx_power_lmt_in_half_dbm; /* max tx power in half-dBm format */
+	s8 tx_power_next;
 
 
 #ifdef CONFIG_IWLWIFI_DEBUG
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 67da312..1424267 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -605,7 +605,7 @@ out_settings:
 
 	/* Since setting the TXPOWER may have been deferred while
 	 * performing the scan, fire one off */
-	iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
+	iwl_set_tx_power(priv, priv->tx_power_next, true);
 
 	priv->cfg->ops->utils->post_scan(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 980c609..9d0f736 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3866,6 +3866,7 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	priv->missed_beacon_threshold = IWL_MISSED_BEACON_THRESHOLD_DEF;
 
 	priv->tx_power_user_lmt = IWL_DEFAULT_TX_POWER;
+	priv->tx_power_next = IWL_DEFAULT_TX_POWER;
 
 	if (eeprom->version < EEPROM_3945_EEPROM_VERSION) {
 		IWL_WARN(priv, "Unsupported EEPROM version: 0x%04X\n",
-- 
1.7.1

