Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51322 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934156AbcA0S6w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 13:58:52 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] ath10k: update 10.4 WMI service map
Date: Wed, 27 Jan 2016 10:55:55 -0800
Message-ID: <1453920957-9908-3-git-send-email-poh@qca.qualcomm.com> (sfid-20160127_195900_412156_FC3DB149)
In-Reply-To: <1453920957-9908-1-git-send-email-poh@qca.qualcomm.com>
References: <1453920957-9908-1-git-send-email-poh@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update 10.4 WMI service map to sync to the latest 10.4 firmware
as of 1/20/2016.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 26a1bb9..90b6581 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -178,6 +178,8 @@ enum wmi_service {
 	WMI_SERVICE_EXT_RES_CFG_SUPPORT,
 	WMI_SERVICE_MESH_11S,
 	WMI_SERVICE_MESH_NON_11S,
+	WMI_SERVICE_RESTRT_CHNL_SUPPORT,
+	WMI_SERVICE_PEER_STATS,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
@@ -296,6 +298,9 @@ enum wmi_10_4_service {
 	WMI_10_4_SERVICE_BSS_CHANNEL_INFO_64,
 	WMI_10_4_SERVICE_EXT_RES_CFG_SUPPORT,
 	WMI_10_4_SERVICE_MESH_NON_11S,
+	WMI_10_4_SERVICE_RESTRT_CHNL_SUPPORT,
+	WMI_10_4_SERVICE_PEER_STATS,
+	WMI_10_4_SERVICE_MESH_11S,
 };
 
 static inline char *wmi_service_name(int service_id)
@@ -388,6 +393,8 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_EXT_RES_CFG_SUPPORT);
 	SVCSTR(WMI_SERVICE_MESH_11S);
 	SVCSTR(WMI_SERVICE_MESH_NON_11S);
+	SVCSTR(WMI_SERVICE_RESTRT_CHNL_SUPPORT);
+	SVCSTR(WMI_SERVICE_PEER_STATS);
 	default:
 		return NULL;
 	}
@@ -627,6 +634,12 @@ static inline void wmi_10_4_svc_map(const __le32 *in, unsigned long *out,
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

