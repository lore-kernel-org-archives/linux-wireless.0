Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:23281 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932468AbaKMKzd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 05:55:33 -0500
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 4/6] mwifiex: add auto TDLS support
Date: Thu, 13 Nov 2014 21:54:16 +0530
Message-ID: <1415895858-4007-5-git-send-email-patila@marvell.com> (sfid-20141113_115537_263809_7C76BB92)
In-Reply-To: <1415895858-4007-1-git-send-email-patila@marvell.com>
References: <1415895858-4007-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds auto TDLS support to mwifiex.

Auto TDLS functionality works as follows:
1. Whenever userspace application has triggered TDLS connection with
any peer, driver would store this peer mac address details in its database.
2. After this driver whenever driver receives packet on direct link,
it would store rssi and timestamp in peer information.
3. Whenever a packet is to be transmitted to non-AP peer in station mode,
driver would check if TDLS link can be established by looking at peer RSSI
information. Driver would initiate TDLS setup in such cases.
4. Periodic timer is used for updating peer information.
5. Auto TDLS peer list & timer are cleared during disconnection or driver unload.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |   6 +
 drivers/net/wireless/mwifiex/decl.h      |   5 +
 drivers/net/wireless/mwifiex/init.c      |   6 +
 drivers/net/wireless/mwifiex/main.c      |   7 +
 drivers/net/wireless/mwifiex/main.h      |  31 +++-
 drivers/net/wireless/mwifiex/sta_event.c |   6 +-
 drivers/net/wireless/mwifiex/sta_rx.c    |   3 +
 drivers/net/wireless/mwifiex/tdls.c      | 233 +++++++++++++++++++++++++++++++
 8 files changed, 295 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index b3c7635..012c22c 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1805,6 +1805,10 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		dev_dbg(priv->adapter->dev,
 			"info: associated to bssid %pM successfully\n",
 			priv->cfg_bssid);
+		if (ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info) &&
+		    priv->adapter->auto_tdls &&
+		    priv->bss_type == MWIFIEX_BSS_TYPE_STA)
+			mwifiex_setup_auto_tdls_timer(priv);
 	} else {
 		dev_dbg(priv->adapter->dev,
 			"info: association to bssid %pM failed\n",
@@ -2676,11 +2680,13 @@ mwifiex_cfg80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 		dev_dbg(priv->adapter->dev,
 			"Send TDLS Setup Request to %pM status_code=%d\n", peer,
 			 status_code);
+		mwifiex_add_auto_tdls_peer(priv, peer);
 		ret = mwifiex_send_tdls_data_frame(priv, peer, action_code,
 						   dialog_token, status_code,
 						   extra_ies, extra_ies_len);
 		break;
 	case WLAN_TDLS_SETUP_RESPONSE:
+		mwifiex_add_auto_tdls_peer(priv, peer);
 		dev_dbg(priv->adapter->dev,
 			"Send TDLS Setup Response to %pM status_code=%d\n",
 			peer, status_code);
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index f53e5b5..fc0b1ed 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -85,6 +85,11 @@
 #define MWIFIEX_TDLS_CREATE_LINK              0x02
 #define MWIFIEX_TDLS_CONFIG_LINK              0x03
 
+#define MWIFIEX_TDLS_RSSI_HIGH		50
+#define MWIFIEX_TDLS_RSSI_LOW		55
+#define MWIFIEX_TDLS_MAX_FAIL_COUNT      4
+#define MWIFIEX_AUTO_TDLS_IDLE_TIME     10
+
 enum mwifiex_bss_type {
 	MWIFIEX_BSS_TYPE_STA = 0,
 	MWIFIEX_BSS_TYPE_UAP = 1,
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index bd740b6..ee51242 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -137,6 +137,7 @@ int mwifiex_init_priv(struct mwifiex_private *priv)
 	priv->csa_expire_time = 0;
 	priv->del_list_idx = 0;
 	priv->hs2_enabled = false;
+	priv->check_tdls_tx = false;
 	memcpy(priv->tos_to_tid_inv, tos_to_tid_inv, MAX_NUM_TID);
 
 	return mwifiex_add_bss_prio_tbl(priv);
@@ -248,6 +249,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->hw_dev_mcs_support = 0;
 	adapter->sec_chan_offset = 0;
 	adapter->adhoc_11n_enabled = false;
+	adapter->auto_tdls = false;
 
 	mwifiex_wmm_init(adapter);
 
@@ -366,6 +368,7 @@ static void mwifiex_free_lock_list(struct mwifiex_adapter *adapter)
 			list_del(&priv->tx_ba_stream_tbl_ptr);
 			list_del(&priv->rx_reorder_tbl_ptr);
 			list_del(&priv->sta_list);
+			list_del(&priv->auto_tdls_list);
 		}
 	}
 }
@@ -434,6 +437,7 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 			spin_lock_init(&priv->wmm.ra_list_spinlock);
 			spin_lock_init(&priv->curr_bcn_buf_lock);
 			spin_lock_init(&priv->sta_list_spinlock);
+			spin_lock_init(&priv->auto_tdls_lock);
 		}
 	}
 
@@ -465,6 +469,7 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 		INIT_LIST_HEAD(&priv->tx_ba_stream_tbl_ptr);
 		INIT_LIST_HEAD(&priv->rx_reorder_tbl_ptr);
 		INIT_LIST_HEAD(&priv->sta_list);
+		INIT_LIST_HEAD(&priv->auto_tdls_list);
 		skb_queue_head_init(&priv->tdls_txq);
 
 		spin_lock_init(&priv->tx_ba_stream_tbl_lock);
@@ -645,6 +650,7 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 		if (adapter->priv[i]) {
 			priv = adapter->priv[i];
 
+			mwifiex_clean_auto_tdls(priv);
 			mwifiex_clean_txrx(priv);
 			mwifiex_delete_bss_prio_tbl(priv);
 		}
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 2de8a6a..0e50120 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -662,6 +662,13 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	 */
 	__net_timestamp(skb);
 
+	if (ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info) &&
+	    priv->bss_type == MWIFIEX_BSS_TYPE_STA &&
+	    !ether_addr_equal_unaligned(priv->cfg_bssid, skb->data)) {
+		if (priv->adapter->auto_tdls && priv->check_tdls_tx)
+			mwifiex_tdls_check_tx(priv, skb);
+	}
+
 	mwifiex_queue_tx_pkt(priv, skb);
 
 	return 0;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 1038cf8..5a690d5 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -506,8 +506,11 @@ struct mwifiex_private {
 	struct mwifiex_wmm_desc wmm;
 	atomic_t wmm_tx_pending[IEEE80211_NUM_ACS];
 	struct list_head sta_list;
-	/* spin lock for associated station list */
+	/* spin lock for associated station/TDLS peers list */
 	spinlock_t sta_list_spinlock;
+	struct list_head auto_tdls_list;
+	/* spin lock for auto TDLS peer list */
+	spinlock_t auto_tdls_lock;
 	struct list_head tx_ba_stream_tbl_ptr;
 	/* spin lock for tx_ba_stream_tbl_ptr queue */
 	spinlock_t tx_ba_stream_tbl_lock;
@@ -572,6 +575,9 @@ struct mwifiex_private {
 	bool hs2_enabled;
 	struct station_parameters *sta_params;
 	struct sk_buff_head tdls_txq;
+	u8 check_tdls_tx;
+	struct timer_list auto_tdls_timer;
+	bool auto_tdls_timer_active;
 };
 
 enum mwifiex_ba_status {
@@ -672,6 +678,17 @@ struct mwifiex_sta_node {
 	struct mwifiex_tdls_capab tdls_cap;
 };
 
+struct mwifiex_auto_tdls_peer {
+	struct list_head list;
+	u8 mac_addr[ETH_ALEN];
+	u8 tdls_status;
+	int rssi;
+	long rssi_jiffies;
+	u8 failure_count;
+	u8 do_discover;
+	u8 do_setup;
+};
+
 struct mwifiex_if_ops {
 	int (*init_if) (struct mwifiex_adapter *);
 	void (*cleanup_if) (struct mwifiex_adapter *);
@@ -849,6 +866,7 @@ struct mwifiex_adapter {
 	struct mwifiex_chan_stats *chan_stats;
 	u32 num_in_chan_stats;
 	int survey_idx;
+	bool auto_tdls;
 };
 
 int mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
@@ -1306,6 +1324,17 @@ u8 mwifiex_get_center_freq_index(struct mwifiex_private *priv, u8 band,
 				 u32 pri_chan, u8 chan_bw);
 int mwifiex_init_channel_scan_gap(struct mwifiex_adapter *adapter);
 
+int mwifiex_tdls_check_tx(struct mwifiex_private *priv, struct sk_buff *skb);
+void mwifiex_flush_auto_tdls_list(struct mwifiex_private *priv);
+void mwifiex_auto_tdls_update_peer_status(struct mwifiex_private *priv,
+					  const u8 *mac, u8 link_status);
+void mwifiex_auto_tdls_update_peer_signal(struct mwifiex_private *priv,
+					  u8 *mac, s8 snr, s8 nflr);
+void mwifiex_check_auto_tdls(unsigned long context);
+void mwifiex_add_auto_tdls_peer(struct mwifiex_private *priv, const u8 *mac);
+void mwifiex_setup_auto_tdls_timer(struct mwifiex_private *priv);
+void mwifiex_clean_auto_tdls(struct mwifiex_private *priv);
+
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
 void mwifiex_debugfs_remove(void);
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 0efd6f0..204ecc8 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -55,9 +55,13 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason_code)
 	priv->scan_block = false;
 
 	if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
-	    ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info))
+	    ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info)) {
 		mwifiex_disable_all_tdls_links(priv);
 
+		if (priv->adapter->auto_tdls)
+			mwifiex_clean_auto_tdls(priv);
+	}
+
 	/* Free Tx and Rx packets, report disconnect to upper layer */
 	mwifiex_clean_txrx(priv);
 
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index 9ceb1db..c2ad3b6 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -232,6 +232,9 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_private *priv,
 			if (sta_ptr)
 				sta_ptr->rx_seq[local_rx_pd->priority] =
 					      le16_to_cpu(local_rx_pd->seq_num);
+			mwifiex_auto_tdls_update_peer_signal(priv, ta,
+							     local_rx_pd->snr,
+							     local_rx_pd->nf);
 		}
 	} else {
 		if (rx_pkt_type != PKT_TYPE_BAR)
diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index 93a492f..22884b4 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -1028,6 +1028,7 @@ mwifiex_tdls_process_disable_link(struct mwifiex_private *priv, const u8 *peer)
 	}
 
 	mwifiex_restore_tdls_packets(priv, peer, TDLS_LINK_TEARDOWN);
+	mwifiex_auto_tdls_update_peer_status(priv, peer, TDLS_NOT_SETUP);
 	memcpy(&tdls_oper.peer_mac, peer, ETH_ALEN);
 	tdls_oper.tdls_action = MWIFIEX_TDLS_DISABLE_LINK;
 	return mwifiex_send_cmd(priv, HostCmd_CMD_TDLS_OPER,
@@ -1072,6 +1073,8 @@ mwifiex_tdls_process_enable_link(struct mwifiex_private *priv, const u8 *peer)
 
 		memset(sta_ptr->rx_seq, 0xff, sizeof(sta_ptr->rx_seq));
 		mwifiex_restore_tdls_packets(priv, peer, TDLS_SETUP_COMPLETE);
+		mwifiex_auto_tdls_update_peer_status(priv, peer,
+						     TDLS_SETUP_COMPLETE);
 	} else {
 		dev_dbg(priv->adapter->dev,
 			"tdls: enable link %pM failed\n", peer);
@@ -1085,6 +1088,8 @@ mwifiex_tdls_process_enable_link(struct mwifiex_private *priv, const u8 *peer)
 			mwifiex_del_sta_entry(priv, peer);
 		}
 		mwifiex_restore_tdls_packets(priv, peer, TDLS_LINK_TEARDOWN);
+		mwifiex_auto_tdls_update_peer_status(priv, peer,
+						     TDLS_NOT_SETUP);
 
 		return -1;
 	}
@@ -1152,3 +1157,231 @@ void mwifiex_disable_all_tdls_links(struct mwifiex_private *priv)
 
 	mwifiex_del_all_sta_list(priv);
 }
+
+int mwifiex_tdls_check_tx(struct mwifiex_private *priv, struct sk_buff *skb)
+{
+	struct mwifiex_auto_tdls_peer *peer;
+	unsigned long flags;
+	u8 mac[ETH_ALEN];
+
+	ether_addr_copy(mac, skb->data);
+
+	spin_lock_irqsave(&priv->auto_tdls_lock, flags);
+	list_for_each_entry(peer, &priv->auto_tdls_list, list) {
+		if (!memcmp(mac, peer->mac_addr, ETH_ALEN)) {
+			if (peer->rssi <= MWIFIEX_TDLS_RSSI_HIGH &&
+			    peer->tdls_status == TDLS_NOT_SETUP &&
+			    (peer->failure_count <
+			     MWIFIEX_TDLS_MAX_FAIL_COUNT)) {
+				peer->tdls_status = TDLS_SETUP_INPROGRESS;
+				dev_dbg(priv->adapter->dev,
+					"setup TDLS link, peer=%pM rssi=%d\n",
+					peer->mac_addr, peer->rssi);
+
+				cfg80211_tdls_oper_request(priv->netdev,
+							   peer->mac_addr,
+							   NL80211_TDLS_SETUP,
+							   0, GFP_ATOMIC);
+				peer->do_setup = false;
+				priv->check_tdls_tx = false;
+			} else if (peer->failure_count <
+				   MWIFIEX_TDLS_MAX_FAIL_COUNT &&
+				   peer->do_discover) {
+				mwifiex_send_tdls_data_frame(priv,
+							     peer->mac_addr,
+						    WLAN_TDLS_DISCOVERY_REQUEST,
+							     1, 0, NULL, 0);
+				peer->do_discover = false;
+			}
+		}
+	}
+	spin_unlock_irqrestore(&priv->auto_tdls_lock, flags);
+
+	return 0;
+}
+
+void mwifiex_flush_auto_tdls_list(struct mwifiex_private *priv)
+{
+	struct mwifiex_auto_tdls_peer *peer, *tmp_node;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->auto_tdls_lock, flags);
+	list_for_each_entry_safe(peer, tmp_node, &priv->auto_tdls_list, list) {
+		list_del(&peer->list);
+		kfree(peer);
+	}
+
+	INIT_LIST_HEAD(&priv->auto_tdls_list);
+	spin_unlock_irqrestore(&priv->auto_tdls_lock, flags);
+	priv->check_tdls_tx = false;
+}
+
+void mwifiex_add_auto_tdls_peer(struct mwifiex_private *priv, const u8 *mac)
+{
+	struct mwifiex_auto_tdls_peer *tdls_peer;
+	unsigned long flags;
+
+	if (!priv->adapter->auto_tdls)
+		return;
+
+	spin_lock_irqsave(&priv->auto_tdls_lock, flags);
+	list_for_each_entry(tdls_peer, &priv->auto_tdls_list, list) {
+		if (!memcmp(tdls_peer->mac_addr, mac, ETH_ALEN)) {
+			tdls_peer->tdls_status = TDLS_SETUP_INPROGRESS;
+			tdls_peer->rssi_jiffies = jiffies;
+			spin_unlock_irqrestore(&priv->auto_tdls_lock, flags);
+			return;
+		}
+	}
+
+	/* create new TDLS peer */
+	tdls_peer = kzalloc(sizeof(*tdls_peer), GFP_ATOMIC);
+	if (tdls_peer) {
+		ether_addr_copy(tdls_peer->mac_addr, mac);
+		tdls_peer->tdls_status = TDLS_SETUP_INPROGRESS;
+		tdls_peer->rssi_jiffies = jiffies;
+		INIT_LIST_HEAD(&tdls_peer->list);
+		list_add_tail(&tdls_peer->list, &priv->auto_tdls_list);
+		dev_dbg(priv->adapter->dev, "Add auto TDLS peer= %pM to list\n",
+			mac);
+	}
+
+	spin_unlock_irqrestore(&priv->auto_tdls_lock, flags);
+}
+
+void mwifiex_auto_tdls_update_peer_status(struct mwifiex_private *priv,
+					  const u8 *mac, u8 link_status)
+{
+	struct mwifiex_auto_tdls_peer *peer;
+	unsigned long flags;
+
+	if (!priv->adapter->auto_tdls)
+		return;
+
+	spin_lock_irqsave(&priv->auto_tdls_lock, flags);
+	list_for_each_entry(peer, &priv->auto_tdls_list, list) {
+		if (!memcmp(peer->mac_addr, mac, ETH_ALEN)) {
+			if ((link_status == TDLS_NOT_SETUP) &&
+			    (peer->tdls_status == TDLS_SETUP_INPROGRESS))
+				peer->failure_count++;
+			else if (link_status == TDLS_SETUP_COMPLETE)
+				peer->failure_count = 0;
+
+			peer->tdls_status = link_status;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&priv->auto_tdls_lock, flags);
+}
+
+void mwifiex_auto_tdls_update_peer_signal(struct mwifiex_private *priv,
+					  u8 *mac, s8 snr, s8 nflr)
+{
+	struct mwifiex_auto_tdls_peer *peer;
+	unsigned long flags;
+
+	if (!priv->adapter->auto_tdls)
+		return;
+
+	spin_lock_irqsave(&priv->auto_tdls_lock, flags);
+	list_for_each_entry(peer, &priv->auto_tdls_list, list) {
+		if (!memcmp(peer->mac_addr, mac, ETH_ALEN)) {
+			peer->rssi = nflr - snr;
+			peer->rssi_jiffies = jiffies;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&priv->auto_tdls_lock, flags);
+}
+
+void mwifiex_check_auto_tdls(unsigned long context)
+{
+	struct mwifiex_private *priv = (struct mwifiex_private *)context;
+	struct mwifiex_auto_tdls_peer *tdls_peer;
+	unsigned long flags;
+	u16 reason = WLAN_REASON_TDLS_TEARDOWN_UNSPECIFIED;
+
+	if (WARN_ON_ONCE(!priv || !priv->adapter)) {
+		pr_err("mwifiex: %s: adapter or private structure is NULL\n",
+		       __func__);
+		return;
+	}
+
+	if (unlikely(!priv->adapter->auto_tdls))
+		return;
+
+	if (!priv->auto_tdls_timer_active) {
+		dev_dbg(priv->adapter->dev,
+			"auto TDLS timer inactive; return");
+		return;
+	}
+
+	priv->check_tdls_tx = false;
+
+	if (list_empty(&priv->auto_tdls_list)) {
+		mod_timer(&priv->auto_tdls_timer,
+			  jiffies +
+			  msecs_to_jiffies(MWIFIEX_TIMER_10S));
+		return;
+	}
+
+	spin_lock_irqsave(&priv->auto_tdls_lock, flags);
+	list_for_each_entry(tdls_peer, &priv->auto_tdls_list, list) {
+		if ((jiffies - tdls_peer->rssi_jiffies) >
+		    (MWIFIEX_AUTO_TDLS_IDLE_TIME * HZ)) {
+			tdls_peer->rssi = 0;
+			tdls_peer->do_discover = true;
+			priv->check_tdls_tx = true;
+		}
+
+		if (((tdls_peer->rssi >= MWIFIEX_TDLS_RSSI_LOW) ||
+		     !tdls_peer->rssi) &&
+		    tdls_peer->tdls_status == TDLS_SETUP_COMPLETE) {
+			tdls_peer->tdls_status = TDLS_LINK_TEARDOWN;
+			dev_dbg(priv->adapter->dev,
+				"teardown TDLS link,peer=%pM rssi=%d\n",
+				tdls_peer->mac_addr, -tdls_peer->rssi);
+			tdls_peer->do_discover = true;
+			priv->check_tdls_tx = true;
+			cfg80211_tdls_oper_request(priv->netdev,
+						   tdls_peer->mac_addr,
+						   NL80211_TDLS_TEARDOWN,
+						   reason, GFP_ATOMIC);
+		} else if (tdls_peer->rssi &&
+			   tdls_peer->rssi <= MWIFIEX_TDLS_RSSI_HIGH &&
+			   tdls_peer->tdls_status == TDLS_NOT_SETUP &&
+			   tdls_peer->failure_count <
+			   MWIFIEX_TDLS_MAX_FAIL_COUNT) {
+				priv->check_tdls_tx = true;
+				tdls_peer->do_setup = true;
+				dev_dbg(priv->adapter->dev,
+					"check TDLS with peer=%pM rssi=%d\n",
+					tdls_peer->mac_addr, -tdls_peer->rssi);
+		}
+	}
+	spin_unlock_irqrestore(&priv->auto_tdls_lock, flags);
+
+	mod_timer(&priv->auto_tdls_timer,
+		  jiffies + msecs_to_jiffies(MWIFIEX_TIMER_10S));
+}
+
+void mwifiex_setup_auto_tdls_timer(struct mwifiex_private *priv)
+{
+	init_timer(&priv->auto_tdls_timer);
+	priv->auto_tdls_timer.function = mwifiex_check_auto_tdls;
+	priv->auto_tdls_timer.data = (unsigned long)priv;
+	priv->auto_tdls_timer_active = true;
+	mod_timer(&priv->auto_tdls_timer,
+		  jiffies + msecs_to_jiffies(MWIFIEX_TIMER_10S));
+}
+
+void mwifiex_clean_auto_tdls(struct mwifiex_private *priv)
+{
+	if (ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info) &&
+	    priv->adapter->auto_tdls &&
+	    priv->bss_type == MWIFIEX_BSS_TYPE_STA) {
+		priv->auto_tdls_timer_active = false;
+		del_timer(&priv->auto_tdls_timer);
+		mwifiex_flush_auto_tdls_list(priv);
+	}
+}
-- 
1.8.1.4

