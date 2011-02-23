Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:48894 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab1BWXkB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 18:40:01 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: remove unused/unnecessary ret variables and usage of goto
Date: Wed, 23 Feb 2011 15:42:31 -0800
Message-Id: <1298504551-19205-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

ret variable is unused or unnecessary in some functions. Also,
use of goto can be avoided at a few places by returning from
the function there itself.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           |   17 +-
 drivers/net/wireless/mwifiex/11n_aggr.c      |   11 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   11 +-
 drivers/net/wireless/mwifiex/cfg80211.c      |  119 +++-----
 drivers/net/wireless/mwifiex/cmdevt.c        |   96 ++----
 drivers/net/wireless/mwifiex/debugfs.c       |   38 +--
 drivers/net/wireless/mwifiex/init.c          |   26 +-
 drivers/net/wireless/mwifiex/join.c          |   83 ++----
 drivers/net/wireless/mwifiex/main.c          |   51 ++--
 drivers/net/wireless/mwifiex/scan.c          |   49 +--
 drivers/net/wireless/mwifiex/sdio.c          |  107 +++-----
 drivers/net/wireless/mwifiex/sta_cmd.c       |   77 ++---
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |    9 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c     |  422 +++++++++-----------------
 drivers/net/wireless/mwifiex/sta_rx.c        |    8 +-
 drivers/net/wireless/mwifiex/sta_tx.c        |   30 +--
 drivers/net/wireless/mwifiex/txrx.c          |   20 +-
 drivers/net/wireless/mwifiex/util.c          |    9 +-
 drivers/net/wireless/mwifiex/wmm.c           |    4 +-
 19 files changed, 404 insertions(+), 783 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 525ace6..c93a5c3 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -32,14 +32,13 @@
 int mwifiex_set_get_11n_htcap_cfg(struct mwifiex_private *priv, u16 action,
 				  int *htcap_cfg)
 {
-	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
 	if (action == HostCmd_ACT_GEN_SET) {
 		if (((*htcap_cfg & ~IGN_HW_DEV_CAP) &
 		     adapter->hw_dot_11n_dev_cap)
 		    != (*htcap_cfg & ~IGN_HW_DEV_CAP))
-			ret = -EFAULT;
+			return -EFAULT;
 		else
 			adapter->usr_dot_11n_dev_cap = *htcap_cfg;
 		PRINTM(MINFO, "UsrDot11nCap 0x%x\n",
@@ -49,7 +48,7 @@ int mwifiex_set_get_11n_htcap_cfg(struct mwifiex_private *priv, u16 action,
 		PRINTM(MINFO, "UsrDot11nCap 0x%x\n", *htcap_cfg);
 	}
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -110,7 +109,6 @@ int mwifiex_11n_ioctl_addba_param(struct mwifiex_adapter *adapter,
 				  struct mwifiex_ds_11n_addba_param
 				  *addba_param, u16 action)
 {
-	int ret = 0;
 	struct mwifiex_private *priv = adapter->priv[wait_queue->bss_index];
 	u32 timeout;
 
@@ -132,7 +130,7 @@ int mwifiex_11n_ioctl_addba_param(struct mwifiex_adapter *adapter,
 
 	}
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -697,7 +695,7 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 	int ret_len = 0;
 
 	if (!buffer || !*buffer)
-		goto exit;
+		return ret_len;
 
 	if (bss_desc->bcn_ht_cap) {
 		ht_cap = (struct mwifiex_ie_types_htcap *) *buffer;
@@ -812,7 +810,6 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 		ret_len += sizeof(struct mwifiex_ie_types_extcap);
 	}
 
-exit:
 	return ret_len;
 }
 
@@ -888,7 +885,7 @@ mwifiex_11n_delete_tx_ba_stream_tbl_entry(struct mwifiex_private *priv,
 {
 	if (!tx_ba_tsr_tbl &&
 			mwifiex_is_tx_ba_stream_ptr_valid(priv, tx_ba_tsr_tbl))
-		goto exit;
+		return;
 
 	PRINTM(MINFO, "tx_ba_stream_tbl_ptr %p\n", tx_ba_tsr_tbl);
 
@@ -896,7 +893,6 @@ mwifiex_11n_delete_tx_ba_stream_tbl_entry(struct mwifiex_private *priv,
 
 	kfree(tx_ba_tsr_tbl);
 
-exit:
 	return;
 }
 
@@ -996,7 +992,7 @@ mwifiex_11n_create_tx_ba_stream_tbl(struct mwifiex_private *priv,
 		if (!new_node) {
 			PRINTM(MERROR, "%s: failed to alloc new_node\n",
 			       __func__);
-			goto exit;
+			return;
 		}
 
 		INIT_LIST_HEAD(&new_node->list);
@@ -1010,7 +1006,6 @@ mwifiex_11n_create_tx_ba_stream_tbl(struct mwifiex_private *priv,
 		spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 	}
 
-exit:
 	return;
 }
 
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 2312db6..33e8e46 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -204,7 +204,7 @@ int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 	if (total_pkt_len > MWIFIEX_RX_DATA_BUF_SIZE) {
 		PRINTM(MERROR, "Total packet length greater than tx buffer"
 		       " size %d\n", total_pkt_len);
-		goto done;
+		return -1;
 	}
 
 	rx_info->use_count = mwifiex_11n_get_num_aggr_pkts(data, total_pkt_len);
@@ -241,8 +241,7 @@ int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 		if (!skb_daggr) {
 			PRINTM(MERROR, "%s: failed to alloc mbuf_daggr\n",
 			       __func__);
-			ret = -1;
-			goto done;
+			return -1;
 		}
 		rx_info_daggr = MWIFIEX_SKB_RXCB(skb_daggr);
 
@@ -270,7 +269,6 @@ int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 		data += pkt_len + pad;
 	}
 
-done:
 	return ret;
 }
 
@@ -309,7 +307,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	if (skb_queue_empty(&pra_list->skb_head)) {
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
-		goto exit;
+		return 0;
 	}
 	skb_src = skb_peek(&pra_list->skb_head);
 	tx_info_src = MWIFIEX_SKB_TXCB(skb_src);
@@ -408,7 +406,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		       ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		mwifiex_write_data_complete(adapter, skb_aggr, ret);
-		goto exit;
+		return 0;
 	case -EINPROGRESS:
 		adapter->data_sent = false;
 		break;
@@ -434,6 +432,5 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 				       ra_list_flags);
 	}
 
-exit:
 	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 9ac9a2c..7465598 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -54,7 +54,6 @@ mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
 					 *rx_reor_tbl_ptr, int start_win)
 {
 	int no_pkt_to_send, i, xchg;
-	int ret = 0;
 	void *rx_tmp_ptr = NULL;
 	unsigned long flags;
 
@@ -89,7 +88,7 @@ mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
 	rx_reor_tbl_ptr->start_win = start_win;
 	spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -105,7 +104,6 @@ mwifiex_11n_scan_and_dispatch(struct mwifiex_private *priv,
 			      struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr)
 {
 	int i, j, xchg;
-	int ret = 0;
 	void *rx_tmp_ptr = NULL;
 	unsigned long flags;
 
@@ -137,7 +135,7 @@ mwifiex_11n_scan_and_dispatch(struct mwifiex_private *priv,
 	rx_reor_tbl_ptr->start_win = (rx_reor_tbl_ptr->start_win + i)
 		&(MAX_TID_VALUE - 1);
 	spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
-	return ret;
+	return 0;
 }
 
 /*
@@ -277,7 +275,7 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 		if (!new_node) {
 			PRINTM(MERROR, "%s: failed to alloc new_node\n",
 			       __func__);
-			goto exit;
+			return;
 		}
 
 		INIT_LIST_HEAD(&new_node->list);
@@ -305,7 +303,7 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 			kfree((u8 *) new_node);
 			PRINTM(MERROR, "%s: failed to alloc reorder_ptr\n",
 			       __func__);
-			goto exit;
+			return;
 		}
 
 		PRINTM(MDAT_D, "Create ReorderPtr: %p\n", new_node);
@@ -326,7 +324,6 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 		spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 	}
 
-exit:
 	return;
 }
 
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index d785e5e..995975b 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -423,10 +423,8 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 		status = mwifiex_radio_ioctl_band_cfg(priv, HostCmd_ACT_GEN_SET,
 						      &band_cfg);
 
-		if (status) {
-			ret = -EFAULT;
-			goto done;
-		}
+		if (status)
+			return -EFAULT;
 		mwifiex_send_domain_info_cmd_fw(wiphy);
 	}
 
@@ -441,15 +439,12 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 
 		status = mwifiex_bss_ioctl_channel(priv, HostCmd_ACT_GEN_SET,
 						   &cfp);
-		if (status) {
-			ret = -EFAULT;
-			goto done;
-		}
+		if (status)
+			return -EFAULT;
 
 		ret = mwifiex_drv_change_adhoc_chan(priv, cfp.channel);
 	}
 
-done:
 	return ret;
 }
 
@@ -494,26 +489,19 @@ mwifiex_set_frag(struct mwifiex_private *priv, u32 frag_thr)
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
 	if (frag_thr < MWIFIEX_FRAG_MIN_VALUE
-	    || frag_thr > MWIFIEX_FRAG_MAX_VALUE) {
-		ret = -EINVAL;
-		goto done;
-	}
+	    || frag_thr > MWIFIEX_FRAG_MAX_VALUE)
+		return -EINVAL;
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	status = mwifiex_snmp_mib_ioctl(priv, wait, FRAG_THRESH_I,
 					HostCmd_ACT_GEN_SET, &frag_thr);
 
-	if (mwifiex_request_ioctl(priv, wait, status, wait_option)) {
+	if (mwifiex_request_ioctl(priv, wait, status, wait_option))
 		ret = -EFAULT;
-		goto done;
-	}
 
-done:
 	kfree(wait);
 	return ret;
 }
@@ -536,19 +524,15 @@ mwifiex_set_rts(struct mwifiex_private *priv, u32 rts_thr)
 		rts_thr = MWIFIEX_RTS_MAX_VALUE;
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	status = mwifiex_snmp_mib_ioctl(priv, wait, RTS_THRESH_I,
 					HostCmd_ACT_GEN_SET, &rts_thr);
 
-	if (mwifiex_request_ioctl(priv, wait, status, wait_option)) {
+	if (mwifiex_request_ioctl(priv, wait, status, wait_option))
 		ret = -EFAULT;
-		goto done;
-	}
-done:
+
 	kfree(wait);
 	return ret;
 }
@@ -600,10 +584,8 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 	int status = 0;
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	switch (type) {
 	case NL80211_IFTYPE_ADHOC:
@@ -628,10 +610,8 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		goto done;
 	status = mwifiex_bss_ioctl_mode(priv, wait, HostCmd_ACT_GEN_SET, &mode);
 
-	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
+	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT))
 		ret = -EFAULT;
-		goto done;
-	}
 
 done:
 	kfree(wait);
@@ -922,7 +902,7 @@ static int mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
 {
 	struct mwifiex_scan_resp scan_resp;
 	struct mwifiex_bssdescriptor *scan_table;
-	int ret = 0, i, j;
+	int i, j;
 	struct ieee80211_channel *chan;
 	u8 *ie, *tmp, *ie_buf;
 	u32 ie_len;
@@ -932,17 +912,14 @@ static int mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
 	u8 element_id, element_len;
 
 	memset(&scan_resp, 0, sizeof(scan_resp));
-	if (mwifiex_get_scan_table(priv, MWIFIEX_IOCTL_WAIT, &scan_resp)) {
-		ret = -EFAULT;
-		goto done;
-	}
+	if (mwifiex_get_scan_table(priv, MWIFIEX_IOCTL_WAIT, &scan_resp))
+		return -EFAULT;
 
 #define MAX_IE_BUF	2048
 	ie_buf = kzalloc(MAX_IE_BUF, GFP_KERNEL);
 	if (!ie_buf) {
 		PRINTM(MERROR, "%s: failed to allocate ie_buf\n", __func__);
-		ret = -ENOMEM;
-		goto done;
+		return -ENOMEM;
 	}
 
 	scan_table = (struct mwifiex_bssdescriptor *) scan_resp.scan_table;
@@ -1035,9 +1012,7 @@ static int mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
 	}
 
 	kfree(ie_buf);
-
-done:
-	return ret;
+	return 0;
 }
 
 /*
@@ -1073,15 +1048,13 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	req_ssid.ssid_len = ssid_len;
 	if (ssid_len > IW_ESSID_MAX_SIZE) {
 		PRINTM(MERROR, "Invalid SSID - aborting\n");
-		ret = -EINVAL;
-		goto done;
+		return -EINVAL;
 	}
 
 	memcpy(req_ssid.ssid, ssid, ssid_len);
 	if (!req_ssid.ssid_len || req_ssid.ssid[0] < 0x20) {
 		PRINTM(MERROR, "Invalid SSID - aborting\n");
-		ret = -EINVAL;
-		goto done;
+		return -EINVAL;
 	}
 
 	/* disconnect before try to associate */
@@ -1098,7 +1071,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 
 	if (!sme && (mode != MWIFIEX_BSS_MODE_IBSS)) {
 		BUG_ON(sme == NULL);
-		goto done;
+		return ret;
 	}
 
 	ret = mwifiex_set_encode(priv, 0, NULL, 0, 0, 1);/* Disable keys */
@@ -1163,8 +1136,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	/* Do specific SSID scanning */
 	if (mwifiex_request_scan(priv, MWIFIEX_IOCTL_WAIT, &req_ssid)) {
 		PRINTM(MERROR, "Scan error\n");
-		ret = -EFAULT;
-		goto done;
+		return -EFAULT;
 	}
 
 
@@ -1172,17 +1144,13 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 
 	if (mode != MWIFIEX_BSS_MODE_IBSS) {
 		if (mwifiex_find_best_bss(priv, MWIFIEX_IOCTL_WAIT,
-					  &ssid_bssid)) {
-			ret = -EFAULT;
-			goto done;
-		}
+					  &ssid_bssid))
+			return -EFAULT;
 		/* Inform the BSS information to kernel, otherwise
 		 * kernel will give a panic after successful assoc */
 		if (mwifiex_inform_bss_from_scan_result(priv,
-					&req_ssid)) {
-			ret = -EFAULT;
-			goto done;
-		}
+					&req_ssid))
+			return -EFAULT;
 	}
 
 	PRINTM(MINFO, "Trying to associate to %s and bssid %pM\n",
@@ -1193,21 +1161,16 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	/* Connect to BSS by ESSID */
 	memset(&ssid_bssid.bssid, 0, MWIFIEX_MAC_ADDR_LENGTH);
 
-	if (mwifiex_bss_start(priv, MWIFIEX_IOCTL_WAIT, &ssid_bssid)) {
-		ret = -EFAULT;
-		goto done;
-	}
+	if (mwifiex_bss_start(priv, MWIFIEX_IOCTL_WAIT, &ssid_bssid))
+		return -EFAULT;
 
 	if (mode == MWIFIEX_BSS_MODE_IBSS) {
 		/* Inform the BSS information to kernel, otherwise
 		 * kernel will give a panic after successful assoc */
-		if (mwifiex_cfg80211_inform_ibss_bss(priv)) {
-			ret = -EFAULT;
-			goto done;
-		}
+		if (mwifiex_cfg80211_inform_ibss_bss(priv))
+			return -EFAULT;
 	}
 
-done:
 	return ret;
 }
 
@@ -1423,16 +1386,13 @@ mwifiex_register_cfg80211(struct net_device *dev, u8 *mac,
 	wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
 	if (!wdev) {
 		PRINTM(MERROR, "Error allocating wireless device\n");
-		ret = -ENOMEM;
-		goto done;
+		return -ENOMEM;
 	}
 	wdev->wiphy =
 		wiphy_new(&mwifiex_cfg80211_ops,
 			  sizeof(struct mwifiex_private *));
-	if (!wdev->wiphy) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!wdev->wiphy)
+		return -ENOMEM;
 	wdev->iftype = NL80211_IFTYPE_STATION;
 	wdev->wiphy->max_scan_ssids = 10;
 	wdev->wiphy->interface_modes =
@@ -1468,7 +1428,7 @@ mwifiex_register_cfg80211(struct net_device *dev, u8 *mac,
 	if (ret < 0) {
 		PRINTM(MERROR, "Error registering cfg80211 device\n");
 		wiphy_free(wdev->wiphy);
-		goto done;
+		return ret;
 	} else
 		PRINTM(MINFO, "Successfully registered wiphy device\n");
 
@@ -1484,7 +1444,6 @@ mwifiex_register_cfg80211(struct net_device *dev, u8 *mac,
 	dev->hard_header_len +=
 		MWIFIEX_MIN_DATA_HEADER_LEN;
 
-done:
 	return ret;
 }
 
@@ -1532,10 +1491,8 @@ mwifiex_cfg80211_results(struct work_struct *work)
 			ret = -EFAULT;
 			goto done;
 		}
-		if (mwifiex_inform_bss_from_scan_result(priv, NULL)) {
+		if (mwifiex_inform_bss_from_scan_result(priv, NULL))
 			ret = -EFAULT;
-			goto done;
-		}
 done:
 		priv->scan_result_status = ret;
 		PRINTM(MINFO, "Sending scan results\n");
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 5f7274c..ef063d1 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -163,10 +163,8 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	struct timeval tstamp;
 	unsigned long flags;
 
-	if (!adapter || !cmd_node) {
-		ret = -1;
-		goto done;
-	}
+	if (!adapter || !cmd_node)
+		return -1;
 
 	host_cmd = (struct host_cmd_ds_command *) (cmd_node->cmd_skb->data);
 	if (cmd_node->wq_buf)
@@ -180,8 +178,7 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 		if (wait_queue)
 			wait_queue->status = MWIFIEX_ERROR_CMD_DNLD_FAIL;
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
-		ret = -1;
-		goto done;
+		return -1;
 	}
 
 	/* Set command sequence number */
@@ -225,8 +222,7 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 
 		adapter->dbg.num_cmd_host_to_card_failure++;
-		ret = -1;
-		goto done;
+		return -1;
 	}
 
 	/* Save the last command id and action to debug log */
@@ -243,10 +239,7 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	mod_timer(&adapter->cmd_timer,
 		jiffies + (MWIFIEX_TIMER_10S * HZ) / 1000);
 
-	ret = 0;
-
-done:
-	return ret;
+	return 0;
 }
 
 /*
@@ -286,7 +279,7 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 	if (ret == -1) {
 		PRINTM(MERROR, "SLEEP_CFM: failed\n");
 		adapter->dbg.num_cmd_sleep_cfm_host_to_card_failure++;
-		goto done;
+		return -1;
 	} else {
 		if (GET_BSS_ROLE(mwifiex_get_priv(adapter,
 				 MWIFIEX_BSS_ROLE_ANY))
@@ -316,7 +309,6 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 			PRINTM(MEVENT, "+");
 	}
 
-done:
 	return ret;
 }
 
@@ -334,7 +326,6 @@ done:
  */
 int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter)
 {
-	int ret = 0;
 	struct cmd_ctrl_node *cmd_array;
 	u32 buf_size;
 	u32 i;
@@ -344,8 +335,7 @@ int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter)
 	cmd_array = kzalloc(buf_size, GFP_KERNEL);
 	if (!cmd_array) {
 		PRINTM(MERROR, "%s: failed to alloc cmd_array\n", __func__);
-		ret = -1;
-		goto done;
+		return -1;
 	}
 
 	adapter->cmd_pool = cmd_array;
@@ -358,16 +348,14 @@ int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter)
 		if (!cmd_array[i].skb) {
 			PRINTM(MERROR,
 			       "ALLOC_CMD_BUF: pcmd_buf: out of memory\n");
-			ret = -1;
-			goto done;
+			return -1;
 		}
 	}
 
 	for (i = 0; i < MWIFIEX_NUM_OF_CMD_BUFFER; i++)
 		mwifiex_insert_cmd_to_free_q(adapter, &cmd_array[i]);
-	ret = 0;
-done:
-	return ret;
+
+	return 0;
 }
 
 /*
@@ -384,7 +372,7 @@ int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
 	/* Need to check if cmd pool is allocated or not */
 	if (adapter->cmd_pool == NULL) {
 		PRINTM(MINFO, "FREE_CMD_BUF: cmd_pool is Null\n");
-		goto done;
+		return 0;
 	}
 
 	cmd_array = adapter->cmd_pool;
@@ -407,7 +395,6 @@ int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
 		adapter->cmd_pool = NULL;
 	}
 
-done:
 	return 0;
 }
 
@@ -491,27 +478,23 @@ int mwifiex_prepare_cmd(struct mwifiex_private *priv,
 	/* Sanity test */
 	if (adapter->is_suspended) {
 		PRINTM(MERROR, "PREP_CMD: Device in suspended state\n");
-		ret = -1;
-		goto done;
+		return -1;
 	}
 
 	if (adapter == NULL) {
 		PRINTM(MERROR, "PREP_CMD: adapter is NULL\n");
-		ret = -1;
-		goto done;
+		return -1;
 	}
 
 	if (adapter->surprise_removed) {
 		PRINTM(MERROR, "PREP_CMD: Card is Removed\n");
-		ret = -1;
-		goto done;
+		return -1;
 	}
 
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_RESET) {
 		if (cmd_no != HostCmd_CMD_FUNC_INIT) {
 			PRINTM(MERROR, "PREP_CMD: FW is in reset state\n");
-			ret = -1;
-			goto done;
+			return -1;
 		}
 	}
 
@@ -520,8 +503,7 @@ int mwifiex_prepare_cmd(struct mwifiex_private *priv,
 
 	if (cmd_node == NULL) {
 		PRINTM(MERROR, "PREP_CMD: No free cmd node\n");
-		ret = -1;
-		goto done;
+		return -1;
 	}
 
 	/* Initialize the command node */
@@ -529,8 +511,7 @@ int mwifiex_prepare_cmd(struct mwifiex_private *priv,
 
 	if (!cmd_node->cmd_skb) {
 		PRINTM(MERROR, "PREP_CMD: No free cmd buf\n");
-		ret = -1;
-		goto done;
+		return -1;
 	}
 
 	skb_put(cmd_node->cmd_skb, sizeof(struct host_cmd_ds_command));
@@ -554,8 +535,7 @@ int mwifiex_prepare_cmd(struct mwifiex_private *priv,
 		PRINTM(MERROR, "PREP_CMD: Command 0x%x preparation failed\n",
 		       cmd_no);
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
-		ret = -1;
-		goto done;
+		return -1;
 	}
 
 	/* Send command */
@@ -563,7 +543,7 @@ int mwifiex_prepare_cmd(struct mwifiex_private *priv,
 		mwifiex_queue_scan_cmd(priv, cmd_node);
 	else
 		mwifiex_insert_cmd_to_pending_q(adapter, cmd_node, true);
-done:
+
 	return ret;
 }
 
@@ -581,7 +561,7 @@ mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
 	unsigned long flags;
 
 	if (cmd_node == NULL)
-		goto done;
+		return;
 	if (cmd_node->wq_buf) {
 		wait_queue = (struct mwifiex_wait_queue *) cmd_node->wq_buf;
 		if (wait_queue->status != MWIFIEX_ERROR_NO_ERROR)
@@ -597,7 +577,6 @@ mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
 	list_add_tail(&cmd_node->list, &adapter->cmd_free_q);
 	spin_unlock_irqrestore(&adapter->cmd_free_q_lock, flags);
 
-done:
 	return;
 }
 
@@ -619,7 +598,7 @@ mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
 	host_cmd = (struct host_cmd_ds_command *) (cmd_node->cmd_skb->data);
 	if (host_cmd == NULL) {
 		PRINTM(MERROR, "QUEUE_CMD: host_cmd is NULL\n");
-		goto done;
+		return;
 	}
 
 	command = le16_to_cpu(host_cmd->command);
@@ -644,7 +623,6 @@ mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
 
 	PRINTM(MCMND, "QUEUE_CMD: cmd=0x%x is queued\n", command);
 
-done:
 	return;
 }
 
@@ -672,8 +650,7 @@ int mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 	if (adapter->curr_cmd) {
 		PRINTM(MERROR,
 		       "EXEC_NEXT_CMD: there is command in processing!\n");
-		ret = -1;
-		goto done;
+		return -1;
 	}
 
 	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
@@ -683,8 +660,7 @@ int mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 		spin_unlock_irqrestore(&adapter->cmd_pending_q_lock,
 				       cmd_pending_q_flags);
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
-		ret = 0;
-		goto done;
+		return 0;
 	}
 	cmd_node = list_first_entry(&adapter->cmd_pending_q,
 				    struct cmd_ctrl_node, list);
@@ -700,7 +676,7 @@ int mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 				", this should not happen\n");
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock,
 				       cmd_flags);
-		goto done;
+		return ret;
 	}
 
 	spin_lock_irqsave(&adapter->cmd_pending_q_lock, cmd_pending_q_flags);
@@ -724,7 +700,6 @@ int mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 		}
 	}
 
-done:
 	return ret;
 }
 
@@ -754,8 +729,7 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 		resp = (struct host_cmd_ds_command *) adapter->upld_buf;
 		PRINTM(MERROR, "CMD_RESP: NULL curr_cmd, 0x%x\n",
 		       le16_to_cpu(resp->command));
-		ret = -1;
-		goto done;
+		return -1;
 	}
 
 	if (adapter->curr_cmd->wq_buf)
@@ -777,8 +751,7 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->curr_cmd = NULL;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
-		ret = -1;
-		goto done;
+		return -1;
 	}
 
 	if (adapter->curr_cmd->cmd_flag & CMD_F_HOSTCMD) {
@@ -829,8 +802,7 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->curr_cmd = NULL;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
-		ret = -1;
-		goto done;
+		return -1;
 	}
 
 	if (adapter->curr_cmd->cmd_flag & CMD_F_HOSTCMD) {
@@ -850,7 +822,7 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 			PRINTM(MERROR, "cmd 0x%02x failed during "
 				       "initialization\n", cmdresp_no);
 			mwifiex_init_fw_complete(adapter);
-			goto done;
+			return -1;
 		} else if (adapter->last_init_cmd == cmdresp_no)
 			adapter->hw_status = MWIFIEX_HW_STATUS_INIT_DONE;
 	}
@@ -869,7 +841,6 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 	}
 
-done:
 	return ret;
 }
 
@@ -892,7 +863,7 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 	adapter->dbg.num_cmd_timeout++;
 	if (!adapter->curr_cmd) {
 		PRINTM(MWARN, "CurCmd Empty\n");
-		goto exit;
+		return;
 	}
 	cmd_node = adapter->curr_cmd;
 	if (cmd_node->wq_buf) {
@@ -960,7 +931,7 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 	}
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING)
 		mwifiex_init_fw_complete(adapter);
-exit:
+
 	return;
 }
 
@@ -1183,7 +1154,7 @@ int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 
 	if (phs_cfg->action == cpu_to_le16(HS_ACTIVATE)) {
 		mwifiex_hs_activated_event(priv, true);
-		goto done;
+		return 0;
 	} else {
 		PRINTM(MCMND,
 		       "CMD_RESP: HS_CFG cmd reply result=%#x, "
@@ -1199,7 +1170,7 @@ int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 		if (adapter->hs_activated)
 			mwifiex_hs_activated_event(priv, false);
 	}
-done:
+
 	return 0;
 }
 
@@ -1491,7 +1462,6 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 {
 	struct host_cmd_ds_get_hw_spec *hw_spec = &resp->params.hw_spec;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	int ret = 0;
 	int i;
 
 	adapter->fw_cap_info = le32_to_cpu(hw_spec->fw_cap_info);
@@ -1570,5 +1540,5 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 		adapter->if_ops.update_mp_end_port(adapter,
 					le16_to_cpu(hw_spec->mp_end_port));
 
-	return ret;
+	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 9bcf18e..e440376 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -196,10 +196,8 @@ mwifiex_info_read(struct file *file, char __user *ubuf,
 	ssize_t ret = 0;
 	int i = 0;
 
-	if (!p) {
-		ret = -ENOMEM;
-		goto exit;
-	}
+	if (!p)
+		return -ENOMEM;
 
 	memset(&info, 0, sizeof(info));
 	ret = mwifiex_get_bss_info(priv, &info);
@@ -260,7 +258,6 @@ mwifiex_info_read(struct file *file, char __user *ubuf,
 
 free_and_exit:
 	free_page(page);
-exit:
 	return ret;
 }
 
@@ -294,10 +291,8 @@ mwifiex_getlog_read(struct file *file, char __user *ubuf,
 	ssize_t ret = 0;
 	struct mwifiex_ds_get_stats stats;
 
-	if (!p) {
-		ret = -ENOMEM;
-		goto exit;
-	}
+	if (!p)
+		return -ENOMEM;
 
 	memset(&stats, 0, sizeof(stats));
 	ret = mwifiex_get_stats_info(priv, &stats);
@@ -344,7 +339,6 @@ mwifiex_getlog_read(struct file *file, char __user *ubuf,
 
 free_and_exit:
 	free_page(page);
-exit:
 	return ret;
 }
 
@@ -411,10 +405,8 @@ mwifiex_debug_read(struct file *file, char __user *ubuf,
 	long val;
 	int i, j;
 
-	if (!p) {
-		ret = -ENOMEM;
-		goto exit;
-	}
+	if (!p)
+		return -ENOMEM;
 
 	ret = mwifiex_get_debug_info(priv, &info);
 	if (ret)
@@ -498,7 +490,6 @@ mwifiex_debug_read(struct file *file, char __user *ubuf,
 
 free_and_exit:
 	free_page(page);
-exit:
 	return ret;
 }
 
@@ -2159,10 +2150,8 @@ mwifiex_esuppmode_read(struct file *file, char __user *ubuf,
 	ssize_t ret = 0;
 	struct mwifiex_ds_esupp_mode esupp_mode;
 
-	if (!p) {
-		ret = -ENOMEM;
-		goto exit;
-	}
+	if (!p)
+		return -ENOMEM;
 
 	memset(&esupp_mode, 0, sizeof(struct mwifiex_ds_esupp_mode));
 	ret = mwifiex_get_esupp_mode(priv, &esupp_mode);
@@ -2182,14 +2171,13 @@ mwifiex_esuppmode_read(struct file *file, char __user *ubuf,
 
 free_and_exit:
 	free_page(page);
-exit:
 	return ret;
 }
 
 #define MWIFIEX_DFS_ADD_FILE(name) do {                                 \
 	if (!debugfs_create_file(#name, 0644, priv->dfs_dev_dir,        \
 			priv, &mwifiex_dfs_##name##_fops))              \
-		goto exit;                                               \
+		return;                                                 \
 } while (0);
 
 #define MWIFIEX_DFS_FILE_OPS(name)                                      \
@@ -2243,13 +2231,13 @@ void
 mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 {
 	if (!mwifiex_dfs_dir || !priv)
-		goto exit;
+		return;
 
 	priv->dfs_dev_dir = debugfs_create_dir(priv->netdev->name,
 					       mwifiex_dfs_dir);
 
 	if (!priv->dfs_dev_dir)
-		goto exit;
+		return;
 
 	MWIFIEX_DFS_ADD_FILE(info);
 	MWIFIEX_DFS_ADD_FILE(debug);
@@ -2275,7 +2263,6 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(passphrase);
 	MWIFIEX_DFS_ADD_FILE(esuppmode);
 
-exit:
 	return;
 }
 
@@ -2286,10 +2273,9 @@ void
 mwifiex_dev_debugfs_remove(struct mwifiex_private *priv)
 {
 	if (!priv)
-		goto exit;
+		return;
 
 	debugfs_remove_recursive(priv->dfs_dev_dir);
-exit:
 	return;
 }
 
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index f4e3392..9a23bfd 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -42,8 +42,7 @@ static int mwifiex_add_bss_prio_tbl(struct mwifiex_private *priv)
 	bss_prio = kzalloc(sizeof(struct mwifiex_bss_prio_node), GFP_KERNEL);
 	if (!bss_prio) {
 		PRINTM(MERROR, "%s: failed to alloc bss_prio\n", __func__);
-		status = -1;
-		goto exit;
+		return -1;
 	}
 
 	bss_prio->priv = priv;
@@ -60,7 +59,6 @@ static int mwifiex_add_bss_prio_tbl(struct mwifiex_private *priv)
 	spin_unlock_irqrestore(&adapter->bss_prio_tbl[priv->bss_priority]
 			.bss_prio_lock, flags);
 
-exit:
 	return status;
 }
 
@@ -361,7 +359,6 @@ mwifiex_free_adapter(struct mwifiex_adapter *adapter)
  */
 int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 {
-	int ret = 0;
 	struct mwifiex_private   *priv = NULL;
 	s32           i = 0;
 	u32           j = 0;
@@ -413,7 +410,7 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -471,10 +468,8 @@ int mwifiex_init_fw(struct mwifiex_adapter *adapter)
 
 	/* Allocate memory for member of adapter structure */
 	ret = mwifiex_allocate_adapter(adapter);
-	if (ret) {
-		ret = -1;
-		goto done;
-	}
+	if (ret)
+		return -1;
 
 	/* Initialize adapter structure */
 	mwifiex_init_adapter(adapter);
@@ -485,10 +480,8 @@ int mwifiex_init_fw(struct mwifiex_adapter *adapter)
 
 			/* Initialize private structure */
 			ret = mwifiex_init_priv(priv);
-			if (ret) {
-				ret = -1;
-				goto done;
-			}
+			if (ret)
+				return -1;
 		}
 	}
 	for (i = 0; i < adapter->priv_num; i++) {
@@ -496,7 +489,7 @@ int mwifiex_init_fw(struct mwifiex_adapter *adapter)
 			ret = mwifiex_sta_init_cmd(adapter->priv[i],
 						   first_sta);
 			if (ret == -1)
-				goto done;
+				return -1;
 
 			first_sta = false;
 		}
@@ -512,7 +505,7 @@ int mwifiex_init_fw(struct mwifiex_adapter *adapter)
 	} else {
 		adapter->hw_status = MWIFIEX_HW_STATUS_READY;
 	}
-done:
+
 	return ret;
 }
 
@@ -622,8 +615,7 @@ poll_fw:
 	ret = adapter->if_ops.check_fw_status(adapter, poll_num, NULL);
 	if (ret) {
 		PRINTM(MFATAL, "FW failed to be active in time!\n");
-		ret = -1;
-		return ret;
+		return -1;
 	}
 done:
 	/* re-enable host interrupt for mwifiex after fw dnld is successful */
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index f48e7f3..23b4f1f 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -149,8 +149,7 @@ static int mwifiex_get_common_rates(struct mwifiex_private *priv,
 	tmp = kmalloc(rate1_size, GFP_KERNEL);
 	if (!tmp) {
 		PRINTM(MERROR, "%s: failed to alloc tmp\n", __func__);
-		ret = -1;
-		goto done;
+		return -ENOMEM;
 	}
 
 	memcpy(tmp, rate1, rate1_size);
@@ -334,7 +333,6 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 				 struct host_cmd_ds_command *cmd,
 				 void *data_buf)
 {
-	int ret = 0;
 	struct host_cmd_ds_802_11_associate *assoc = &cmd->params.associate;
 	struct mwifiex_bssdescriptor *bss_desc;
 	struct mwifiex_ie_types_ssid_param_set *ssid_tlv;
@@ -395,10 +393,8 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 
 	/* Get the common rates supported between the driver and the BSS Desc */
 	if (mwifiex_setup_rates_from_bssdesc
-	    (priv, bss_desc, rates, &rates_size)) {
-		ret = -1;
-		goto done;
-	}
+	    (priv, bss_desc, rates, &rates_size))
+		return -1;
 
 	/* Save the data rates into Current BSS state structure */
 	priv->curr_bss_params.num_of_rates = rates_size;
@@ -478,10 +474,8 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 					<= (sizeof(priv->wpa_ie) - 2))
 				memcpy(rsn_ie_tlv->rsn_ie, &priv->wpa_ie[2],
 					le16_to_cpu(rsn_ie_tlv->header.len));
-			else {
-				ret = -1;
-				goto done;
-			}
+			else
+				return -1;
 			HEXDUMP("ASSOC_CMD: RSN IE", (u8 *) rsn_ie_tlv,
 					sizeof(rsn_ie_tlv->header)
 					+ le16_to_cpu(rsn_ie_tlv->header.len));
@@ -508,7 +502,7 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 							rsn_ie_tlv->header.len)
 							& 0x00FF);
 				if (le16_to_cpu(rsn_ie_tlv->header.len)
-						<= (sizeof(priv->wpa_ie))) {
+						<= (sizeof(priv->wpa_ie)))
 					memcpy(rsn_ie_tlv->rsn_ie,
 						&((*(bss_desc->bcn_wpa_ie))
 							.vend_hdr.
@@ -516,10 +510,8 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 							le16_to_cpu(
 							rsn_ie_tlv->header
 							.len));
-				} else {
-					ret = -1;
-					goto done;
-				}
+				else
+					return -1;
 
 				HEXDUMP("ASSOC_CMD: RSN IE", (u8 *) rsn_ie_tlv,
 						sizeof(rsn_ie_tlv->header) +
@@ -549,16 +541,14 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 						rsn_ie_tlv->header.len)
 						& 0x00FF);
 				if (le16_to_cpu(rsn_ie_tlv->header.len)
-						<= (sizeof(priv->wpa_ie))) {
+						<= (sizeof(priv->wpa_ie)))
 					memcpy(rsn_ie_tlv->rsn_ie,
 						&((*(bss_desc->bcn_rsn_ie))
 						.data[0]),
 						le16_to_cpu(
 						rsn_ie_tlv->header.len));
-				} else {
-					ret = -1;
-					goto done;
-				}
+				else
+					return -1;
 
 				HEXDUMP("ASSOC_CMD: RSN IE", (u8 *) rsn_ie_tlv,
 						sizeof(rsn_ie_tlv->header) +
@@ -602,8 +592,7 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	       tmp_cap, CAPINFO_MASK);
 	assoc->cap_info_bitmap = cpu_to_le16(tmp_cap);
 
-done:
-	return ret;
+	return 0;
 }
 
 /*
@@ -863,10 +852,8 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 		(u8 *) adhoc_start +
 		sizeof(struct host_cmd_ds_802_11_ad_hoc_start);
 
-	if (!adapter) {
-		ret = -1;
-		goto done;
-	}
+	if (!adapter)
+		return -1;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_AD_HOC_START);
 
@@ -927,8 +914,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 
 	if (!priv->adhoc_channel) {
 		PRINTM(MERROR, "ADHOC_S_CMD: adhoc_channel cannot be 0\n");
-		ret = -1;
-		goto done;
+		return -1;
 	}
 
 	PRINTM(MINFO, "ADHOC_S_CMD: Creating ADHOC on Channel %d\n",
@@ -992,8 +978,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 		if (ret) {
 			PRINTM(MERROR,
 			       "ADHOC_S_CMD: G Protection config failed\n");
-			ret = -1;
-			goto done;
+			return -1;
 		}
 	}
 	/* Find the last non zero */
@@ -1075,10 +1060,8 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 				<= (sizeof(priv->wpa_ie) - 2))
 			memcpy(rsn_ie_tlv->rsn_ie, &priv->wpa_ie[2],
 			       le16_to_cpu(rsn_ie_tlv->header.len));
-		else {
-			ret = -1;
-			goto done;
-		}
+		else
+			return -1;
 
 		DBG_HEXDUMP(MCMD_D, "ADHOC_S_CMD: RSN IE", (u8 *) rsn_ie_tlv,
 			    sizeof(rsn_ie_tlv->header) +
@@ -1159,9 +1142,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 
 	adhoc_start->cap_info_bitmap = cpu_to_le16(tmp_cap);
 
-	ret = 0;
-done:
-	return ret;
+	return 0;
 }
 
 /*
@@ -1213,8 +1194,7 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 		if (ret) {
 			PRINTM(MERROR,
 			       "ADHOC_J_CMD: G Protection config failed\n");
-			ret = -1;
-			goto done;
+			return -1;
 		}
 	}
 
@@ -1328,10 +1308,8 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 			<= (sizeof(priv->wpa_ie) - 2))
 			memcpy(rsn_ie_tlv->rsn_ie, &priv->wpa_ie[2],
 			       le16_to_cpu(rsn_ie_tlv->header.len));
-		else {
-			ret = -1;
-			goto done;
-		}
+		else
+			return -1;
 
 		HEXDUMP("ADHOC_JOIN: RSN IE", (u8 *) rsn_ie_tlv,
 			sizeof(rsn_ie_tlv->header)
@@ -1357,15 +1335,13 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 				cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.len)
 				& 0x00FF);
 			if (le16_to_cpu(rsn_ie_tlv->header.len)
-					<= (sizeof(priv->wpa_ie))) {
+					<= (sizeof(priv->wpa_ie)))
 				memcpy(rsn_ie_tlv->rsn_ie,
 				       &((*(bss_desc->bcn_wpa_ie)).vend_hdr.
 					 oui[0]),
 					le16_to_cpu(rsn_ie_tlv->header.len));
-			} else {
-				ret = -1;
-				goto done;
-			}
+			else
+				return -1;
 
 			HEXDUMP("ADHOC_JOIN: RSN IE", (u8 *) rsn_ie_tlv,
 				sizeof(rsn_ie_tlv->header) +
@@ -1392,14 +1368,12 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 				cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.len)
 				& 0x00FF);
 			if (le16_to_cpu(rsn_ie_tlv->header.len)
-					<= (sizeof(priv->wpa_ie))) {
+					<= (sizeof(priv->wpa_ie)))
 				memcpy(rsn_ie_tlv->rsn_ie,
 				       &((*(bss_desc->bcn_rsn_ie)).data[0])
 				       , le16_to_cpu(rsn_ie_tlv->header.len));
-			} else {
-				ret = -1;
-				goto done;
-			}
+			else
+				return -1;
 
 			HEXDUMP("ADHOC_JOIN: RSN IE", (u8 *) rsn_ie_tlv,
 				sizeof(rsn_ie_tlv->header) +
@@ -1429,7 +1403,6 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 	adhoc_join->bss_descriptor.cap_info_bitmap =
 				cpu_to_le16(tmp_cap);
 
-done:
 	return ret;
 }
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 5df47f4..e3118aa 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -78,10 +78,8 @@ static int mwifiex_register(void *card,
 
 	adapter = kzalloc(sizeof(struct mwifiex_adapter), GFP_KERNEL);
 	/* Allocate memory for adapter structure */
-	if (!adapter) {
-		ret = -1;
-		goto exit_register;
-	}
+	if (!adapter)
+		return -1;
 
 	g_adapter = adapter;
 	adapter->card = card;
@@ -91,10 +89,8 @@ static int mwifiex_register(void *card,
 
 	/* card specific initialization has been deferred until now .. */
 	ret = adapter->if_ops.init_if(adapter);
-	if (ret) {
-		ret = -1;
+	if (ret)
 		goto error;
-	}
 
 	adapter->priv_num = 0;
 	for (i = 0; i < MWIFIEX_MAX_BSS_NUM; i++) {
@@ -109,7 +105,6 @@ static int mwifiex_register(void *card,
 				PRINTM(MERROR,
 				       "%s: failed to allocate priv[]\n",
 				       __func__);
-				ret = -1;
 				goto error;
 			}
 
@@ -141,10 +136,8 @@ static int mwifiex_register(void *card,
 	}
 
 	/* Initialize lock variables */
-	if (mwifiex_init_lock_list(adapter)) {
-		ret = -1;
+	if (mwifiex_init_lock_list(adapter))
 		goto error;
-	}
 
 	init_timer(&adapter->cmd_timer);
 	adapter->cmd_timer.function = mwifiex_cmd_timeout_func;
@@ -152,7 +145,7 @@ static int mwifiex_register(void *card,
 
 	/* Return pointer of struct mwifiex_adapter */
 	*padapter = adapter;
-	goto exit_register;
+	return 0;
 
 error:
 	PRINTM(MINFO, "Leave mwifiex_register with error\n");
@@ -163,8 +156,7 @@ error:
 		kfree(adapter->priv[i]);
 	kfree(adapter);
 
-exit_register:
-	return ret;
+	return -1;
 }
 
 /*
@@ -358,7 +350,6 @@ exit_main_proc:
 static int
 mwifiex_init_sw(void *card, struct mwifiex_if_ops *if_ops, void **pmwifiex)
 {
-	int ret = 0;
 	int i;
 	struct mwifiex_device device;
 	struct mwifiex_drv_mode *drv_mode_ptr;
@@ -391,9 +382,9 @@ mwifiex_init_sw(void *card, struct mwifiex_if_ops *if_ops, void **pmwifiex)
 	}
 
 	if (mwifiex_register(card, if_ops, &device, pmwifiex))
-		ret = -1;
+		return -1;
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -567,14 +558,14 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (priv->adapter->surprise_removed) {
 		kfree(skb);
 		priv->stats.tx_dropped++;
-		goto done;
+		return 0;
 	}
 	if (!skb->len || (skb->len > ETH_FRAME_LEN)) {
 		PRINTM(MERROR, "Tx Error: Bad skb lengthd : %d\n",
 		       skb->len, ETH_FRAME_LEN);
 		kfree(skb);
 		priv->stats.tx_dropped++;
-		goto done;
+		return 0;
 	}
 	if (skb_headroom(skb) < MWIFIEX_MIN_DATA_HEADER_LEN) {
 		PRINTM(MWARN, "Tx: Insufficient skb headroomd\n",
@@ -586,7 +577,7 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			PRINTM(MERROR, "Tx: Cannot allocate skb\n");
 			kfree(skb);
 			priv->stats.tx_dropped++;
-			goto done;
+			return 0;
 		}
 		kfree_skb(skb);
 		skb = new_skb;
@@ -607,7 +598,6 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	queue_work(priv->adapter->workqueue, &priv->adapter->main_work);
 
-done:
 	return 0;
 }
 
@@ -617,7 +607,6 @@ done:
 static int
 mwifiex_set_mac_address(struct net_device *dev, void *addr)
 {
-	int ret = 0;
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) mwifiex_netdev_get_priv(dev);
 	struct sockaddr *hw_addr = (struct sockaddr *) addr;
@@ -630,13 +619,12 @@ mwifiex_set_mac_address(struct net_device *dev, void *addr)
 	memcpy(priv->curr_addr, hw_addr->sa_data, ETH_ALEN);
 	if (mwifiex_request_set_mac_address(priv)) {
 		PRINTM(MERROR, "Set MAC address failed\n");
-		ret = -EFAULT;
-		goto done;
+		return -EFAULT;
 	}
 	HEXDUMP("priv->MacAddr:", priv->curr_addr, ETH_ALEN);
 	memcpy(dev->dev_addr, priv->curr_addr, ETH_ALEN);
-done:
-	return ret;
+
+	return 0;
 }
 
 /*
@@ -810,7 +798,7 @@ mwifiex_remove_interface(struct mwifiex_adapter *adapter, u8 bss_index)
 	struct mwifiex_private *priv = adapter->priv[bss_index];
 
 	if (!priv)
-		goto error;
+		return;
 	dev = priv->netdev;
 
 	if (priv->media_connected)
@@ -838,7 +826,7 @@ mwifiex_remove_interface(struct mwifiex_adapter *adapter, u8 bss_index)
 	wiphy_unregister(priv->wdev->wiphy);
 	wiphy_free(priv->wdev->wiphy);
 	kfree(priv->wdev);
-error:
+
 	return;
 }
 
@@ -855,17 +843,14 @@ int mwifiex_shutdown_fw(struct mwifiex_private *priv, u8 wait_option)
 
 	/* Allocate an IOCTL request buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait) {
-		status = -1;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	status = mwifiex_misc_ioctl_init_shutdown(priv->adapter, wait,
 						  MWIFIEX_FUNC_SHUTDOWN);
 
 	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
 
-done:
 	kfree(wait);
 	return status;
 }
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 0dc5829..42ef23a 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -190,18 +190,14 @@ int mwifiex_find_best_bss(struct mwifiex_private *priv,
 	int ret = 0;
 	u8 *mac = NULL;
 
-	if (!ssid_bssid) {
-		ret = -1;
-		goto done;
-	}
+	if (!ssid_bssid)
+		return -1;
 
 	if (priv->ewpa_query) {
 		/* Allocate wait request buffer */
 		wait1 = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-		if (!wait1) {
-			ret = -1;
-			goto done;
-		}
+		if (!wait1)
+			return -ENOMEM;
 
 		memset(&passphrase, 0, sizeof(passphrase));
 		passphrase.psk_type = MWIFIEX_PSK_QUERY;
@@ -220,10 +216,8 @@ int mwifiex_find_best_bss(struct mwifiex_private *priv,
 
 	/* Allocate wait request buffer */
 	wait2 = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait2) {
-		ret = -1;
-		goto done;
-	}
+	if (!wait2)
+		return -ENOMEM;
 
 	memcpy(&tmp_ssid_bssid, ssid_bssid,
 	       sizeof(struct mwifiex_ssid_bssid));
@@ -263,17 +257,14 @@ int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
 
 	/* Allocate an IOCTL request buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait) {
-		status = -ENOMEM;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	status = mwifiex_scan_networks(priv, wait, HostCmd_ACT_GEN_SET,
 				       scan_req, NULL);
 
 	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
 
-done:
 	if (wait && (status != -EINPROGRESS))
 		kfree(wait);
 	return status;
@@ -2696,8 +2687,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 				GFP_KERNEL);
 	if (!bss_new_entry) {
 		PRINTM(MERROR, "%s: failed to alloc bss_new_entry\n", __func__);
-		ret = -1;
-		goto done;
+		return -1;
 	}
 
 	for (idx = 0; idx < scan_rsp->number_of_sets && bytes_left; idx++) {
@@ -3075,7 +3065,6 @@ int mwifiex_find_best_network(struct mwifiex_private *priv,
 			      struct mwifiex_ssid_bssid *req_ssid_bssid)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	int ret = 0;
 	struct mwifiex_bssdescriptor *req_bss;
 	s32 i;
 
@@ -3096,10 +3085,8 @@ int mwifiex_find_best_network(struct mwifiex_private *priv,
 			priv->bss_mode = req_bss->bss_mode;
 	}
 
-	if (!req_ssid_bssid->ssid.ssid_len) {
-		ret = -1;
-		goto done;
-	}
+	if (!req_ssid_bssid->ssid.ssid_len)
+		return -1;
 
 	PRINTM(MINFO, "Best network found = [%s], "
 	       "[%02x:%02x:%02x:%02x:%02x:%02x]\n",
@@ -3108,8 +3095,7 @@ int mwifiex_find_best_network(struct mwifiex_private *priv,
 	       req_ssid_bssid->bssid[2], req_ssid_bssid->bssid[3],
 	       req_ssid_bssid->bssid[4], req_ssid_bssid->bssid[5]);
 
-done:
-	return ret;
+	return 0;
 }
 
 /*
@@ -3125,10 +3111,8 @@ int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 	int ret = 0;
 	struct mwifiex_user_scan_cfg *scan_cfg;
 
-	if (!req_ssid) {
-		ret = -1;
-		goto done;
-	}
+	if (!req_ssid)
+		return -1;
 
 	if (action == HostCmd_ACT_GEN_GET) {
 		if (scan_resp) {
@@ -3157,8 +3141,7 @@ int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 	scan_cfg = kzalloc(sizeof(struct mwifiex_user_scan_cfg), GFP_KERNEL);
 	if (!scan_cfg) {
 		PRINTM(MERROR, "%s: failed to alloc scan_cfg\n", __func__);
-		ret = -1;
-		goto done;
+		return -1;
 	}
 
 	memcpy(scan_cfg->ssid_list[0].ssid, req_ssid->ssid,
@@ -3168,8 +3151,6 @@ int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 	ret = mwifiex_scan_networks(priv, wait_buf, action, scan_cfg, NULL);
 
 	kfree(scan_cfg);
-
-done:
 	return ret;
 }
 
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 7bff953..dbc3837 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -447,11 +447,10 @@ static int mwifiex_write_data_to_card(struct mwifiex_adapter *adapter,
 			}
 			ret = -1;
 			if (i > MAX_WRITE_IOMEM_RETRY)
-				goto exit;
+				return ret;
 		}
 	} while (ret == -1);
 
-exit:
 	return ret;
 }
 
@@ -634,24 +633,21 @@ static int mwifiex_sdio_card_to_host(struct mwifiex_adapter *adapter,
 
 	if (!buffer) {
 		PRINTM(MWARN, "skb NULL pointer received!\n");
-		ret = -1;
-		goto exit;
+		return -1;
 	}
 
 	ret = mwifiex_read_data_sync(adapter, buffer, npayload, ioport, 0, 1);
 
 	if (ret) {
 		PRINTM(MERROR, "card_to_host, read iomem failed: %d\n", ret);
-		ret = -1;
-		goto exit;
+		return -1;
 	}
 
 	*nb = le16_to_cpu(*(__le16 *) (buffer));
 	if (*nb > npayload) {
 		PRINTM(MERROR, "invalid packet, *nb=%d, npayload=%d\n", *nb,
 		       npayload);
-		ret = -1;
-		goto exit;
+		return -1;
 	}
 
 	DBG_HEXDUMP(MDAT_D, "SDIO Blk Rd", buffer,
@@ -659,7 +655,6 @@ static int mwifiex_sdio_card_to_host(struct mwifiex_adapter *adapter,
 
 	*type = le16_to_cpu(*(__le16 *) (buffer + 2));
 
-exit:
 	return ret;
 }
 
@@ -874,7 +869,7 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 				   0)) {
 		PRINTM(MWARN,
 		       "mwifiex_read_data_sync: read registers failed\n");
-		goto done;
+		return;
 	}
 
 	DBG_HEXDUMP(MDAT_D, "SDIO MP Registers", card->mp_regs, MAX_MP_REGS);
@@ -889,7 +884,7 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 		adapter->int_status |= sdio_ireg;
 		spin_unlock_irqrestore(&adapter->int_lock, flags);
 	}
-done:
+
 	return;
 }
 
@@ -909,12 +904,12 @@ mwifiex_sdio_interrupt(struct sdio_func *func)
 	if (!card || !card->adapter) {
 		PRINTM(MINFO, "%s: func=%p card=%p adapter=%p\n", __func__,
 		       func, card, card ? card->adapter : NULL);
-		goto exit;
+		return;
 	}
 	adapter = card->adapter;
 
 	if (adapter->surprise_removed)
-		goto exit;
+		return;
 
 	if (!adapter->pps_uapsd_mode && adapter->ps_state == PS_STATE_SLEEP)
 		adapter->ps_state = PS_STATE_AWAKE;
@@ -922,7 +917,6 @@ mwifiex_sdio_interrupt(struct sdio_func *func)
 	mwifiex_interrupt_status(adapter);
 	queue_work(adapter->workqueue, &adapter->main_work);
 
-exit:
 	return;
 }
 
@@ -1006,7 +1000,6 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 					     struct sk_buff *skb, u8 port)
 {
 	struct sdio_mmc_card *card = adapter->card;
-	int ret = 0;
 	s32 f_do_rx_aggr = 0;
 	s32 f_do_rx_cur = 0;
 	s32 f_aggr_cur = 0;
@@ -1092,10 +1085,8 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 					   card->mpa_rx.buf_len,
 					   (adapter->ioport | 0x1000 |
 					    (card->mpa_rx.ports << 4)) +
-					   card->mpa_rx.start_port, 0, 1)) {
-			ret = -1;
-			goto done;
-		}
+					   card->mpa_rx.start_port, 0, 1))
+			return -1;
 
 		curr_ptr = card->mpa_rx.buf;
 
@@ -1140,18 +1131,14 @@ rx_curr_single:
 		if (mwifiex_sdio_card_to_host(adapter, &pkt_type,
 					      (u32 *) &adapter->upld_len,
 					      skb->data, skb->len,
-					      adapter->ioport + port)) {
-			ret = -1;
-			goto done;
-		}
+					      adapter->ioport + port))
+			return -1;
 
 		mwifiex_decode_rx_packet(adapter, skb, pkt_type);
 
 	}
 
-done:
-	return ret;
-
+	return 0;
 }
 
 /*
@@ -1187,7 +1174,7 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 	spin_unlock_irqrestore(&adapter->int_lock, flags);
 
 	if (!sdio_ireg)
-		goto done;
+		return ret;
 
 	if (sdio_ireg & DN_LD_HOST_INT_STATUS) {
 		card->mp_wr_bitmap = ((u16) card->mp_regs[WR_BITMAP_U]) << 8;
@@ -1238,8 +1225,7 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 			    || (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE) >
 			    MWIFIEX_RX_DATA_BUF_SIZE) {
 				PRINTM(MERROR, "invalid rx_len=%d\n", rx_len);
-				ret = -1;
-				goto done;
+				return -1;
 			}
 			rx_len = (u16) (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE);
 
@@ -1248,8 +1234,7 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 			if (!skb) {
 				PRINTM(MERROR, "%s: failed to alloc skb",
 								__func__);
-				ret = -1;
-				goto done;
+				return -1;
 			}
 
 			skb_put(skb, rx_len);
@@ -1281,16 +1266,13 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 					PRINTM(MERROR, "read CFG reg failed\n");
 
 				PRINTM(MINFO, "Config reg val =%x\n", cr);
-				ret = -1;
 				dev_kfree_skb_any(skb);
-				goto done;
+				return -1;
 			}
 		}
 	}
 
-	ret = 0;
-done:
-	return ret;
+	return 0;
 }
 
 /*
@@ -1329,7 +1311,7 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 		ret = mwifiex_get_wr_port_data(adapter, &port);
 		if (ret) {
 			PRINTM(MERROR, "no wr_port available: %d\n", ret);
-			goto exit;
+			return ret;
 		}
 	} else {
 		adapter->cmd_sent = true;
@@ -1371,7 +1353,6 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 				min_t(u32, pkt_len, MAX_DATA_DUMP_LEN));
 	}
 
-exit:
 	return ret;
 }
 
@@ -1679,8 +1660,7 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 	card->mp_regs = kzalloc(MAX_MP_REGS, GFP_KERNEL);
 	if (!card->mp_regs) {
 		PRINTM(MERROR, "%s: failed to allocate mp_regs\n", __func__);
-		ret = -1;
-		goto done;
+		return -1;
 	}
 
 	ret = mwifiex_alloc_sdio_mpa_buffers(adapter,
@@ -1689,11 +1669,9 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 	if (ret) {
 		PRINTM(MERROR, "Failed to allocate sdio mp-a buffers\n");
 		kfree(card->mp_regs);
-		ret = -1;
-		goto done;
+		return -1;
 	}
 
-done:
 	return ret;
 }
 
@@ -1769,7 +1747,6 @@ mwifiex_sdio_mpactrl(struct mwifiex_private *priv, u8 write, int *data,
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct sdio_mmc_card *card = adapter->card;
-	int ret = 0;
 
 	if (!write) {
 		data[0] = card->mpa_tx.enabled;
@@ -1785,45 +1762,34 @@ mwifiex_sdio_mpactrl(struct mwifiex_private *priv, u8 write, int *data,
 		if (priv->media_connected) {
 			PRINTM(MMSG, "SDIO MPA CTRL: not allowed "
 			       "in connected state\n");
-			ret = -EINVAL;
-			goto done;
+			return -EINVAL;
 		}
 
-		if (length > 6) {
-			ret = -EINVAL;
-			goto done;
-		}
+		if (length > 6)
+			return -EINVAL;
 
 		/* mpa_tx enabled */
 		if (length > 0) {
-			if (data[0] > 1) {
-				ret = -EINVAL;
-				goto done;
-			}
+			if (data[0] > 1)
+				return -EINVAL;
 		}
 
 		/* mpa_rx enabled */
 		if (length > 1) {
-			if (data[1] > 1) {
-				ret = -EINVAL;
-				goto done;
-			}
+			if (data[1] > 1)
+				return -EINVAL;
 		}
 
 		/* mpa_tx port limit */
 		if (length > 4) {
-			if (data[4] > SDIO_MP_AGGR_DEF_PKT_LIMIT) {
-				ret = -EINVAL;
-				goto done;
-			}
+			if (data[4] > SDIO_MP_AGGR_DEF_PKT_LIMIT)
+				return -EINVAL;
 		}
 
 		/* mpa_rx port limit */
 		if (length > 5) {
-			if (data[5] > SDIO_MP_AGGR_DEF_PKT_LIMIT) {
-				ret = -EINVAL;
-				goto done;
-			}
+			if (data[5] > SDIO_MP_AGGR_DEF_PKT_LIMIT)
+				return -EINVAL;
 		}
 
 		if (((length > 2) && data[2]) || ((length > 3) && data[3])) {
@@ -1847,8 +1813,7 @@ mwifiex_sdio_mpactrl(struct mwifiex_private *priv, u8 write, int *data,
 				PRINTM(MERROR,
 				       "Failed to allocate "
 				       "sdio mp-a buffers\n");
-				ret = -EINVAL;
-				goto done;
+				return -EINVAL;
 			}
 		}
 
@@ -1868,8 +1833,7 @@ mwifiex_sdio_mpactrl(struct mwifiex_private *priv, u8 write, int *data,
 			card->mpa_tx.enabled = data[0];
 			break;
 		default:
-			ret = -EINVAL;
-			goto done;
+			return -EINVAL;
 		}
 
 		PRINTM(MINFO, "New Param: %d %d %d %d %d %d\n",
@@ -1881,8 +1845,7 @@ mwifiex_sdio_mpactrl(struct mwifiex_private *priv, u8 write, int *data,
 		       card->mpa_rx.pkt_aggr_limit);
 	}
 
-done:
-	return ret;
+	return 0;
 }
 
 static struct mwifiex_if_ops sdio_ops = {
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index d0a7558..6715410 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -535,7 +535,6 @@ mwifiex_set_keyparamset_wep(struct mwifiex_private *priv,
 {
 	int cur_key_param_len = 0;
 	u8 i;
-	int ret = 0;
 
 	/* Multi-key_param_set TLV is supported */
 	for (i = 0; i < NUM_WEP_KEYS; i++) {
@@ -585,13 +584,11 @@ mwifiex_set_keyparamset_wep(struct mwifiex_private *priv,
 		} else {
 			PRINTM(MERROR, "key%d Length = %d is incorrect\n",
 			       (i + 1), priv->wep_key[i].key_length);
-			ret = -1;
-			goto done;
+			return -1;
 		}
 	}
 
-done:
-	return ret;
+	return 0;
 }
 
 /*
@@ -622,7 +619,7 @@ static int mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 	if (cmd_action == HostCmd_ACT_GEN_GET) {
 		cmd->size =
 			cpu_to_le16(sizeof(key_material->action) + S_DS_GEN);
-		goto done;
+		return ret;
 	}
 
 	if (!enc_key) {
@@ -635,7 +632,7 @@ static int mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 		cmd->size =
 			cpu_to_le16(key_param_len +
 				    sizeof(key_material->action) + S_DS_GEN);
-		goto done;
+		return ret;
 	} else
 		memset(&key_material->key_param_set, 0,
 		       sizeof(struct mwifiex_ie_type_key_param_set));
@@ -689,7 +686,7 @@ static int mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 		cmd->size =
 			cpu_to_le16(key_param_len +
 				    sizeof(key_material->action) + S_DS_GEN);
-		goto done;
+		return ret;
 	}
 	if (enc_key->key_len == WLAN_KEY_LEN_CCMP) {
 		PRINTM(MCMND, "WPA_AES\n");
@@ -744,7 +741,7 @@ static int mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 			cpu_to_le16(key_param_len +
 				    sizeof(key_material->action) + S_DS_GEN);
 	}
-done:
+
 	return ret;
 }
 
@@ -1413,29 +1410,23 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 
 		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_FUNC_INIT,
 					  HostCmd_ACT_GEN_SET, 0, NULL, NULL);
-		if (ret) {
-			ret = -1;
-			goto done;
-		}
+		if (ret)
+			return -1;
 		/*
 		 * Read MAC address from HW
 		 */
 		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_GET_HW_SPEC,
 					  HostCmd_ACT_GEN_GET, 0, NULL, NULL);
-		if (ret) {
-			ret = -1;
-			goto done;
-		}
+		if (ret)
+			return -1;
 
 		/* Reconfigure tx buf size */
 		ret = mwifiex_prepare_cmd(priv,
 					  HostCmd_CMD_RECONFIGURE_TX_BUFF,
 					  HostCmd_ACT_GEN_SET, 0, NULL,
 					  &priv->adapter->tx_buf_size);
-		if (ret) {
-			ret = -1;
-			goto done;
-		}
+		if (ret)
+			return -1;
 
 		/* Enable IEEE PS by default */
 		priv->adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_PSP;
@@ -1443,39 +1434,31 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 					  HostCmd_CMD_802_11_PS_MODE_ENH,
 					  EN_AUTO_PS, BITMAP_STA_PS, NULL,
 					  NULL);
-		if (ret) {
-			ret = -1;
-			goto done;
-		}
+		if (ret)
+			return -1;
 	}
 
 	/* get tx rate */
 	ret = mwifiex_prepare_cmd(priv,
 				  HostCmd_CMD_TX_RATE_CFG,
 				  HostCmd_ACT_GEN_GET, 0, NULL, NULL);
-	if (ret) {
-		ret = -1;
-		goto done;
-	}
+	if (ret)
+		return -1;
 	priv->data_rate = 0;
 
 	/* get tx power */
 	ret = mwifiex_prepare_cmd(priv,
 				  HostCmd_CMD_TXPWR_CFG,
 				  HostCmd_ACT_GEN_GET, 0, NULL, NULL);
-	if (ret) {
-		ret = -1;
-		goto done;
-	}
+	if (ret)
+		return -1;
 
 	/* set ibss coalescing_status */
 	ret = mwifiex_prepare_cmd(priv,
 				  HostCmd_CMD_802_11_IBSS_COALESCING_STATUS,
 				  HostCmd_ACT_GEN_SET, 0, NULL, &enable);
-	if (ret) {
-		ret = -1;
-		goto done;
-	}
+	if (ret)
+		return -1;
 
 	memset(&amsdu_aggr_ctrl, 0, sizeof(amsdu_aggr_ctrl));
 	amsdu_aggr_ctrl.enable = true;
@@ -1483,19 +1466,15 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_AMSDU_AGGR_CTRL,
 				  HostCmd_ACT_GEN_SET, 0, NULL,
 				  (void *) &amsdu_aggr_ctrl);
-	if (ret) {
-		ret = -1;
-		goto done;
-	}
+	if (ret)
+		return -1;
 	/* MAC Control must be the last command in init_fw */
 	/* set MAC Control */
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_MAC_CONTROL,
 				  HostCmd_ACT_GEN_SET, 0, NULL,
 				  &priv->curr_pkt_filter);
-	if (ret) {
-		ret = -1;
-		goto done;
-	}
+	if (ret)
+		return -1;
 
 	if (first_sta) {
 		/* Enable auto deep sleep */
@@ -1505,10 +1484,8 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 				HostCmd_CMD_802_11_PS_MODE_ENH,
 				EN_AUTO_PS, BITMAP_AUTO_DS, NULL,
 				&auto_ds);
-		if (ret) {
-			ret = -1;
-			goto done;
-		}
+		if (ret)
+			return -1;
 	}
 
 	/* Send cmd to FW to enable/disable 11D function */
@@ -1522,6 +1499,6 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	/** set last_init_cmd */
 	priv->adapter->last_init_cmd = HostCmd_CMD_802_11_SNMP_MIB;
 	ret = -EINPROGRESS;
-done:
+
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 4d13bb9..e922d16 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -657,7 +657,6 @@ static int mwifiex_ret_802_11_supplicant_pmk(struct mwifiex_private *priv,
 					     struct host_cmd_ds_command *resp,
 					     void *data_buf)
 {
-	int ret = 0;
 	struct host_cmd_ds_802_11_supplicant_pmk *supplicant_pmk_resp =
 		&resp->params.esupp_psk;
 	struct mwifiex_ds_passphrase *passphrase = NULL;
@@ -783,7 +782,7 @@ static int mwifiex_ret_802_11_supplicant_pmk(struct mwifiex_private *priv,
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -853,7 +852,6 @@ static int mwifiex_ret_802_11_supplicant_profile(struct mwifiex_private *priv,
 int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
 				    struct host_cmd_ds_command *resp)
 {
-	int ret = 0;
 	struct host_cmd_ds_802_11d_domain_info_rsp *domain_info =
 		&resp->params.domain_info_resp;
 	struct mwifiex_ietypes_domain_param_set *domain = &domain_info->domain;
@@ -887,11 +885,10 @@ int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
 	default:
 		PRINTM(MERROR, "11D: Invalid Action:%d\n",
 			domain_info->action);
-		ret = -1;
-		break;
+		return -1;
 	}
 
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index e9d80a2..6181198 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -67,7 +67,7 @@ mwifiex_alloc_fill_wait_queue(struct mwifiex_private *priv,
 		kzalloc(sizeof(struct mwifiex_wait_queue), GFP_ATOMIC);
 	if (!wait) {
 		PRINTM(MERROR, "%s:Fail to alloc wait buffer\n", __func__);
-		goto done;
+		return wait;
 	}
 
 	wait->bss_index = priv->bss_index;
@@ -99,7 +99,6 @@ mwifiex_alloc_fill_wait_queue(struct mwifiex_private *priv,
 		break;
 	}
 
-done:
 	return wait;
 }
 
@@ -194,10 +193,8 @@ int mwifiex_request_set_mac_address(struct mwifiex_private *priv)
 
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait) {
-		status = -1;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	status = mwifiex_bss_ioctl_mac_address(priv, wait, HostCmd_ACT_GEN_SET,
 					       NULL);
@@ -211,7 +208,7 @@ int mwifiex_request_set_mac_address(struct mwifiex_private *priv)
 		       "set mac address failed! status=%d, error_code=0x%lx\n",
 		       status, wait->status);
 	}
-done:
+
 	kfree(wait);
 	return status;
 }
@@ -234,7 +231,7 @@ mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait)
-		goto done;
+		return;
 
 	if (dev->flags & IFF_PROMISC) {
 		mcast_list.mode = MWIFIEX_PROMISC_MODE;
@@ -254,7 +251,7 @@ mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
 	if (wait && status != -EINPROGRESS)
 		kfree(wait);
-done:
+
 	return;
 }
 
@@ -271,16 +268,13 @@ int mwifiex_disconnect(struct mwifiex_private *priv, u8 wait_option, u8 *mac)
 
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait) {
-		status = -1;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	status = mwifiex_bss_ioctl_stop(priv, wait, mac);
 
 	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
 
-done:
 	kfree(wait);
 	return status;
 }
@@ -305,10 +299,8 @@ int mwifiex_bss_start(struct mwifiex_private *priv, u8 wait_option,
 
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait) {
-		status = -1;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	if (ssid_bssid)
 		memcpy(&tmp_ssid_bssid, ssid_bssid,
@@ -316,7 +308,7 @@ int mwifiex_bss_start(struct mwifiex_private *priv, u8 wait_option,
 	status = mwifiex_bss_ioctl_start(priv, wait, &tmp_ssid_bssid);
 
 	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
-done:
+
 	kfree(wait);
 	return status;
 }
@@ -336,10 +328,8 @@ int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
 
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait) {
-		ret = -1;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	memset(rate, 0, sizeof(struct mwifiex_rate_cfg));
 	rate->action = HostCmd_ACT_GEN_GET;
@@ -356,7 +346,7 @@ int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
 	} else {
 		ret = -1;
 	}
-done:
+
 	kfree(wait);
 	return ret;
 }
@@ -374,22 +364,18 @@ int mwifiex_set_get_hs_params(struct mwifiex_private *priv, u16 action,
 	int ret = 0;
 	struct mwifiex_wait_queue *wait = NULL;
 
-	if (!hscfg) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!hscfg)
+		return -ENOMEM;
+
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	ret = mwifiex_pm_ioctl_hs_cfg(priv, wait, action, hscfg);
 
 	ret = mwifiex_request_ioctl(priv, wait, ret, wait_option);
 
-done:
 	if (wait && (ret != -EINPROGRESS))
 		kfree(wait);
 	return ret;
@@ -426,12 +412,10 @@ EXPORT_SYMBOL_GPL(mwifiex_cancel_hs);
 int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 {
 	struct mwifiex_ds_hs_cfg hscfg;
-	int hs_actived = false;
 
 	if (adapter->hs_activated) {
 		PRINTM(MCMND, "HS Already actived\n");
-		hs_actived = true;
-		goto done;
+		return true;
 	}
 
 	/* Enable Host Sleep */
@@ -445,15 +429,13 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 				      HostCmd_ACT_GEN_SET,
 				      MWIFIEX_IOCTL_WAIT, &hscfg)) {
 		PRINTM(MERROR, "IOCTL request HS enable failed\n");
-		goto done;
+		return false;
 	}
 
 	wait_event_interruptible(adapter->hs_activate_wait_q,
 			adapter->hs_activate_wait_q_woken);
-	hs_actived = true;
 
-done:
-	return hs_actived;
+	return true;
 }
 EXPORT_SYMBOL_GPL(mwifiex_enable_hs);
 
@@ -473,15 +455,13 @@ int mwifiex_get_info_signal(struct mwifiex_private *priv,
 
 	if (!wait) {
 		PRINTM(MERROR, "WAIT information is not present\n");
-		ret = -1;
-		goto exit;
+		return -1;
 	}
 
 	/* Signal info can be obtained only if connected */
 	if (!priv->media_connected) {
 		PRINTM(MINFO, "Can not get signal in disconnected state\n");
-		ret = -1;
-		goto exit;
+		return -1;
 	}
 
 	/* Send request to firmware */
@@ -491,7 +471,6 @@ int mwifiex_get_info_signal(struct mwifiex_private *priv,
 	if (!ret)
 		ret = -EINPROGRESS;
 
-exit:
 	return ret;
 }
 
@@ -509,8 +488,7 @@ int mwifiex_get_info_stats(struct mwifiex_private *priv,
 
 	if (!wait) {
 		PRINTM(MERROR, "MWIFIEX IOCTL information is not present\n");
-		ret = -1;
-		goto exit;
+		return -1;
 	}
 
 	/* Send request to firmware */
@@ -520,7 +498,6 @@ int mwifiex_get_info_stats(struct mwifiex_private *priv,
 	if (!ret)
 		ret = -EINPROGRESS;
 
-exit:
 	return ret;
 }
 
@@ -534,7 +511,6 @@ int mwifiex_get_bss_info(struct mwifiex_private *priv,
 			 struct mwifiex_bss_info *info)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	int ret = 0;
 	struct mwifiex_bssdescriptor *bss_desc;
 	s32 tbl_idx = 0;
 
@@ -596,7 +572,7 @@ int mwifiex_get_bss_info(struct mwifiex_private *priv,
 	info->is_hs_configured = adapter->is_hs_configured;
 	info->is_deep_sleep = adapter->is_deep_sleep;
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -637,10 +613,8 @@ int mwifiex_snmp_mib_ioctl(struct mwifiex_private *priv,
 {
 	int ret = 0;
 
-	if (!value) {
-		ret = -1;
-		goto done;
-	}
+	if (!value)
+		return -1;
 
 	/* Send request to firmware */
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
@@ -649,7 +623,6 @@ int mwifiex_snmp_mib_ioctl(struct mwifiex_private *priv,
 	if (!ret)
 		ret = -EINPROGRESS;
 
-done:
 	return ret;
 }
 
@@ -762,8 +735,7 @@ int mwifiex_radio_ioctl_ant_cfg(struct mwifiex_private *priv,
 		    && (*antenna != RF_ANTENNA_AUTO
 			|| adapter->number_of_antenna <= 1)) {
 			PRINTM(MERROR, "Invalid antenna setting\n");
-			ret = -1;
-			goto exit;
+			return -1;
 		}
 	}
 
@@ -778,7 +750,6 @@ int mwifiex_radio_ioctl_ant_cfg(struct mwifiex_private *priv,
 	if (!ret)
 		ret = -EINPROGRESS;
 
-exit:
 	return ret;
 }
 
@@ -797,8 +768,7 @@ int mwifiex_bss_ioctl_mac_address(struct mwifiex_private *priv,
 	if ((action == HostCmd_ACT_GEN_GET) && mac) {
 		memcpy(mac, priv->curr_addr,
 		       MWIFIEX_MAC_ADDR_LENGTH);
-		ret = 0;
-		goto exit;
+		return 0;
 	}
 
 	/* Send request to firmware */
@@ -806,7 +776,7 @@ int mwifiex_bss_ioctl_mac_address(struct mwifiex_private *priv,
 				  action, 0, wait, mac);
 	if (!ret)
 		ret = -EINPROGRESS;
-exit:
+
 	return ret;
 }
 
@@ -828,10 +798,9 @@ int mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *priv,
 	u16 old_pkt_filter;
 
 	old_pkt_filter = priv->curr_pkt_filter;
-	if (action == HostCmd_ACT_GEN_GET) {
-		ret = -1;
-		goto exit;
-	}
+	if (action == HostCmd_ACT_GEN_GET)
+		return -1;
+
 	if (mcast_list->mode == MWIFIEX_PROMISC_MODE) {
 		PRINTM(MINFO, "Enable Promiscuous mode\n");
 		priv->curr_pkt_filter |= HostCmd_ACT_MAC_PROMISCUOUS_ENABLE;
@@ -878,7 +847,6 @@ int mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *priv,
 			ret = -EINPROGRESS;
 	}
 
-exit:
 	return ret;
 }
 
@@ -893,7 +861,9 @@ int mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_chan_freq_power *cfp = NULL;
-	int ret = 0;
+
+	if (!chan)
+		return -1;
 
 	if (action == HostCmd_ACT_GEN_GET) {
 		cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211(priv,
@@ -903,12 +873,10 @@ int mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
 							   curr_bss_params.
 							   bss_descriptor.
 							   channel);
-		if (chan) {
-			chan->channel = cfp->channel;
-			chan->freq = cfp->freq;
-		} else
-			ret = -1;
-		return ret;
+		chan->channel = cfp->channel;
+		chan->freq = cfp->freq;
+
+		return 0;
 	}
 	if (!chan->channel && !chan->freq)
 		return -1;
@@ -962,7 +930,7 @@ int mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
 	chan->channel = cfp->channel;
 	chan->freq = cfp->freq;
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -980,22 +948,20 @@ int mwifiex_bss_ioctl_mode(struct mwifiex_private *priv,
 {
 	int ret = 0;
 
-	if (!mode) {
-		ret = -1;
-		goto exit;
-	}
+	if (!mode)
+		return -1;
+
 	if (action == HostCmd_ACT_GEN_GET) {
 		*mode = priv->bss_mode;
-		goto exit;
+		return 0;
 	}
 
 	if ((priv->bss_mode == *mode) || (*mode == MWIFIEX_BSS_MODE_AUTO)) {
 		PRINTM(MINFO, "Already set to required mode! No change!\n");
 		priv->bss_mode = *mode;
-		goto exit;
+		return 0;
 	}
 
-
 	ret = mwifiex_deauthenticate(priv, wait, NULL);
 
 	priv->sec_info.authentication_mode = MWIFIEX_AUTH_MODE_OPEN;
@@ -1006,7 +972,7 @@ int mwifiex_bss_ioctl_mode(struct mwifiex_private *priv,
 		if (!ret)
 			ret = -EINPROGRESS;
 	}
-exit:
+
 	return ret;
 }
 
@@ -1026,16 +992,14 @@ int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 	s32 i = -1;
 
 	priv->scan_block = false;
-	if (!ssid_bssid) {
-		ret = -1;
-		goto start_ssid_done;
-	}
+	if (!ssid_bssid)
+		return -1;
 
 	if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA) {
 		/* Infra mode */
 		ret = mwifiex_deauthenticate(priv, NULL, NULL);
 		if (ret)
-			goto start_ssid_done;
+			return ret;
 
 		/* Search for the requested SSID in the scan table */
 		if (ssid_bssid->ssid.ssid_len) {
@@ -1058,10 +1022,9 @@ int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 			ret = mwifiex_associate(priv, wait,
 						&adapter->scan_table[i]);
 			if (ret)
-				goto start_ssid_done;
+				return ret;
 		} else {	/* i >= 0 */
-			ret = -1;
-			goto start_ssid_done;
+			return -1;
 		}
 	} else {
 		/* Adhoc mode */
@@ -1069,16 +1032,14 @@ int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 		if (ssid_bssid->ssid.ssid_len &&
 		    (!mwifiex_ssid_cmp
 		     (&priv->curr_bss_params.bss_descriptor.ssid,
-		      &ssid_bssid->ssid))) {
-			ret = 0;
-			goto start_ssid_done;
-		}
+		      &ssid_bssid->ssid)))
+			return 0;
 
 		/* Exit Adhoc mode first */
 		PRINTM(MINFO, "Sending Adhoc Stop\n");
 		ret = mwifiex_deauthenticate(priv, NULL, NULL);
 		if (ret)
-			goto start_ssid_done;
+			return ret;
 
 		priv->adhoc_is_link_sensed = false;
 
@@ -1099,7 +1060,7 @@ int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 			ret = mwifiex_adhoc_join(priv, wait,
 						 &adapter->scan_table[i]);
 			if (ret)
-				goto start_ssid_done;
+				return ret;
 		} else {	/* i >= 0 */
 			PRINTM(MINFO, "Network not found in the list, "
 			       "creating adhoc with ssid = %s\n",
@@ -1107,14 +1068,13 @@ int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 			ret = mwifiex_adhoc_start(priv, wait,
 						  &ssid_bssid->ssid);
 			if (ret)
-				goto start_ssid_done;
+				return ret;
 		}
 	}
 
 	if (!ret)
 		ret = -EINPROGRESS;
 
-start_ssid_done:
 	return ret;
 }
 
@@ -1143,7 +1103,7 @@ int mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *priv,
 	if (action == HostCmd_ACT_GEN_GET) {
 		if (!priv->media_connected) {
 			*channel = priv->adhoc_channel;
-			goto exit;
+			return ret;
 		}
 	} else {
 		priv->adhoc_channel = (u8) *channel;
@@ -1155,7 +1115,6 @@ int mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *priv,
 	if (!ret)
 		ret = -EINPROGRESS;
 
-exit:
 	return ret;
 }
 
@@ -1241,17 +1200,13 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 	memset(&bss_info, 0, sizeof(bss_info));
 
 	/* Get BSS information */
-	if (mwifiex_get_bss_info(priv, &bss_info)) {
-		ret = -1;
-		goto done;
-	}
+	if (mwifiex_get_bss_info(priv, &bss_info))
+		return -1;
 
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait) {
-		ret = -1;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	/* Get current channel */
 	status = mwifiex_bss_ioctl_ibss_channel(priv, wait, HostCmd_ACT_GEN_GET,
@@ -1442,8 +1397,7 @@ static int mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
 		if (!rate[i] || (i == MWIFIEX_SUPPORTED_RATES)) {
 			PRINTM(MERROR, "The fixed data rate 0x%X is out "
 			       "of range\n", rate_cfg->rate);
-			ret = -1;
-			goto exit;
+			return -1;
 		}
 		memset(bitmap_rates, 0, sizeof(bitmap_rates));
 
@@ -1470,7 +1424,6 @@ static int mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
 	if (!ret)
 		ret = -EINPROGRESS;
 
-exit:
 	return ret;
 }
 
@@ -1624,15 +1577,13 @@ int mwifiex_power_ioctl_set_power(struct mwifiex_private *priv,
 					"range (%d dBm-%d dBm)!\n",
 					dbm, priv->min_tx_power_level,
 					priv->max_tx_power_level);
-			ret = -1;
-			goto exit;
+			return -1;
 		}
 	}
 	buf = kzalloc(MWIFIEX_SIZE_OF_CMD_BUFFER, GFP_KERNEL);
 	if (!buf) {
 		PRINTM(MERROR, "%s: failed to alloc cmd buffer\n", __func__);
-		ret = -1;
-		goto exit;
+		return -1;
 	}
 
 	txp_cfg = (struct host_cmd_ds_txpwr_cfg *) buf;
@@ -1692,7 +1643,6 @@ int mwifiex_power_ioctl_set_power(struct mwifiex_private *priv,
 		ret = -EINPROGRESS;
 	kfree(buf);
 
-exit:
 	return ret;
 }
 
@@ -2031,8 +1981,7 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
 		wep_key = &priv->wep_key[index];
 		if (!wep_key->key_length) {
 			PRINTM(MERROR, "Key not set, so cannot enable it\n");
-			ret = -1;
-			goto exit;
+			return -1;
 		}
 		priv->wep_key_curr_index = (u16) index;
 		priv->sec_info.wep_status = MWIFIEX_802_11_WEP_ENABLED;
@@ -2062,7 +2011,7 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
 					  HostCmd_CMD_802_11_KEY_MATERIAL,
 					  HostCmd_ACT_GEN_SET, 0, NULL, NULL);
 		if (ret)
-			goto exit;
+			return ret;
 	}
 	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED)
 		priv->curr_pkt_filter |= HostCmd_ACT_MAC_WEP_ENABLE;
@@ -2076,7 +2025,6 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
 	if (!ret)
 		ret = -EINPROGRESS;
 
-exit:
 	return ret;
 }
 
@@ -2102,8 +2050,7 @@ static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
 	/* Current driver only supports key length of up to 32 bytes */
 	if (encrypt_key->key_len > MWIFIEX_MAX_KEY_LENGTH) {
 		PRINTM(MERROR, " Error in key length\n");
-		ret = -1;
-		goto exit;
+		return -1;
 	}
 
 	if (priv->bss_mode == MWIFIEX_BSS_MODE_IBSS) {
@@ -2119,7 +2066,7 @@ static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
 					  KEY_INFO_ENABLED,
 					  NULL, encrypt_key);
 		if (ret)
-			goto exit;
+			return ret;
 
 		ibss_key = &priv->aes_key;
 		memset(ibss_key, 0,
@@ -2159,7 +2106,6 @@ static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
 	if (!ret)
 		ret = -EINPROGRESS;
 
-exit:
 	return ret;
 }
 
@@ -2172,7 +2118,6 @@ static int mwifiex_sec_ioctl_get_key(struct mwifiex_adapter *adapter,
 			  struct mwifiex_wait_queue *wait,
 			  struct mwifiex_ds_encrypt_key *encrypt_key)
 {
-	int ret = 0;
 	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
 	int index;
 
@@ -2237,7 +2182,7 @@ static int mwifiex_sec_ioctl_get_key(struct mwifiex_adapter *adapter,
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -2338,10 +2283,8 @@ int mwifiex_sec_ioctl_esupp_mode(struct mwifiex_private *priv,
 {
 	int ret = 0;
 
-	if (priv->media_connected != true) {
-		ret = -1;
-		goto exit;
-	}
+	if (priv->media_connected != true)
+		return -1;
 
 	/* Send request to firmware */
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_SUPPLICANT_PROFILE,
@@ -2350,7 +2293,6 @@ int mwifiex_sec_ioctl_esupp_mode(struct mwifiex_private *priv,
 	if (!ret)
 		ret = -EINPROGRESS;
 
-exit:
 	return ret;
 }
 
@@ -2388,14 +2330,10 @@ mwifiex_drv_set_deep_sleep(struct mwifiex_private *priv, u8 wait_option,
 	status = mwifiex_pm_ioctl_deep_sleep(priv, wait, &auto_deep_sleep,
 					     HostCmd_ACT_GEN_SET);
 
-	if (mwifiex_request_ioctl(priv, wait, status, wait_option)) {
+	if (mwifiex_request_ioctl(priv, wait, status, wait_option))
 		ret = -EFAULT;
-		goto done;
-	}
 
-done:
 	kfree(wait);
-
 	return ret;
 }
 
@@ -2441,7 +2379,6 @@ int
 mwifiex_set_hs_cfg(struct mwifiex_private *priv, int cond, int gap,
 		   int data_length, int invoke_hostcmd)
 {
-	int ret = 0;
 	struct mwifiex_ds_hs_cfg hscfg;
 
 	memset(&hscfg, 0, sizeof(struct mwifiex_hs_config_param));
@@ -2449,8 +2386,7 @@ mwifiex_set_hs_cfg(struct mwifiex_private *priv, int cond, int gap,
 	/* HS config is blocked if HS is already activated */
 	if (priv->adapter->is_hs_configured) {
 		PRINTM(MERROR, "HS already configured\n");
-		ret = -EFAULT;
-		goto done;
+		return -EFAULT;
 	}
 
 	hscfg.conditions = cond;
@@ -2459,12 +2395,10 @@ mwifiex_set_hs_cfg(struct mwifiex_private *priv, int cond, int gap,
 	hscfg.gpio = HOST_SLEEP_CFG_GPIO_DEF;
 	hscfg.is_invoke_hostcmd = invoke_hostcmd;
 	if (mwifiex_set_get_hs_params(priv, HostCmd_ACT_GEN_SET,
-				      MWIFIEX_IOCTL_WAIT, &hscfg)) {
-		ret = -EFAULT;
-		goto done;
-	}
-done:
-	return ret;
+				      MWIFIEX_IOCTL_WAIT, &hscfg))
+		return -EFAULT;
+
+	return 0;
 }
 
 /*
@@ -2483,10 +2417,8 @@ mwifiex_11n_get_amsdu_params(struct mwifiex_private *priv, int *amsdu_enable,
 	int ret = 0;
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	status = mwifiex_11n_ioctl_amsdu_aggr_ctrl(priv->adapter, wait,
 						   &amsdu_aggr_ctrl,
@@ -2499,7 +2431,6 @@ mwifiex_11n_get_amsdu_params(struct mwifiex_private *priv, int *amsdu_enable,
 		*curr_buf_size = amsdu_aggr_ctrl.curr_buf_size;
 	}
 
-done:
 	kfree(wait);
 	return ret;
 }
@@ -2519,10 +2450,8 @@ mwifiex_11n_amsdu_aggr_ctrl(struct mwifiex_private *priv, int amsdu_enable)
 	int ret = 0;
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	amsdu_aggr_ctrl.enable = amsdu_enable;
 
@@ -2537,7 +2466,7 @@ mwifiex_11n_amsdu_aggr_ctrl(struct mwifiex_private *priv, int amsdu_enable)
 	else
 		PRINTM(MINFO,
 		       "Successfully enabled amsdu aggregation feature\n");
-done:
+
 	kfree(wait);
 	return ret;
 }
@@ -2588,15 +2517,13 @@ mwifiex_get_tx_aggr_prio_tbl(struct mwifiex_private *priv, int *data)
 {
 	struct mwifiex_ds_11n_aggr_prio_tbl aggr_prio_tbl;
 	int status = 0;
-	int ret = 0, i, j;
+	int i, j;
 
 	status = mwifiex_11n_ioctl_aggr_prio_tbl(priv, &aggr_prio_tbl,
 						 HostCmd_ACT_GEN_GET);
 
-	if (status) {
-		ret = -EFAULT;
-		goto done;
-	}
+	if (status)
+		return -EFAULT;
 
 	for (i = 0, j = 0; i < (MAX_NUM_TID * 2); i = i + 2, ++j) {
 		data[i] = aggr_prio_tbl.ampdu[j];
@@ -2604,8 +2531,7 @@ mwifiex_get_tx_aggr_prio_tbl(struct mwifiex_private *priv, int *data)
 
 	}
 
-done:
-	return ret;
+	return 0;
 }
 
 /*
@@ -2619,7 +2545,7 @@ mwifiex_tx_aggr_prio_tbl(struct mwifiex_private *priv, int *data, int length)
 {
 	struct mwifiex_ds_11n_aggr_prio_tbl aggr_prio_tbl;
 	int status = 0;
-	int ret = 0, i, j;
+	int i, j;
 
 	for (i = 0, j = 0; i < (length); i = i + 2, ++j) {
 		aggr_prio_tbl.ampdu[j] = data[i];
@@ -2629,9 +2555,9 @@ mwifiex_tx_aggr_prio_tbl(struct mwifiex_private *priv, int *data, int length)
 	status = mwifiex_11n_ioctl_aggr_prio_tbl(priv, &aggr_prio_tbl,
 						 HostCmd_ACT_GEN_SET);
 	if (status)
-		ret = -EFAULT;
+		return -EFAULT;
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -2649,10 +2575,8 @@ mwifiex_set_sleep_pd(struct mwifiex_private *priv, int sleeppd)
 	struct mwifiex_wait_queue *wait = NULL;
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	if ((sleeppd <= MAX_SLEEP_PERIOD && sleeppd >= MIN_SLEEP_PERIOD)
 	    || (sleeppd == 0) || (sleeppd == SLEEP_PERIOD_RESERVED_FF)) {
@@ -2686,10 +2610,8 @@ mwifiex_get_sleep_pd(struct mwifiex_private *priv, int *sleeppd)
 	struct mwifiex_wait_queue *wait = NULL;
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	status = mwifiex_pm_ioctl_sleep_pd(priv, wait, &sleep_period,
 					   HostCmd_ACT_GEN_GET);
@@ -2698,7 +2620,7 @@ mwifiex_get_sleep_pd(struct mwifiex_private *priv, int *sleeppd)
 
 	if (!ret)
 		*sleeppd = sleep_period;
-done:
+
 	kfree(wait);
 	return ret;
 }
@@ -2742,10 +2664,8 @@ mwifiex_set_tx_power(struct mwifiex_private *priv, int type, int dbm)
 	int ret = 0;
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	if (type == NL80211_TX_POWER_FIXED) {
 		power_cfg.is_power_auto = 0;
@@ -2757,7 +2677,6 @@ mwifiex_set_tx_power(struct mwifiex_private *priv, int type, int dbm)
 
 	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
 
-done:
 	kfree(wait);
 	return ret;
 }
@@ -2773,24 +2692,18 @@ mwifiex_set_gen_ie(struct mwifiex_private *priv, u8 *ie, int ie_len)
 {
 	struct mwifiex_ds_misc_gen_ie gen_ie;
 	int status = 0;
-	int ret = 0;
 
-	if (ie_len > IW_CUSTOM_MAX) {
-		ret = -EFAULT;
-		goto done;
-	}
+	if (ie_len > IW_CUSTOM_MAX)
+		return -EFAULT;
 
 	gen_ie.type = MWIFIEX_IE_TYPE_GEN_IE;
 	gen_ie.len = ie_len;
 	memcpy(gen_ie.ie_data, ie, ie_len);
 	status = mwifiex_misc_ioctl_gen_ie(priv, &gen_ie, HostCmd_ACT_GEN_SET);
-	if (status) {
-		ret = -EFAULT;
-		goto done;
-	}
+	if (status)
+		return -EFAULT;
 
-done:
-	return ret;
+	return 0;
 }
 
 /*
@@ -2809,7 +2722,7 @@ int mwifiex_get_scan_table(struct mwifiex_private *priv, u8 wait_option,
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait)
-		return -1;
+		return -ENOMEM;
 
 	status = mwifiex_scan_networks(priv, wait, HostCmd_ACT_GEN_GET,
 				       NULL, &scan);
@@ -2843,7 +2756,7 @@ int mwifiex_get_signal_info(struct mwifiex_private *priv, u8 wait_option,
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait)
-		return -1;
+		return -ENOMEM;
 
 	info.selector = ALL_RSSI_INFO_MASK;
 
@@ -2886,15 +2799,13 @@ int
 mwifiex_set_auth(struct mwifiex_private *priv, int encrypt_mode,
 		 int auth_mode, int wpa_enabled)
 {
-	int ret = 0;
-
 	if (mwifiex_set_encrypt_mode(priv, MWIFIEX_IOCTL_WAIT, encrypt_mode))
-		ret = -EFAULT;
+		return -EFAULT;
 
 	if (mwifiex_set_auth_mode(priv, auth_mode))
-		ret = -EFAULT;
+		return -EFAULT;
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -2919,10 +2830,8 @@ mwifiex_set_encode(struct mwifiex_private *priv, u32 cipher, const u8 *key,
 	int ret = 0;
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	encrypt_key.key_len = key_len;
 	if (!disable) {
@@ -2952,7 +2861,8 @@ mwifiex_set_encode(struct mwifiex_private *priv, u32 cipher, const u8 *key,
 	} else {
 		encrypt_key.key_disable = true;
 	}
-		status = mwifiex_sec_ioctl_encrypt_key(priv, wait, &encrypt_key,
+
+	status = mwifiex_sec_ioctl_encrypt_key(priv, wait, &encrypt_key,
 						       HostCmd_ACT_GEN_SET);
 
 	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT))
@@ -2977,10 +2887,8 @@ mwifiex_drv_set_power(struct mwifiex_private *priv, bool power_on)
 	u32 ps_mode;
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	ps_mode = power_on;
 	status = mwifiex_pm_ioctl_ps_mode(priv, wait, &ps_mode,
@@ -2988,7 +2896,6 @@ mwifiex_drv_set_power(struct mwifiex_private *priv, bool power_on)
 
 	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
 
-done:
 	kfree(wait);
 	return ret;
 }
@@ -3019,12 +2926,9 @@ mwifiex_get_ver_ext(struct mwifiex_private *priv)
 
 	ret = mwifiex_request_ioctl(priv, wait, status, wait_option);
 
-	if (ret) {
+	if (ret)
 		ret = -1;
-		goto done;
-	}
 
-done:
 	kfree(wait);
 	return ret;
 }
@@ -3045,22 +2949,17 @@ mwifiex_set_tx_rx_ant(struct mwifiex_private *priv, int antenna)
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	ant = antenna;
 	status = mwifiex_radio_ioctl_ant_cfg(priv, wait, HostCmd_ACT_GEN_SET,
 					     &ant);
 
 	ret = mwifiex_request_ioctl(priv, wait, status, wait_option);
-	if (ret) {
+	if (ret)
 		ret = -EFAULT;
-		goto done;
-	}
 
-done:
 	kfree(wait);
 	return ret;
 }
@@ -3081,10 +2980,8 @@ mwifiex_get_tx_rx_ant(struct mwifiex_private *priv, int *antenna)
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	status = mwifiex_radio_ioctl_ant_cfg(priv, wait, HostCmd_ACT_GEN_GET,
 					     &ant);
@@ -3120,10 +3017,8 @@ mwifiex_get_stats_info(struct mwifiex_private *priv,
 
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	memset(&get_log, 0, sizeof(struct mwifiex_ds_get_stats));
 	status = mwifiex_get_info_stats(priv, wait, &get_log);
@@ -3138,7 +3033,7 @@ mwifiex_get_stats_info(struct mwifiex_private *priv,
 		priv->w_stats.discard.retries = get_log.retry;
 		priv->w_stats.discard.misc = get_log.ack_failure;
 	}
-done:
+
 	kfree(wait);
 	return ret;
 }
@@ -3159,10 +3054,8 @@ mwifiex_reg_write(struct mwifiex_private *priv, u32 reg_type,
 	struct mwifiex_ds_reg_rw reg_rw;
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	reg_rw.type = cpu_to_le32(reg_type);
 	reg_rw.offset = cpu_to_le32(reg_offset);
@@ -3172,7 +3065,6 @@ mwifiex_reg_write(struct mwifiex_private *priv, u32 reg_type,
 
 	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
 
-done:
 	kfree(wait);
 	return ret;
 }
@@ -3193,10 +3085,8 @@ mwifiex_reg_read(struct mwifiex_private *priv, u32 reg_type,
 	struct mwifiex_ds_reg_rw reg_rw;
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	reg_rw.type = cpu_to_le32(reg_type);
 	reg_rw.offset = cpu_to_le32(reg_offset);
@@ -3230,10 +3120,8 @@ mwifiex_eeprom_read(struct mwifiex_private *priv, u16 offset, u16 bytes,
 	struct mwifiex_ds_read_eeprom rd_eeprom;
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	rd_eeprom.offset = cpu_to_le16((u16) offset);
 	rd_eeprom.byte_count = cpu_to_le16((u16) bytes);
@@ -3264,10 +3152,8 @@ mwifiex_set_11n_httx_cfg(struct mwifiex_private *priv, int data)
 	int ret = 0;
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	tx_cfg.tx_htcap = data;
 	status = mwifiex_11n_ioctl_ht_tx_cfg(priv->adapter, wait, &tx_cfg,
@@ -3275,7 +3161,6 @@ mwifiex_set_11n_httx_cfg(struct mwifiex_private *priv, int data)
 
 	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
 
-done:
 	kfree(wait);
 	return ret;
 }
@@ -3295,10 +3180,8 @@ mwifiex_get_11n_httx_cfg(struct mwifiex_private *priv, int *data)
 	int ret = 0;
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	status = mwifiex_11n_ioctl_ht_tx_cfg(priv->adapter, wait, &tx_cfg,
 					     HostCmd_ACT_GEN_GET);
@@ -3356,10 +3239,8 @@ mwifiex_set_tx_rate_cfg(struct mwifiex_private *priv, int tx_rate_idx)
 
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	memset(&rate_cfg, 0, sizeof(struct mwifiex_rate_cfg));
 	rate_cfg.action = HostCmd_ACT_GEN_SET;
@@ -3377,11 +3258,8 @@ mwifiex_set_tx_rate_cfg(struct mwifiex_private *priv, int tx_rate_idx)
 	}
 	status = mwifiex_rate_ioctl_cfg(priv, wait, &rate_cfg);
 
-
-	if (mwifiex_request_ioctl(priv, wait, status, wait_option)) {
+	if (mwifiex_request_ioctl(priv, wait, status, wait_option))
 		ret = -EFAULT;
-		goto done;
-	}
 done:
 	kfree(wait);
 	return ret;
@@ -3409,10 +3287,8 @@ mwifiex_get_tx_rate_cfg(struct mwifiex_private *priv, int *tx_rate_idx)
 	}
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (!wait)
+		return -ENOMEM;
 
 	memset(&rate_cfg, 0, sizeof(struct mwifiex_rate_cfg));
 	rate_cfg.action = HostCmd_ACT_GEN_GET;
@@ -3490,11 +3366,9 @@ mwifiex_set_addba_param(struct mwifiex_private *priv, int *data)
 					       &addba_param,
 					       HostCmd_ACT_GEN_SET);
 
-	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
+	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT))
 		ret = -EFAULT;
-		goto done;
-	}
-done:
+
 	kfree(wait);
 	return ret;
 }
@@ -3559,12 +3433,9 @@ int mwifiex_set_passphrase(struct mwifiex_private *priv, int action,
 	status = mwifiex_sec_ioctl_passphrase(priv, wait, ds_passphrase,
 					      action);
 
-	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
+	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT))
 		ret = -EFAULT;
-		goto done;
-	}
 
-done:
 	kfree(wait);
 	return ret;
 }
@@ -3717,8 +3588,7 @@ int mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_private *priv,
 		cmd_no = HostCmd_CMD_CAU_REG_ACCESS;
 		break;
 	default:
-		ret = -1;
-		goto exit;
+		return -1;
 	}
 
 	/* Send request to firmware */
@@ -3727,7 +3597,6 @@ int mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_private *priv,
 	if (!ret)
 		ret = -EINPROGRESS;
 
-exit:
 	return ret;
 }
 
@@ -3741,7 +3610,6 @@ int mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *priv,
 			      struct mwifiex_ds_misc_gen_ie *gen_ie,
 			      u16 action)
 {
-	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
 	switch (gen_ie->type) {
@@ -3760,7 +3628,7 @@ int mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *priv,
 		if (gen_ie->len > ARP_FILTER_MAX_BUF_SIZE) {
 			adapter->arp_filter_size = 0;
 			PRINTM(MERROR, "Invalid ARP Filter Size\n");
-			ret = -1;
+			return -1;
 		} else {
 			memcpy(adapter->arp_filter, gen_ie->ie_data,
 								gen_ie->len);
@@ -3771,9 +3639,9 @@ int mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *priv,
 		break;
 	default:
 		PRINTM(MERROR, "Invalid IE type\n");
-		ret = -1;
+		return -1;
 	}
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index cf001d7..d7efd11 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -150,11 +150,11 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 		       local_rx_pd->rx_pkt_offset, local_rx_pd->rx_pkt_length);
 		priv->stats.rx_dropped++;
 		dev_kfree_skb_any(skb);
-		goto done;
+		return ret;
 	}
 	if (local_rx_pd->rx_pkt_type == PKT_TYPE_AMSDU) {
 		mwifiex_11n_deaggregate_pkt(priv, skb);
-		goto done;
+		return ret;
 	}
 	/*
 	 * If the packet is not an unicast packet then send the packet
@@ -164,7 +164,7 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 	    memcmp(priv->curr_addr, rx_pkt_hdr->eth803_hdr.h_dest,
 		   MWIFIEX_MAC_ADDR_LENGTH)) {
 		mwifiex_process_rx_packet(adapter, skb);
-		goto done;
+		return ret;
 	}
 
 	if (mwifiex_queuing_ra_based(priv)) {
@@ -191,6 +191,6 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 
 		dev_kfree_skb_any(skb);
 	}
-done:
+
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index 273ae8b..f457e24 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -54,7 +54,7 @@ mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 		PRINTM(MERROR, "Tx Error: bad packet length: %d\n",
 		       skb->len);
 		tx_info->status_code = MWIFIEX_ERROR_PKT_SIZE_INVALID;
-		goto done;
+		return skb->data;
 	}
 
 	BUG_ON(skb_headroom(skb) < (sizeof(*local_tx_pd) + INTF_HEADER_LEN));
@@ -101,7 +101,6 @@ mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 		local_tx_pd->tx_control = cpu_to_le32(priv->pkt_tx_ctrl);
 	}
 
-done:
 	return skb->data;
 }
 
@@ -122,26 +121,18 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 	int ret = 0;
 	struct mwifiex_txinfo *tx_info = NULL;
 
-	if (adapter->surprise_removed) {
-		ret = -1;
-		goto done;
-	}
+	if (adapter->surprise_removed)
+		return -1;
 
-	if (!priv->media_connected) {
-		ret = -1;
-		goto done;
-	}
+	if (!priv->media_connected)
+		return -1;
 
-	if (adapter->data_sent) {
-		ret = -1;
-		goto done;
-	}
+	if (adapter->data_sent)
+		return -1;
 
 	skb = dev_alloc_skb(data_len);
-	if (!skb) {
-		ret = -1;
-		goto done;
-	}
+	if (!skb)
+		return -1;
 
 	tx_info = MWIFIEX_SKB_TXCB(skb);
 	tx_info->bss_index = priv->bss_index;
@@ -170,7 +161,7 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 		       "TX Error: mwifiex_send_null_packet failed! ret=%d\n",
 		       ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
-		goto done;
+		break;
 	case 0:
 		dev_kfree_skb_any(skb);
 		PRINTM(MDATA, "TX: mwifiex_send_null_packet succeeded!\n");
@@ -182,7 +173,6 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 		break;
 	}
 
-done:
 	return ret;
 }
 
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 4500142..7f94cc4 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -70,23 +70,20 @@ EXPORT_SYMBOL_GPL(mwifiex_handle_rx_packet);
 int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 		       struct mwifiex_tx_param *tx_param)
 {
-	int ret = 0;
+	int ret = -1;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u8 *head_ptr = NULL;
 	struct txpd *local_tx_pd = NULL;
 
 	head_ptr = (u8 *) mwifiex_process_sta_txpd(priv, skb);
-	if (!head_ptr) {
-		ret = -1;
-		goto done;
-	}
+	if (head_ptr) {
+		if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA)
+			local_tx_pd =
+				(struct txpd *) (head_ptr + INTF_HEADER_LEN);
 
-	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA)
-		local_tx_pd = (struct txpd *) (head_ptr + INTF_HEADER_LEN);
-
-	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
+		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
 					     skb->data, skb->len, tx_param);
-done:
+	}
 
 	switch (ret) {
 	case -EBUSY:
@@ -178,7 +175,6 @@ int mwifiex_recv_packet_complete(struct mwifiex_adapter *adapter,
 				 struct sk_buff *skb,
 				 int status)
 {
-	int ret = 0;
 	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
 	struct mwifiex_rxinfo *rx_info_parent = NULL;
 	struct mwifiex_private *priv;
@@ -207,5 +203,5 @@ int mwifiex_recv_packet_complete(struct mwifiex_adapter *adapter,
 		dev_kfree_skb_any(skb);
 	}
 
-	return ret;
+	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 07b8b43..05ae840 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -67,7 +67,7 @@ int mwifiex_misc_ioctl_init_shutdown(struct mwifiex_adapter *adapter,
 				     u32 func_init_shutdown)
 {
 	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
-	int ret = 0;
+	int ret;
 	u16 cmd;
 
 	if (func_init_shutdown == MWIFIEX_FUNC_INIT) {
@@ -76,8 +76,7 @@ int mwifiex_misc_ioctl_init_shutdown(struct mwifiex_adapter *adapter,
 		cmd = HostCmd_CMD_FUNC_SHUTDOWN;
 	} else {
 		PRINTM(MERROR, "Unsupported parameter\n");
-		ret = -1;
-		goto exit;
+		return -1;
 	}
 
 	/* Send command to firmware */
@@ -87,7 +86,6 @@ int mwifiex_misc_ioctl_init_shutdown(struct mwifiex_adapter *adapter,
 	if (!ret)
 		ret = -EINPROGRESS;
 
-exit:
 	return ret;
 }
 
@@ -100,7 +98,6 @@ exit:
 int mwifiex_get_debug_info(struct mwifiex_private *priv,
 			   struct mwifiex_debug_info *info)
 {
-	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
 	if (info) {
@@ -158,7 +155,7 @@ int mwifiex_get_debug_info(struct mwifiex_private *priv,
 		info->cmd_resp_received = adapter->cmd_resp_received;
 	}
 
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 868e119..789632d 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -113,7 +113,7 @@ mwifiex_wmm_allocate_ralist_node(struct mwifiex_adapter *adapter, u8 *ra)
 
 	if (!ra_list) {
 		PRINTM(MERROR, "%s: failed to alloc ra_list\n", __func__);
-		goto done;
+		return NULL;
 	}
 	INIT_LIST_HEAD(&ra_list->list);
 	skb_queue_head_init(&ra_list->skb_head);
@@ -123,7 +123,7 @@ mwifiex_wmm_allocate_ralist_node(struct mwifiex_adapter *adapter, u8 *ra)
 	ra_list->total_pkts_size = 0;
 
 	PRINTM(MINFO, "RAList: Allocating buffers for TID %p\n", ra_list);
-done:
+
 	return ra_list;
 }
 
-- 
1.7.0.2

