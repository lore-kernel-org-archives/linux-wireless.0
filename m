Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15207 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab1GWOW0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 10:22:26 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 02/11] ath6kl: Move scan table from wmi to ath6kl
Date: Sat, 23 Jul 2011 19:43:08 +0530
Message-ID: <1311430397-4960-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110723_162229_420483_7965AB15)
In-Reply-To: <1311430397-4960-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1311430397-4960-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It does not need to be in wmi

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    2 ++
 drivers/net/wireless/ath/ath6kl/wmi.c  |   30 +++++++++++++++---------------
 drivers/net/wireless/ath/ath6kl/wmi.h  |    1 -
 3 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 6778475..f3f588a 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -455,6 +455,8 @@ struct ath6kl {
 	size_t fw_patch_len;
 
 	struct workqueue_struct *ath6kl_wq;
+
+	struct ath6kl_node_table scan_table;
 };
 
 static inline void *ath6kl_priv(struct net_device *dev)
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 9b06a82..2e1b411 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -390,7 +390,7 @@ void ath6kl_wmi_iterate_nodes(struct wmi *wmi,
 			      void (*f) (void *arg, struct bss *),
 			      void *arg)
 {
-	wlan_iterate_nodes(&wmi->scan_table, f, arg);
+	wlan_iterate_nodes(&wmi->parent_dev->scan_table, f, arg);
 }
 
 static void ath6kl_wmi_convert_bssinfo_hdr2_to_hdr(struct sk_buff *skb,
@@ -728,7 +728,7 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len)
 		return -EINVAL;
 
 	bih = (struct wmi_bss_info_hdr *) datap;
-	bss = wlan_find_node(&wmi->scan_table, bih->bssid);
+	bss = wlan_find_node(&wmi->parent_dev->scan_table, bih->bssid);
 
 	if (a_sle16_to_cpu(bih->rssi) > 0) {
 		if (bss == NULL)
@@ -777,7 +777,7 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len)
 			bih->snr = bss->ni_snr;
 		}
 
-		wlan_node_reclaim(&wmi->scan_table, bss);
+		wlan_node_reclaim(&wmi->parent_dev->scan_table, bss);
 	}
 
 	/*
@@ -862,7 +862,7 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len)
 	 * which is done in ath6kl_wlan_parse_beacon
 	 */
 	bss->ni_cie.ie_chan = le16_to_cpu(bih->ch);
-	wlan_setup_node(&wmi->scan_table, bss, bih->bssid);
+	wlan_setup_node(&wmi->parent_dev->scan_table, bss, bih->bssid);
 
 	return 0;
 }
@@ -883,10 +883,10 @@ static int ath6kl_wmi_opt_frame_event_rx(struct wmi *wmi, u8 *datap, int len)
 	ath6kl_dbg(ATH6KL_DBG_WMI, "opt frame event %2.2x:%2.2x\n",
 		   bih->bssid[4], bih->bssid[5]);
 
-	bss = wlan_find_node(&wmi->scan_table, bih->bssid);
+	bss = wlan_find_node(&wmi->parent_dev->scan_table, bih->bssid);
 	if (bss != NULL) {
 		/* Free up the node. We are about to allocate a new node. */
-		wlan_node_reclaim(&wmi->scan_table, bss);
+		wlan_node_reclaim(&wmi->parent_dev->scan_table, bss);
 	}
 
 	bss = wlan_node_alloc(len);
@@ -900,7 +900,7 @@ static int ath6kl_wmi_opt_frame_event_rx(struct wmi *wmi, u8 *datap, int len)
 		return -EINVAL;
 
 	memcpy(bss->ni_buf, buf, len);
-	wlan_setup_node(&wmi->scan_table, bss, bih->bssid);
+	wlan_setup_node(&wmi->parent_dev->scan_table, bss, bih->bssid);
 
 	return 0;
 }
@@ -1009,7 +1009,7 @@ static int ath6kl_wmi_scan_complete_rx(struct wmi *wmi, u8 *datap, int len)
 	ev = (struct wmi_scan_complete_event *) datap;
 
 	if (a_sle32_to_cpu(ev->status) == 0)
-		wlan_refresh_inactive_nodes(&wmi->scan_table);
+		wlan_refresh_inactive_nodes(&wmi->parent_dev->scan_table);
 
 	ath6kl_scan_complete_evt(wmi->parent_dev, a_sle32_to_cpu(ev->status));
 	wmi->is_probe_ssid = false;
@@ -2343,7 +2343,7 @@ s32 ath6kl_wmi_get_rate(s8 rate_index)
 void ath6kl_wmi_node_return(struct wmi *wmi, struct bss *bss)
 {
 	if (bss)
-		wlan_node_return(&wmi->scan_table, bss);
+		wlan_node_return(&wmi->parent_dev->scan_table, bss);
 }
 
 struct bss *ath6kl_wmi_find_ssid_node(struct wmi *wmi, u8 * ssid,
@@ -2352,7 +2352,7 @@ struct bss *ath6kl_wmi_find_ssid_node(struct wmi *wmi, u8 * ssid,
 {
 	struct bss *node = NULL;
 
-	node = wlan_find_ssid_node(&wmi->scan_table, ssid,
+	node = wlan_find_ssid_node(&wmi->parent_dev->scan_table, ssid,
 				  ssid_len, is_wpa2, match_ssid);
 	return node;
 }
@@ -2361,7 +2361,7 @@ struct bss *ath6kl_wmi_find_node(struct wmi *wmi, const u8 * mac_addr)
 {
 	struct bss *ni = NULL;
 
-	ni = wlan_find_node(&wmi->scan_table, mac_addr);
+	ni = wlan_find_node(&wmi->parent_dev->scan_table, mac_addr);
 
 	return ni;
 }
@@ -2370,9 +2370,9 @@ void ath6kl_wmi_node_free(struct wmi *wmi, const u8 * mac_addr)
 {
 	struct bss *ni = NULL;
 
-	ni = wlan_find_node(&wmi->scan_table, mac_addr);
+	ni = wlan_find_node(&wmi->parent_dev->scan_table, mac_addr);
 	if (ni != NULL)
-		wlan_node_reclaim(&wmi->scan_table, ni);
+		wlan_node_reclaim(&wmi->parent_dev->scan_table, ni);
 
 	return;
 }
@@ -2736,7 +2736,7 @@ void *ath6kl_wmi_init(struct ath6kl *dev)
 
 	wmi->parent_dev = dev;
 
-	wlan_node_table_init(wmi, &wmi->scan_table);
+	wlan_node_table_init(wmi, &dev->scan_table);
 	ath6kl_wmi_qos_state_init(wmi);
 
 	wmi->pwr_mode = REC_POWER;
@@ -2756,6 +2756,6 @@ void ath6kl_wmi_shutdown(struct wmi *wmi)
 	if (!wmi)
 		return;
 
-	wlan_node_table_cleanup(&wmi->scan_table);
+	wlan_node_table_cleanup(&wmi->parent_dev->scan_table);
 	kfree(wmi);
 }
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index afc9be9..1ef779d 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -116,7 +116,6 @@ struct wmi {
 	u8 fat_pipe_exist;
 	struct ath6kl *parent_dev;
 	struct wmi_stats stat;
-	struct ath6kl_node_table scan_table;
 	u8 bssid[ETH_ALEN];
 	u8 pwr_mode;
 	u8 phy_mode;
-- 
1.7.0.4

