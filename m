Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 490C4C10F00
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1543D20700
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfBVOVi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:21:38 -0500
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:54040 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726978AbfBVOVg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 09:21:36 -0500
X-IronPort-AV: E=Sophos;i="5.58,400,1544482800"; 
   d="scan'208";a="2017380"
Received: from ironmsg02-ams.qualcomm.com ([10.251.56.3])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 22 Feb 2019 15:21:30 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9174"; a="7285586"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg02-ams.qualcomm.com with ESMTP; 22 Feb 2019 15:21:29 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 13/21] wil6210: check mid is valid
Date:   Fri, 22 Feb 2019 16:21:11 +0200
Message-Id: <1550845279-16103-14-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
References: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ahmad Masri <amasri@codeaurora.org>

Check that the mid is valid and that it does not exceed the memory
size allocated to vifs array.

Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  6 +++---
 drivers/net/wireless/ath/wil6210/debugfs.c  | 10 +++++-----
 drivers/net/wireless/ath/wil6210/main.c     |  8 ++++----
 drivers/net/wireless/ath/wil6210/netdev.c   | 10 +++++-----
 drivers/net/wireless/ath/wil6210/pcie_bus.c |  4 ++--
 drivers/net/wireless/ath/wil6210/pm.c       |  6 +++---
 drivers/net/wireless/ath/wil6210/wil6210.h  |  1 +
 drivers/net/wireless/ath/wil6210/wmi.c      |  2 +-
 8 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index a1e226652..e8d65dd 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -465,7 +465,7 @@ static int wil_cfg80211_validate_add_iface(struct wil6210_priv *wil,
 		.num_different_channels = 1,
 	};
 
-	for (i = 0; i < wil->max_vifs; i++) {
+	for (i = 0; i < GET_MAX_VIFS(wil); i++) {
 		if (wil->vifs[i]) {
 			wdev = vif_to_wdev(wil->vifs[i]);
 			params.iftype_num[wdev->iftype]++;
@@ -486,7 +486,7 @@ static int wil_cfg80211_validate_change_iface(struct wil6210_priv *wil,
 	};
 	bool check_combos = false;
 
-	for (i = 0; i < wil->max_vifs; i++) {
+	for (i = 0; i < GET_MAX_VIFS(wil); i++) {
 		struct wil6210_vif *vif_pos = wil->vifs[i];
 
 		if (vif_pos && vif != vif_pos) {
@@ -1806,7 +1806,7 @@ void wil_cfg80211_ap_recovery(struct wil6210_priv *wil)
 	int rc, i;
 	struct wiphy *wiphy = wil_to_wiphy(wil);
 
-	for (i = 0; i < wil->max_vifs; i++) {
+	for (i = 0; i < GET_MAX_VIFS(wil); i++) {
 		struct wil6210_vif *vif = wil->vifs[i];
 		struct net_device *ndev;
 		struct cfg80211_beacon_data bcon = {};
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 27cb182..817762f 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1381,7 +1381,7 @@ static int link_show(struct seq_file *s, void *data)
 		if (p->status != wil_sta_connected)
 			continue;
 
-		vif = (mid < wil->max_vifs) ? wil->vifs[mid] : NULL;
+		vif = (mid < GET_MAX_VIFS(wil)) ? wil->vifs[mid] : NULL;
 		if (vif) {
 			rc = wil_cid_fill_sinfo(vif, i, sinfo);
 			if (rc)
@@ -1579,7 +1579,7 @@ static int sta_show(struct seq_file *s, void *data)
 			break;
 		}
 		mid = (p->status != wil_sta_unused) ? p->mid : U8_MAX;
-		if (mid < wil->max_vifs) {
+		if (mid < GET_MAX_VIFS(wil)) {
 			struct wil6210_vif *vif = wil->vifs[mid];
 
 			if (vif->wdev.iftype == NL80211_IFTYPE_STATION &&
@@ -1645,7 +1645,7 @@ static int mids_show(struct seq_file *s, void *data)
 	int i;
 
 	mutex_lock(&wil->vif_mutex);
-	for (i = 0; i < wil->max_vifs; i++) {
+	for (i = 0; i < GET_MAX_VIFS(wil); i++) {
 		vif = wil->vifs[i];
 
 		if (vif) {
@@ -1866,7 +1866,7 @@ static int wil_link_stats_debugfs_show(struct seq_file *s, void *data)
 	/* iterate over all MIDs and show per-cid statistics. Then show the
 	 * global statistics
 	 */
-	for (i = 0; i < wil->max_vifs; i++) {
+	for (i = 0; i < GET_MAX_VIFS(wil); i++) {
 		vif = wil->vifs[i];
 
 		seq_printf(s, "MID %d ", i);
@@ -1922,7 +1922,7 @@ static ssize_t wil_link_stats_write(struct file *file, const char __user *buf,
 	if (rc)
 		return rc;
 
-	for (i = 0; i < wil->max_vifs; i++) {
+	for (i = 0; i < GET_MAX_VIFS(wil); i++) {
 		vif = wil->vifs[i];
 		if (!vif)
 			continue;
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index f2432ad..6a6bfb3 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -685,7 +685,7 @@ void wil_bcast_fini_all(struct wil6210_priv *wil)
 	int i;
 	struct wil6210_vif *vif;
 
-	for (i = 0; i < wil->max_vifs; i++) {
+	for (i = 0; i < GET_MAX_VIFS(wil); i++) {
 		vif = wil->vifs[i];
 		if (vif)
 			wil_bcast_fini(vif);
@@ -1483,7 +1483,7 @@ void wil_abort_scan_all_vifs(struct wil6210_priv *wil, bool sync)
 
 	lockdep_assert_held(&wil->vif_mutex);
 
-	for (i = 0; i < wil->max_vifs; i++) {
+	for (i = 0; i < GET_MAX_VIFS(wil); i++) {
 		struct wil6210_vif *vif = wil->vifs[i];
 
 		if (vif)
@@ -1551,7 +1551,7 @@ static int wil_restore_vifs(struct wil6210_priv *wil)
 	struct wireless_dev *wdev;
 	int i, rc;
 
-	for (i = 0; i < wil->max_vifs; i++) {
+	for (i = 0; i < GET_MAX_VIFS(wil); i++) {
 		vif = wil->vifs[i];
 		if (!vif)
 			continue;
@@ -1627,7 +1627,7 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 	wil_abort_scan_all_vifs(wil, false);
 	mutex_unlock(&wil->vif_mutex);
 
-	for (i = 0; i < wil->max_vifs; i++) {
+	for (i = 0; i < GET_MAX_VIFS(wil); i++) {
 		vif = wil->vifs[i];
 		if (vif) {
 			cancel_work_sync(&vif->disconnect_worker);
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index b4e0eb1..59f041d 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -27,7 +27,7 @@ bool wil_has_other_active_ifaces(struct wil6210_priv *wil,
 	struct wil6210_vif *vif;
 	struct net_device *ndev_i;
 
-	for (i = 0; i < wil->max_vifs; i++) {
+	for (i = 0; i < GET_MAX_VIFS(wil); i++) {
 		vif = wil->vifs[i];
 		if (vif) {
 			ndev_i = vif_to_ndev(vif);
@@ -155,7 +155,7 @@ static int wil6210_netdev_poll_tx(struct napi_struct *napi, int budget)
 		struct wil6210_vif *vif;
 
 		if (!ring->va || !txdata->enabled ||
-		    txdata->mid >= wil->max_vifs)
+		    txdata->mid >= GET_MAX_VIFS(wil))
 			continue;
 
 		vif = wil->vifs[txdata->mid];
@@ -294,7 +294,7 @@ static u8 wil_vif_find_free_mid(struct wil6210_priv *wil)
 {
 	u8 i;
 
-	for (i = 0; i < wil->max_vifs; i++) {
+	for (i = 0; i < GET_MAX_VIFS(wil); i++) {
 		if (!wil->vifs[i])
 			return i;
 	}
@@ -500,7 +500,7 @@ void wil_vif_remove(struct wil6210_priv *wil, u8 mid)
 	bool any_active = wil_has_active_ifaces(wil, true, false);
 
 	ASSERT_RTNL();
-	if (mid >= wil->max_vifs) {
+	if (mid >= GET_MAX_VIFS(wil)) {
 		wil_err(wil, "invalid MID: %d\n", mid);
 		return;
 	}
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index c8c6613..3b82d6c 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -176,7 +176,7 @@ static void wil_remove_all_additional_vifs(struct wil6210_priv *wil)
 	struct wil6210_vif *vif;
 	int i;
 
-	for (i = 1; i < wil->max_vifs; i++) {
+	for (i = 1; i < GET_MAX_VIFS(wil); i++) {
 		vif = wil->vifs[i];
 		if (vif) {
 			wil_vif_prepare_stop(vif);
diff --git a/drivers/net/wireless/ath/wil6210/pm.c b/drivers/net/wireless/ath/wil6210/pm.c
index f307522..56143e7 100644
--- a/drivers/net/wireless/ath/wil6210/pm.c
+++ b/drivers/net/wireless/ath/wil6210/pm.c
@@ -26,7 +26,7 @@ static void wil_pm_wake_connected_net_queues(struct wil6210_priv *wil)
 	int i;
 
 	mutex_lock(&wil->vif_mutex);
-	for (i = 0; i < wil->max_vifs; i++) {
+	for (i = 0; i < GET_MAX_VIFS(wil); i++) {
 		struct wil6210_vif *vif = wil->vifs[i];
 
 		if (vif && test_bit(wil_vif_fwconnected, vif->status))
@@ -40,7 +40,7 @@ static void wil_pm_stop_all_net_queues(struct wil6210_priv *wil)
 	int i;
 
 	mutex_lock(&wil->vif_mutex);
-	for (i = 0; i < wil->max_vifs; i++) {
+	for (i = 0; i < GET_MAX_VIFS(wil); i++) {
 		struct wil6210_vif *vif = wil->vifs[i];
 
 		if (vif)
@@ -123,7 +123,7 @@ int wil_can_suspend(struct wil6210_priv *wil, bool is_runtime)
 
 	/* interface is running */
 	mutex_lock(&wil->vif_mutex);
-	for (i = 0; i < wil->max_vifs; i++) {
+	for (i = 0; i < GET_MAX_VIFS(wil); i++) {
 		struct wil6210_vif *vif = wil->vifs[i];
 
 		if (!vif)
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 1b81f3f..de72466 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -1061,6 +1061,7 @@ struct wil6210_priv {
 #define vif_to_wil(v) (v->wil)
 #define vif_to_ndev(v) (v->ndev)
 #define vif_to_wdev(v) (&v->wdev)
+#define GET_MAX_VIFS(wil) min_t(int, (wil)->max_vifs, WIL_MAX_VIFS)
 
 static inline struct wil6210_vif *wdev_to_vif(struct wil6210_priv *wil,
 					      struct wireless_dev *wdev)
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 19247c5..c5bcb8d 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -3205,7 +3205,7 @@ static void wmi_event_handle(struct wil6210_priv *wil,
 
 		if (mid == MID_BROADCAST)
 			mid = 0;
-		if (mid >= ARRAY_SIZE(wil->vifs) || mid >= wil->max_vifs) {
+		if (mid >= GET_MAX_VIFS(wil)) {
 			wil_dbg_wmi(wil, "invalid mid %d, event skipped\n",
 				    mid);
 			return;
-- 
1.9.1

