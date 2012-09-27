Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12993 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab2I0Muv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 08:50:51 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <ath6kl-devel@qualcomm.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 5/6] ath6kl: Fix mapping uplink endpoint for AR6004
Date: Thu, 27 Sep 2012 18:19:52 +0530
Message-ID: <1348750193-2665-5-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120927_145054_038032_60DA3EAF)
In-Reply-To: <1348750193-2665-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1348750193-2665-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

AR6004(UB134) firmware supports only LP Endpoint, So map
all Access Categories to Low Priority endpoints. This fixes a WPA2
connection issue as the uplink(tx) endpoint is appropriately
mapped in sync with the firmware.

Tested-by: Ben Gray <ben.r.gray@gmail.com>
Reported-by: Ben Gray <ben.r.gray@gmail.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    1 +
 drivers/net/wireless/ath/ath6kl/init.c |    5 +++--
 drivers/net/wireless/ath/ath6kl/usb.c  |   12 ++++++++++--
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 95fc9b3..1778bd3 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -151,6 +151,7 @@ struct ath6kl_fw_ie {
 enum ath6kl_hw_flags {
 	ATH6KL_HW_64BIT_RATES		= BIT(0),
 	ATH6KL_HW_AP_INACTIVITY_MINS	= BIT(1),
+	ATH6KL_HW_MAP_LP_ENDPOINT	= BIT(2),
 };
 
 #define ATH6KL_FW_API2_FILE "fw-2.bin"
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 7ffb853..bb6aeea 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -155,7 +155,8 @@ static const struct ath6kl_hw hw_list[] = {
 		.refclk_hz                      = 40000000,
 		.uarttx_pin                     = 11,
 		.flags				= ATH6KL_HW_64BIT_RATES |
-						  ATH6KL_HW_AP_INACTIVITY_MINS,
+						  ATH6KL_HW_AP_INACTIVITY_MINS |
+						  ATH6KL_HW_MAP_LP_ENDPOINT,
 
 		.fw = {
 			.dir            = AR6004_HW_1_3_FW_DIR,
@@ -360,7 +361,7 @@ static int ath6kl_init_service_ep(struct ath6kl *ar)
 	if (ath6kl_connectservice(ar, &connect, "WMI DATA BK"))
 		return -EIO;
 
-	/* connect to Video service, map this to to HI PRI */
+	/* connect to Video service, map this to HI PRI */
 	connect.svc_id = WMI_DATA_VI_SVC;
 	if (ath6kl_connectservice(ar, &connect, "WMI DATA VI"))
 		return -EIO;
diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index 2014fac..62bcc0d 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -805,7 +805,11 @@ static int ath6kl_usb_map_service_pipe(struct ath6kl *ar, u16 svc_id,
 		*dl_pipe = ATH6KL_USB_PIPE_RX_DATA;
 		break;
 	case WMI_DATA_VI_SVC:
-		*ul_pipe = ATH6KL_USB_PIPE_TX_DATA_MP;
+
+		if (ar->hw.flags & ATH6KL_HW_MAP_LP_ENDPOINT)
+			*ul_pipe = ATH6KL_USB_PIPE_TX_DATA_LP;
+		else
+			*ul_pipe = ATH6KL_USB_PIPE_TX_DATA_MP;
 		/*
 		* Disable rxdata2 directly, it will be enabled
 		* if FW enable rxdata2
@@ -813,7 +817,11 @@ static int ath6kl_usb_map_service_pipe(struct ath6kl *ar, u16 svc_id,
 		*dl_pipe = ATH6KL_USB_PIPE_RX_DATA;
 		break;
 	case WMI_DATA_VO_SVC:
-		*ul_pipe = ATH6KL_USB_PIPE_TX_DATA_HP;
+
+		if (ar->hw.flags & ATH6KL_HW_MAP_LP_ENDPOINT)
+			*ul_pipe = ATH6KL_USB_PIPE_TX_DATA_LP;
+		else
+			*ul_pipe = ATH6KL_USB_PIPE_TX_DATA_MP;
 		/*
 		* Disable rxdata2 directly, it will be enabled
 		* if FW enable rxdata2
-- 
1.7.0.4

