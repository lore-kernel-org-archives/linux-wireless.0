Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from a.mail.sonic.net ([64.142.16.245]:59064 "EHLO a.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbYDBHBs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 03:01:48 -0400
From: Jason Riedy <jason@acm.org>
To: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: [PATCH] Remove most references to iwl4965-only features from iwl3945.
Date: Tue, 01 Apr 2008 23:26:00 -0700
Message-ID: <87bq4shix3.fsf@sparse.dyndns.org> (sfid-20080402_080151_851138_5FB6CF51)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The references confused me while trying to debug my configuration
problem, and the #ifdef using a *4965* symbol is obviously wrong.

I know the rfkill switch on my laptop works, so I left that
"4965-only" feature in iwl3945-base.c.  There is one remaining
"4965-only" feature:
	/* Chip got too hot and stopped itself (4965 only) */
I don't know if the 3945 supports this, but I also lack the guts
to remove it and the time to search for documentation.

Signed-off-by: Jason Riedy <jason@acm.org>
---
 drivers/net/wireless/iwlwifi/iwl-3945-commands.h |    1 -
 drivers/net/wireless/iwlwifi/iwl-3945.h          |    9 ++++-----
 drivers/net/wireless/iwlwifi/iwl3945-base.c      |    3 +--
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
index 817ece7..925678b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
@@ -89,7 +89,6 @@ enum {
 	REPLY_TX = 0x1c,
 	REPLY_RATE_SCALE = 0x47,	/* 3945 only */
 	REPLY_LEDS_CMD = 0x48,
-	REPLY_TX_LINK_QUALITY_CMD = 0x4e, /* 4965 only */
 
 	/* 802.11h related */
 	RADAR_NOTIFICATION = 0x70,	/* not used */
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index ac12269..a4a4f3a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -188,7 +188,7 @@ struct iwl3945_scan_power_info {
  * Some of the fields (e.g. eeprom and flags/max_power_avg) are redundant
  *     with one another!
  */
-#define IWL4965_MAX_RATE (33)
+#define IWL3945_MAX_RATE (33)
 
 struct iwl3945_channel_info {
 	struct iwl3945_channel_tgd_info tgd;
@@ -211,7 +211,7 @@ struct iwl3945_channel_info {
 	/* Radio/DSP gain settings for each "normal" data Tx rate.
 	 * These include, in addition to RF and DSP gain, a few fields for
 	 *   remembering/modifying gain settings (indexes). */
-	struct iwl3945_channel_power_info power_info[IWL4965_MAX_RATE];
+	struct iwl3945_channel_power_info power_info[IWL3945_MAX_RATE];
 
 	/* Radio/DSP gain settings for each scan rate, for directed scans. */
 	struct iwl3945_scan_power_info scan_pwr_info[IWL_NUM_SCAN_RATES];
@@ -653,7 +653,6 @@ extern int iwl3945_hw_reg_set_txpower(struct iwl3945_priv *priv, s8 power);
 extern void iwl3945_hw_rx_statistics(struct iwl3945_priv *priv,
 				 struct iwl3945_rx_mem_buffer *rxb);
 extern void iwl3945_disable_events(struct iwl3945_priv *priv);
-extern int iwl4965_get_temperature(const struct iwl3945_priv *priv);
 
 /**
  * iwl3945_hw_find_station - Find station id for a given BSSID
@@ -775,11 +774,11 @@ struct iwl3945_priv {
 	struct iwl3945_rxon_cmd recovery_rxon;
 
 	/* 1st responses from initialize and runtime uCode images.
-	 * 4965's initialize alive response contains some calibration data. */
+	 * 3945's initialize alive response contains some calibration data. */
 	struct iwl3945_init_alive_resp card_alive_init;
 	struct iwl3945_alive_resp card_alive;
 
-#ifdef CONFIG_IWL4965_LEDS
+#ifdef CONFIG_IWL3945_LEDS
 	struct iwl3945_led led[IWL_LED_TRG_MAX];
 	unsigned long last_blink_time;
 	u8 last_blink_rate;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index dc9ff50..8705383 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -582,7 +582,6 @@ static const char *get_cmd_string(u8 cmd)
 		IWL_CMD(REPLY_TX);
 		IWL_CMD(REPLY_RATE_SCALE);
 		IWL_CMD(REPLY_LEDS_CMD);
-		IWL_CMD(REPLY_TX_LINK_QUALITY_CMD);
 		IWL_CMD(RADAR_NOTIFICATION);
 		IWL_CMD(REPLY_QUIET_CMD);
 		IWL_CMD(REPLY_CHANNEL_SWITCH);
@@ -4480,7 +4479,7 @@ static void iwl3945_irq_tasklet(struct iwl3945_priv *priv)
 	/* Safely ignore these bits for debug checks below */
 	inta &= ~(CSR_INT_BIT_SCD | CSR_INT_BIT_ALIVE);
 
-	/* HW RF KILL switch toggled (4965 only) */
+	/* HW RF KILL switch toggled */
 	if (inta & CSR_INT_BIT_RF_KILL) {
 		int hw_rf_kill = 0;
 		if (!(iwl3945_read32(priv, CSR_GP_CNTRL) &
-- 
1.5.5.rc1.121.g1594

