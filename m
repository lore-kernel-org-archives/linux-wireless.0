Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:26932 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932425AbZHMUbT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 16:31:19 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel C Halperin <daniel.c.halperin@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/13] iwlwifi: fix erroneous use of iwl_rx_packet.len as a length
Date: Thu, 13 Aug 2009 13:31:01 -0700
Message-Id: <1250195462-15811-13-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
References: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel C Halperin <daniel.c.halperin@intel.com>

The field called 'len' in struct iwl_rx_packet is in fact not just a length
field but also includes some flags from the flow handler.  In several places
throughout the driver, this causes incorrect values to be interpreted as
lengths when the field is improperly masked.

In most situations the improper use is for debugging output, and simply results
in an erroneous message, such as:

[551933.070224] ieee80211 phy0: I iwl_rx_statistics Statistics notification received (480 vs -1367342620).

which should read '(480 vs 484)'.

In at least one case this could case bad things to happen:

void iwl_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
                                      struct iwl_rx_mem_buffer *rxb)
{
        struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
        IWL_DEBUG_RADIO(priv, "Dumping %d bytes of unhandled "
                        "notification for %s:\n",
                        le32_to_cpu(pkt->len), get_cmd_string(pkt->hdr.cmd));
        iwl_print_hex_dump(priv, IWL_DL_RADIO, pkt->u.raw, le32_to_cpu(pkt->len)
);
}
EXPORT_SYMBOL(iwl_rx_pm_debug_statistics_notif);

Given the rampant misuse of this field without proper masking throughout the
driver (every use but one), this patch renames the field from 'len' to
'len_n_flags' to reduce confusion.  It also adds the proper masking when
this field is used as a length value.

Signed-off-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    3 ++-
 5 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index b5a4d2e..e9a685d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -349,12 +349,13 @@ static void iwl3945_rx_reply_tx(struct iwl_priv *priv,
  *
  *****************************************************************************/
 
-void iwl3945_hw_rx_statistics(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
+void iwl3945_hw_rx_statistics(struct iwl_priv *priv,
+		struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	IWL_DEBUG_RX(priv, "Statistics notification received (%d vs %d).\n",
 		     (int)sizeof(struct iwl3945_notif_statistics),
-		     le32_to_cpu(pkt->len));
+		     le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
 
 	memcpy(&priv->statistics_39, pkt->u.raw, sizeof(priv->statistics_39));
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 720d234..1d539e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -494,7 +494,7 @@ static void iwl5000_rx_calib_result(struct iwl_priv *priv,
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_calib_hdr *hdr = (struct iwl_calib_hdr *)pkt->u.raw;
-	int len = le32_to_cpu(pkt->len) & FH_RSCSR_FRAME_SIZE_MSK;
+	int len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
 	int index;
 
 	/* reduce the size of the length field itself */
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 9398ad7..f430384 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3482,7 +3482,7 @@ struct iwl_wimax_coex_cmd {
  *****************************************************************************/
 
 struct iwl_rx_packet {
-	__le32 len;
+	__le32 len_n_flags;
 	struct iwl_cmd_header hdr;
 	union {
 		struct iwl3945_rx_frame rx_frame;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 62aa87b..f4c2431 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2294,10 +2294,11 @@ void iwl_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
 				      struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	u32 len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
 	IWL_DEBUG_RADIO(priv, "Dumping %d bytes of unhandled "
-			"notification for %s:\n",
-			le32_to_cpu(pkt->len), get_cmd_string(pkt->hdr.cmd));
-	iwl_print_hex_dump(priv, IWL_DL_RADIO, pkt->u.raw, le32_to_cpu(pkt->len));
+			"notification for %s:\n", len,
+			get_cmd_string(pkt->hdr.cmd));
+	iwl_print_hex_dump(priv, IWL_DL_RADIO, pkt->u.raw, len);
 }
 EXPORT_SYMBOL(iwl_rx_pm_debug_statistics_notif);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 092d327..353d9a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -539,7 +539,8 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 
 	IWL_DEBUG_RX(priv, "Statistics notification received (%d vs %d).\n",
-		     (int)sizeof(priv->statistics), pkt->len);
+		     (int)sizeof(priv->statistics),
+		     le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
 
 	change = ((priv->statistics.general.temperature !=
 		   pkt->u.stats.general.temperature) ||
-- 
1.5.6.3

