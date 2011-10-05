Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:48706 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab1JEHM5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 03:12:57 -0400
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh03-2.mail.saunalahti.fi (Postfix) with SMTP id 6698DEC464
	for <linux-wireless@vger.kernel.org>; Wed,  5 Oct 2011 10:12:56 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh04.mail.saunalahti.fi (Postfix) with ESMTP id 4438741BEE
	for <linux-wireless@vger.kernel.org>; Wed,  5 Oct 2011 10:12:53 +0300 (EEST)
Subject: [PATCH] ath6kl: make sure WLAN power save is enabled during suspend
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Wed, 05 Oct 2011 10:12:52 +0300
Message-ID: <20111005071252.19388.38625.stgit@localhost6.localdomain6> (sfid-20111005_091301_333300_C55A0815)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chilam Ng <chilamng@qca.qualcomm.com>

Power save is enabled during ath6kl init. But when user space disables power
save, the system will go into suspend with power save disabled. The ath6kl
driver will now explicitly enable power save prior to entering suspend and
restore its previous setting upon resume

Signed-off-by: Chilam Ng <chilamng@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    8 ++++++++
 drivers/net/wireless/ath/ath6kl/hif-ops.h  |    4 ++++
 drivers/net/wireless/ath/ath6kl/hif.h      |    1 +
 drivers/net/wireless/ath/ath6kl/main.c     |    7 +++++++
 drivers/net/wireless/ath/ath6kl/sdio.c     |   13 +++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |    1 +
 6 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 2dae5d8..b7b2c57 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1421,6 +1421,13 @@ static int ar6k_cfg80211_suspend(struct wiphy *wiphy,
 
 	return ath6kl_hif_suspend(ar);
 }
+
+static int ar6k_cfg80211_resume(struct wiphy *wiphy)
+{
+	struct ath6kl *ar = wiphy_priv(wiphy);
+
+	return ath6kl_hif_resume(ar);
+}
 #endif
 
 static int ath6kl_set_channel(struct wiphy *wiphy, struct net_device *dev,
@@ -1831,6 +1838,7 @@ static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	CFG80211_TESTMODE_CMD(ath6kl_tm_cmd)
 #ifdef CONFIG_PM
 	.suspend = ar6k_cfg80211_suspend,
+	.resume = ar6k_cfg80211_resume,
 #endif
 	.set_channel = ath6kl_set_channel,
 	.add_beacon = ath6kl_add_beacon,
diff --git a/drivers/net/wireless/ath/ath6kl/hif-ops.h b/drivers/net/wireless/ath/ath6kl/hif-ops.h
index d6c898f..21b1575 100644
--- a/drivers/net/wireless/ath/ath6kl/hif-ops.h
+++ b/drivers/net/wireless/ath/ath6kl/hif-ops.h
@@ -74,4 +74,8 @@ static inline int ath6kl_hif_suspend(struct ath6kl *ar)
 	return ar->hif_ops->suspend(ar);
 }
 
+static inline int ath6kl_hif_resume(struct ath6kl *ar)
+{
+	return ar->hif_ops->resume(ar);
+}
 #endif
diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index 797e2d1..906fde9 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -203,6 +203,7 @@ struct ath6kl_hif_ops {
 			    struct hif_scatter_req *scat_req);
 	void (*cleanup_scatter)(struct ath6kl *ar);
 	int (*suspend)(struct ath6kl *ar);
+	int (*resume)(struct ath6kl *ar);
 };
 
 #endif
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index adb1635..e693756 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -959,6 +959,13 @@ void ath6kl_deep_sleep_enable(struct ath6kl *ar)
 		       "during suspend\n");
 
 	ath6kl_cfg80211_scan_complete_event(ar, -ECANCELED);
+
+	/* save the current power mode before enabling power save */
+	ar->wmi->saved_pwr_mode = ar->wmi->pwr_mode;
+
+	if (ath6kl_wmi_powermode_cmd(ar->wmi, REC_POWER) != 0)
+		ath6kl_warn("ath6kl_deep_sleep_enable: "
+			"wmi_powermode_cmd failed\n");
 }
 
 /* WMI Event handlers */
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 7695c29..9b8ee1f 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -743,6 +743,18 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar)
 	return 0;
 }
 
+static int ath6kl_sdio_resume(struct ath6kl *ar)
+{
+	if (ar->wmi->pwr_mode != ar->wmi->saved_pwr_mode) {
+		if (ath6kl_wmi_powermode_cmd(ar->wmi,
+			ar->wmi->saved_pwr_mode) != 0)
+			ath6kl_warn("ath6kl_sdio_resume: "
+				"wmi_powermode_cmd failed\n");
+	}
+
+	return 0;
+}
+
 static const struct ath6kl_hif_ops ath6kl_sdio_ops = {
 	.read_write_sync = ath6kl_sdio_read_write_sync,
 	.write_async = ath6kl_sdio_write_async,
@@ -754,6 +766,7 @@ static const struct ath6kl_hif_ops ath6kl_sdio_ops = {
 	.scat_req_rw = ath6kl_sdio_async_rw_scatter,
 	.cleanup_scatter = ath6kl_sdio_cleanup_scatter,
 	.suspend = ath6kl_sdio_suspend,
+	.resume = ath6kl_sdio_resume,
 };
 
 static int ath6kl_sdio_probe(struct sdio_func *func,
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index f8e644d..1600e7c 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -132,6 +132,7 @@ struct wmi {
 
 	u8 *last_mgmt_tx_frame;
 	size_t last_mgmt_tx_frame_len;
+	u8 saved_pwr_mode;
 };
 
 struct host_app_area {

