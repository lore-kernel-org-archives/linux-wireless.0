Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5732 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbcA1V5V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 16:57:21 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 2/4] ath10k: update 10.4 WMI service map
Date: Thu, 28 Jan 2016 13:54:08 -0800
Message-ID: <20d44823ecdacb54a92efaf56020c9d2f2cc4ff5.1454015989.git.poh@qca.qualcomm.com> (sfid-20160128_225724_554845_06DB4D1E)
In-Reply-To: <cover.1454015989.git.poh@qca.qualcomm.com>
References: <cover.1454015989.git.poh@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update 10.4 WMI service map to sync to the latest 10.4 firmware
as of 1/20/2016.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 0458bf6..031018a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -179,6 +179,7 @@ enum wmi_service {
 	WMI_SERVICE_MESH_11S,
 	WMI_SERVICE_MESH_NON_11S,
 	WMI_SERVICE_PEER_STATS,
+	WMI_SERVICE_RESTRT_CHNL_SUPPORT,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
@@ -298,6 +299,9 @@ enum wmi_10_4_service {
 	WMI_10_4_SERVICE_BSS_CHANNEL_INFO_64,
 	WMI_10_4_SERVICE_EXT_RES_CFG_SUPPORT,
 	WMI_10_4_SERVICE_MESH_NON_11S,
+	WMI_10_4_SERVICE_RESTRT_CHNL_SUPPORT,
+	WMI_10_4_SERVICE_PEER_STATS,
+	WMI_10_4_SERVICE_MESH_11S,
 };
 
 static inline char *wmi_service_name(int service_id)
@@ -391,6 +395,7 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_MESH_11S);
 	SVCSTR(WMI_SERVICE_MESH_NON_11S);
 	SVCSTR(WMI_SERVICE_PEER_STATS);
+	SVCSTR(WMI_SERVICE_RESTRT_CHNL_SUPPORT);
 	default:
 		return NULL;
 	}
@@ -632,6 +637,12 @@ static inline void wmi_10_4_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_EXT_RES_CFG_SUPPORT, len);
 	SVCMAP(WMI_10_4_SERVICE_MESH_NON_11S,
 	       WMI_SERVICE_MESH_NON_11S, len);
+	SVCMAP(WMI_10_4_SERVICE_RESTRT_CHNL_SUPPORT,
+	       WMI_SERVICE_RESTRT_CHNL_SUPPORT, len);
+	SVCMAP(WMI_10_4_SERVICE_PEER_STATS,
+	       WMI_SERVICE_PEER_STATS, len);
+	SVCMAP(WMI_10_4_SERVICE_MESH_11S,
+	       WMI_SERVICE_MESH_11S, len);
 }
 
 #undef SVCMAP
-- 
1.9.1

