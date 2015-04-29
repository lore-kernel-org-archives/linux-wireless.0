Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:16870 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422827AbbD2Lpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2015 07:45:47 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 6/7] wil6210: broadcast for secure link
Date: Wed, 29 Apr 2015 14:45:05 +0300
Message-Id: <1430307906-28393-7-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150429_134554_229262_7122F055)
In-Reply-To: <1430307906-28393-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1430307906-28393-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce 2 types of GTK, Tx (for this STA) and Rx (for each peer).
Now, AP has only Tx GTK, STA - only Rx one. PBSS not supported yet;
for it, continue using pseudo-DMS.
Handle per-vring .1x state, update it from WMI_VRING_EN_EVENTID
event. This allows unification for unicast and broadcast vrings.
This mechanism replaces former per-CID "data_port_open"

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 64 +++++++++++++++++++++------
 drivers/net/wireless/ath/wil6210/debugfs.c  | 14 +++---
 drivers/net/wireless/ath/wil6210/main.c     |  6 +--
 drivers/net/wireless/ath/wil6210/txrx.c     | 46 ++++++++++---------
 drivers/net/wireless/ath/wil6210/wil6210.h  |  7 +--
 drivers/net/wireless/ath/wil6210/wmi.c      | 68 ++++++++---------------------
 drivers/net/wireless/ath/wil6210/wmi.h      | 25 +++++++----
 7 files changed, 124 insertions(+), 106 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index f53a190..1b02b73 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -425,10 +425,17 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 	wil->privacy = sme->privacy;
 
 	if (wil->privacy) {
-		/* For secure assoc, send WMI_DELETE_CIPHER_KEY_CMD */
-		rc = wmi_del_cipher_key(wil, 0, bss->bssid);
+		/* For secure assoc, remove old keys */
+		rc = wmi_del_cipher_key(wil, 0, bss->bssid,
+					WMI_KEY_USE_PAIRWISE);
 		if (rc) {
-			wil_err(wil, "WMI_DELETE_CIPHER_KEY_CMD failed\n");
+			wil_err(wil, "WMI_DELETE_CIPHER_KEY_CMD(PTK) failed\n");
+			goto out;
+		}
+		rc = wmi_del_cipher_key(wil, 0, bss->bssid,
+					WMI_KEY_USE_RX_GROUP);
+		if (rc) {
+			wil_err(wil, "WMI_DELETE_CIPHER_KEY_CMD(GTK) failed\n");
 			goto out;
 		}
 	}
@@ -462,6 +469,8 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 		conn.auth_mode = WMI_AUTH_WPA2_PSK;
 		conn.pairwise_crypto_type = WMI_CRYPT_AES_GCMP;
 		conn.pairwise_crypto_len = 16;
+		conn.group_crypto_type = WMI_CRYPT_AES_GCMP;
+		conn.group_crypto_len = 16;
 	} else {
 		conn.dot11_auth_mode = WMI_AUTH11_OPEN;
 		conn.auth_mode = WMI_AUTH_NONE;
@@ -563,6 +572,39 @@ static int wil_cfg80211_set_channel(struct wiphy *wiphy,
 	return 0;
 }
 
+static enum wmi_key_usage wil_detect_key_usage(struct wil6210_priv *wil,
+					       bool pairwise)
+{
+	struct wireless_dev *wdev = wil->wdev;
+	enum wmi_key_usage rc;
+	static const char * const key_usage_str[] = {
+		[WMI_KEY_USE_PAIRWISE]	= "WMI_KEY_USE_PAIRWISE",
+		[WMI_KEY_USE_RX_GROUP]	= "WMI_KEY_USE_RX_GROUP",
+		[WMI_KEY_USE_TX_GROUP]	= "WMI_KEY_USE_TX_GROUP",
+	};
+
+	if (pairwise) {
+		rc = WMI_KEY_USE_PAIRWISE;
+	} else {
+		switch (wdev->iftype) {
+		case NL80211_IFTYPE_STATION:
+			rc = WMI_KEY_USE_RX_GROUP;
+			break;
+		case NL80211_IFTYPE_AP:
+			rc = WMI_KEY_USE_TX_GROUP;
+			break;
+		default:
+			/* TODO: Rx GTK or Tx GTK? */
+			wil_err(wil, "Can't determine GTK type\n");
+			rc = WMI_KEY_USE_RX_GROUP;
+			break;
+		}
+	}
+	wil_dbg_misc(wil, "%s() -> %s\n", __func__, key_usage_str[rc]);
+
+	return rc;
+}
+
 static int wil_cfg80211_add_key(struct wiphy *wiphy,
 				struct net_device *ndev,
 				u8 key_index, bool pairwise,
@@ -570,16 +612,13 @@ static int wil_cfg80211_add_key(struct wiphy *wiphy,
 				struct key_params *params)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	enum wmi_key_usage key_usage = wil_detect_key_usage(wil, pairwise);
 
 	wil_dbg_misc(wil, "%s(%pM[%d] %s)\n", __func__, mac_addr, key_index,
 		     pairwise ? "PTK" : "GTK");
 
-	/* group key is not used */
-	if (!pairwise)
-		return 0;
-
-	return wmi_add_cipher_key(wil, key_index, mac_addr,
-				  params->key_len, params->key);
+	return wmi_add_cipher_key(wil, key_index, mac_addr, params->key_len,
+				  params->key, key_usage);
 }
 
 static int wil_cfg80211_del_key(struct wiphy *wiphy,
@@ -588,15 +627,12 @@ static int wil_cfg80211_del_key(struct wiphy *wiphy,
 				const u8 *mac_addr)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	enum wmi_key_usage key_usage = wil_detect_key_usage(wil, pairwise);
 
 	wil_dbg_misc(wil, "%s(%pM[%d] %s)\n", __func__, mac_addr, key_index,
 		     pairwise ? "PTK" : "GTK");
 
-	/* group key is not used */
-	if (!pairwise)
-		return 0;
-
-	return wmi_del_cipher_key(wil, key_index, mac_addr);
+	return wmi_del_cipher_key(wil, key_index, mac_addr, key_usage);
 }
 
 /* Need to be present or wiphy_new() will WARN */
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 19f77e5..8f9c072 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2014 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2015 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -124,15 +124,17 @@ static int wil_vring_debugfs_show(struct seq_file *s, void *data)
 
 			if (cid < WIL6210_MAX_CID)
 				seq_printf(s,
-					   "\n%pM CID %d TID %d BACK([%u] %u TU A%s) [%3d|%3d] idle %s\n",
+					   "\n%pM CID %d TID %d 1x%s BACK([%u] %u TU A%s) [%3d|%3d] idle %s\n",
 					   wil->sta[cid].addr, cid, tid,
+					   txdata->dot1x_open ? "+" : "-",
 					   txdata->agg_wsize,
 					   txdata->agg_timeout,
 					   txdata->agg_amsdu ? "+" : "-",
 					   used, avail, sidle);
 			else
 				seq_printf(s,
-					   "\nBroadcast [%3d|%3d] idle %s\n",
+					   "\nBroadcast 1x%s [%3d|%3d] idle %s\n",
+					   txdata->dot1x_open ? "+" : "-",
 					   used, avail, sidle);
 
 			wil_print_vring(s, wil, name, vring, '_', 'H');
@@ -1195,8 +1197,7 @@ static int wil_link_debugfs_show(struct seq_file *s, void *data)
 			status = "connected";
 			break;
 		}
-		seq_printf(s, "[%d] %pM %s%s\n", i, p->addr, status,
-			   (p->data_port_open ? " data_port_open" : ""));
+		seq_printf(s, "[%d] %pM %s\n", i, p->addr, status);
 
 		if (p->status == wil_sta_connected) {
 			rc = wil_cid_fill_sinfo(wil, i, &sinfo);
@@ -1376,8 +1377,7 @@ __acquires(&p->tid_rx_lock) __releases(&p->tid_rx_lock)
 			status = "connected";
 			break;
 		}
-		seq_printf(s, "[%d] %pM %s%s\n", i, p->addr, status,
-			   (p->data_port_open ? " data_port_open" : ""));
+		seq_printf(s, "[%d] %pM %s\n", i, p->addr, status);
 
 		if (p->status == wil_sta_connected) {
 			spin_lock_bh(&p->tid_rx_lock);
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 146fd80..ef3b6bc 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -150,7 +150,6 @@ __acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 	wil_dbg_misc(wil, "%s(CID %d, status %d)\n", __func__, cid,
 		     sta->status);
 
-	sta->data_port_open = false;
 	if (sta->status != wil_sta_unused) {
 		if (!from_event)
 			wmi_disconnect_sta(wil, sta->addr, reason_code);
@@ -377,9 +376,10 @@ int wil_bcast_init(struct wil6210_priv *wil)
 	if (ri < 0)
 		return ri;
 
+	wil->bcast_vring = ri;
 	rc = wil_vring_init_bcast(wil, ri, 1 << bcast_ring_order);
-	if (rc == 0)
-		wil->bcast_vring = ri;
+	if (rc)
+		wil->bcast_vring = -1;
 
 	return rc;
 }
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 1fd34e5..0113dac 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2014 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2015 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -724,6 +724,8 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 
 	cmd.vring_cfg.tx_sw_ring.ring_mem_base = cpu_to_le64(vring->pa);
 
+	if (!wil->privacy)
+		txdata->dot1x_open = true;
 	rc = wmi_call(wil, WMI_VRING_CFG_CMDID, &cmd, sizeof(cmd),
 		      WMI_VRING_CFG_DONE_EVENTID, &reply, sizeof(reply), 100);
 	if (rc)
@@ -738,11 +740,13 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 	vring->hwtail = le32_to_cpu(reply.cmd.tx_vring_tail_ptr);
 
 	txdata->enabled = 1;
-	if (wil->sta[cid].data_port_open && (agg_wsize >= 0))
+	if (txdata->dot1x_open && (agg_wsize >= 0))
 		wil_addba_tx_request(wil, id, agg_wsize);
 
 	return 0;
  out_free:
+	txdata->dot1x_open = false;
+	txdata->enabled = 0;
 	wil_vring_free(wil, vring, 1);
  out:
 
@@ -792,6 +796,8 @@ int wil_vring_init_bcast(struct wil6210_priv *wil, int id, int size)
 
 	cmd.vring_cfg.tx_sw_ring.ring_mem_base = cpu_to_le64(vring->pa);
 
+	if (!wil->privacy)
+		txdata->dot1x_open = true;
 	rc = wmi_call(wil, WMI_BCAST_VRING_CFG_CMDID, &cmd, sizeof(cmd),
 		      WMI_VRING_CFG_DONE_EVENTID, &reply, sizeof(reply), 100);
 	if (rc)
@@ -809,6 +815,8 @@ int wil_vring_init_bcast(struct wil6210_priv *wil, int id, int size)
 
 	return 0;
  out_free:
+	txdata->enabled = 0;
+	txdata->dot1x_open = false;
 	wil_vring_free(wil, vring, 1);
  out:
 
@@ -828,6 +836,7 @@ void wil_vring_fini_tx(struct wil6210_priv *wil, int id)
 	wil_dbg_misc(wil, "%s() id=%d\n", __func__, id);
 
 	spin_lock_bh(&txdata->lock);
+	txdata->dot1x_open = false;
 	txdata->enabled = 0; /* no Tx can be in progress or start anew */
 	spin_unlock_bh(&txdata->lock);
 	/* make sure NAPI won't touch this vring */
@@ -848,12 +857,11 @@ static struct vring *wil_find_tx_ucast(struct wil6210_priv *wil,
 	if (cid < 0)
 		return NULL;
 
-	if (!wil->sta[cid].data_port_open &&
-	    (skb->protocol != cpu_to_be16(ETH_P_PAE)))
-		return NULL;
-
 	/* TODO: fix for multiple TID */
 	for (i = 0; i < ARRAY_SIZE(wil->vring2cid_tid); i++) {
+		if (!wil->vring_tx_data[i].dot1x_open &&
+		    (skb->protocol != cpu_to_be16(ETH_P_PAE)))
+			continue;
 		if (wil->vring2cid_tid[i][0] == cid) {
 			struct vring *v = &wil->vring_tx[i];
 
@@ -883,7 +891,7 @@ static struct vring *wil_find_tx_vring_sta(struct wil6210_priv *wil,
 
 	/* In the STA mode, it is expected to have only 1 VRING
 	 * for the AP we connected to.
-	 * find 1-st vring and see whether it is eligible for data
+	 * find 1-st vring eligible for this skb and use it.
 	 */
 	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
 		v = &wil->vring_tx[i];
@@ -894,9 +902,9 @@ static struct vring *wil_find_tx_vring_sta(struct wil6210_priv *wil,
 		if (cid >= WIL6210_MAX_CID) /* skip BCAST */
 			continue;
 
-		if (!wil->sta[cid].data_port_open &&
+		if (!wil->vring_tx_data[i].dot1x_open &&
 		    (skb->protocol != cpu_to_be16(ETH_P_PAE)))
-			break;
+			continue;
 
 		wil_dbg_txrx(wil, "Tx -> ring %d\n", i);
 
@@ -918,7 +926,6 @@ static struct vring *wil_find_tx_vring_sta(struct wil6210_priv *wil,
  *    in all cases override dest address to unicast peer's address
  * Use old strategy when new is not supported yet:
  *  - for PBSS
- *  - for secure link
  */
 static struct vring *wil_find_tx_bcast_1(struct wil6210_priv *wil,
 					 struct sk_buff *skb)
@@ -931,6 +938,9 @@ static struct vring *wil_find_tx_bcast_1(struct wil6210_priv *wil,
 	v = &wil->vring_tx[i];
 	if (!v->va)
 		return NULL;
+	if (!wil->vring_tx_data[i].dot1x_open &&
+	    (skb->protocol != cpu_to_be16(ETH_P_PAE)))
+		return NULL;
 
 	return v;
 }
@@ -963,7 +973,8 @@ static struct vring *wil_find_tx_bcast_2(struct wil6210_priv *wil,
 		cid = wil->vring2cid_tid[i][0];
 		if (cid >= WIL6210_MAX_CID) /* skip BCAST */
 			continue;
-		if (!wil->sta[cid].data_port_open)
+		if (!wil->vring_tx_data[i].dot1x_open &&
+		    (skb->protocol != cpu_to_be16(ETH_P_PAE)))
 			continue;
 
 		/* don't Tx back to source when re-routing Rx->Tx at the AP */
@@ -989,7 +1000,8 @@ found:
 		cid = wil->vring2cid_tid[i][0];
 		if (cid >= WIL6210_MAX_CID) /* skip BCAST */
 			continue;
-		if (!wil->sta[cid].data_port_open)
+		if (!wil->vring_tx_data[i].dot1x_open &&
+		    (skb->protocol != cpu_to_be16(ETH_P_PAE)))
 			continue;
 
 		if (0 == memcmp(wil->sta[cid].addr, src, ETH_ALEN))
@@ -1016,9 +1028,6 @@ static struct vring *wil_find_tx_bcast(struct wil6210_priv *wil,
 	if (wdev->iftype != NL80211_IFTYPE_AP)
 		return wil_find_tx_bcast_2(wil, skb);
 
-	if (wil->privacy)
-		return wil_find_tx_bcast_2(wil, skb);
-
 	return wil_find_tx_bcast_1(wil, skb);
 }
 
@@ -1144,13 +1153,8 @@ static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	wil_tx_desc_map(d, pa, len, vring_index);
 	if (unlikely(mcast)) {
 		d->mac.d[0] |= BIT(MAC_CFG_DESC_TX_0_MCS_EN_POS); /* MCS 0 */
-		if (unlikely(len > WIL_BCAST_MCS0_LIMIT)) {
-			/* set MCS 1 */
+		if (unlikely(len > WIL_BCAST_MCS0_LIMIT)) /* set MCS 1 */
 			d->mac.d[0] |= (1 << MAC_CFG_DESC_TX_0_MCS_INDEX_POS);
-			/* packet mode 2 */
-			d->mac.d[1] |= BIT(MAC_CFG_DESC_TX_1_PKT_MODE_EN_POS) |
-				       (2 << MAC_CFG_DESC_TX_1_PKT_MODE_POS);
-		}
 	}
 	/* Process TCP/UDP checksum offloading */
 	if (unlikely(wil_tx_desc_offload_cksum_set(wil, d, skb))) {
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 9d74bd8..f3513a1 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -398,6 +398,7 @@ struct vring {
  * Additional data for Tx Vring
  */
 struct vring_tx_data {
+	bool dot1x_open;
 	int enabled;
 	cycles_t idle, last_idle, begin;
 	u8 agg_wsize; /* agreed aggregation window, 0 - no agg */
@@ -486,7 +487,6 @@ struct wil_sta_info {
 	u8 addr[ETH_ALEN];
 	enum wil_sta_status status;
 	struct wil_net_stats stats;
-	bool data_port_open; /* can send any data, not only EAPOL */
 	/* Rx BACK */
 	struct wil_tid_ampdu_rx *tid_rx[WIL_STA_TID_NUM];
 	spinlock_t tid_rx_lock; /* guarding tid_rx array */
@@ -716,9 +716,10 @@ int wmi_get_ssid(struct wil6210_priv *wil, u8 *ssid_len, void *ssid);
 int wmi_set_channel(struct wil6210_priv *wil, int channel);
 int wmi_get_channel(struct wil6210_priv *wil, int *channel);
 int wmi_del_cipher_key(struct wil6210_priv *wil, u8 key_index,
-		       const void *mac_addr);
+		       const void *mac_addr, int key_usage);
 int wmi_add_cipher_key(struct wil6210_priv *wil, u8 key_index,
-		       const void *mac_addr, int key_len, const void *key);
+		       const void *mac_addr, int key_len, const void *key,
+		       int key_usage);
 int wmi_echo(struct wil6210_priv *wil);
 int wmi_set_ie(struct wil6210_priv *wil, u8 type, u16 ie_len, const void *ie);
 int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 04fad5f..3dc8daf 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2014 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2015 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -543,55 +543,22 @@ static void wmi_evt_eapol_rx(struct wil6210_priv *wil, int id,
 	}
 }
 
-static void wil_addba_tx_cid(struct wil6210_priv *wil, u8 cid, u16 wsize)
+static void wmi_evt_vring_en(struct wil6210_priv *wil, int id, void *d, int len)
 {
-	struct vring_tx_data *t;
-	int i;
+	struct wmi_vring_en_event *evt = d;
+	u8 vri = evt->vring_index;
 
-	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
-		if (cid != wil->vring2cid_tid[i][0])
-			continue;
-		t = &wil->vring_tx_data[i];
-		if (!t->enabled)
-			continue;
+	wil_dbg_wmi(wil, "Enable vring %d\n", vri);
 
-		wil_addba_tx_request(wil, i, wsize);
-	}
-}
-
-static void wmi_evt_linkup(struct wil6210_priv *wil, int id, void *d, int len)
-{
-	struct wmi_data_port_open_event *evt = d;
-	u8 cid = evt->cid;
-
-	wil_dbg_wmi(wil, "Link UP for CID %d\n", cid);
-
-	if (cid >= ARRAY_SIZE(wil->sta)) {
-		wil_err(wil, "Link UP for invalid CID %d\n", cid);
+	if (vri >= ARRAY_SIZE(wil->vring_tx)) {
+		wil_err(wil, "Enable for invalid vring %d\n", vri);
 		return;
 	}
-
-	wil->sta[cid].data_port_open = true;
-	if (agg_wsize >= 0)
-		wil_addba_tx_cid(wil, cid, agg_wsize);
-}
-
-static void wmi_evt_linkdown(struct wil6210_priv *wil, int id, void *d, int len)
-{
-	struct net_device *ndev = wil_to_ndev(wil);
-	struct wmi_wbe_link_down_event *evt = d;
-	u8 cid = evt->cid;
-
-	wil_dbg_wmi(wil, "Link DOWN for CID %d, reason %d\n",
-		    cid, le32_to_cpu(evt->reason));
-
-	if (cid >= ARRAY_SIZE(wil->sta)) {
-		wil_err(wil, "Link DOWN for invalid CID %d\n", cid);
+	wil->vring_tx_data[vri].dot1x_open = true;
+	if (vri == wil->bcast_vring) /* no BA for bcast */
 		return;
-	}
-
-	wil->sta[cid].data_port_open = false;
-	netif_carrier_off(ndev);
+	if (agg_wsize >= 0)
+		wil_addba_tx_request(wil, vri, agg_wsize);
 }
 
 static void wmi_evt_ba_status(struct wil6210_priv *wil, int id, void *d,
@@ -695,11 +662,10 @@ static const struct {
 	{WMI_CONNECT_EVENTID,		wmi_evt_connect},
 	{WMI_DISCONNECT_EVENTID,	wmi_evt_disconnect},
 	{WMI_EAPOL_RX_EVENTID,		wmi_evt_eapol_rx},
-	{WMI_DATA_PORT_OPEN_EVENTID,	wmi_evt_linkup},
-	{WMI_WBE_LINKDOWN_EVENTID,	wmi_evt_linkdown},
 	{WMI_BA_STATUS_EVENTID,		wmi_evt_ba_status},
 	{WMI_RCP_ADDBA_REQ_EVENTID,	wmi_evt_addba_rx_req},
 	{WMI_DELBA_EVENTID,		wmi_evt_delba},
+	{WMI_VRING_EN_EVENTID,		wmi_evt_vring_en},
 };
 
 /*
@@ -985,7 +951,7 @@ int wmi_p2p_cfg(struct wil6210_priv *wil, int channel)
 }
 
 int wmi_del_cipher_key(struct wil6210_priv *wil, u8 key_index,
-		       const void *mac_addr)
+		       const void *mac_addr, int key_usage)
 {
 	struct wmi_delete_cipher_key_cmd cmd = {
 		.key_index = key_index,
@@ -998,11 +964,12 @@ int wmi_del_cipher_key(struct wil6210_priv *wil, u8 key_index,
 }
 
 int wmi_add_cipher_key(struct wil6210_priv *wil, u8 key_index,
-		       const void *mac_addr, int key_len, const void *key)
+		       const void *mac_addr, int key_len, const void *key,
+		       int key_usage)
 {
 	struct wmi_add_cipher_key_cmd cmd = {
 		.key_index = key_index,
-		.key_usage = WMI_KEY_USE_PAIRWISE,
+		.key_usage = key_usage,
 		.key_len = key_len,
 	};
 
@@ -1238,7 +1205,8 @@ int wmi_addba_rx_resp(struct wil6210_priv *wil, u8 cid, u8 tid, u8 token,
 		    cid, tid, agg_wsize, timeout, status, amsdu ? "+" : "-");
 
 	rc = wmi_call(wil, WMI_RCP_ADDBA_RESP_CMDID, &cmd, sizeof(cmd),
-		      WMI_ADDBA_RESP_SENT_EVENTID, &reply, sizeof(reply), 100);
+		      WMI_RCP_ADDBA_RESP_SENT_EVENTID, &reply, sizeof(reply),
+		      100);
 	if (rc)
 		return rc;
 
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index 24c253d..cc04ab7 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2014 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2015 Qualcomm Atheros, Inc.
  * Copyright (c) 2006-2012 Wilocity .
  *
  * Permission to use, copy, modify, and/or distribute this software for any
@@ -253,8 +253,8 @@ struct wmi_set_passphrase_cmd {
  */
 enum wmi_key_usage {
 	WMI_KEY_USE_PAIRWISE	= 0,
-	WMI_KEY_USE_GROUP	= 1,
-	WMI_KEY_USE_TX		= 2,  /* default Tx Key - Static WEP only */
+	WMI_KEY_USE_RX_GROUP	= 1,
+	WMI_KEY_USE_TX_GROUP	= 2,
 };
 
 struct wmi_add_cipher_key_cmd {
@@ -885,7 +885,7 @@ enum wmi_event_id {
 	WMI_VRING_CFG_DONE_EVENTID		= 0x1821,
 	WMI_BA_STATUS_EVENTID			= 0x1823,
 	WMI_RCP_ADDBA_REQ_EVENTID		= 0x1824,
-	WMI_ADDBA_RESP_SENT_EVENTID		= 0x1825,
+	WMI_RCP_ADDBA_RESP_SENT_EVENTID		= 0x1825,
 	WMI_DELBA_EVENTID			= 0x1826,
 	WMI_GET_SSID_EVENTID			= 0x1828,
 	WMI_GET_PCP_CHANNEL_EVENTID		= 0x182a,
@@ -897,7 +897,7 @@ enum wmi_event_id {
 	WMI_WRITE_MAC_TXQ_EVENTID		= 0x1833,
 	WMI_WRITE_MAC_XQ_FIELD_EVENTID		= 0x1834,
 
-	WMI_BEAFORMING_MGMT_DONE_EVENTID	= 0x1836,
+	WMI_BEAMFORMING_MGMT_DONE_EVENTID	= 0x1836,
 	WMI_BF_TXSS_MGMT_DONE_EVENTID		= 0x1837,
 	WMI_BF_RXSS_MGMT_DONE_EVENTID		= 0x1839,
 	WMI_RS_MGMT_DONE_EVENTID		= 0x1852,
@@ -909,11 +909,12 @@ enum wmi_event_id {
 
 	/* Performance monitoring events */
 	WMI_DATA_PORT_OPEN_EVENTID		= 0x1860,
-	WMI_WBE_LINKDOWN_EVENTID		= 0x1861,
+	WMI_WBE_LINK_DOWN_EVENTID		= 0x1861,
 
 	WMI_BF_CTRL_DONE_EVENTID		= 0x1862,
 	WMI_NOTIFY_REQ_DONE_EVENTID		= 0x1863,
 	WMI_GET_STATUS_DONE_EVENTID		= 0x1864,
+	WMI_VRING_EN_EVENTID			= 0x1865,
 
 	WMI_UNIT_TEST_EVENTID			= 0x1900,
 	WMI_FLASH_READ_DONE_EVENTID		= 0x1902,
@@ -1162,7 +1163,7 @@ struct wmi_vring_cfg_done_event {
 } __packed;
 
 /*
- * WMI_ADDBA_RESP_SENT_EVENTID
+ * WMI_RCP_ADDBA_RESP_SENT_EVENTID
  */
 struct wmi_rcp_addba_resp_sent_event {
 	u8 cidxtid;
@@ -1194,7 +1195,7 @@ struct wmi_cfg_rx_chain_done_event {
 } __packed;
 
 /*
- * WMI_WBE_LINKDOWN_EVENTID
+ * WMI_WBE_LINK_DOWN_EVENTID
  */
 enum wmi_wbe_link_down_event_reason {
 	WMI_WBE_REASON_USER_REQUEST	= 0,
@@ -1217,6 +1218,14 @@ struct wmi_data_port_open_event {
 } __packed;
 
 /*
+ * WMI_VRING_EN_EVENTID
+ */
+struct wmi_vring_en_event {
+	u8 vring_index;
+	u8 reserved[3];
+} __packed;
+
+/*
  * WMI_GET_PCP_CHANNEL_EVENTID
  */
 struct wmi_get_pcp_channel_event {
-- 
2.1.0

