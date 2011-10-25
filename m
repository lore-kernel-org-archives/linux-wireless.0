Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48448 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535Ab1JYKQj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:16:39 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <nataraja@qca.qualcomm.com>,
	<athiruve@qca.qualcomm.com>
Subject: [PATCH 25/34] ath6kl: Maintain virtual interface in a list
Date: Tue, 25 Oct 2011 15:40:21 +0530
Message-ID: <1319537430-12459-26-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_121801_759135_02E4B94A)
In-Reply-To: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes all references to ar->vif and takes
vif from a list.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   66 ++++++++++++++++----------
 drivers/net/wireless/ath/ath6kl/core.h     |    6 ++-
 drivers/net/wireless/ath/ath6kl/debug.c    |   25 +++++++---
 drivers/net/wireless/ath/ath6kl/init.c     |   15 ++++--
 drivers/net/wireless/ath/ath6kl/main.c     |   32 ++++++++++++-
 drivers/net/wireless/ath/ath6kl/txrx.c     |   72 ++++++++++++++++------------
 drivers/net/wireless/ath/ath6kl/wmi.c      |   22 +++++++--
 drivers/net/wireless/ath/ath6kl/wmi.h      |    4 +-
 8 files changed, 163 insertions(+), 79 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 722deb5..51555e7 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -228,9 +228,9 @@ static void ath6kl_set_key_mgmt(struct ath6kl_vif *vif, u32 key_mgmt)
 	}
 }
 
-static bool ath6kl_cfg80211_ready(struct ath6kl *ar)
+static bool ath6kl_cfg80211_ready(struct ath6kl_vif *vif)
 {
-	struct ath6kl_vif *vif = ar->vif;
+	struct ath6kl *ar = vif->ar;
 
 	if (!test_bit(WMI_READY, &ar->flag)) {
 		ath6kl_err("wmi is not ready\n");
@@ -301,7 +301,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 
 	vif->sme_state = SME_CONNECTING;
 
-	if (!ath6kl_cfg80211_ready(ar))
+	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
 
 	if (test_bit(DESTROY_IN_PROGRESS, &ar->flag)) {
@@ -614,7 +614,7 @@ static int ath6kl_cfg80211_disconnect(struct wiphy *wiphy,
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: reason=%u\n", __func__,
 		   reason_code);
 
-	if (!ath6kl_cfg80211_ready(ar))
+	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
 
 	if (test_bit(DESTROY_IN_PROGRESS, &ar->flag)) {
@@ -713,7 +713,7 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	int ret = 0;
 	u32 force_fg_scan = 0;
 
-	if (!ath6kl_cfg80211_ready(ar))
+	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
 
 	if (!ar->usr_bss_filter) {
@@ -831,7 +831,7 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	u8 key_type;
 	int status = 0;
 
-	if (!ath6kl_cfg80211_ready(ar))
+	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
 
 	if (params->cipher == CCKM_KRK_CIPHER_SUITE) {
@@ -953,7 +953,7 @@ static int ath6kl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: index %d\n", __func__, key_index);
 
-	if (!ath6kl_cfg80211_ready(ar))
+	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
 
 	if (key_index < WMI_MIN_KEY_INDEX || key_index > WMI_MAX_KEY_INDEX) {
@@ -980,14 +980,13 @@ static int ath6kl_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 				   void (*callback) (void *cookie,
 						     struct key_params *))
 {
-	struct ath6kl *ar = (struct ath6kl *)ath6kl_priv(ndev);
 	struct ath6kl_vif *vif = netdev_priv(ndev);
 	struct ath6kl_key *key = NULL;
 	struct key_params params;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: index %d\n", __func__, key_index);
 
-	if (!ath6kl_cfg80211_ready(ar))
+	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
 
 	if (key_index < WMI_MIN_KEY_INDEX || key_index > WMI_MAX_KEY_INDEX) {
@@ -1024,7 +1023,7 @@ static int ath6kl_cfg80211_set_default_key(struct wiphy *wiphy,
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: index %d\n", __func__, key_index);
 
-	if (!ath6kl_cfg80211_ready(ar))
+	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
 
 	if (key_index < WMI_MIN_KEY_INDEX || key_index > WMI_MAX_KEY_INDEX) {
@@ -1080,12 +1079,17 @@ void ath6kl_cfg80211_tkip_micerr_event(struct ath6kl_vif *vif, u8 keyid,
 static int ath6kl_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
 	struct ath6kl *ar = (struct ath6kl *)wiphy_priv(wiphy);
+	struct ath6kl_vif *vif;
 	int ret;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: changed 0x%x\n", __func__,
 		   changed);
 
-	if (!ath6kl_cfg80211_ready(ar))
+	vif = ath6kl_vif_first(ar);
+	if (!vif)
+		return -EIO;
+
+	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
 
 	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
@@ -1108,12 +1112,17 @@ static int ath6kl_cfg80211_set_txpower(struct wiphy *wiphy,
 				       int dbm)
 {
 	struct ath6kl *ar = (struct ath6kl *)wiphy_priv(wiphy);
+	struct ath6kl_vif *vif;
 	u8 ath6kl_dbm;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: type 0x%x, dbm %d\n", __func__,
 		   type, dbm);
 
-	if (!ath6kl_cfg80211_ready(ar))
+	vif = ath6kl_vif_first(ar);
+	if (!vif)
+		return -EIO;
+
+	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
 
 	switch (type) {
@@ -1128,7 +1137,7 @@ static int ath6kl_cfg80211_set_txpower(struct wiphy *wiphy,
 		return -EOPNOTSUPP;
 	}
 
-	ath6kl_wmi_set_tx_pwr_cmd(ar->wmi, ath6kl_dbm);
+	ath6kl_wmi_set_tx_pwr_cmd(ar->wmi, vif->fw_vif_idx, ath6kl_dbm);
 
 	return 0;
 }
@@ -1136,15 +1145,19 @@ static int ath6kl_cfg80211_set_txpower(struct wiphy *wiphy,
 static int ath6kl_cfg80211_get_txpower(struct wiphy *wiphy, int *dbm)
 {
 	struct ath6kl *ar = (struct ath6kl *)wiphy_priv(wiphy);
-	struct ath6kl_vif *vif = ar->vif;
+	struct ath6kl_vif *vif;
+
+	vif = ath6kl_vif_first(ar);
+	if (!vif)
+		return -EIO;
 
-	if (!ath6kl_cfg80211_ready(ar))
+	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
 
 	if (test_bit(CONNECTED, &vif->flags)) {
 		ar->tx_pwr = 0;
 
-		if (ath6kl_wmi_get_tx_pwr_cmd(ar->wmi) != 0) {
+		if (ath6kl_wmi_get_tx_pwr_cmd(ar->wmi, vif->fw_vif_idx) != 0) {
 			ath6kl_err("ath6kl_wmi_get_tx_pwr_cmd failed\n");
 			return -EIO;
 		}
@@ -1173,7 +1186,7 @@ static int ath6kl_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: pmgmt %d, timeout %d\n",
 		   __func__, pmgmt, timeout);
 
-	if (!ath6kl_cfg80211_ready(ar))
+	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
 
 	if (pmgmt) {
@@ -1204,7 +1217,7 @@ static int ath6kl_cfg80211_change_iface(struct wiphy *wiphy,
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: type %u\n", __func__, type);
 
-	if (!ath6kl_cfg80211_ready(ar))
+	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
 
 	switch (type) {
@@ -1241,7 +1254,7 @@ static int ath6kl_cfg80211_join_ibss(struct wiphy *wiphy,
 	struct ath6kl_vif *vif = netdev_priv(dev);
 	int status;
 
-	if (!ath6kl_cfg80211_ready(ar))
+	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
 
 	vif->ssid_len = ibss_param->ssid_len;
@@ -1306,10 +1319,9 @@ static int ath6kl_cfg80211_join_ibss(struct wiphy *wiphy,
 static int ath6kl_cfg80211_leave_ibss(struct wiphy *wiphy,
 				      struct net_device *dev)
 {
-	struct ath6kl *ar = (struct ath6kl *)ath6kl_priv(dev);
 	struct ath6kl_vif *vif = netdev_priv(dev);
 
-	if (!ath6kl_cfg80211_ready(ar))
+	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
 
 	ath6kl_disconnect(vif);
@@ -1539,10 +1551,9 @@ static int ath6kl_set_channel(struct wiphy *wiphy, struct net_device *dev,
 			      struct ieee80211_channel *chan,
 			      enum nl80211_channel_type channel_type)
 {
-	struct ath6kl *ar = ath6kl_priv(dev);
 	struct ath6kl_vif *vif = netdev_priv(dev);
 
-	if (!ath6kl_cfg80211_ready(ar))
+	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: center_freq=%u hw_value=%u\n",
@@ -1608,7 +1619,7 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: add=%d\n", __func__, add);
 
-	if (!ath6kl_cfg80211_ready(ar))
+	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
 
 	if (vif->next_mode != AP_NETWORK)
@@ -1989,11 +2000,13 @@ struct ath6kl *ath6kl_core_alloc(struct device *dev)
 
 	spin_lock_init(&ar->lock);
 	spin_lock_init(&ar->mcastpsq_lock);
+	spin_lock_init(&ar->list_lock);
 
 	init_waitqueue_head(&ar->event_wq);
 	sema_init(&ar->sem, 1);
 
 	INIT_LIST_HEAD(&ar->amsdu_rx_buffer_queue);
+	INIT_LIST_HEAD(&ar->vif_list);
 
 	clear_bit(WMI_ENABLED, &ar->flag);
 	clear_bit(SKIP_SCAN, &ar->flag);
@@ -2112,7 +2125,6 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 	ndev->ieee80211_ptr = &vif->wdev;
 	vif->wdev.wiphy = ar->wiphy;
 	vif->ar = ar;
-	ar->vif = vif;
 	vif->ndev = ndev;
 	SET_NETDEV_DEV(ndev, wiphy_dev(vif->wdev.wiphy));
 	vif->wdev.netdev = ndev;
@@ -2136,6 +2148,10 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 	ar->wlan_pwr_state = WLAN_POWER_STATE_ON;
 	set_bit(NETDEV_REGISTERED, &vif->flags);
 
+	spin_lock(&ar->list_lock);
+	list_add_tail(&vif->list, &ar->vif_list);
+	spin_unlock(&ar->list_lock);
+
 	return ndev;
 
 err:
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 1668ac5..75028d3 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -397,6 +397,7 @@ enum ath6kl_vif_state {
 };
 
 struct ath6kl_vif {
+	struct list_head list;
 	struct wireless_dev wdev;
 	struct net_device *ndev;
 	struct ath6kl *ar;
@@ -456,7 +457,9 @@ struct ath6kl {
 	int total_tx_data_pend;
 	struct htc_target *htc_target;
 	void *hif_priv;
-	struct ath6kl_vif *vif;
+	struct list_head vif_list;
+	/* Lock to avoid race in vif_list entries among add/del/traverse */
+	spinlock_t list_lock;
 	spinlock_t lock;
 	struct semaphore sem;
 	u16 listen_intvl_b;
@@ -652,4 +655,5 @@ void ath6kl_reset_device(struct ath6kl *ar, u32 target_type,
 void ath6kl_init_control_info(struct ath6kl_vif *vif);
 void ath6kl_deinit_if_data(struct ath6kl *ar, struct net_device *ndev);
 void ath6kl_core_free(struct ath6kl *ar);
+struct ath6kl_vif *ath6kl_vif_first(struct ath6kl *ar);
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 1a9084b..cc8ea3d 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -395,15 +395,20 @@ static ssize_t read_file_tgt_stats(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
 	struct ath6kl *ar = file->private_data;
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
-	struct target_stats *tgt_stats = &vif->target_stats;
+	struct ath6kl_vif *vif;
+	struct target_stats *tgt_stats;
 	char *buf;
 	unsigned int len = 0, buf_len = 1500;
 	int i;
 	long left;
 	ssize_t ret_cnt;
 
+	vif = ath6kl_vif_first(ar);
+	if (!vif)
+		return -EIO;
+
+	tgt_stats = &vif->target_stats;
+
 	buf = kzalloc(buf_len, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
@@ -1246,8 +1251,7 @@ static ssize_t ath6kl_create_qos_write(struct file *file,
 {
 
 	struct ath6kl *ar = file->private_data;
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
+	struct ath6kl_vif *vif;
 	char buf[100];
 	ssize_t len;
 	char *sptr, *token;
@@ -1255,6 +1259,10 @@ static ssize_t ath6kl_create_qos_write(struct file *file,
 	u32 val32;
 	u16 val16;
 
+	vif = ath6kl_vif_first(ar);
+	if (!vif)
+		return -EIO;
+
 	len = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, len))
 		return -EFAULT;
@@ -1420,14 +1428,17 @@ static ssize_t ath6kl_delete_qos_write(struct file *file,
 {
 
 	struct ath6kl *ar = file->private_data;
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
+	struct ath6kl_vif *vif;
 	char buf[100];
 	ssize_t len;
 	char *sptr, *token;
 	u8 traffic_class;
 	u8 tsid;
 
+	vif = ath6kl_vif_first(ar);
+	if (!vif)
+		return -EIO;
+
 	len = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, len))
 		return -EFAULT;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 9818a48..b629a5a 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1627,11 +1627,7 @@ static void ath6kl_cleanup_vif(struct ath6kl_vif *vif, bool wmi_ready)
 
 void ath6kl_stop_txrx(struct ath6kl *ar)
 {
-	struct ath6kl_vif *vif = ar->vif;
-	struct net_device *ndev = vif->ndev;
-
-	if (!ndev)
-		return;
+	struct ath6kl_vif *vif, *tmp_vif;
 
 	set_bit(DESTROY_IN_PROGRESS, &ar->flag);
 
@@ -1640,7 +1636,14 @@ void ath6kl_stop_txrx(struct ath6kl *ar)
 		return;
 	}
 
-	ath6kl_cleanup_vif(ar->vif, test_bit(WMI_READY, &ar->flag));
+	spin_lock(&ar->list_lock);
+	list_for_each_entry_safe(vif, tmp_vif, &ar->vif_list, list) {
+		list_del(&vif->list);
+		spin_unlock(&ar->list_lock);
+		ath6kl_cleanup_vif(vif, test_bit(WMI_READY, &ar->flag));
+		spin_lock(&ar->list_lock);
+	}
+	spin_unlock(&ar->list_lock);
 
 	clear_bit(WMI_READY, &ar->flag);
 
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 6a555ee..766b096 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -580,8 +580,19 @@ void ath6kl_disconnect(struct ath6kl_vif *vif)
 
 void ath6kl_deep_sleep_enable(struct ath6kl *ar)
 {
-	/* TODO: Pass vif instead of taking it from ar */
-	struct ath6kl_vif *vif = ar->vif;
+	struct ath6kl_vif *vif;
+
+	/* FIXME: for multi vif */
+	vif = ath6kl_vif_first(ar);
+	if (!vif) {
+		/* save the current power mode before enabling power save */
+		ar->wmi->saved_pwr_mode = ar->wmi->pwr_mode;
+
+		if (ath6kl_wmi_powermode_cmd(ar->wmi, 0, REC_POWER) != 0)
+			ath6kl_warn("ath6kl_deep_sleep_enable: "
+				    "wmi_powermode_cmd failed\n");
+		return;
+	}
 
 	switch (vif->sme_state) {
 	case SME_CONNECTING:
@@ -1081,6 +1092,23 @@ void ath6kl_disconnect_event(struct ath6kl_vif *vif, u8 reason, u8 *bssid,
 	ath6kl_tx_data_cleanup(ar);
 }
 
+struct ath6kl_vif *ath6kl_vif_first(struct ath6kl *ar)
+{
+	struct ath6kl_vif *vif;
+
+	spin_lock(&ar->list_lock);
+	if (list_empty(&ar->vif_list)) {
+		spin_unlock(&ar->list_lock);
+		return NULL;
+	}
+
+	vif = list_first_entry(&ar->vif_list, struct ath6kl_vif, list);
+
+	spin_unlock(&ar->list_lock);
+
+	return vif;
+}
+
 static int ath6kl_open(struct net_device *dev)
 {
 	struct ath6kl_vif *vif = netdev_priv(dev);
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index ff288da..ab9a5c1 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -432,9 +432,9 @@ enum htc_send_full_action ath6kl_tx_queue_full(struct htc_target *target,
 					       struct htc_packet *packet)
 {
 	struct ath6kl *ar = target->dev->ar;
-	/* TODO: Findout vif properly */
-	struct ath6kl_vif *vif = ar->vif;
+	struct ath6kl_vif *vif;
 	enum htc_endpoint_id endpoint = packet->endpoint;
+	enum htc_send_full_action action = HTC_SEND_FULL_KEEP;
 
 	if (endpoint == ar->ctrl_ep) {
 		/*
@@ -447,19 +447,11 @@ enum htc_send_full_action ath6kl_tx_queue_full(struct htc_target *target,
 		set_bit(WMI_CTRL_EP_FULL, &ar->flag);
 		spin_unlock_bh(&ar->lock);
 		ath6kl_err("wmi ctrl ep is full\n");
-		return HTC_SEND_FULL_KEEP;
+		goto stop_adhoc_netq;
 	}
 
 	if (packet->info.tx.tag == ATH6KL_CONTROL_PKT_TAG)
-		return HTC_SEND_FULL_KEEP;
-
-	if (vif->nw_type == ADHOC_NETWORK)
-		/*
-		 * In adhoc mode, we cannot differentiate traffic
-		 * priorities so there is no need to continue, however we
-		 * should stop the network.
-		 */
-		goto stop_net_queues;
+		goto stop_adhoc_netq;
 
 	/*
 	 * The last MAX_HI_COOKIE_NUM "batch" of cookies are reserved for
@@ -467,28 +459,40 @@ enum htc_send_full_action ath6kl_tx_queue_full(struct htc_target *target,
 	 */
 	if (ar->ac_stream_pri_map[ar->ep2ac_map[endpoint]] <
 	    ar->hiac_stream_active_pri &&
-	    ar->cookie_count <= MAX_HI_COOKIE_NUM)
+	    ar->cookie_count <= MAX_HI_COOKIE_NUM) {
 		/*
 		 * Give preference to the highest priority stream by
 		 * dropping the packets which overflowed.
 		 */
-		return HTC_SEND_FULL_DROP;
+		action = HTC_SEND_FULL_DROP;
+		goto stop_adhoc_netq;
+	}
 
-stop_net_queues:
-	spin_lock_bh(&vif->if_lock);
-	set_bit(NETQ_STOPPED, &vif->flags);
-	spin_unlock_bh(&vif->if_lock);
-	netif_stop_queue(vif->ndev);
+stop_adhoc_netq:
+	/* FIXME: Locking */
+	spin_lock(&ar->list_lock);
+	list_for_each_entry(vif, &ar->vif_list, list) {
+		if (vif->nw_type == ADHOC_NETWORK) {
+			spin_unlock(&ar->list_lock);
 
-	return HTC_SEND_FULL_KEEP;
+			spin_lock_bh(&vif->if_lock);
+			set_bit(NETQ_STOPPED, &vif->flags);
+			spin_unlock_bh(&vif->if_lock);
+			netif_stop_queue(vif->ndev);
+
+			return action;
+		}
+	}
+	spin_unlock(&ar->list_lock);
+
+	return action;
 }
 
 /* TODO this needs to be looked at */
-static void ath6kl_tx_clear_node_map(struct ath6kl *ar,
+static void ath6kl_tx_clear_node_map(struct ath6kl_vif *vif,
 				     enum htc_endpoint_id eid, u32 map_no)
 {
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
+	struct ath6kl *ar = vif->ar;
 	u32 i;
 
 	if (vif->nw_type != ADHOC_NETWORK)
@@ -533,10 +537,9 @@ void ath6kl_tx_complete(void *context, struct list_head *packet_queue)
 	int status;
 	enum htc_endpoint_id eid;
 	bool wake_event = false;
-	bool flushing = false;
+	bool flushing[MAX_NUM_VIF] = {false};
 	u8 if_idx;
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
+	struct ath6kl_vif *vif;
 
 	skb_queue_head_init(&skb_queue);
 
@@ -599,7 +602,7 @@ void ath6kl_tx_complete(void *context, struct list_head *packet_queue)
 		if (status) {
 			if (status == -ECANCELED)
 				/* a packet was flushed  */
-				flushing = true;
+				flushing[if_idx] = true;
 
 			vif->net_stats.tx_errors++;
 
@@ -615,12 +618,12 @@ void ath6kl_tx_complete(void *context, struct list_head *packet_queue)
 				   __func__, skb, packet->buf, packet->act_len,
 				   eid, "OK");
 
-			flushing = false;
+			flushing[if_idx] = false;
 			vif->net_stats.tx_packets++;
 			vif->net_stats.tx_bytes += skb->len;
 		}
 
-		ath6kl_tx_clear_node_map(ar, eid, map_no);
+		ath6kl_tx_clear_node_map(vif, eid, map_no);
 
 		ath6kl_free_cookie(ar, ath6kl_cookie);
 
@@ -632,10 +635,17 @@ void ath6kl_tx_complete(void *context, struct list_head *packet_queue)
 
 	__skb_queue_purge(&skb_queue);
 
-	if (test_bit(CONNECTED, &vif->flags)) {
-		if (!flushing)
+	/* FIXME: Locking */
+	spin_lock(&ar->list_lock);
+	list_for_each_entry(vif, &ar->vif_list, list) {
+		if (test_bit(CONNECTED, &vif->flags) &&
+		    !flushing[vif->fw_vif_idx]) {
+			spin_unlock(&ar->list_lock);
 			netif_wake_queue(vif->ndev);
+			spin_lock(&ar->list_lock);
+		}
 	}
+	spin_unlock(&ar->list_lock);
 
 	if (wake_event)
 		wake_up(&ar->event_wq);
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index ed95c2a..1fada31 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -83,10 +83,22 @@ enum htc_endpoint_id ath6kl_wmi_get_control_ep(struct wmi *wmi)
 
 struct ath6kl_vif *ath6kl_get_vif_by_index(struct ath6kl *ar, u8 if_idx)
 {
+	struct ath6kl_vif *vif, *found = NULL;
+
 	if (WARN_ON(if_idx > (MAX_NUM_VIF - 1)))
 		return NULL;
 
-	return ar->vif;
+	/* FIXME: Locking */
+	spin_lock(&ar->list_lock);
+	list_for_each_entry(vif, &ar->vif_list, list) {
+		if (vif->fw_vif_idx == if_idx) {
+			found = vif;
+			break;
+		}
+	}
+	spin_unlock(&ar->list_lock);
+
+	return found;
 }
 
 /*  Performs DIX to 802.3 encapsulation for transmit packets.
@@ -2459,7 +2471,7 @@ int ath6kl_wmi_get_stats_cmd(struct wmi *wmi, u8 if_idx)
 	return ath6kl_wmi_simple_cmd(wmi, if_idx, WMI_GET_STATISTICS_CMDID);
 }
 
-int ath6kl_wmi_set_tx_pwr_cmd(struct wmi *wmi, u8 dbM)
+int ath6kl_wmi_set_tx_pwr_cmd(struct wmi *wmi, u8 if_idx, u8 dbM)
 {
 	struct sk_buff *skb;
 	struct wmi_set_tx_pwr_cmd *cmd;
@@ -2472,15 +2484,15 @@ int ath6kl_wmi_set_tx_pwr_cmd(struct wmi *wmi, u8 dbM)
 	cmd = (struct wmi_set_tx_pwr_cmd *) skb->data;
 	cmd->dbM = dbM;
 
-	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_TX_PWR_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SET_TX_PWR_CMDID,
 				  NO_SYNC_WMIFLAG);
 
 	return ret;
 }
 
-int ath6kl_wmi_get_tx_pwr_cmd(struct wmi *wmi)
+int ath6kl_wmi_get_tx_pwr_cmd(struct wmi *wmi, u8 if_idx)
 {
-	return ath6kl_wmi_simple_cmd(wmi, 0, WMI_GET_TX_PWR_CMDID);
+	return ath6kl_wmi_simple_cmd(wmi, if_idx, WMI_GET_TX_PWR_CMDID);
 }
 
 int ath6kl_wmi_get_roam_tbl_cmd(struct wmi *wmi)
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 621189b..e2f3304 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -2258,8 +2258,8 @@ int ath6kl_wmi_add_krk_cmd(struct wmi *wmi, u8 if_idx, u8 *krk);
 int ath6kl_wmi_deletekey_cmd(struct wmi *wmi, u8 if_idx, u8 key_index);
 int ath6kl_wmi_setpmkid_cmd(struct wmi *wmi, u8 if_idx, const u8 *bssid,
 			    const u8 *pmkid, bool set);
-int ath6kl_wmi_set_tx_pwr_cmd(struct wmi *wmi, u8 dbM);
-int ath6kl_wmi_get_tx_pwr_cmd(struct wmi *wmi);
+int ath6kl_wmi_set_tx_pwr_cmd(struct wmi *wmi, u8 if_idx, u8 dbM);
+int ath6kl_wmi_get_tx_pwr_cmd(struct wmi *wmi, u8 if_idx);
 int ath6kl_wmi_get_roam_tbl_cmd(struct wmi *wmi);
 
 int ath6kl_wmi_set_wmm_txop(struct wmi *wmi, enum wmi_txop_cfg cfg);
-- 
1.7.0.4

