Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:56115 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935531AbeEIVl4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 17:41:56 -0400
Subject: [PATCH v2 1/3] wireless-drivers: Dynamically allocate struct
 station_info
From: Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org
Date: Wed, 09 May 2018 23:41:53 +0200
Message-ID: <152590211357.13924.18408619969539206421.stgit@alrua-kau> (sfid-20180509_234203_013546_ECD24203)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the addition of the TXQ stats to cfg80211, the station_info struct
has grown to be quite large, which results in warnings when allocated on
the stack. Fix the affected places to do dynamic allocations instead.

Fixes: 52539ca89f36 ("cfg80211: Expose TXQ stats and parameters to userspace")
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 drivers/net/wireless/ath/ath6kl/main.c             |   14 ++++++----
 drivers/net/wireless/ath/wil6210/debugfs.c         |   22 ++++++++++-----
 drivers/net/wireless/ath/wil6210/wmi.c             |   19 ++++++++-----
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   18 ++++++++----
 drivers/net/wireless/marvell/mwifiex/uap_event.c   |   25 +++++++++++------
 drivers/net/wireless/quantenna/qtnfmac/event.c     |   29 +++++++++++++-------
 6 files changed, 82 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index db95f85751e3..808fb30be9ad 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -426,7 +426,7 @@ void ath6kl_connect_ap_mode_sta(struct ath6kl_vif *vif, u16 aid, u8 *mac_addr,
 {
 	u8 *ies = NULL, *wpa_ie = NULL, *pos;
 	size_t ies_len = 0;
-	struct station_info sinfo;
+	struct station_info *sinfo;
 
 	ath6kl_dbg(ATH6KL_DBG_TRC, "new station %pM aid=%d\n", mac_addr, aid);
 
@@ -482,16 +482,20 @@ void ath6kl_connect_ap_mode_sta(struct ath6kl_vif *vif, u16 aid, u8 *mac_addr,
 			   keymgmt, ucipher, auth, apsd_info);
 
 	/* send event to application */
-	memset(&sinfo, 0, sizeof(sinfo));
+	sinfo = kzalloc(sizeof(*sinfo), GFP_KERNEL);
+	if (!sinfo)
+		return;
 
 	/* TODO: sinfo.generation */
 
-	sinfo.assoc_req_ies = ies;
-	sinfo.assoc_req_ies_len = ies_len;
+	sinfo->assoc_req_ies = ies;
+	sinfo->assoc_req_ies_len = ies_len;
 
-	cfg80211_new_sta(vif->ndev, mac_addr, &sinfo, GFP_KERNEL);
+	cfg80211_new_sta(vif->ndev, mac_addr, sinfo, GFP_KERNEL);
 
 	netif_wake_queue(vif->ndev);
+
+	kfree(sinfo);
 }
 
 void disconnect_timer_handler(struct timer_list *t)
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 8c90b3111f0b..11e46e44381e 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1200,8 +1200,12 @@ static const struct file_operations fops_freq = {
 static int wil_link_debugfs_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
-	struct station_info sinfo;
-	int i, rc;
+	struct station_info *sinfo;
+	int i, rc = 0;
+
+	sinfo = kzalloc(sizeof(*sinfo), GFP_KERNEL);
+	if (!sinfo)
+		return -ENOMEM;
 
 	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
 		struct wil_sta_info *p = &wil->sta[i];
@@ -1229,19 +1233,21 @@ static int wil_link_debugfs_show(struct seq_file *s, void *data)
 
 		vif = (mid < wil->max_vifs) ? wil->vifs[mid] : NULL;
 		if (vif) {
-			rc = wil_cid_fill_sinfo(vif, i, &sinfo);
+			rc = wil_cid_fill_sinfo(vif, i, sinfo);
 			if (rc)
-				return rc;
+				goto out;
 
-			seq_printf(s, "  Tx_mcs = %d\n", sinfo.txrate.mcs);
-			seq_printf(s, "  Rx_mcs = %d\n", sinfo.rxrate.mcs);
-			seq_printf(s, "  SQ     = %d\n", sinfo.signal);
+			seq_printf(s, "  Tx_mcs = %d\n", sinfo->txrate.mcs);
+			seq_printf(s, "  Rx_mcs = %d\n", sinfo->rxrate.mcs);
+			seq_printf(s, "  SQ     = %d\n", sinfo->signal);
 		} else {
 			seq_puts(s, "  INVALID MID\n");
 		}
 	}
 
-	return 0;
+out:
+	kfree(sinfo);
+	return rc;
 }
 
 static int wil_link_seq_open(struct inode *inode, struct file *file)
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index a3dda9a97c1f..21124af06bdd 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -824,7 +824,7 @@ static void wmi_evt_connect(struct wil6210_vif *vif, int id, void *d, int len)
 	struct wireless_dev *wdev = vif_to_wdev(vif);
 	struct wmi_connect_event *evt = d;
 	int ch; /* channel number */
-	struct station_info sinfo;
+	struct station_info *sinfo;
 	u8 *assoc_req_ie, *assoc_resp_ie;
 	size_t assoc_req_ielen, assoc_resp_ielen;
 	/* capinfo(u16) + listen_interval(u16) + IEs */
@@ -940,6 +940,11 @@ static void wmi_evt_connect(struct wil6210_vif *vif, int id, void *d, int len)
 		vif->bss = NULL;
 	} else if ((wdev->iftype == NL80211_IFTYPE_AP) ||
 		   (wdev->iftype == NL80211_IFTYPE_P2P_GO)) {
+
+		sinfo = kzalloc(sizeof(*sinfo), GFP_KERNEL);
+		if (!sinfo)
+			rc = -ENOMEM;
+
 		if (rc) {
 			if (disable_ap_sme)
 				/* notify new_sta has failed */
@@ -947,16 +952,16 @@ static void wmi_evt_connect(struct wil6210_vif *vif, int id, void *d, int len)
 			goto out;
 		}
 
-		memset(&sinfo, 0, sizeof(sinfo));
-
-		sinfo.generation = wil->sinfo_gen++;
+		sinfo->generation = wil->sinfo_gen++;
 
 		if (assoc_req_ie) {
-			sinfo.assoc_req_ies = assoc_req_ie;
-			sinfo.assoc_req_ies_len = assoc_req_ielen;
+			sinfo->assoc_req_ies = assoc_req_ie;
+			sinfo->assoc_req_ies_len = assoc_req_ielen;
 		}
 
-		cfg80211_new_sta(ndev, evt->bssid, &sinfo, GFP_KERNEL);
+		cfg80211_new_sta(ndev, evt->bssid, sinfo, GFP_KERNEL);
+
+		kfree(sinfo);
 	} else {
 		wil_err(wil, "unhandled iftype %d for CID %d\n", wdev->iftype,
 			evt->cid);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 89b86251910e..f29f9ef521ab 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5498,7 +5498,7 @@ brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
 	static int generation;
 	u32 event = e->event_code;
 	u32 reason = e->reason;
-	struct station_info sinfo;
+	struct station_info *sinfo;
 
 	brcmf_dbg(CONN, "event %s (%u), reason %d\n",
 		  brcmf_fweh_event_name(event), event, reason);
@@ -5511,16 +5511,22 @@ brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
 
 	if (((event == BRCMF_E_ASSOC_IND) || (event == BRCMF_E_REASSOC_IND)) &&
 	    (reason == BRCMF_E_STATUS_SUCCESS)) {
-		memset(&sinfo, 0, sizeof(sinfo));
 		if (!data) {
 			brcmf_err("No IEs present in ASSOC/REASSOC_IND");
 			return -EINVAL;
 		}
-		sinfo.assoc_req_ies = data;
-		sinfo.assoc_req_ies_len = e->datalen;
+
+		sinfo = kzalloc(sizeof(*sinfo), GFP_KERNEL);
+		if (!sinfo)
+			return -ENOMEM;
+
+		sinfo->assoc_req_ies = data;
+		sinfo->assoc_req_ies_len = e->datalen;
 		generation++;
-		sinfo.generation = generation;
-		cfg80211_new_sta(ndev, e->addr, &sinfo, GFP_KERNEL);
+		sinfo->generation = generation;
+		cfg80211_new_sta(ndev, e->addr, sinfo, GFP_KERNEL);
+
+		kfree(sinfo);
 	} else if ((event == BRCMF_E_DISASSOC_IND) ||
 		   (event == BRCMF_E_DEAUTH_IND) ||
 		   (event == BRCMF_E_DEAUTH)) {
diff --git a/drivers/net/wireless/marvell/mwifiex/uap_event.c b/drivers/net/wireless/marvell/mwifiex/uap_event.c
index e8c8728db15a..e86217a6b9ca 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_event.c
@@ -108,7 +108,7 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 	struct mwifiex_adapter *adapter = priv->adapter;
 	int len, i;
 	u32 eventcause = adapter->event_cause;
-	struct station_info sinfo;
+	struct station_info *sinfo;
 	struct mwifiex_assoc_event *event;
 	struct mwifiex_sta_node *node;
 	u8 *deauth_mac;
@@ -117,7 +117,10 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 
 	switch (eventcause) {
 	case EVENT_UAP_STA_ASSOC:
-		memset(&sinfo, 0, sizeof(sinfo));
+		sinfo = kzalloc(sizeof(*sinfo), GFP_KERNEL);
+		if (!sinfo)
+			return -ENOMEM;
+
 		event = (struct mwifiex_assoc_event *)
 			(adapter->event_body + MWIFIEX_UAP_EVENT_EXTRA_HEADER);
 		if (le16_to_cpu(event->type) == TLV_TYPE_UAP_MGMT_FRAME) {
@@ -132,28 +135,31 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 				len = ETH_ALEN;
 
 			if (len != -1) {
-				sinfo.assoc_req_ies = &event->data[len];
-				len = (u8 *)sinfo.assoc_req_ies -
+				sinfo->assoc_req_ies = &event->data[len];
+				len = (u8 *)sinfo->assoc_req_ies -
 				      (u8 *)&event->frame_control;
-				sinfo.assoc_req_ies_len =
+				sinfo->assoc_req_ies_len =
 					le16_to_cpu(event->len) - (u16)len;
 			}
 		}
-		cfg80211_new_sta(priv->netdev, event->sta_addr, &sinfo,
+		cfg80211_new_sta(priv->netdev, event->sta_addr, sinfo,
 				 GFP_KERNEL);
 
 		node = mwifiex_add_sta_entry(priv, event->sta_addr);
 		if (!node) {
 			mwifiex_dbg(adapter, ERROR,
 				    "could not create station entry!\n");
+			kfree(sinfo);
 			return -1;
 		}
 
-		if (!priv->ap_11n_enabled)
+		if (!priv->ap_11n_enabled) {
+			kfree(sinfo);
 			break;
+		}
 
-		mwifiex_set_sta_ht_cap(priv, sinfo.assoc_req_ies,
-				       sinfo.assoc_req_ies_len, node);
+		mwifiex_set_sta_ht_cap(priv, sinfo->assoc_req_ies,
+				       sinfo->assoc_req_ies_len, node);
 
 		for (i = 0; i < MAX_NUM_TID; i++) {
 			if (node->is_11n_enabled)
@@ -163,6 +169,7 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 				node->ampdu_sta[i] = BA_STREAM_NOT_ALLOWED;
 		}
 		memset(node->rx_seq, 0xff, sizeof(node->rx_seq));
+		kfree(sinfo);
 		break;
 	case EVENT_UAP_STA_DEAUTH:
 		deauth_mac = adapter->event_body +
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index bcd415f96412..e9231bd498f7 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -34,12 +34,13 @@ qtnf_event_handle_sta_assoc(struct qtnf_wmac *mac, struct qtnf_vif *vif,
 {
 	const u8 *sta_addr;
 	u16 frame_control;
-	struct station_info sinfo = { 0 };
+	struct station_info *sinfo;
 	size_t payload_len;
 	u16 tlv_type;
 	u16 tlv_value_len;
 	size_t tlv_full_len;
 	const struct qlink_tlv_hdr *tlv;
+	int ret = 0;
 
 	if (unlikely(len < sizeof(*sta_assoc))) {
 		pr_err("VIF%u.%u: payload is too short (%u < %zu)\n",
@@ -53,6 +54,10 @@ qtnf_event_handle_sta_assoc(struct qtnf_wmac *mac, struct qtnf_vif *vif,
 		return -EPROTO;
 	}
 
+	sinfo = kzalloc(sizeof(*sinfo), GFP_KERNEL);
+	if (!sinfo)
+		return -ENOMEM;
+
 	sta_addr = sta_assoc->sta_addr;
 	frame_control = le16_to_cpu(sta_assoc->frame_control);
 
@@ -61,9 +66,9 @@ qtnf_event_handle_sta_assoc(struct qtnf_wmac *mac, struct qtnf_vif *vif,
 
 	qtnf_sta_list_add(vif, sta_addr);
 
-	sinfo.assoc_req_ies = NULL;
-	sinfo.assoc_req_ies_len = 0;
-	sinfo.generation = vif->generation;
+	sinfo->assoc_req_ies = NULL;
+	sinfo->assoc_req_ies_len = 0;
+	sinfo->generation = vif->generation;
 
 	payload_len = len - sizeof(*sta_assoc);
 	tlv = (const struct qlink_tlv_hdr *)sta_assoc->ies;
@@ -88,8 +93,8 @@ qtnf_event_handle_sta_assoc(struct qtnf_wmac *mac, struct qtnf_vif *vif,
 				(sizeof(*ie_set) - sizeof(ie_set->hdr));
 
 			if (ie_set->type == QLINK_IE_SET_ASSOC_REQ && ie_len) {
-				sinfo.assoc_req_ies = ie_set->ie_data;
-				sinfo.assoc_req_ies_len = ie_len;
+				sinfo->assoc_req_ies = ie_set->ie_data;
+				sinfo->assoc_req_ies_len = ie_len;
 			}
 		}
 
@@ -97,13 +102,17 @@ qtnf_event_handle_sta_assoc(struct qtnf_wmac *mac, struct qtnf_vif *vif,
 		tlv = (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
 	}
 
-	if (payload_len)
-		return -EINVAL;
+	if (payload_len) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	cfg80211_new_sta(vif->netdev, sta_assoc->sta_addr, &sinfo,
+	cfg80211_new_sta(vif->netdev, sta_assoc->sta_addr, sinfo,
 			 GFP_KERNEL);
 
-	return 0;
+out:
+	kfree(sinfo);
+	return ret;
 }
 
 static int
