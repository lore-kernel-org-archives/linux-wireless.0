Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:28784 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbbANKrw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 05:47:52 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0EAOBV1027959
	for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 02:47:52 -0800
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0a-0016f401.pphosted.com with ESMTP id 1rwj838p3j-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 02:47:52 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<gaoqs@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 09/10] mwifiex: channel switch support for mwifiex
Date: Wed, 14 Jan 2015 21:45:37 +0530
Message-ID: <1421252138-30157-10-git-send-email-patila@marvell.com> (sfid-20150114_114755_707807_C5B3338E)
In-Reply-To: <1421252138-30157-1-git-send-email-patila@marvell.com>
References: <1421252138-30157-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds cfg80211 channel_switch support for mwifiex.
Upon receiving channel switch request, driver would parse channel
switch announcement IE from beacon_data.
If TX is blocked, netdev queues are stopped. IEs from csa_beacon
are then parsed and set to FW.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Qingshui Gao <gaoqs@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/11h.c      | 37 ++++++++++++++
 drivers/net/wireless/mwifiex/cfg80211.c | 85 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/mwifiex/ie.c       | 12 ++++-
 drivers/net/wireless/mwifiex/main.h     |  5 ++
 4 files changed, 136 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11h.c b/drivers/net/wireless/mwifiex/11h.c
index 08c12ae..d794686 100644
--- a/drivers/net/wireless/mwifiex/11h.c
+++ b/drivers/net/wireless/mwifiex/11h.c
@@ -240,3 +240,40 @@ int mwifiex_11h_handle_radar_detected(struct mwifiex_private *priv,
 
 	return 0;
 }
+
+/* This is work queue function for channel switch handling.
+ * This function takes care of updating new channel definitin to
+ * bss config structure, restart AP and indicate channel switch success
+ * to cfg80211.
+ */
+void mwifiex_dfs_chan_sw_work_queue(struct work_struct *work)
+{
+	struct mwifiex_uap_bss_param *bss_cfg;
+	struct delayed_work *delayed_work =
+			container_of(work, struct delayed_work, work);
+	struct mwifiex_private *priv =
+			container_of(delayed_work, struct mwifiex_private,
+				     dfs_chan_sw_work);
+
+	if (WARN_ON(!priv))
+		return;
+
+	bss_cfg = &priv->bss_cfg;
+	if (!bss_cfg->beacon_period) {
+		dev_err(priv->adapter->dev,
+			"channel switch: AP already stopped\n");
+		return;
+	}
+
+	mwifiex_uap_set_channel(bss_cfg, priv->dfs_chandef);
+
+	if (mwifiex_config_start_uap(priv, bss_cfg)) {
+		dev_dbg(priv->adapter->dev,
+			"Failed to start AP after channel switch\n");
+		return;
+	}
+
+	dev_notice(priv->adapter->dev,
+		   "indicating channel switch completion to kernel\n");
+	cfg80211_ch_switch_notify(priv->netdev, &priv->dfs_chandef);
+}
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 13c9c67..72dd1f3 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2397,7 +2397,7 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	struct mwifiex_private *priv;
 	struct net_device *dev;
 	void *mdev_priv;
-	char dfs_cac_str[MWIFIEX_MAX_WQ_LEN];
+	char dfs_cac_str[MWIFIEX_MAX_WQ_LEN], dfs_chsw_str[MWIFIEX_MAX_WQ_LEN];
 
 	if (!adapter)
 		return ERR_PTR(-EFAULT);
@@ -2580,6 +2580,24 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 
 	INIT_DELAYED_WORK(&priv->dfs_cac_work, mwifiex_dfs_cac_work_queue);
 
+	strcpy(dfs_chsw_str, "MWIFIEX_DFS_CHSW");
+	strcat(dfs_chsw_str, name);
+	priv->dfs_chan_sw_workqueue = alloc_workqueue(dfs_chsw_str,
+						      WQ_HIGHPRI | WQ_UNBOUND |
+						      WQ_MEM_RECLAIM, 1);
+	if (!priv->dfs_chan_sw_workqueue) {
+		wiphy_err(wiphy, "cannot register virtual network device\n");
+		free_netdev(dev);
+		priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
+		priv->netdev = NULL;
+		memset(&priv->wdev, 0, sizeof(priv->wdev));
+		priv->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+		return ERR_PTR(-ENOMEM);
+	}
+
+	INIT_DELAYED_WORK(&priv->dfs_chan_sw_work,
+			  mwifiex_dfs_chan_sw_work_queue);
+
 	sema_init(&priv->async_sem, 1);
 
 	dev_dbg(adapter->dev, "info: %s: Marvell 802.11 Adapter\n", dev->name);
@@ -2635,6 +2653,11 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 		priv->dfs_cac_workqueue = NULL;
 	}
 
+	if (priv->dfs_chan_sw_workqueue) {
+		flush_workqueue(priv->dfs_chan_sw_workqueue);
+		destroy_workqueue(priv->dfs_chan_sw_workqueue);
+		priv->dfs_chan_sw_workqueue = NULL;
+	}
 	/* Clear the priv in adapter */
 	priv->netdev->ieee80211_ptr = NULL;
 	priv->netdev = NULL;
@@ -3083,6 +3106,62 @@ mwifiex_cfg80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static int
+mwifiex_cfg80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
+				struct cfg80211_csa_settings *params)
+{
+	struct ieee_types_header *chsw_ie;
+	struct ieee80211_channel_sw_ie *channel_sw;
+	int chsw_msec;
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+
+	if (priv->adapter->scan_processing) {
+		dev_err(priv->adapter->dev,
+			"radar detection: scan in process...\n");
+		return -EBUSY;
+	}
+
+	if (priv->wdev.cac_started)
+		return -EBUSY;
+
+	if (cfg80211_chandef_identical(&params->chandef,
+				       &priv->dfs_chandef))
+		return -EINVAL;
+
+	chsw_ie = (void *)cfg80211_find_ie(WLAN_EID_CHANNEL_SWITCH,
+					   params->beacon_csa.tail,
+					   params->beacon_csa.tail_len);
+	if (!chsw_ie) {
+		dev_err(priv->adapter->dev,
+			"Could not parse channel switch announcement IE\n");
+		return -EINVAL;
+	}
+
+	channel_sw = (void *)(chsw_ie + 1);
+	if (channel_sw->mode) {
+		if (netif_carrier_ok(priv->netdev))
+			netif_carrier_off(priv->netdev);
+		mwifiex_stop_net_dev_queue(priv->netdev, priv->adapter);
+	}
+
+	if (mwifiex_del_mgmt_ies(priv))
+		wiphy_err(wiphy, "Failed to delete mgmt IEs!\n");
+
+	if (mwifiex_set_mgmt_ies(priv, &params->beacon_csa)) {
+		wiphy_err(wiphy, "%s: setting mgmt ies failed\n", __func__);
+		return -EFAULT;
+	}
+
+	memcpy(&priv->dfs_chandef, &params->chandef, sizeof(priv->dfs_chandef));
+	memcpy(&priv->beacon_after, &params->beacon_after,
+	       sizeof(priv->beacon_after));
+
+	chsw_msec = max(channel_sw->count * priv->bss_cfg.beacon_period, 100);
+	queue_delayed_work(priv->dfs_chan_sw_workqueue, &priv->dfs_chan_sw_work,
+			   msecs_to_jiffies(chsw_msec));
+	return 0;
+}
+
+static int
 mwifiex_cfg80211_start_radar_detection(struct wiphy *wiphy,
 				       struct net_device *dev,
 				       struct cfg80211_chan_def *chandef,
@@ -3177,6 +3256,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.add_station = mwifiex_cfg80211_add_station,
 	.change_station = mwifiex_cfg80211_change_station,
 	.start_radar_detection = mwifiex_cfg80211_start_radar_detection,
+	.channel_switch = mwifiex_cfg80211_channel_switch,
 };
 
 #ifdef CONFIG_PM
@@ -3280,7 +3360,8 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME |
 			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD |
 			WIPHY_FLAG_AP_UAPSD |
-			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
+			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
+			WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 
 	if (ISSUPP_TDLS_ENABLED(adapter->fw_cap_info))
 		wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifiex/ie.c
index a6af7b8..f3b6ed2 100644
--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -325,6 +325,7 @@ static int mwifiex_uap_set_head_tail_ies(struct mwifiex_private *priv,
 {
 	struct mwifiex_ie *gen_ie;
 	struct ieee_types_header *rsn_ie = NULL, *wpa_ie = NULL;
+	struct ieee_types_header *chsw_ie = NULL;
 	u16 gen_idx = MWIFIEX_AUTO_IDX_MASK, ie_len = 0;
 	const u8 *vendor_ie;
 
@@ -356,9 +357,18 @@ static int mwifiex_uap_set_head_tail_ies(struct mwifiex_private *priv,
 			ie_len += wpa_ie->len + 2;
 			gen_ie->ie_length = cpu_to_le16(ie_len);
 		}
+
+		chsw_ie = (void *)cfg80211_find_ie(WLAN_EID_CHANNEL_SWITCH,
+						   info->tail, info->tail_len);
+		if (chsw_ie) {
+			memcpy(gen_ie->ie_buffer + ie_len,
+			       chsw_ie, chsw_ie->len + 2);
+			ie_len += chsw_ie->len + 2;
+			gen_ie->ie_length = cpu_to_le16(ie_len);
+		}
 	}
 
-	if (rsn_ie || wpa_ie) {
+	if (rsn_ie || wpa_ie || chsw_ie) {
 		if (mwifiex_update_uap_custom_ie(priv, gen_ie, &gen_idx, NULL,
 						 NULL, NULL, NULL)) {
 			kfree(gen_ie);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 1a612f6..0163fcb 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -592,6 +592,10 @@ struct mwifiex_private {
 	struct cfg80211_chan_def dfs_chandef;
 	struct workqueue_struct *dfs_cac_workqueue;
 	struct delayed_work dfs_cac_work;
+	struct timer_list dfs_chan_switch_timer;
+	struct workqueue_struct *dfs_chan_sw_workqueue;
+	struct delayed_work dfs_chan_sw_work;
+	struct cfg80211_beacon_data beacon_after;
 };
 
 enum mwifiex_ba_status {
@@ -1394,6 +1398,7 @@ struct sk_buff *
 mwifiex_clone_skb_for_tx_status(struct mwifiex_private *priv,
 				struct sk_buff *skb, u8 flag, u64 *cookie);
 void mwifiex_dfs_cac_work_queue(struct work_struct *work);
+void mwifiex_dfs_chan_sw_work_queue(struct work_struct *work);
 void mwifiex_abort_cac(struct mwifiex_private *priv);
 int mwifiex_11h_handle_radar_detected(struct mwifiex_private *priv,
 				      struct sk_buff *skb);
-- 
1.8.1.4

