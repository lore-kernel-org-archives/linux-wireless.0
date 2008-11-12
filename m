Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63790 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbYKLVNu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 16:13:50 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/8] iwlwifi : fix checkpatch.pl errors
Date: Wed, 12 Nov 2008 13:14:08 -0800
Message-Id: <1226524451-3417-6-git-send-email-reinette.chatre@intel.com> (sfid-20081112_221358_987134_248266D0)
In-Reply-To: <1226524451-3417-5-git-send-email-reinette.chatre@intel.com>
References: <>
 <1226524451-3417-1-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-2-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-3-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-4-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Patch fixes checkpatch.pl errors for iwlwifi.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-io.h  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-io.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 9 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-io.h b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
index 1daa3f0..7dea155 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
@@ -107,7 +107,7 @@ static inline int __iwl3945_poll_bit(const char *f, u32 l,
 	int ret = _iwl3945_poll_bit(priv, addr, bits, mask, timeout);
 	IWL_DEBUG_IO("poll_bit(0x%08X, 0x%08X, 0x%08X) - %s- %s %d\n",
 		      addr, bits, mask,
-		      unlikely(ret  == -ETIMEDOUT)?"timeout":"", f, l);
+		      unlikely(ret  == -ETIMEDOUT) ? "timeout" : "", f, l);
 	return ret;
 }
 #define iwl3945_poll_bit(priv, addr, bits, mask, timeout) \
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 17f4098..9007ff2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -661,7 +661,7 @@ static void iwl4965_tx_queue_set_status(struct iwl_priv *priv,
 	int txq_id = txq->q.id;
 
 	/* Find out whether to activate Tx queue */
-	int active = test_bit(txq_id, &priv->txq_ctx_active_msk)?1:0;
+	int active = test_bit(txq_id, &priv->txq_ctx_active_msk) ? 1 : 0;
 
 	/* Set up and activate */
 	iwl_write_prph(priv, IWL49_SCD_QUEUE_STATUS_BITS(txq_id),
@@ -2025,7 +2025,7 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 		info = IEEE80211_SKB_CB(priv->txq[txq_id].txb[idx].skb[0]);
 		info->status.rates[0].count = tx_resp->failure_frame + 1;
 		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
-		info->flags |= iwl_is_tx_success(status)?
+		info->flags |= iwl_is_tx_success(status) ?
 			IEEE80211_TX_STAT_ACK : 0;
 		iwl_hwrate_to_tx_control(priv, rate_n_flags, info);
 		/* FIXME: code repetition end */
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index b6d7e91..aeb69ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1111,7 +1111,7 @@ static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
 		info = IEEE80211_SKB_CB(priv->txq[txq_id].txb[idx].skb[0]);
 		info->status.rates[0].count = tx_resp->failure_frame + 1;
 		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
-		info->flags |= iwl_is_tx_success(status)?
+		info->flags |= iwl_is_tx_success(status) ?
 					IEEE80211_TX_STAT_ACK : 0;
 		iwl_hwrate_to_tx_control(priv, rate_n_flags, info);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 224c0b7..c1cfb87 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2521,7 +2521,7 @@ static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
 	for (i = 0; i < LQ_SIZE; i++) {
 		desc += sprintf(buff+desc, "%s type=%d SGI=%d FAT=%d DUP=%d\n"
 				"rate=0x%X\n",
-				lq_sta->active_tbl == i?"*":"x",
+				lq_sta->active_tbl == i ? "*" : "x",
 				lq_sta->lq_info[i].lq_type,
 				lq_sta->lq_info[i].is_SGI,
 				lq_sta->lq_info[i].is_fat,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d02f82e..af1dff6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1496,7 +1496,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 			hw_rf_kill = 1;
 
 		IWL_DEBUG(IWL_DL_RF_KILL, "RF_KILL bit toggled to %s.\n",
-				hw_rf_kill ? "disable radio":"enable radio");
+				hw_rf_kill ? "disable radio" : "enable radio");
 
 		/* driver only loads ucode once setting the interface up.
 		 * the driver as well won't allow loading if RFKILL is set
@@ -3670,7 +3670,8 @@ static ssize_t show_power_level(struct device *d,
 		break;
 	}
 
-	p += sprintf(p, "\tMODE:%s", (mode < IWL_POWER_AUTO)?"fixed":"auto");
+	p += sprintf(p, "\tMODE:%s", (mode < IWL_POWER_AUTO) ?
+			"fixed" : "auto");
 	p += sprintf(p, "\tINDEX:%d", level);
 	p += sprintf(p, "\n");
 	return p - buf + 1;
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 8300f3d..0008a35 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -36,7 +36,7 @@
 #include "iwl-core.h"
 
 
-#define IWL_CMD(x) case x : return #x
+#define IWL_CMD(x) case x: return #x
 
 const char *get_cmd_string(u8 cmd)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 40e0050..bc10435 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -109,7 +109,7 @@ static inline int __iwl_poll_bit(const char *f, u32 l,
 	int ret = _iwl_poll_bit(priv, addr, bits, mask, timeout);
 	IWL_DEBUG_IO("poll_bit(0x%08X, 0x%08X, 0x%08X) - %s- %s %d\n",
 		     addr, bits, mask,
-		     unlikely(ret  == -ETIMEDOUT)?"timeout":"", f, l);
+		     unlikely(ret  == -ETIMEDOUT) ? "timeout" : "", f, l);
 	return ret;
 }
 #define iwl_poll_bit(priv, addr, bits, mask, timeout) \
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 8d25781..d347505 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1502,7 +1502,7 @@ static int iwl_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 		ack = bitmap & (1ULL << i);
 		successes += !!ack;
 		IWL_DEBUG_TX_REPLY("%s ON i=%d idx=%d raw=%d\n",
-			ack? "ACK":"NACK", i, (agg->start_idx + i) & 0xff,
+			ack ? "ACK" : "NACK", i, (agg->start_idx + i) & 0xff,
 			agg->start_idx + i);
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index bee42ef..c8b85cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -520,7 +520,7 @@ static inline int iwl3945_is_ready_rf(struct iwl3945_priv *priv)
 
 /*************** HOST COMMAND QUEUE FUNCTIONS   *****/
 
-#define IWL_CMD(x) case x : return #x
+#define IWL_CMD(x) case x: return #x
 
 static const char *get_cmd_string(u8 cmd)
 {
@@ -4330,7 +4330,7 @@ static void iwl3945_irq_tasklet(struct iwl3945_priv *priv)
 
 		IWL_DEBUG(IWL_DL_INFO | IWL_DL_RF_KILL | IWL_DL_ISR,
 				"RF_KILL bit toggled to %s.\n",
-				hw_rf_kill ? "disable radio":"enable radio");
+				hw_rf_kill ? "disable radio" : "enable radio");
 
 		/* Queue restart only if RF_KILL switch was set to "kill"
 		 *   when we loaded driver, and is now set to "enable".
-- 
1.5.4.3

