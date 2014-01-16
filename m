Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:64646 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbaAPJSh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 04:18:37 -0500
Received: by mail-pa0-f42.google.com with SMTP id kl14so2422864pab.15
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 01:18:36 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] ath10k: set the AP keepalive timer
Date: Thu, 16 Jan 2014 17:18:24 +0800
Message-Id: <1389863904-7159-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20140116_101843_266333_489BF9EA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the AP keepalive timer as following:
ap_keepalive_min_idle_inactive_time_secs to 60 seconds
ap_keepalive_max_idle_inactive_time_secs to 120 seconds
ap_keepalive_max_unresponsive_time_secs to 300 seconds

This ensure that the WMI_PEER_STA_KICKOUT_EVENTID is triggered
by the FW only once the unresponsive timer is expired.

Tested with firmware version 999.999.0.636 but the timer
is still default to 100 seconds. Tested with firmware 
version 10.1.467-1, the timer is set according to 
ap_keepalive_max_unresponsive_time_secs.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   22 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h |    3 +++
 2 files changed, 25 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 776e364..2141034 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2313,6 +2313,28 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_pdev_set_param(ar, param_id, 0);
 		if (ret)
 			ath10k_warn("Failed to disable STA KICKOUT\n");
+
+		/* Set the AP keepalive timer */
+		vdev_param =
+			ar->wmi.vdev_param->ap_keepalive_min_idle_inactive_time_secs;
+		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
+			WMI_VDEV_AP_KEEPALIVE_MIN_IDLE_INACTIVE_TIME_SECS);
+		if (ret)
+			ath10k_warn("Failed to set keepalive min idle timer\n");
+
+		vdev_param =
+			ar->wmi.vdev_param->ap_keepalive_max_idle_inactive_time_secs;
+		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
+			WMI_VDEV_AP_KEEPALIVE_MAX_IDLE_INACTIVE_TIME_SECS);
+		if (ret)
+			ath10k_warn("Failed to set keepalive max idle timer\n");
+
+		vdev_param =
+			ar->wmi.vdev_param->ap_keepalive_max_unresponsive_time_secs;
+		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
+			WMI_VDEV_AP_KEEPALIVE_MAX_UNRESPONSIVE_TIME_SECS);
+		if (ret)
+			ath10k_warn("Failed to set keepalive unresponsive timer\n");
 	}
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_STA) {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 4b5e7d3..7ce002a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -3080,6 +3080,9 @@ struct wmi_vdev_param_map {
 };
 
 #define WMI_VDEV_PARAM_UNSUPPORTED 0
+#define WMI_VDEV_AP_KEEPALIVE_MIN_IDLE_INACTIVE_TIME_SECS 60
+#define WMI_VDEV_AP_KEEPALIVE_MAX_IDLE_INACTIVE_TIME_SECS 120
+#define WMI_VDEV_AP_KEEPALIVE_MAX_UNRESPONSIVE_TIME_SECS 300
 
 /* the definition of different VDEV parameters */
 enum wmi_vdev_param {
-- 
1.7.9.5

