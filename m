Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42101 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430Ab0IQVXa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 17:23:30 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/10] iwlagn: correct naming for failure reply tx status
Date: Fri, 17 Sep 2010 14:24:32 -0700
Message-Id: <1284758674-25297-9-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1284758674-25297-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1284758674-25297-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For failure tx status 0x90 and 0x91, give the correct name to reflect
the errors.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-commands.h    |    9 ++-------
 drivers/net/wireless/iwlwifi/iwl-tx.c          |    4 ++--
 4 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
index 33862ff..5391b46 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
@@ -1009,11 +1009,11 @@ ssize_t iwl_reply_tx_error_read(struct file *file,
 				TX_STATUS_FAIL_INSUFFICIENT_CF_POLL),
 			 priv->_agn.reply_tx_stats.insuff_cf_poll);
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t%u\n",
-			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_FW_DROP),
+			 iwl_get_tx_fail_reason(TX_STATUS_FAIL_PASSIVE_NO_RX),
 			 priv->_agn.reply_tx_stats.fail_hw_drop);
-	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t%u\n",
+	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t%u\n",
 			 iwl_get_tx_fail_reason(
-				TX_STATUS_FAIL_STA_COLOR_MISMATCH_DROP),
+				TX_STATUS_FAIL_NO_BEACON_ON_RADAR),
 			 priv->_agn.reply_tx_stats.sta_color_mismatch);
 	pos += scnprintf(buf + pos, bufsz - pos, "UNKNOWN:\t\t\t%u\n",
 			 priv->_agn.reply_tx_stats.unknown);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index c42cb18..616115a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -111,10 +111,10 @@ static void iwlagn_count_tx_err_status(struct iwl_priv *priv, u16 status)
 	case TX_STATUS_FAIL_INSUFFICIENT_CF_POLL:
 		priv->_agn.reply_tx_stats.insuff_cf_poll++;
 		break;
-	case TX_STATUS_FAIL_FW_DROP:
+	case TX_STATUS_FAIL_PASSIVE_NO_RX:
 		priv->_agn.reply_tx_stats.fail_hw_drop++;
 		break;
-	case TX_STATUS_FAIL_STA_COLOR_MISMATCH_DROP:
+	case TX_STATUS_FAIL_NO_BEACON_ON_RADAR:
 		priv->_agn.reply_tx_stats.sta_color_mismatch++;
 		break;
 	default:
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index dd47aca..294a1d5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1820,13 +1820,8 @@ enum {
 	TX_STATUS_FAIL_TID_DISABLE = 0x8d,
 	TX_STATUS_FAIL_FIFO_FLUSHED = 0x8e,
 	TX_STATUS_FAIL_INSUFFICIENT_CF_POLL = 0x8f,
-	/* uCode drop due to FW drop request */
-	TX_STATUS_FAIL_FW_DROP = 0x90,
-	/*
-	 * uCode drop due to station color mismatch
-	 * between tx command and station table
-	 */
-	TX_STATUS_FAIL_STA_COLOR_MISMATCH_DROP = 0x91,
+	TX_STATUS_FAIL_PASSIVE_NO_RX = 0x90,
+	TX_STATUS_FAIL_NO_BEACON_ON_RADAR = 0x91,
 };
 
 #define	TX_PACKET_MODE_REGULAR		0x0000
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 347d3dc..3290b15 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -666,8 +666,8 @@ const char *iwl_get_tx_fail_reason(u32 status)
 		TX_STATUS_FAIL(TID_DISABLE);
 		TX_STATUS_FAIL(FIFO_FLUSHED);
 		TX_STATUS_FAIL(INSUFFICIENT_CF_POLL);
-		TX_STATUS_FAIL(FW_DROP);
-		TX_STATUS_FAIL(STA_COLOR_MISMATCH_DROP);
+		TX_STATUS_FAIL(PASSIVE_NO_RX);
+		TX_STATUS_FAIL(NO_BEACON_ON_RADAR);
 	}
 
 	return "UNKNOWN";
-- 
1.7.0.4

