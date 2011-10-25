Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35234 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933533Ab1JYOHg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 10:07:36 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 28/31] ath6kl: Implement add_virtual_intf() and del_virtual_intf()
Date: Tue, 25 Oct 2011 19:34:23 +0530
Message-ID: <1319551466-29070-29-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_160740_567138_A22CF1AF)
In-Reply-To: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  123 +++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    2 +-
 drivers/net/wireless/ath/ath6kl/core.h     |    4 +
 drivers/net/wireless/ath/ath6kl/init.c     |   10 ++-
 4 files changed, 133 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 7cdd893..7713ab4 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -293,6 +293,57 @@ static int ath6kl_set_assoc_req_ies(struct ath6kl_vif *vif, const u8 *ies,
 	return ret;
 }
 
+static int ath6kl_nliftype_to_drv_iftype(enum nl80211_iftype type, u8 *nw_type)
+{
+	switch (type) {
+	case NL80211_IFTYPE_STATION:
+		*nw_type = INFRA_NETWORK;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		*nw_type = ADHOC_NETWORK;
+		break;
+	case NL80211_IFTYPE_AP:
+		*nw_type = AP_NETWORK;
+		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+		*nw_type = INFRA_NETWORK;
+		break;
+	case NL80211_IFTYPE_P2P_GO:
+		*nw_type = AP_NETWORK;
+		break;
+	default:
+		ath6kl_err("invalid interface type %u\n", type);
+		return -ENOTSUPP;
+	}
+
+	return 0;
+}
+
+static bool ath6kl_is_valid_iftype(struct ath6kl *ar, enum nl80211_iftype type,
+				   u8 *if_idx, u8 *nw_type)
+{
+	int i;
+
+	if (ath6kl_nliftype_to_drv_iftype(type, nw_type))
+		return false;
+
+	if (ar->ibss_if_active || ((type == NL80211_IFTYPE_ADHOC) &&
+	    ar->num_vif))
+		return false;
+
+	if (type == NL80211_IFTYPE_STATION ||
+	    type == NL80211_IFTYPE_AP || type == NL80211_IFTYPE_ADHOC) {
+		for (i = 0; i < MAX_NUM_VIF; i++) {
+			if ((ar->avail_idx_map >> i) & BIT(0)) {
+				*if_idx = i;
+				return true;
+			}
+		}
+	}
+
+	return false;
+}
+
 static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 				   struct cfg80211_connect_params *sme)
 {
@@ -1206,6 +1257,52 @@ static int ath6kl_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 	return 0;
 }
 
+static struct net_device *ath6kl_cfg80211_add_iface(struct wiphy *wiphy,
+						    char *name,
+						    enum nl80211_iftype type,
+						    u32 *flags,
+						    struct vif_params *params)
+{
+	struct ath6kl *ar = wiphy_priv(wiphy);
+	struct net_device *ndev;
+	u8 if_idx, nw_type;
+
+	if (ar->num_vif == MAX_NUM_VIF) {
+		ath6kl_err("Reached maximum number of supported vif\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (!ath6kl_is_valid_iftype(ar, type, &if_idx, &nw_type)) {
+		ath6kl_err("Not a supported interface type\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	ndev = ath6kl_interface_add(ar, name, type, if_idx, nw_type);
+	if (!ndev)
+		return ERR_PTR(-ENOMEM);
+
+	ar->num_vif++;
+
+	return ndev;
+}
+
+static int ath6kl_cfg80211_del_iface(struct wiphy *wiphy,
+				     struct net_device *ndev)
+{
+	struct ath6kl *ar = wiphy_priv(wiphy);
+	struct ath6kl_vif *vif = netdev_priv(ndev);
+
+	spin_lock(&ar->list_lock);
+	list_del(&vif->list);
+	spin_unlock(&ar->list_lock);
+
+	ath6kl_cleanup_vif(vif, test_bit(WMI_READY, &ar->flag));
+
+	ath6kl_deinit_if_data(vif);
+
+	return 0;
+}
+
 static int ath6kl_cfg80211_change_iface(struct wiphy *wiphy,
 					struct net_device *ndev,
 					enum nl80211_iftype type, u32 *flags,
@@ -1946,6 +2043,8 @@ ath6kl_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 };
 
 static struct cfg80211_ops ath6kl_cfg80211_ops = {
+	.add_virtual_intf = ath6kl_cfg80211_add_iface,
+	.del_virtual_intf = ath6kl_cfg80211_del_iface,
 	.change_virtual_intf = ath6kl_cfg80211_change_iface,
 	.scan = ath6kl_cfg80211_scan,
 	.connect = ath6kl_cfg80211_connect,
@@ -2096,18 +2195,28 @@ static int ath6kl_init_if_data(struct ath6kl_vif *vif)
 
 void ath6kl_deinit_if_data(struct ath6kl_vif *vif)
 {
+	struct ath6kl *ar = vif->ar;
+
 	aggr_module_destroy(vif->aggr_cntxt);
 
+	ar->avail_idx_map |= BIT(vif->fw_vif_idx);
+
+	if (vif->nw_type == ADHOC_NETWORK)
+		ar->ibss_if_active = false;
+
 	unregister_netdevice(vif->ndev);
+
+	ar->num_vif--;
 }
 
 struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
-					enum nl80211_iftype type, u8 fw_vif_idx)
+					enum nl80211_iftype type, u8 fw_vif_idx,
+					u8 nw_type)
 {
 	struct net_device *ndev;
 	struct ath6kl_vif *vif;
 
-	ndev = alloc_netdev(sizeof(*vif), "wlan%d", ether_setup);
+	ndev = alloc_netdev(sizeof(*vif), name, ether_setup);
 	if (!ndev)
 		return NULL;
 
@@ -2120,8 +2229,14 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 	vif->wdev.netdev = ndev;
 	vif->wdev.iftype = type;
 	vif->fw_vif_idx = fw_vif_idx;
+	vif->nw_type = vif->next_mode = nw_type;
 	ar->wdev = &vif->wdev;
 
+	memcpy(ndev->dev_addr, ar->mac_addr, ETH_ALEN);
+	if (fw_vif_idx != 0)
+		ndev->dev_addr[0] = (ndev->dev_addr[0] ^ (1 << fw_vif_idx)) |
+				     0x2;
+
 	init_netdev(ndev);
 
 	ath6kl_init_control_info(vif);
@@ -2133,11 +2248,15 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 	if (register_netdevice(ndev))
 		goto err;
 
+	ar->avail_idx_map &= ~BIT(fw_vif_idx);
 	vif->sme_state = SME_DISCONNECTED;
 	set_bit(WLAN_ENABLED, &vif->flags);
 	ar->wlan_pwr_state = WLAN_POWER_STATE_ON;
 	set_bit(NETDEV_REGISTERED, &vif->flags);
 
+	if (type == NL80211_IFTYPE_ADHOC)
+		ar->ibss_if_active = true;
+
 	spin_lock(&ar->list_lock);
 	list_add_tail(&vif->list, &ar->vif_list);
 	spin_unlock(&ar->list_lock);
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.h b/drivers/net/wireless/ath/ath6kl/cfg80211.h
index 66042f2..d1a0216 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.h
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.h
@@ -19,7 +19,7 @@
 
 struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 					enum nl80211_iftype type,
-					u8 fw_vif_idx);
+					u8 fw_vif_idx, u8 nw_type);
 int ath6kl_register_ieee80211_hw(struct ath6kl *ar);
 struct ath6kl *ath6kl_core_alloc(struct device *dev);
 void ath6kl_deinit_ieee80211_hw(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 29bb235..6933fb6 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -460,6 +460,8 @@ struct ath6kl {
 	struct list_head vif_list;
 	/* Lock to avoid race in vif_list entries among add/del/traverse */
 	spinlock_t list_lock;
+	u8 num_vif;
+	u8 avail_idx_map;
 	spinlock_t lock;
 	struct semaphore sem;
 	u16 listen_intvl_b;
@@ -470,6 +472,7 @@ struct ath6kl {
 	u8 tx_pwr;
 	struct ath6kl_node_mapping node_map[MAX_NODE_NUM];
 	u8 ibss_ps_enable;
+	bool ibss_if_active;
 	u8 node_num;
 	u8 next_ep_id;
 	struct ath6kl_cookie *cookie_list;
@@ -666,4 +669,5 @@ void ath6kl_init_control_info(struct ath6kl_vif *vif);
 void ath6kl_deinit_if_data(struct ath6kl_vif *vif);
 void ath6kl_core_free(struct ath6kl *ar);
 struct ath6kl_vif *ath6kl_vif_first(struct ath6kl *ar);
+void ath6kl_cleanup_vif(struct ath6kl_vif *vif, bool wmi_ready);
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index e76d118..2780170 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -88,7 +88,6 @@ void ath6kl_init_profile_info(struct ath6kl_vif *vif)
 	memset(vif->req_bssid, 0, sizeof(vif->req_bssid));
 	memset(vif->bssid, 0, sizeof(vif->bssid));
 	vif->bss_ch = 0;
-	vif->nw_type = vif->next_mode = INFRA_NETWORK;
 }
 
 static int ath6kl_set_host_app_area(struct ath6kl *ar)
@@ -1414,6 +1413,7 @@ static int ath6kl_init(struct ath6kl *ar)
 	int status = 0;
 	s32 timeleft;
 	struct net_device *ndev;
+	int i;
 
 	if (!ar)
 		return -EIO;
@@ -1445,10 +1445,14 @@ static int ath6kl_init(struct ath6kl *ar)
 		goto err_node_cleanup;
 	}
 
+	for (i = 0; i < MAX_NUM_VIF; i++)
+		ar->avail_idx_map |= BIT(i);
+
 	rtnl_lock();
 
 	/* Add an initial station interface */
-	ndev = ath6kl_interface_add(ar, "wlan%d", NL80211_IFTYPE_STATION, 0);
+	ndev = ath6kl_interface_add(ar, "wlan%d", NL80211_IFTYPE_STATION, 0,
+				    INFRA_NETWORK);
 
 	rtnl_unlock();
 
@@ -1631,7 +1635,7 @@ err_wq:
 	return ret;
 }
 
-static void ath6kl_cleanup_vif(struct ath6kl_vif *vif, bool wmi_ready)
+void ath6kl_cleanup_vif(struct ath6kl_vif *vif, bool wmi_ready)
 {
 	static u8 bcast_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	bool discon_issued;
-- 
1.7.0.4

