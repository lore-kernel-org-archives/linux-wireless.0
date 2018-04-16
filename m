Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:57072 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755008AbeDPNQu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 09:16:50 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, kvalo@codeaurora.org,
        loic.poulain@linaro.org, rfried@codeaurora.org,
        bjorn.andersson@linaro.org, Daniel Mack <daniel@zonque.org>
Subject: [PATCH 5/5] wcn36xx: pass information elements in scan requests
Date: Mon, 16 Apr 2018 15:16:34 +0200
Message-Id: <20180416131634.25432-6-daniel@zonque.org> (sfid-20180416_151654_275731_1F6043CC)
In-Reply-To: <20180416131634.25432-1-daniel@zonque.org>
References: <20180416131634.25432-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the ieee8022 core passes IE elements in the scan request, append
them to the firmware message. The driver currently tells the core that
it is capable of attaching up to WCN36XX_MAX_SCAN_IE_LEN octets, but
doesn't actually pass them to the the hardware.

Some defines were moved around to avoid cyclic include dependencies.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/net/wireless/ath/wcn36xx/hal.h     |  8 +++++++-
 drivers/net/wireless/ath/wcn36xx/smd.c     | 12 ++++++++++++
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  6 ------
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
index 182963522941..2aed6c233508 100644
--- a/drivers/net/wireless/ath/wcn36xx/hal.h
+++ b/drivers/net/wireless/ath/wcn36xx/hal.h
@@ -88,6 +88,12 @@
 /* version string max length (including NULL) */
 #define WCN36XX_HAL_VERSION_LENGTH  64
 
+/* How many frames until we start a-mpdu TX session */
+#define WCN36XX_AMPDU_START_THRESH	20
+
+#define WCN36XX_MAX_SCAN_SSIDS		9
+#define WCN36XX_MAX_SCAN_IE_LEN		500
+
 /* message types for messages exchanged between WDI and HAL */
 enum wcn36xx_hal_host_msg_type {
 	/* Init/De-Init */
@@ -1170,7 +1176,7 @@ struct wcn36xx_hal_start_scan_offload_req_msg {
 
 	/* IE field */
 	u16 ie_len;
-	u8 ie[0];
+	u8 ie[WCN36XX_MAX_SCAN_IE_LEN];
 } __packed;
 
 struct wcn36xx_hal_start_scan_offload_rsp_msg {
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 09320c3f6bd0..ea74f2b92df5 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -620,9 +620,13 @@ int wcn36xx_smd_finish_scan(struct wcn36xx *wcn,
 int wcn36xx_smd_start_hw_scan(struct wcn36xx *wcn, struct ieee80211_vif *vif,
 			      struct cfg80211_scan_request *req)
 {
+	struct wcn36xx_vif *vif_priv = wcn36xx_vif_to_priv(vif);
 	struct wcn36xx_hal_start_scan_offload_req_msg msg_body;
 	int ret, i;
 
+	if (req->ie_len > WCN36XX_MAX_SCAN_IE_LEN)
+		return -EINVAL;
+
 	mutex_lock(&wcn->hal_mutex);
 	INIT_HAL_MSG(msg_body, WCN36XX_HAL_START_SCAN_OFFLOAD_REQ);
 
@@ -647,6 +651,14 @@ int wcn36xx_smd_start_hw_scan(struct wcn36xx *wcn, struct ieee80211_vif *vif,
 	for (i = 0; i < msg_body.num_channel; i++)
 		msg_body.channels[i] = req->channels[i]->hw_value;
 
+	msg_body.header.len -= WCN36XX_MAX_SCAN_IE_LEN;
+
+	if (req->ie_len > 0) {
+		msg_body.ie_len = req->ie_len;
+		msg_body.header.len += req->ie_len;
+		memcpy(msg_body.ie, req->ie, req->ie_len);
+	}
+
 	PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
 
 	wcn36xx_dbg(WCN36XX_DBG_HAL,
diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index 22e05cb4eb98..9343989d1169 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -32,12 +32,6 @@
 #define WLAN_NV_FILE               "wlan/prima/WCNSS_qcom_wlan_nv.bin"
 #define WCN36XX_AGGR_BUFFER_SIZE 64
 
-/* How many frames until we start a-mpdu TX session */
-#define WCN36XX_AMPDU_START_THRESH	20
-
-#define WCN36XX_MAX_SCAN_SSIDS		9
-#define WCN36XX_MAX_SCAN_IE_LEN		500
-
 extern unsigned int wcn36xx_dbg_mask;
 
 enum wcn36xx_debug_mask {
-- 
2.14.3
