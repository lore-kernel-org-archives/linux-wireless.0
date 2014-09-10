Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:4690 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaIJNfU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:35:20 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
	Dedy Lansky <qca_dlansky@qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/22] wil6210: add more debug printouts
Date: Wed, 10 Sep 2014 16:34:36 +0300
Message-ID: <1410356091-19219-8-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140910_153547_552890_ACB84FF3)
In-Reply-To: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

added misc printouts in some init/uninit functions for better traceability

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c  |  8 ++++++--
 drivers/net/wireless/ath/wil6210/interrupt.c |  5 +++++
 drivers/net/wireless/ath/wil6210/main.c      | 10 ++++++++++
 drivers/net/wireless/ath/wil6210/netdev.c    | 12 ++++++++++++
 drivers/net/wireless/ath/wil6210/pcie_bus.c  |  6 ++++++
 drivers/net/wireless/ath/wil6210/txrx.c      | 10 ++++++++++
 6 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index cba04e5..c8c9852 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -782,8 +782,8 @@ static void wil_wiphy_init(struct wiphy *wiphy)
 	 */
 	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME |
 			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
-	dev_warn(wiphy_dev(wiphy), "%s : flags = 0x%08x\n",
-		 __func__, wiphy->flags);
+	dev_dbg(wiphy_dev(wiphy), "%s : flags = 0x%08x\n",
+		__func__, wiphy->flags);
 	wiphy->probe_resp_offload =
 		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
 		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2 |
@@ -804,6 +804,8 @@ struct wireless_dev *wil_cfg80211_init(struct device *dev)
 	int rc = 0;
 	struct wireless_dev *wdev;
 
+	dev_dbg(dev, "%s()\n", __func__);
+
 	wdev = kzalloc(sizeof(*wdev), GFP_KERNEL);
 	if (!wdev)
 		return ERR_PTR(-ENOMEM);
@@ -836,6 +838,8 @@ void wil_wdev_free(struct wil6210_priv *wil)
 {
 	struct wireless_dev *wdev = wil_to_wdev(wil);
 
+	dev_dbg(wil_to_dev(wil), "%s()\n", __func__);
+
 	if (!wdev)
 		return;
 
diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 6411651..331d0dc 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -528,6 +528,9 @@ void wil6210_clear_irq(struct wil6210_priv *wil)
 int wil6210_init_irq(struct wil6210_priv *wil, int irq)
 {
 	int rc;
+
+	wil_dbg_misc(wil, "%s() n_msi=%d\n", __func__, wil->n_msi);
+
 	if (wil->n_msi == 3)
 		rc = wil6210_request_3msi(wil, irq);
 	else
@@ -545,6 +548,8 @@ int wil6210_init_irq(struct wil6210_priv *wil, int irq)
 
 void wil6210_fini_irq(struct wil6210_priv *wil, int irq)
 {
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
 	wil6210_disable_irq(wil);
 	free_irq(irq, wil);
 	if (wil->n_msi == 3) {
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 8afd8a2..696be3e 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -301,12 +301,16 @@ int wil_priv_init(struct wil6210_priv *wil)
 
 void wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid)
 {
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
 	del_timer_sync(&wil->connect_timer);
 	_wil6210_disconnect(wil, bssid);
 }
 
 void wil_priv_deinit(struct wil6210_priv *wil)
 {
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
 	del_timer_sync(&wil->scan_timer);
 	cancel_work_sync(&wil->disconnect_worker);
 	cancel_work_sync(&wil->fw_error_worker);
@@ -457,6 +461,8 @@ int wil_reset(struct wil6210_priv *wil)
 {
 	int rc;
 
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
 	WARN_ON(!mutex_is_locked(&wil->mutex));
 
 	cancel_work_sync(&wil->disconnect_worker);
@@ -614,6 +620,8 @@ int wil_up(struct wil6210_priv *wil)
 {
 	int rc;
 
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
 	mutex_lock(&wil->mutex);
 	rc = __wil_up(wil);
 	mutex_unlock(&wil->mutex);
@@ -650,6 +658,8 @@ int wil_down(struct wil6210_priv *wil)
 {
 	int rc;
 
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
 	mutex_lock(&wil->mutex);
 	rc = __wil_down(wil);
 	mutex_unlock(&wil->mutex);
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index a44c2b6..a995d9d 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -22,6 +22,8 @@ static int wil_open(struct net_device *ndev)
 {
 	struct wil6210_priv *wil = ndev_to_wil(ndev);
 
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
 	return wil_up(wil);
 }
 
@@ -29,6 +31,8 @@ static int wil_stop(struct net_device *ndev)
 {
 	struct wil6210_priv *wil = ndev_to_wil(ndev);
 
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
 	return wil_down(wil);
 }
 
@@ -121,6 +125,8 @@ void *wil_if_alloc(struct device *dev, void __iomem *csr)
 	wil->csr = csr;
 	wil->wdev = wdev;
 
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
 	rc = wil_priv_init(wil);
 	if (rc) {
 		dev_err(dev, "wil_priv_init failed\n");
@@ -169,6 +175,8 @@ void wil_if_free(struct wil6210_priv *wil)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
 
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
 	if (!ndev)
 		return;
 
@@ -185,6 +193,8 @@ int wil_if_add(struct wil6210_priv *wil)
 	struct net_device *ndev = wil_to_ndev(wil);
 	int rc;
 
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
 	rc = register_netdev(ndev);
 	if (rc < 0) {
 		dev_err(&ndev->dev, "Failed to register netdev: %d\n", rc);
@@ -200,5 +210,7 @@ void wil_if_remove(struct wil6210_priv *wil)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
 
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
 	unregister_netdev(ndev);
 }
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 968f0d6..d2a1ca2 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -41,6 +41,8 @@ static int wil_if_pcie_enable(struct wil6210_priv *wil)
 	 */
 	int msi_only = pdev->msi_enabled;
 
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
 	pdev->msi_enabled = 0;
 
 	pci_set_master(pdev);
@@ -107,6 +109,8 @@ static int wil_if_pcie_disable(struct wil6210_priv *wil)
 {
 	struct pci_dev *pdev = wil->pdev;
 
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
 	pci_clear_master(pdev);
 	/* disable and release IRQ */
 	wil6210_fini_irq(wil, pdev->irq);
@@ -226,6 +230,8 @@ static void wil_pcie_remove(struct pci_dev *pdev)
 	struct wil6210_priv *wil = pci_get_drvdata(pdev);
 	void __iomem *csr = wil->csr;
 
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
 	wil6210_debugfs_remove(wil);
 	wil_if_pcie_disable(wil);
 	wil_if_remove(wil);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index ce0c4ba..02fd43d 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -87,6 +87,8 @@ static int wil_vring_alloc(struct wil6210_priv *wil, struct vring *vring)
 	size_t sz = vring->size * sizeof(vring->va[0]);
 	uint i;
 
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
 	BUILD_BUG_ON(sizeof(vring->va[0]) != 32);
 
 	vring->swhead = 0;
@@ -599,6 +601,8 @@ int wil_rx_init(struct wil6210_priv *wil)
 	struct vring *vring = &wil->vring_rx;
 	int rc;
 
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
 	if (vring->va) {
 		wil_err(wil, "Rx ring already allocated\n");
 		return -EINVAL;
@@ -628,6 +632,8 @@ void wil_rx_fini(struct wil6210_priv *wil)
 {
 	struct vring *vring = &wil->vring_rx;
 
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
 	if (vring->va)
 		wil_vring_free(wil, vring, 0);
 }
@@ -662,6 +668,8 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 	struct vring *vring = &wil->vring_tx[id];
 	struct vring_tx_data *txdata = &wil->vring_tx_data[id];
 
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
 	if (vring->va) {
 		wil_err(wil, "Tx ring [%d] already allocated\n", id);
 		rc = -EINVAL;
@@ -711,6 +719,8 @@ void wil_vring_fini_tx(struct wil6210_priv *wil, int id)
 	if (!vring->va)
 		return;
 
+	wil_dbg_misc(wil, "%s() id=%d\n", __func__, id);
+
 	/* make sure NAPI won't touch this vring */
 	wil->vring_tx_data[id].enabled = 0;
 	if (test_bit(wil_status_napi_en, &wil->status))
-- 
1.9.1

