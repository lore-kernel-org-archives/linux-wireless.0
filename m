Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:25299 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388425AbeGXIuE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 04:50:04 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH v2 12/19] wil6210: support max aggregation window size 64
Date: Tue, 24 Jul 2018 10:44:33 +0300
Message-Id: <1532418280-5849-13-git-send-email-merez@codeaurora.org> (sfid-20180724_094516_368736_79C4F593)
In-Reply-To: <1532418280-5849-1-git-send-email-merez@codeaurora.org>
References: <1532418280-5849-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FW can support BACK window size 64 for performance improvements.
A new FW capability is added for notifying the host on the increased
max BACK win size support.
Defining WIL_MAX_AGG_WSIZE_64 and WIL_MAX_AMPDU_SIZE_128 to be used
in this case.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/main.c       | 9 +++++++++
 drivers/net/wireless/ath/wil6210/rx_reorder.c | 8 ++++----
 drivers/net/wireless/ath/wil6210/wil6210.h    | 5 +++++
 drivers/net/wireless/ath/wil6210/wmi.h        | 1 +
 4 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 9495c6c..a949e91 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1141,6 +1141,15 @@ void wil_refresh_fw_capabilities(struct wil6210_priv *wil)
 
 		wil->platform_ops.set_features(wil->platform_handle, features);
 	}
+
+	if (test_bit(WMI_FW_CAPABILITY_BACK_WIN_SIZE_64,
+		     wil->fw_capabilities)) {
+		wil->max_agg_wsize = WIL_MAX_AGG_WSIZE_64;
+		wil->max_ampdu_size = WIL_MAX_AMPDU_SIZE_128;
+	} else {
+		wil->max_agg_wsize = WIL_MAX_AGG_WSIZE;
+		wil->max_ampdu_size = WIL_MAX_AMPDU_SIZE;
+	}
 }
 
 void wil_mbox_ring_le2cpus(struct wil6210_mbox_ring *r)
diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index ba4e93f..b608aa1 100644
--- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -297,7 +297,7 @@ void wil_tid_ampdu_rx_free(struct wil6210_priv *wil,
 /* ADDBA processing */
 static u16 wil_agg_size(struct wil6210_priv *wil, u16 req_agg_wsize)
 {
-	u16 max_agg_size = min_t(u16, WIL_MAX_AGG_WSIZE, WIL_MAX_AMPDU_SIZE /
+	u16 max_agg_size = min_t(u16, wil->max_agg_wsize, wil->max_ampdu_size /
 				 (mtu_max + WIL_MAX_MPDU_OVERHEAD));
 
 	if (!req_agg_wsize)
@@ -364,11 +364,11 @@ int wil_addba_rx_request(struct wil6210_priv *wil, u8 mid,
 	if (status == WLAN_STATUS_SUCCESS) {
 		if (req_agg_wsize == 0) {
 			wil_dbg_misc(wil, "Suggest BACK wsize %d\n",
-				     WIL_MAX_AGG_WSIZE);
-			agg_wsize = WIL_MAX_AGG_WSIZE;
+				     wil->max_agg_wsize);
+			agg_wsize = wil->max_agg_wsize;
 		} else {
 			agg_wsize = min_t(u16,
-					  WIL_MAX_AGG_WSIZE, req_agg_wsize);
+					  wil->max_agg_wsize, req_agg_wsize);
 		}
 	}
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index e87c889..b5d8ad2 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -90,6 +90,8 @@ static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
 #define WIL6210_NAPI_BUDGET	(16) /* arbitrary */
 #define WIL_MAX_AMPDU_SIZE	(64 * 1024) /* FW/HW limit */
 #define WIL_MAX_AGG_WSIZE	(32) /* FW/HW limit */
+#define WIL_MAX_AMPDU_SIZE_128	(128 * 1024) /* FW/HW limit */
+#define WIL_MAX_AGG_WSIZE_64	(64) /* FW/HW limit */
 #define WIL6210_MAX_STATUS_RINGS	(8)
 
 /* Hardware offload block adds the following:
@@ -1013,6 +1015,9 @@ struct wil6210_priv {
 	u8 boot_config;
 
 	struct wil_fw_stats_global fw_stats_global;
+
+	u32 max_agg_wsize;
+	u32 max_ampdu_size;
 };
 
 #define wil_to_wiphy(i) (i->wiphy)
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index 00cf3c4..719f310 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -99,6 +99,7 @@ enum wmi_fw_capability {
 	WMI_FW_CAPABILITY_AP_SME_OFFLOAD_NONE		= 19,
 	WMI_FW_CAPABILITY_MULTI_VIFS			= 20,
 	WMI_FW_CAPABILITY_FT_ROAMING			= 21,
+	WMI_FW_CAPABILITY_BACK_WIN_SIZE_64		= 22,
 	WMI_FW_CAPABILITY_AMSDU				= 23,
 	WMI_FW_CAPABILITY_MAX,
 };
-- 
1.9.1
