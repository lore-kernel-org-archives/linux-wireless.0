Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44513 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbcB2VdO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 16:33:14 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH 10/15] wil6210: P2P_DEVICE virtual interface support
Date: Mon, 29 Feb 2016 23:32:45 +0200
Message-Id: <1456781570-16552-11-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160229_223332_659120_D779D3D4)
In-Reply-To: <1456781570-16552-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1456781570-16552-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

Added support for the P2P_DEVICE virtual interface. This interface
is intended for P2P management operations such as discovery and
GO negotiation. Normally it is implemented by drivers to allow
a separate interface for P2P management with its own MAC address,
but for 11ad drivers it is needed to support P2P search, since it
cannot otherwise be separated from normal scan.

Since we only support a single interface/MAC address, we can't
easily separate between primary and P2P_DEVICE interfaces.
For example when a management packet arrives we can't tell for
which interface it is intended. To work around this, we store
a pointer to the interface where the last "radio operation" was
triggered such as scan or remain on channel, and we forward
management packets and scan results to this interface.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 136 +++++++++++++++++++++++++---
 drivers/net/wireless/ath/wil6210/main.c     |   1 +
 drivers/net/wireless/ath/wil6210/netdev.c   |   1 +
 drivers/net/wireless/ath/wil6210/p2p.c      |  24 +++--
 drivers/net/wireless/ath/wil6210/pcie_bus.c |   1 +
 drivers/net/wireless/ath/wil6210/wil6210.h  |   8 +-
 drivers/net/wireless/ath/wil6210/wmi.c      |   7 +-
 7 files changed, 152 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 80e1482f..24f9829 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -78,6 +78,12 @@ wil_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
 		BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
 	},
+	[NL80211_IFTYPE_P2P_DEVICE] = {
+		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_RESP >> 4),
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+	},
 };
 
 static const u32 wil_cipher_suites[] = {
@@ -234,13 +240,68 @@ static int wil_cfg80211_dump_station(struct wiphy *wiphy,
 	return rc;
 }
 
+static struct wireless_dev *
+wil_cfg80211_add_iface(struct wiphy *wiphy, const char *name,
+		       unsigned char name_assign_type,
+		       enum nl80211_iftype type,
+		       u32 *flags, struct vif_params *params)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct wireless_dev *p2p_wdev;
+
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
+	if (type != NL80211_IFTYPE_P2P_DEVICE) {
+		wil_err(wil, "%s: unsupported iftype %d\n", __func__, type);
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (wil->p2p_wdev) {
+		wil_err(wil, "%s: P2P_DEVICE interface already created\n",
+			__func__);
+		return ERR_PTR(-EINVAL);
+	}
+
+	p2p_wdev = kzalloc(sizeof(*p2p_wdev), GFP_KERNEL);
+	if (!p2p_wdev)
+		return ERR_PTR(-ENOMEM);
+
+	p2p_wdev->iftype = type;
+	p2p_wdev->wiphy = wiphy;
+	/* use our primary ethernet address */
+	ether_addr_copy(p2p_wdev->address, ndev->perm_addr);
+
+	wil->p2p_wdev = p2p_wdev;
+
+	return p2p_wdev;
+}
+
+static int wil_cfg80211_del_iface(struct wiphy *wiphy,
+				  struct wireless_dev *wdev)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
+	if (wdev != wil->p2p_wdev) {
+		wil_err(wil, "%s: delete of incorrect interface 0x%p\n",
+			__func__, wdev);
+		return -EINVAL;
+	}
+
+	wil_p2p_wdev_free(wil);
+
+	return 0;
+}
+
 static int wil_cfg80211_change_iface(struct wiphy *wiphy,
 				     struct net_device *ndev,
 				     enum nl80211_iftype type, u32 *flags,
 				     struct vif_params *params)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
-	struct wireless_dev *wdev = wil->wdev;
+	struct wireless_dev *wdev = wil_to_wdev(wil);
 	int rc;
 
 	wil_dbg_misc(wil, "%s() type=%d\n", __func__, type);
@@ -282,7 +343,7 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 			     struct cfg80211_scan_request *request)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
-	struct wireless_dev *wdev = wil->wdev;
+	struct wireless_dev *wdev = request->wdev;
 	struct {
 		struct wmi_start_scan_cmd cmd;
 		u16 chnl[4];
@@ -290,7 +351,8 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 	uint i, n;
 	int rc;
 
-	wil_dbg_misc(wil, "%s()\n", __func__);
+	wil_dbg_misc(wil, "%s(), wdev=0x%p iftype=%d\n",
+		     __func__, wdev, wdev->iftype);
 
 	if (wil->scan_request) {
 		wil_err(wil, "Already scanning\n");
@@ -301,6 +363,7 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_P2P_DEVICE:
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -312,10 +375,16 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 		return -EBUSY;
 	}
 
-	/* check if scan request is a P2P search request */
-	if (wil_scan_is_p2p_search(wil, request)) {
+	/* scan on P2P_DEVICE is handled as p2p search */
+	if (wdev->iftype == NL80211_IFTYPE_P2P_DEVICE) {
 		wil->scan_request = request;
-		return wil_p2p_search(wil, request);
+		wil->radio_wdev = wdev;
+		rc = wil_p2p_search(wil, request);
+		if (rc) {
+			wil->radio_wdev = wil_to_wdev(wil);
+			wil->scan_request = NULL;
+		}
+		return rc;
 	}
 
 	wil_p2p_stop_discovery(wil);
@@ -378,12 +447,14 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 		wil_dbg_misc(wil, "active scan with discovery_mode=1\n");
 	}
 
+	wil->radio_wdev = wdev;
 	rc = wmi_send(wil, WMI_START_SCAN_CMDID, &cmd, sizeof(cmd.cmd) +
 			cmd.cmd.num_channels * sizeof(cmd.cmd.channel_list[0]));
 
 out:
 	if (rc) {
 		del_timer_sync(&wil->scan_timer);
+		wil->radio_wdev = wil_to_wdev(wil);
 		wil->scan_request = NULL;
 	}
 
@@ -647,7 +718,7 @@ static int wil_cfg80211_set_channel(struct wiphy *wiphy,
 				    struct cfg80211_chan_def *chandef)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
-	struct wireless_dev *wdev = wil->wdev;
+	struct wireless_dev *wdev = wil_to_wdev(wil);
 
 	wdev->preset_chandef = *chandef;
 
@@ -657,7 +728,7 @@ static int wil_cfg80211_set_channel(struct wiphy *wiphy,
 static enum wmi_key_usage wil_detect_key_usage(struct wil6210_priv *wil,
 					       bool pairwise)
 {
-	struct wireless_dev *wdev = wil->wdev;
+	struct wireless_dev *wdev = wil_to_wdev(wil);
 	enum wmi_key_usage rc;
 
 	if (pairwise) {
@@ -809,14 +880,16 @@ static int wil_remain_on_channel(struct wiphy *wiphy,
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 	int rc;
 
-	wil_dbg_misc(wil, "%s() center_freq=%d, duration=%d\n", __func__,
-		     chan->center_freq, duration);
+	wil_dbg_misc(wil, "%s() center_freq=%d, duration=%d iftype=%d\n",
+		     __func__, chan->center_freq, duration, wdev->iftype);
 
 	rc = wil_p2p_listen(wil, duration, chan, cookie);
 	if (rc)
 		return rc;
 
-	cfg80211_ready_on_channel(wil->wdev, *cookie, chan, duration,
+	wil->radio_wdev = wdev;
+
+	cfg80211_ready_on_channel(wdev, *cookie, chan, duration,
 				  GFP_KERNEL);
 
 	return 0;
@@ -1263,7 +1336,26 @@ static int wil_cfg80211_change_bss(struct wiphy *wiphy,
 	return 0;
 }
 
+static int wil_cfg80211_start_p2p_device(struct wiphy *wiphy,
+					 struct wireless_dev *wdev)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_dbg_misc(wil, "%s: entered\n", __func__);
+	return 0;
+}
+
+static void wil_cfg80211_stop_p2p_device(struct wiphy *wiphy,
+					 struct wireless_dev *wdev)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_dbg_misc(wil, "%s: entered\n", __func__);
+}
+
 static struct cfg80211_ops wil_cfg80211_ops = {
+	.add_virtual_intf = wil_cfg80211_add_iface,
+	.del_virtual_intf = wil_cfg80211_del_iface,
 	.scan = wil_cfg80211_scan,
 	.connect = wil_cfg80211_connect,
 	.disconnect = wil_cfg80211_disconnect,
@@ -1284,6 +1376,9 @@ static struct cfg80211_ops wil_cfg80211_ops = {
 	.del_station = wil_cfg80211_del_station,
 	.probe_client = wil_cfg80211_probe_client,
 	.change_bss = wil_cfg80211_change_bss,
+	/* P2P device */
+	.start_p2p_device = wil_cfg80211_start_p2p_device,
+	.stop_p2p_device = wil_cfg80211_stop_p2p_device,
 };
 
 static void wil_wiphy_init(struct wiphy *wiphy)
@@ -1296,9 +1391,7 @@ static void wil_wiphy_init(struct wiphy *wiphy)
 				 BIT(NL80211_IFTYPE_AP) |
 				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
 				 BIT(NL80211_IFTYPE_P2P_GO) |
-				 /* enable this when supporting multi vif
-				  * BIT(NL80211_IFTYPE_P2P_DEVICE) |
-				  */
+				 BIT(NL80211_IFTYPE_P2P_DEVICE) |
 				 BIT(NL80211_IFTYPE_MONITOR);
 	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME |
 			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
@@ -1369,3 +1462,18 @@ void wil_wdev_free(struct wil6210_priv *wil)
 	wiphy_free(wdev->wiphy);
 	kfree(wdev);
 }
+
+void wil_p2p_wdev_free(struct wil6210_priv *wil)
+{
+	struct wireless_dev *p2p_wdev;
+
+	mutex_lock(&wil->p2p_wdev_mutex);
+	p2p_wdev = wil->p2p_wdev;
+	if (p2p_wdev) {
+		wil->p2p_wdev = NULL;
+		wil->radio_wdev = wil_to_wdev(wil);
+		cfg80211_unregister_wdev(p2p_wdev);
+		kfree(p2p_wdev);
+	}
+	mutex_unlock(&wil->p2p_wdev_mutex);
+}
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 025751e..e09e9bb 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -446,6 +446,7 @@ int wil_priv_init(struct wil6210_priv *wil)
 	mutex_init(&wil->mutex);
 	mutex_init(&wil->wmi_mutex);
 	mutex_init(&wil->probe_client_mutex);
+	mutex_init(&wil->p2p_wdev_mutex);
 
 	init_completion(&wil->wmi_ready);
 	init_completion(&wil->wmi_call);
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index ecc3c1b..d4ec5b2 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -149,6 +149,7 @@ void *wil_if_alloc(struct device *dev)
 
 	wil = wdev_to_wil(wdev);
 	wil->wdev = wdev;
+	wil->radio_wdev = wdev;
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
diff --git a/drivers/net/wireless/ath/wil6210/p2p.c b/drivers/net/wireless/ath/wil6210/p2p.c
index 974bf84..d223648 100644
--- a/drivers/net/wireless/ath/wil6210/p2p.c
+++ b/drivers/net/wireless/ath/wil6210/p2p.c
@@ -22,13 +22,6 @@
 #define P2P_SEARCH_DURATION_MS 500
 #define P2P_DEFAULT_BI 100
 
-int wil_scan_is_p2p_search(struct wil6210_priv *wil,
-			   struct cfg80211_scan_request *request)
-{
-	/* need P2P_DEVICE changes to make this work */
-	return 0;
-}
-
 void wil_p2p_discovery_timer_fn(ulong x)
 {
 	struct wil6210_priv *wil = (void *)x;
@@ -183,10 +176,14 @@ void wil_p2p_cancel_listen(struct wil6210_priv *wil, u64 cookie)
 			 __func__, p2p->cookie, cookie);
 
 	wil_p2p_stop_discovery(wil);
-	cfg80211_remain_on_channel_expired(wil->wdev,
+
+	mutex_lock(&wil->p2p_wdev_mutex);
+	cfg80211_remain_on_channel_expired(wil->radio_wdev,
 					   p2p->cookie,
 					   &p2p->listen_chan,
 					   GFP_KERNEL);
+	wil->radio_wdev = wil->wdev;
+	mutex_unlock(&wil->p2p_wdev_mutex);
 }
 
 void wil_p2p_listen_expired(struct work_struct *work)
@@ -199,10 +196,15 @@ void wil_p2p_listen_expired(struct work_struct *work)
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
 	wil_p2p_stop_discovery(wil);
-	cfg80211_remain_on_channel_expired(wil->wdev,
+
+	mutex_lock(&wil->p2p_wdev_mutex);
+	cfg80211_remain_on_channel_expired(wil->radio_wdev,
 					   p2p->cookie,
 					   &p2p->listen_chan,
 					   GFP_KERNEL);
+	wil->radio_wdev = wil->wdev;
+	mutex_unlock(&wil->p2p_wdev_mutex);
+
 }
 
 void wil_p2p_search_expired(struct work_struct *work)
@@ -215,6 +217,10 @@ void wil_p2p_search_expired(struct work_struct *work)
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
 	wil_p2p_stop_discovery(wil);
+
+	mutex_lock(&wil->p2p_wdev_mutex);
 	cfg80211_scan_done(wil->scan_request, 0);
 	wil->scan_request = NULL;
+	wil->radio_wdev = wil->wdev;
+	mutex_unlock(&wil->p2p_wdev_mutex);
 }
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index e36f2a0..aeb72c4 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -275,6 +275,7 @@ static void wil_pcie_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 	if (wil->platform_ops.uninit)
 		wil->platform_ops.uninit(wil->platform_handle);
+	wil_p2p_wdev_free(wil);
 	wil_if_free(wil);
 }
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 0aba86c..9b77a08 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -616,6 +616,11 @@ struct wil6210_priv {
 	bool pbss;
 
 	struct wil_p2p_info p2p;
+
+	/* P2P_DEVICE vif */
+	struct wireless_dev *p2p_wdev;
+	struct mutex p2p_wdev_mutex; /* protect @p2p_wdev */
+	struct wireless_dev *radio_wdev;
 };
 
 #define wil_to_wiphy(i) (i->wdev->wiphy)
@@ -765,8 +770,6 @@ void wil_disable_irq(struct wil6210_priv *wil);
 void wil_enable_irq(struct wil6210_priv *wil);
 
 /* P2P */
-int wil_scan_is_p2p_search(struct wil6210_priv *wil,
-			   struct cfg80211_scan_request *request);
 void wil_p2p_discovery_timer_fn(ulong x);
 int wil_p2p_search(struct wil6210_priv *wil,
 		   struct cfg80211_scan_request *request);
@@ -794,6 +797,7 @@ int wil_cid_fill_sinfo(struct wil6210_priv *wil, int cid,
 
 struct wireless_dev *wil_cfg80211_init(struct device *dev);
 void wil_wdev_free(struct wil6210_priv *wil);
+void wil_p2p_wdev_free(struct wil6210_priv *wil);
 
 int wmi_set_mac_address(struct wil6210_priv *wil, void *addr);
 int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype,
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 4a1cdd2..f076175 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -380,8 +380,10 @@ static void wmi_evt_rx_mgmt(struct wil6210_priv *wil, int id, void *d, int len)
 			wil_err(wil, "cfg80211_inform_bss_frame() failed\n");
 		}
 	} else {
-		cfg80211_rx_mgmt(wil->wdev, freq, signal,
+		mutex_lock(&wil->p2p_wdev_mutex);
+		cfg80211_rx_mgmt(wil->radio_wdev, freq, signal,
 				 (void *)rx_mgmt_frame, d_len, 0);
+		mutex_unlock(&wil->p2p_wdev_mutex);
 	}
 }
 
@@ -408,7 +410,10 @@ static void wmi_evt_scan_complete(struct wil6210_priv *wil, int id,
 			     wil->scan_request, aborted);
 
 		del_timer_sync(&wil->scan_timer);
+		mutex_lock(&wil->p2p_wdev_mutex);
 		cfg80211_scan_done(wil->scan_request, aborted);
+		wil->radio_wdev = wil->wdev;
+		mutex_unlock(&wil->p2p_wdev_mutex);
 		wil->scan_request = NULL;
 	} else {
 		wil_err(wil, "SCAN_COMPLETE while not scanning\n");
-- 
1.8.5.2

