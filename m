Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58365 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab0AHRbN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 12:31:13 -0500
Date: Fri, 8 Jan 2010 18:30:58 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 06/11] mwl8k: implement AP firmware station database maintenance
Message-ID: <20100108173058.GZ1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

STA firmware uses UPDATE_STADB to manipulate the hardware station
database, whereas AP firmware uses SET_NEW_STN -- this implements the
latter, and hooks it into mwl8k_sta_notify(), to be used if we're
running on AP firmware.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |  134 ++++++++++++++++++++++++++++++++++++-----
 1 files changed, 117 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index ec79033..f0026f3 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -281,6 +281,7 @@ static const struct ieee80211_rate mwl8k_rates[] = {
 #define MWL8K_CMD_ENABLE_SNIFFER	0x0150
 #define MWL8K_CMD_SET_MAC_ADDR		0x0202
 #define MWL8K_CMD_SET_RATEADAPT_MODE	0x0203
+#define MWL8K_CMD_SET_NEW_STN		0x1111
 #define MWL8K_CMD_UPDATE_STADB		0x1123
 
 static const char *mwl8k_cmd_name(u16 cmd, char *buf, int bufsize)
@@ -313,6 +314,7 @@ static const char *mwl8k_cmd_name(u16 cmd, char *buf, int bufsize)
 		MWL8K_CMDNAME(ENABLE_SNIFFER);
 		MWL8K_CMDNAME(SET_MAC_ADDR);
 		MWL8K_CMDNAME(SET_RATEADAPT_MODE);
+		MWL8K_CMDNAME(SET_NEW_STN);
 		MWL8K_CMDNAME(UPDATE_STADB);
 	default:
 		snprintf(buf, bufsize, "0x%x", cmd);
@@ -2660,6 +2662,90 @@ static int mwl8k_cmd_set_rateadapt_mode(struct ieee80211_hw *hw, __u16 mode)
 }
 
 /*
+ * CMD_SET_NEW_STN.
+ */
+struct mwl8k_cmd_set_new_stn {
+	struct mwl8k_cmd_pkt header;
+	__le16 aid;
+	__u8 mac_addr[6];
+	__le16 stn_id;
+	__le16 action;
+	__le16 rsvd;
+	__le32 legacy_rates;
+	__u8 ht_rates[4];
+	__le16 cap_info;
+	__le16 ht_capabilities_info;
+	__u8 mac_ht_param_info;
+	__u8 rev;
+	__u8 control_channel;
+	__u8 add_channel;
+	__le16 op_mode;
+	__le16 stbc;
+	__u8 add_qos_info;
+	__u8 is_qos_sta;
+	__le32 fw_sta_ptr;
+} __attribute__((packed));
+
+#define MWL8K_STA_ACTION_ADD		0
+#define MWL8K_STA_ACTION_REMOVE		2
+
+static int mwl8k_cmd_set_new_stn_add(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_sta *sta)
+{
+	struct mwl8k_cmd_set_new_stn *cmd;
+	int rc;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_NEW_STN);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+	cmd->aid = cpu_to_le16(sta->aid);
+	memcpy(cmd->mac_addr, sta->addr, ETH_ALEN);
+	cmd->stn_id = cpu_to_le16(sta->aid);
+	cmd->action = cpu_to_le16(MWL8K_STA_ACTION_ADD);
+	cmd->legacy_rates = cpu_to_le32(sta->supp_rates[IEEE80211_BAND_2GHZ]);
+	if (sta->ht_cap.ht_supported) {
+		cmd->ht_rates[0] = sta->ht_cap.mcs.rx_mask[0];
+		cmd->ht_rates[1] = sta->ht_cap.mcs.rx_mask[1];
+		cmd->ht_rates[2] = sta->ht_cap.mcs.rx_mask[2];
+		cmd->ht_rates[3] = sta->ht_cap.mcs.rx_mask[3];
+		cmd->ht_capabilities_info = cpu_to_le16(sta->ht_cap.cap);
+		cmd->mac_ht_param_info = (sta->ht_cap.ampdu_factor & 3) |
+			((sta->ht_cap.ampdu_density & 7) << 2);
+		cmd->is_qos_sta = 1;
+	}
+
+	rc = mwl8k_post_cmd(hw, &cmd->header);
+	kfree(cmd);
+
+	return rc;
+}
+
+static int mwl8k_cmd_set_new_stn_del(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif, u8 *addr)
+{
+	struct mwl8k_cmd_set_new_stn *cmd;
+	int rc;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_NEW_STN);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+	memcpy(cmd->mac_addr, addr, ETH_ALEN);
+	cmd->action = cpu_to_le16(MWL8K_STA_ACTION_REMOVE);
+
+	rc = mwl8k_post_cmd(hw, &cmd->header);
+	kfree(cmd);
+
+	return rc;
+}
+
+/*
  * CMD_UPDATE_STADB.
  */
 struct ewc_ht_info {
@@ -3247,6 +3333,36 @@ struct mwl8k_sta_notify_item
 	struct ieee80211_sta sta;
 };
 
+static void
+mwl8k_do_sta_notify(struct ieee80211_hw *hw, struct mwl8k_sta_notify_item *s)
+{
+	struct mwl8k_priv *priv = hw->priv;
+
+	/*
+	 * STA firmware uses UPDATE_STADB, AP firmware uses SET_NEW_STN.
+	 */
+	if (!priv->ap_fw && s->cmd == STA_NOTIFY_ADD) {
+		int rc;
+
+		rc = mwl8k_cmd_update_stadb_add(hw, s->vif, &s->sta);
+		if (rc >= 0) {
+			struct ieee80211_sta *sta;
+
+			rcu_read_lock();
+			sta = ieee80211_find_sta(s->vif, s->sta.addr);
+			if (sta != NULL)
+				MWL8K_STA(sta)->peer_id = rc;
+			rcu_read_unlock();
+		}
+	} else if (!priv->ap_fw && s->cmd == STA_NOTIFY_REMOVE) {
+		mwl8k_cmd_update_stadb_del(hw, s->vif, s->sta.addr);
+	} else if (priv->ap_fw && s->cmd == STA_NOTIFY_ADD) {
+		mwl8k_cmd_set_new_stn_add(hw, s->vif, &s->sta);
+	} else if (priv->ap_fw && s->cmd == STA_NOTIFY_REMOVE) {
+		mwl8k_cmd_set_new_stn_del(hw, s->vif, s->sta.addr);
+	}
+}
+
 static void mwl8k_sta_notify_worker(struct work_struct *work)
 {
 	struct mwl8k_priv *priv =
@@ -3263,23 +3379,7 @@ static void mwl8k_sta_notify_worker(struct work_struct *work)
 
 		spin_unlock_bh(&priv->sta_notify_list_lock);
 
-		if (s->cmd == STA_NOTIFY_ADD) {
-			int rc;
-
-			rc = mwl8k_cmd_update_stadb_add(hw, s->vif, &s->sta);
-			if (rc >= 0) {
-				struct ieee80211_sta *sta;
-
-				rcu_read_lock();
-				sta = ieee80211_find_sta(s->vif, s->sta.addr);
-				if (sta != NULL)
-					MWL8K_STA(sta)->peer_id = rc;
-				rcu_read_unlock();
-			}
-		} else {
-			mwl8k_cmd_update_stadb_del(hw, s->vif, s->sta.addr);
-		}
-
+		mwl8k_do_sta_notify(hw, s);
 		kfree(s);
 
 		spin_lock_bh(&priv->sta_notify_list_lock);
-- 
1.5.6.4
