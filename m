Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na6sys009bog029.obsmtp.com ([74.125.150.103]:46604 "EHLO
	na6sys009bog029.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753007Ab2HDBTp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 21:19:45 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 09/16] mwifiex: create list for associated stations in AP mode
Date: Fri,  3 Aug 2012 18:06:07 -0700
Message-Id: <1344042374-6892-10-git-send-email-bzhao@marvell.com> (sfid-20120804_031949_826496_975BF55D)
In-Reply-To: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
References: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

After station is associated an entry would be added to station
list. This entry would have station specific information such as
11n support, AMSDU size. The entry would be deleted after
deauthentication. All station entries would be deleted during
BSS_IDLE event.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c      |    3 +
 drivers/net/wireless/mwifiex/main.h      |   19 ++++
 drivers/net/wireless/mwifiex/uap_event.c |  158 +++++++++++++++++++++++++++++-
 3 files changed, 177 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 118a29f..fad2c8d 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -424,6 +424,7 @@ static void mwifiex_free_lock_list(struct mwifiex_adapter *adapter)
 				list_del(&priv->wmm.tid_tbl_ptr[j].ra_list);
 			list_del(&priv->tx_ba_stream_tbl_ptr);
 			list_del(&priv->rx_reorder_tbl_ptr);
+			list_del(&priv->sta_list);
 		}
 	}
 }
@@ -486,6 +487,7 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 			spin_lock_init(&priv->rx_pkt_lock);
 			spin_lock_init(&priv->wmm.ra_list_spinlock);
 			spin_lock_init(&priv->curr_bcn_buf_lock);
+			spin_lock_init(&priv->sta_list_spinlock);
 		}
 	}
 
@@ -518,6 +520,7 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 		}
 		INIT_LIST_HEAD(&priv->tx_ba_stream_tbl_ptr);
 		INIT_LIST_HEAD(&priv->rx_reorder_tbl_ptr);
+		INIT_LIST_HEAD(&priv->sta_list);
 
 		spin_lock_init(&priv->tx_ba_stream_tbl_lock);
 		spin_lock_init(&priv->rx_reorder_tbl_lock);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index cac0c2d..9a0174d 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -432,6 +432,9 @@ struct mwifiex_private {
 	u8 wmm_enabled;
 	u8 wmm_qosinfo;
 	struct mwifiex_wmm_desc wmm;
+	struct list_head sta_list;
+	/* spin lock for associated station list */
+	spinlock_t sta_list_spinlock;
 	struct list_head tx_ba_stream_tbl_ptr;
 	/* spin lock for tx_ba_stream_tbl_ptr queue */
 	spinlock_t tx_ba_stream_tbl_lock;
@@ -552,6 +555,19 @@ struct mwifiex_bss_priv {
 	u64 fw_tsf;
 };
 
+/* This is AP specific structure which stores information
+ * about associated STA
+ */
+struct mwifiex_sta_node {
+	struct list_head list;
+	u8 mac_addr[ETH_ALEN];
+	u8 is_wmm_enabled;
+	u8 is_11n_enabled;
+	u8 ampdu_sta[MAX_NUM_TID];
+	u16 rx_seq[MAX_NUM_TID];
+	u16 max_amsdu;
+};
+
 struct mwifiex_if_ops {
 	int (*init_if) (struct mwifiex_adapter *);
 	void (*cleanup_if) (struct mwifiex_adapter *);
@@ -786,6 +802,9 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *,
 				  struct sk_buff *skb);
 int mwifiex_process_sta_event(struct mwifiex_private *);
 int mwifiex_process_uap_event(struct mwifiex_private *);
+struct mwifiex_sta_node *
+mwifiex_get_sta_entry(struct mwifiex_private *priv, u8 *mac);
+void mwifiex_delete_all_station_list(struct mwifiex_private *priv);
 void *mwifiex_process_sta_txpd(struct mwifiex_private *, struct sk_buff *skb);
 int mwifiex_sta_init_cmd(struct mwifiex_private *, u8 first_sta);
 int mwifiex_cmd_802_11_scan(struct host_cmd_ds_command *cmd,
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index 5af60d8..37cc642 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -21,6 +21,130 @@
 #include "main.h"
 
 /*
+ * This function will return the pointer to station entry in station list
+ * table which matches specified mac address.
+ * This function should be called after acquiring RA list spinlock.
+ * NULL is returned if station entry is not found in associated STA list.
+ */
+struct mwifiex_sta_node *
+mwifiex_get_sta_entry(struct mwifiex_private *priv, u8 *mac)
+{
+	struct mwifiex_sta_node *node;
+
+	if (!mac)
+		return NULL;
+
+	list_for_each_entry(node, &priv->sta_list, list) {
+		if (!memcmp(node->mac_addr, mac, ETH_ALEN))
+			return node;
+	}
+
+	return NULL;
+}
+
+/*
+ * This function will add a sta_node entry to associated station list
+ * table with the given mac address.
+ * If entry exist already, existing entry is returned.
+ * If received mac address is NULL, NULL is returned.
+ */
+static struct mwifiex_sta_node *
+mwifiex_add_sta_entry(struct mwifiex_private *priv, u8 *mac)
+{
+	struct mwifiex_sta_node *node;
+	unsigned long flags;
+
+	if (!mac)
+		return NULL;
+
+	spin_lock_irqsave(&priv->sta_list_spinlock, flags);
+	node = mwifiex_get_sta_entry(priv, mac);
+	if (node)
+		goto done;
+
+	node = kzalloc(sizeof(struct mwifiex_sta_node), GFP_KERNEL);
+	if (!node)
+		goto done;
+
+	memcpy(node->mac_addr, mac, ETH_ALEN);
+	list_add_tail(&node->list, &priv->sta_list);
+
+done:
+	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
+	return node;
+}
+
+/*
+ * This function will search for HT IE in association request IEs
+ * and set station HT parameters accordingly.
+ */
+static void
+mwifiex_set_sta_ht_cap(struct mwifiex_private *priv, const u8 *ies,
+		       int ies_len, struct mwifiex_sta_node *node)
+{
+	const struct ieee80211_ht_cap *ht_cap;
+
+	if (!ies)
+		return;
+
+	ht_cap = (void *)cfg80211_find_ie(WLAN_EID_HT_CAPABILITY, ies, ies_len);
+	if (ht_cap) {
+		node->is_11n_enabled = 1;
+		node->max_amsdu = le16_to_cpu(ht_cap->cap_info) &
+				  IEEE80211_HT_CAP_MAX_AMSDU ?
+				  MWIFIEX_TX_DATA_BUF_SIZE_8K :
+				  MWIFIEX_TX_DATA_BUF_SIZE_4K;
+	} else {
+		node->is_11n_enabled = 0;
+	}
+
+	return;
+}
+
+/*
+ * This function will delete a station entry from station list
+ */
+static void mwifiex_del_sta_entry(struct mwifiex_private *priv, u8 *mac)
+{
+	struct mwifiex_sta_node *node, *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->sta_list_spinlock, flags);
+
+	node = mwifiex_get_sta_entry(priv, mac);
+	if (node) {
+		list_for_each_entry_safe(node, tmp, &priv->sta_list,
+					 list) {
+			list_del(&node->list);
+			kfree(node);
+		}
+	}
+
+	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
+	return;
+}
+
+/*
+ * This function will delete all stations from associated station list.
+ */
+static void mwifiex_del_all_sta_list(struct mwifiex_private *priv)
+{
+	struct mwifiex_sta_node *node, *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->sta_list_spinlock, flags);
+
+	list_for_each_entry_safe(node, tmp, &priv->sta_list, list) {
+		list_del(&node->list);
+		kfree(node);
+	}
+
+	INIT_LIST_HEAD(&priv->sta_list);
+	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
+	return;
+}
+
+/*
  * This function handles AP interface specific events generated by firmware.
  *
  * Event specific routines are called by this function based
@@ -38,10 +162,12 @@
 int mwifiex_process_uap_event(struct mwifiex_private *priv)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	int len;
+	int len, i;
 	u32 eventcause = adapter->event_cause;
 	struct station_info sinfo;
 	struct mwifiex_assoc_event *event;
+	struct mwifiex_sta_node *node;
+	u8 *deauth_mac;
 
 	switch (eventcause) {
 	case EVENT_UAP_STA_ASSOC:
@@ -70,13 +196,39 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		}
 		cfg80211_new_sta(priv->netdev, event->sta_addr, &sinfo,
 				 GFP_KERNEL);
+
+		node = mwifiex_add_sta_entry(priv, event->sta_addr);
+		if (!node) {
+			dev_warn(adapter->dev,
+				 "could not create station entry!\n");
+			return -1;
+		}
+
+		if (!priv->ap_11n_enabled)
+			break;
+
+		mwifiex_set_sta_ht_cap(priv, sinfo.assoc_req_ies,
+				       sinfo.assoc_req_ies_len, node);
+
+		for (i = 0; i < MAX_NUM_TID; i++) {
+			if (node->is_11n_enabled)
+				node->ampdu_sta[i] =
+					      priv->aggr_prio_tbl[i].ampdu_user;
+			else
+				node->ampdu_sta[i] = BA_STREAM_NOT_ALLOWED;
+		}
+		memset(node->rx_seq, 0xff, sizeof(node->rx_seq));
 		break;
 	case EVENT_UAP_STA_DEAUTH:
-		cfg80211_del_sta(priv->netdev, adapter->event_body +
-				 MWIFIEX_UAP_EVENT_EXTRA_HEADER, GFP_KERNEL);
+		deauth_mac = adapter->event_body +
+			     MWIFIEX_UAP_EVENT_EXTRA_HEADER;
+		cfg80211_del_sta(priv->netdev, deauth_mac, GFP_KERNEL);
+
+		mwifiex_del_sta_entry(priv, deauth_mac);
 		break;
 	case EVENT_UAP_BSS_IDLE:
 		priv->media_connected = false;
+		mwifiex_del_all_sta_list(priv);
 		break;
 	case EVENT_UAP_BSS_ACTIVE:
 		priv->media_connected = true;
-- 
1.7.0.2

