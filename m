Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:40237 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933063Ab1JaJ4X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 05:56:23 -0400
Subject: [PATCH 4/5] ath6kl: add state variable depicting hw/fw state
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 31 Oct 2011 11:56:18 +0200
Message-ID: <20111031095618.3598.57602.stgit@localhost6.localdomain6> (sfid-20111031_105627_352747_1D9B6B06)
In-Reply-To: <20111031095550.3598.52653.stgit@localhost6.localdomain6>
References: <20111031095550.3598.52653.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This way it's easier to track state changes and in the future add
more warnings about using hardware in wrong states. Currently there
are few random flags for trying to do the same, those will be cleaned
and removed in the future.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   28 +++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath6kl/core.h     |    9 +++++++++
 drivers/net/wireless/ath/ath6kl/init.c     |    4 ++++
 3 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 0691a95..53aa3be 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1671,6 +1671,8 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 				    ret);
 		}
 
+		ar->state = ATH6KL_STATE_DEEPSLEEP;
+
 		break;
 	}
 
@@ -1679,11 +1681,25 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 
 int ath6kl_cfg80211_resume(struct ath6kl *ar)
 {
-	if (ar->wmi->pwr_mode != ar->wmi->saved_pwr_mode) {
-		if (ath6kl_wmi_powermode_cmd(ar->wmi, 0,
-			ar->wmi->saved_pwr_mode) != 0)
-			ath6kl_warn("ath6kl_sdio_resume: "
-				"wmi_powermode_cmd failed\n");
+	int ret;
+
+	switch (ar->state) {
+	case ATH6KL_STATE_DEEPSLEEP:
+		if (ar->wmi->pwr_mode != ar->wmi->saved_pwr_mode) {
+			ret = ath6kl_wmi_powermode_cmd(ar->wmi, 0,
+						       ar->wmi->saved_pwr_mode);
+			if (ret) {
+				ath6kl_warn("wmi powermode command failed during resume: %d\n",
+					    ret);
+			}
+		}
+
+		ar->state = ATH6KL_STATE_ON;
+
+		break;
+
+	default:
+		break;
 	}
 
 	return 0;
@@ -2251,6 +2267,8 @@ struct ath6kl *ath6kl_core_alloc(struct device *dev)
 	ar->sc_params.scan_ctrl_flags = DEFAULT_SCAN_CTRL_FLAGS;
 	ar->lrssi_roam_threshold = DEF_LRSSI_ROAM_THRESHOLD;
 
+	ar->state = ATH6KL_STATE_OFF;
+
 	memset((u8 *)ar->sta_list, 0,
 	       AP_MAX_NUM_STA * sizeof(struct ath6kl_sta));
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 00cc1db..6613248 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -450,9 +450,18 @@ enum ath6kl_dev_state {
 	FIRST_BOOT,
 };
 
+enum ath6kl_state {
+	ATH6KL_STATE_OFF,
+	ATH6KL_STATE_ON,
+	ATH6KL_STATE_DEEPSLEEP,
+};
+
 struct ath6kl {
 	struct device *dev;
 	struct wiphy *wiphy;
+
+	enum ath6kl_state state;
+
 	struct ath6kl_bmi bmi;
 	const struct ath6kl_hif_ops *hif_ops;
 	struct wmi *wmi;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 06e5cea..f7fcd91 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1452,6 +1452,8 @@ int ath6kl_init_hw_start(struct ath6kl *ar)
 			goto err_htc_stop;
 	}
 
+	ar->state = ATH6KL_STATE_ON;
+
 	return 0;
 
 err_htc_stop:
@@ -1480,6 +1482,8 @@ int ath6kl_init_hw_stop(struct ath6kl *ar)
 	if (ret)
 		ath6kl_warn("failed to power off hif: %d\n", ret);
 
+	ar->state = ATH6KL_STATE_OFF;
+
 	return 0;
 }
 

