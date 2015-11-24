Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3890 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718AbbKXRjP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 12:39:15 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] ath10k: update WMI 10.x service map
Date: Tue, 24 Nov 2015 09:37:33 -0800
Message-ID: <1448386655-13936-2-git-send-email-poh@qca.qualcomm.com> (sfid-20151124_183924_185640_BDFE09CD)
In-Reply-To: <1448386655-13936-1-git-send-email-poh@qca.qualcomm.com>
References: <1448386655-13936-1-git-send-email-poh@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update WMI 10.x service map to sync with firmware 10.2.4.70.12-2
released on 11/11/2015 which is the latest QCA988X firmware as of
11/18/2015.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 80d3f1c..0747055 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -208,6 +208,11 @@ enum wmi_10x_service {
 	WMI_10X_SERVICE_SMART_ANTENNA_HW_SUPPORT,
 	WMI_10X_SERVICE_ATF,
 	WMI_10X_SERVICE_COEX_GPIO,
+	WMI_10X_SERVICE_AUX_SPECTRAL_INTF,
+	WMI_10X_SERVICE_AUX_CHAN_LOAD_INTF,
+	WMI_10X_SERVICE_BSS_CHANNEL_INFO_64,
+	WMI_10X_SERVICE_MESH,
+	WMI_10X_SERVICE_EXT_RES_CFG_SUPPORT,
 };
 
 enum wmi_main_service {
@@ -448,6 +453,16 @@ static inline void wmi_10x_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_ATF, len);
 	SVCMAP(WMI_10X_SERVICE_COEX_GPIO,
 	       WMI_SERVICE_COEX_GPIO, len);
+	SVCMAP(WMI_10X_SERVICE_AUX_SPECTRAL_INTF,
+	       WMI_SERVICE_AUX_SPECTRAL_INTF, len);
+	SVCMAP(WMI_10X_SERVICE_AUX_CHAN_LOAD_INTF,
+	       WMI_SERVICE_AUX_CHAN_LOAD_INTF, len);
+	SVCMAP(WMI_10X_SERVICE_BSS_CHANNEL_INFO_64,
+	       WMI_SERVICE_BSS_CHANNEL_INFO_64, len);
+	SVCMAP(WMI_10X_SERVICE_MESH,
+	       WMI_SERVICE_MESH, len);
+	SVCMAP(WMI_10X_SERVICE_EXT_RES_CFG_SUPPORT,
+	       WMI_SERVICE_EXT_RES_CFG_SUPPORT, len);
 }
 
 static inline void wmi_main_svc_map(const __le32 *in, unsigned long *out,
-- 
1.9.1

