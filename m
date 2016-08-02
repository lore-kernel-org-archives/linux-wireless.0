Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5618 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274AbcHBLnx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 07:43:53 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 5/8] wil6210: fix stop p2p device handling
Date: Tue,  2 Aug 2016 14:42:09 +0300
Message-Id: <1470138132-18071-6-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160802_195556_434415_18C9423E)
In-Reply-To: <1470138132-18071-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1470138132-18071-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fix stop p2p device handling to identify between search
and listen and update the upper layers with the appropriate
notification.
The stop of p2p radio operations also needs to be performed
in __wil_down.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 25 ++++++----------
 drivers/net/wireless/ath/wil6210/main.c     |  2 +-
 drivers/net/wireless/ath/wil6210/p2p.c      | 46 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/pcie_bus.c |  5 +++-
 drivers/net/wireless/ath/wil6210/wil6210.h  |  1 +
 5 files changed, 61 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 110098e..310a385 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1409,23 +1409,16 @@ static void wil_cfg80211_stop_p2p_device(struct wiphy *wiphy,
 					 struct wireless_dev *wdev)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
-	u8 started;
+	struct wil_p2p_info *p2p = &wil->p2p;
+
+	if (!p2p->p2p_dev_started)
+		return;
 
 	wil_dbg_misc(wil, "%s: entered\n", __func__);
 	mutex_lock(&wil->mutex);
-	started = wil_p2p_stop_discovery(wil);
-	if (started && wil->scan_request) {
-		struct cfg80211_scan_info info = {
-			.aborted = true,
-		};
-
-		cfg80211_scan_done(wil->scan_request, &info);
-		wil->scan_request = NULL;
-		wil->radio_wdev = wil->wdev;
-	}
+	wil_p2p_stop_radio_operations(wil);
+	p2p->p2p_dev_started = 0;
 	mutex_unlock(&wil->mutex);
-
-	wil->p2p.p2p_dev_started = 0;
 }
 
 static struct cfg80211_ops wil_cfg80211_ops = {
@@ -1544,11 +1537,11 @@ void wil_p2p_wdev_free(struct wil6210_priv *wil)
 
 	mutex_lock(&wil->p2p_wdev_mutex);
 	p2p_wdev = wil->p2p_wdev;
+	wil->p2p_wdev = NULL;
+	wil->radio_wdev = wil_to_wdev(wil);
+	mutex_unlock(&wil->p2p_wdev_mutex);
 	if (p2p_wdev) {
-		wil->p2p_wdev = NULL;
-		wil->radio_wdev = wil_to_wdev(wil);
 		cfg80211_unregister_wdev(p2p_wdev);
 		kfree(p2p_wdev);
 	}
-	mutex_unlock(&wil->p2p_wdev_mutex);
 }
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 1205d76..bbc54ee 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1050,7 +1050,7 @@ int __wil_down(struct wil6210_priv *wil)
 	}
 	wil_enable_irq(wil);
 
-	(void)wil_p2p_stop_discovery(wil);
+	wil_p2p_stop_radio_operations(wil);
 
 	if (wil->scan_request) {
 		struct cfg80211_scan_info info = {
diff --git a/drivers/net/wireless/ath/wil6210/p2p.c b/drivers/net/wireless/ath/wil6210/p2p.c
index e0f8aa0..4087785 100644
--- a/drivers/net/wireless/ath/wil6210/p2p.c
+++ b/drivers/net/wireless/ath/wil6210/p2p.c
@@ -263,3 +263,49 @@ void wil_p2p_search_expired(struct work_struct *work)
 		mutex_unlock(&wil->p2p_wdev_mutex);
 	}
 }
+
+void wil_p2p_stop_radio_operations(struct wil6210_priv *wil)
+{
+	struct wil_p2p_info *p2p = &wil->p2p;
+	struct cfg80211_scan_info info = {
+		.aborted = true,
+	};
+
+	lockdep_assert_held(&wil->mutex);
+
+	mutex_lock(&wil->p2p_wdev_mutex);
+
+	if (wil->radio_wdev != wil->p2p_wdev)
+		goto out;
+
+	if (!p2p->discovery_started) {
+		/* Regular scan on the p2p device */
+		if (wil->scan_request &&
+		    wil->scan_request->wdev == wil->p2p_wdev) {
+			cfg80211_scan_done(wil->scan_request, &info);
+			wil->scan_request = NULL;
+		}
+		goto out;
+	}
+
+	/* Search or listen on p2p device */
+	mutex_unlock(&wil->p2p_wdev_mutex);
+	wil_p2p_stop_discovery(wil);
+	mutex_lock(&wil->p2p_wdev_mutex);
+
+	if (wil->scan_request) {
+		/* search */
+		cfg80211_scan_done(wil->scan_request, &info);
+		wil->scan_request = NULL;
+	} else {
+		/* listen */
+		cfg80211_remain_on_channel_expired(wil->radio_wdev,
+						   p2p->cookie,
+						   &p2p->listen_chan,
+						   GFP_KERNEL);
+	}
+
+out:
+	wil->radio_wdev = wil->wdev;
+	mutex_unlock(&wil->p2p_wdev_mutex);
+}
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 7b5c422..5b7a9d2 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -20,6 +20,7 @@
 #include <linux/interrupt.h>
 #include <linux/suspend.h>
 #include "wil6210.h"
+#include <linux/rtnetlink.h>
 
 static bool use_msi = true;
 module_param(use_msi, bool, S_IRUGO);
@@ -293,6 +294,9 @@ static void wil_pcie_remove(struct pci_dev *pdev)
 #endif /* CONFIG_PM */
 
 	wil6210_debugfs_remove(wil);
+	rtnl_lock();
+	wil_p2p_wdev_free(wil);
+	rtnl_unlock();
 	wil_if_remove(wil);
 	wil_if_pcie_disable(wil);
 	pci_iounmap(pdev, csr);
@@ -300,7 +304,6 @@ static void wil_pcie_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 	if (wil->platform_ops.uninit)
 		wil->platform_ops.uninit(wil->platform_handle);
-	wil_p2p_wdev_free(wil);
 	wil_if_free(wil);
 }
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 9742446..6087691 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -841,6 +841,7 @@ u8 wil_p2p_stop_discovery(struct wil6210_priv *wil);
 int wil_p2p_cancel_listen(struct wil6210_priv *wil, u64 cookie);
 void wil_p2p_listen_expired(struct work_struct *work);
 void wil_p2p_search_expired(struct work_struct *work);
+void wil_p2p_stop_radio_operations(struct wil6210_priv *wil);
 
 /* WMI for P2P */
 int wmi_p2p_cfg(struct wil6210_priv *wil, int channel, int bi);
-- 
1.9.1

