Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22867 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027Ab0BYGMR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 01:12:17 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2/7] iwmc3200wifi: remove "_safe" for some list_for_each_entry usage
Date: Thu, 25 Feb 2010 14:15:26 +0800
Message-Id: <1267078531-9817-3-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1267078531-9817-2-git-send-email-yi.zhu@intel.com>
References: <1267078531-9817-1-git-send-email-yi.zhu@intel.com>
 <1267078531-9817-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use list_for_each_entry instead of list_for_each_entry_safe in
places iteration against list entry removal is not required.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |    4 ++--
 drivers/net/wireless/iwmc3200wifi/debugfs.c  |    9 +++++----
 drivers/net/wireless/iwmc3200wifi/hal.c      |   12 ++++++------
 drivers/net/wireless/iwmc3200wifi/main.c     |    4 ++--
 drivers/net/wireless/iwmc3200wifi/rx.c       |   15 ++++++---------
 5 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index 7c4f44a..6778e58 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -263,7 +263,7 @@ static int iwm_cfg80211_get_station(struct wiphy *wiphy,
 int iwm_cfg80211_inform_bss(struct iwm_priv *iwm)
 {
 	struct wiphy *wiphy = iwm_to_wiphy(iwm);
-	struct iwm_bss_info *bss, *next;
+	struct iwm_bss_info *bss;
 	struct iwm_umac_notif_bss_info *umac_bss;
 	struct ieee80211_mgmt *mgmt;
 	struct ieee80211_channel *channel;
@@ -271,7 +271,7 @@ int iwm_cfg80211_inform_bss(struct iwm_priv *iwm)
 	s32 signal;
 	int freq;
 
-	list_for_each_entry_safe(bss, next, &iwm->bss_list, node) {
+	list_for_each_entry(bss, &iwm->bss_list, node) {
 		umac_bss = bss->bss;
 		mgmt = (struct ieee80211_mgmt *)(umac_bss->frame_buf);
 
diff --git a/drivers/net/wireless/iwmc3200wifi/debugfs.c b/drivers/net/wireless/iwmc3200wifi/debugfs.c
index be992ca..6ac5c8d 100644
--- a/drivers/net/wireless/iwmc3200wifi/debugfs.c
+++ b/drivers/net/wireless/iwmc3200wifi/debugfs.c
@@ -265,7 +265,7 @@ static ssize_t iwm_debugfs_rx_ticket_read(struct file *filp,
 					  size_t count, loff_t *ppos)
 {
 	struct iwm_priv *iwm = filp->private_data;
-	struct iwm_rx_ticket_node *ticket, *next;
+	struct iwm_rx_ticket_node *ticket;
 	char *buf;
 	int buf_len = 4096, i;
 	size_t len = 0;
@@ -280,7 +280,7 @@ static ssize_t iwm_debugfs_rx_ticket_read(struct file *filp,
 	if (!buf)
 		return -ENOMEM;
 
-	list_for_each_entry_safe(ticket, next, &iwm->rx_tickets, node) {
+	list_for_each_entry(ticket, &iwm->rx_tickets, node) {
 		len += snprintf(buf + len, buf_len - len, "Ticket #%d\n",
 				ticket->ticket->id);
 		len += snprintf(buf + len, buf_len - len, "\taction: 0x%x\n",
@@ -290,12 +290,13 @@ static ssize_t iwm_debugfs_rx_ticket_read(struct file *filp,
 	}
 
 	for (i = 0; i < IWM_RX_ID_HASH; i++) {
-		struct iwm_rx_packet *packet, *nxt;
+		struct iwm_rx_packet *packet;
 		struct list_head *pkt_list = &iwm->rx_packets[i];
+
 		if (!list_empty(pkt_list)) {
 			len += snprintf(buf + len, buf_len - len,
 					"Packet hash #%d\n", i);
-			list_for_each_entry_safe(packet, nxt, pkt_list, node) {
+			list_for_each_entry(packet, pkt_list, node) {
 				len += snprintf(buf + len, buf_len - len,
 						"\tPacket id:     %d\n",
 						packet->id);
diff --git a/drivers/net/wireless/iwmc3200wifi/hal.c b/drivers/net/wireless/iwmc3200wifi/hal.c
index d13c885..96caab4 100644
--- a/drivers/net/wireless/iwmc3200wifi/hal.c
+++ b/drivers/net/wireless/iwmc3200wifi/hal.c
@@ -206,9 +206,9 @@ void iwm_cmd_flush(struct iwm_priv *iwm)
 
 struct iwm_wifi_cmd *iwm_get_pending_wifi_cmd(struct iwm_priv *iwm, u16 seq_num)
 {
-	struct iwm_wifi_cmd *cmd, *next;
+	struct iwm_wifi_cmd *cmd;
 
-	list_for_each_entry_safe(cmd, next, &iwm->wifi_pending_cmd, pending)
+	list_for_each_entry(cmd, &iwm->wifi_pending_cmd, pending)
 		if (cmd->seq_num == seq_num) {
 			list_del(&cmd->pending);
 			return cmd;
@@ -217,12 +217,12 @@ struct iwm_wifi_cmd *iwm_get_pending_wifi_cmd(struct iwm_priv *iwm, u16 seq_num)
 	return NULL;
 }
 
-struct iwm_nonwifi_cmd *
-iwm_get_pending_nonwifi_cmd(struct iwm_priv *iwm, u8 seq_num, u8 cmd_opcode)
+struct iwm_nonwifi_cmd *iwm_get_pending_nonwifi_cmd(struct iwm_priv *iwm,
+						    u8 seq_num, u8 cmd_opcode)
 {
-	struct iwm_nonwifi_cmd *cmd, *next;
+	struct iwm_nonwifi_cmd *cmd;
 
-	list_for_each_entry_safe(cmd, next, &iwm->nonwifi_pending_cmd, pending)
+	list_for_each_entry(cmd, &iwm->nonwifi_pending_cmd, pending)
 		if ((cmd->seq_num == seq_num) &&
 		    (cmd->udma_cmd.opcode == cmd_opcode) &&
 		    (cmd->resp_received)) {
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index 7f34d6d..9051960 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -423,9 +423,9 @@ int iwm_notif_send(struct iwm_priv *iwm, struct iwm_wifi_cmd *cmd,
 static struct iwm_notif *iwm_notif_find(struct iwm_priv *iwm, u32 cmd,
 					u8 source)
 {
-	struct iwm_notif *notif, *next;
+	struct iwm_notif *notif;
 
-	list_for_each_entry_safe(notif, next, &iwm->pending_notif, pending) {
+	list_for_each_entry(notif, &iwm->pending_notif, pending) {
 		if ((notif->cmd_id == cmd) && (notif->src == source)) {
 			list_del(&notif->pending);
 			return notif;
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 36b1580..cbaf8ae 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -342,12 +342,9 @@ static void iwm_rx_ticket_node_free(struct iwm_rx_ticket_node *ticket_node)
 static struct iwm_rx_packet *iwm_rx_packet_get(struct iwm_priv *iwm, u16 id)
 {
 	u8 id_hash = IWM_RX_ID_GET_HASH(id);
-	struct list_head *packet_list;
-	struct iwm_rx_packet *packet, *next;
-
-	packet_list = &iwm->rx_packets[id_hash];
+	struct iwm_rx_packet *packet;
 
-	list_for_each_entry_safe(packet, next, packet_list, node)
+	list_for_each_entry(packet, &iwm->rx_packets[id_hash], node)
 		if (packet->id == id)
 			return packet;
 
@@ -771,7 +768,7 @@ static int iwm_mlme_update_bss_table(struct iwm_priv *iwm, u8 *buf,
 			(struct iwm_umac_notif_bss_info *)buf;
 	struct ieee80211_channel *channel;
 	struct ieee80211_supported_band *band;
-	struct iwm_bss_info *bss, *next;
+	struct iwm_bss_info *bss;
 	s32 signal;
 	int freq;
 	u16 frame_len = le16_to_cpu(umac_bss->frame_len);
@@ -790,7 +787,7 @@ static int iwm_mlme_update_bss_table(struct iwm_priv *iwm, u8 *buf,
 	IWM_DBG_MLME(iwm, DBG, "\tRSSI: %d\n", umac_bss->rssi);
 	IWM_DBG_MLME(iwm, DBG, "\tFrame Length: %d\n", frame_len);
 
-	list_for_each_entry_safe(bss, next, &iwm->bss_list, node)
+	list_for_each_entry(bss, &iwm->bss_list, node)
 		if (bss->bss->table_idx == umac_bss->table_idx)
 			break;
 
@@ -1331,7 +1328,7 @@ static int iwm_rx_handle_nonwifi(struct iwm_priv *iwm, u8 *buf,
 {
 	u8 seq_num;
 	struct iwm_udma_in_hdr *hdr = (struct iwm_udma_in_hdr *)buf;
-	struct iwm_nonwifi_cmd *cmd, *next;
+	struct iwm_nonwifi_cmd *cmd;
 
 	seq_num = GET_VAL32(hdr->cmd, UDMA_HDI_IN_CMD_NON_WIFI_HW_SEQ_NUM);
 
@@ -1343,7 +1340,7 @@ static int iwm_rx_handle_nonwifi(struct iwm_priv *iwm, u8 *buf,
 	 * That means we only support synchronised non wifi command response
 	 * schemes.
 	 */
-	list_for_each_entry_safe(cmd, next, &iwm->nonwifi_pending_cmd, pending)
+	list_for_each_entry(cmd, &iwm->nonwifi_pending_cmd, pending)
 		if (cmd->seq_num == seq_num) {
 			cmd->resp_received = 1;
 			cmd->buf.len = buf_size;
-- 
1.6.0.4

