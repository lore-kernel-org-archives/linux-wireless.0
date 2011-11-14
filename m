Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:51349 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab1KNRbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 12:31:34 -0500
Subject: [PATCH 09/10] ath6kl: make maximum number of vifs runtime configurable
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 14 Nov 2011 19:31:30 +0200
Message-ID: <20111114173130.29925.17340.stgit@localhost6.localdomain6> (sfid-20111114_183137_841810_A43FF163)
In-Reply-To: <20111114172836.29925.4134.stgit@localhost6.localdomain6>
References: <20111114172836.29925.4134.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Needed when detecting how many vifs firmware supports.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    8 +++++---
 drivers/net/wireless/ath/ath6kl/core.h     |    7 ++++++-
 drivers/net/wireless/ath/ath6kl/init.c     |   10 +++++-----
 drivers/net/wireless/ath/ath6kl/txrx.c     |    2 +-
 drivers/net/wireless/ath/ath6kl/wmi.c      |    6 +++---
 5 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 08708bd..27b3d40 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -359,7 +359,7 @@ static bool ath6kl_is_valid_iftype(struct ath6kl *ar, enum nl80211_iftype type,
 
 	if (type == NL80211_IFTYPE_STATION ||
 	    type == NL80211_IFTYPE_AP || type == NL80211_IFTYPE_ADHOC) {
-		for (i = 0; i < MAX_NUM_VIF; i++) {
+		for (i = 0; i < ar->vif_max; i++) {
 			if ((ar->avail_idx_map >> i) & BIT(0)) {
 				*if_idx = i;
 				return true;
@@ -369,7 +369,7 @@ static bool ath6kl_is_valid_iftype(struct ath6kl *ar, enum nl80211_iftype type,
 
 	if (type == NL80211_IFTYPE_P2P_CLIENT ||
 	    type == NL80211_IFTYPE_P2P_GO) {
-		for (i = ar->max_norm_iface; i < MAX_NUM_VIF; i++) {
+		for (i = ar->max_norm_iface; i < ar->vif_max; i++) {
 			if ((ar->avail_idx_map >> i) & BIT(0)) {
 				*if_idx = i;
 				return true;
@@ -1308,7 +1308,7 @@ static struct net_device *ath6kl_cfg80211_add_iface(struct wiphy *wiphy,
 	struct net_device *ndev;
 	u8 if_idx, nw_type;
 
-	if (ar->num_vif == MAX_NUM_VIF) {
+	if (ar->num_vif == ar->vif_max) {
 		ath6kl_err("Reached maximum number of supported vif\n");
 		return ERR_PTR(-EINVAL);
 	}
@@ -2461,6 +2461,8 @@ struct ath6kl *ath6kl_core_alloc(struct device *dev)
 	ar->wiphy = wiphy;
 	ar->dev = dev;
 
+	ar->vif_max = 1;
+
 	if (multi_norm_if_support)
 		ar->max_norm_iface = 2;
 	else
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 1697c00..6fdaaf7 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -399,7 +399,11 @@ enum ath6kl_hif_type {
 	ATH6KL_HIF_TYPE_USB,
 };
 
-#define MAX_NUM_VIF	1
+/*
+ * Driver's maximum limit, note that some firmwares support only one vif
+ * and the runtime (current) limit must be checked from ar->vif_max.
+ */
+#define ATH6KL_VIF_MAX	1
 
 /* vif flags info */
 enum ath6kl_vif_state {
@@ -498,6 +502,7 @@ struct ath6kl {
 	/* Lock to avoid race in vif_list entries among add/del/traverse */
 	spinlock_t list_lock;
 	u8 num_vif;
+	int vif_max;
 	u8 max_norm_iface;
 	u8 avail_idx_map;
 	spinlock_t lock;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 9d6e50d..0f72461 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -463,7 +463,7 @@ int ath6kl_configure_target(struct ath6kl *ar)
 	 */
 	fw_iftype = HI_OPTION_FW_MODE_BSS_STA;
 
-	for (i = 0; i < MAX_NUM_VIF; i++)
+	for (i = 0; i < ar->vif_max; i++)
 		fw_mode |= fw_iftype << (i * HI_OPTION_FW_MODE_BITS);
 
 	/*
@@ -477,7 +477,7 @@ int ath6kl_configure_target(struct ath6kl *ar)
 		fw_submode |= HI_OPTION_FW_SUBMODE_NONE <<
 			      (i * HI_OPTION_FW_SUBMODE_BITS);
 
-	for (i = ar->max_norm_iface; i < MAX_NUM_VIF; i++)
+	for (i = ar->max_norm_iface; i < ar->vif_max; i++)
 		fw_submode |= HI_OPTION_FW_SUBMODE_P2PDEV <<
 			      (i * HI_OPTION_FW_SUBMODE_BITS);
 
@@ -508,7 +508,7 @@ int ath6kl_configure_target(struct ath6kl *ar)
 		return -EIO;
 	}
 
-	param |= (MAX_NUM_VIF << HI_OPTION_NUM_DEV_SHIFT);
+	param |= (ar->vif_max << HI_OPTION_NUM_DEV_SHIFT);
 	param |= fw_mode << HI_OPTION_FW_MODE_SHIFT;
 	param |= fw_submode << HI_OPTION_FW_SUBMODE_SHIFT;
 
@@ -1482,7 +1482,7 @@ int ath6kl_init_hw_start(struct ath6kl *ar)
 	if ((ath6kl_set_host_app_area(ar)) != 0)
 		ath6kl_err("unable to set the host app area\n");
 
-	for (i = 0; i < MAX_NUM_VIF; i++) {
+	for (i = 0; i < ar->vif_max; i++) {
 		ret = ath6kl_target_config_wlan_params(ar, i);
 		if (ret)
 			goto err_htc_stop;
@@ -1592,7 +1592,7 @@ int ath6kl_core_init(struct ath6kl *ar)
 		goto err_node_cleanup;
 	}
 
-	for (i = 0; i < MAX_NUM_VIF; i++)
+	for (i = 0; i < ar->vif_max; i++)
 		ar->avail_idx_map |= BIT(i);
 
 	rtnl_lock();
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 0b45d45..506a303 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -541,7 +541,7 @@ void ath6kl_tx_complete(void *context, struct list_head *packet_queue)
 	int status;
 	enum htc_endpoint_id eid;
 	bool wake_event = false;
-	bool flushing[MAX_NUM_VIF] = {false};
+	bool flushing[ATH6KL_VIF_MAX] = {false};
 	u8 if_idx;
 	struct ath6kl_vif *vif;
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index f1d53d0..aa1a252 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -85,7 +85,7 @@ struct ath6kl_vif *ath6kl_get_vif_by_index(struct ath6kl *ar, u8 if_idx)
 {
 	struct ath6kl_vif *vif, *found = NULL;
 
-	if (WARN_ON(if_idx > (MAX_NUM_VIF - 1)))
+	if (WARN_ON(if_idx > (ar->vif_max - 1)))
 		return NULL;
 
 	/* FIXME: Locking */
@@ -187,7 +187,7 @@ int ath6kl_wmi_data_hdr_add(struct wmi *wmi, struct sk_buff *skb,
 	struct wmi_data_hdr *data_hdr;
 	int ret;
 
-	if (WARN_ON(skb == NULL || (if_idx > MAX_NUM_VIF - 1)))
+	if (WARN_ON(skb == NULL || (if_idx > wmi->parent_dev->vif_max - 1)))
 		return -EINVAL;
 
 	if (tx_meta_info) {
@@ -1620,7 +1620,7 @@ int ath6kl_wmi_cmd_send(struct wmi *wmi, u8 if_idx, struct sk_buff *skb,
 	int ret;
 	u16 info1;
 
-	if (WARN_ON(skb == NULL || (if_idx > (MAX_NUM_VIF - 1))))
+	if (WARN_ON(skb == NULL || (if_idx > (wmi->parent_dev->vif_max - 1))))
 		return -EINVAL;
 
 	ath6kl_dbg(ATH6KL_DBG_WMI, "wmi tx id %d len %d flag %d\n",

