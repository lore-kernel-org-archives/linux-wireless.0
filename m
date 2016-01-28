Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19212 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbcA1V5M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 16:57:12 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 1/4] ath10k: rename Mesh related service names
Date: Thu, 28 Jan 2016 13:54:07 -0800
Message-ID: <1e6f61146a6fdc7a11b85b796d3921d75d308764.1454015989.git.poh@qca.qualcomm.com> (sfid-20160128_225718_412066_0982055B)
In-Reply-To: <cover.1454015989.git.poh@qca.qualcomm.com>
References: <cover.1454015989.git.poh@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WMI_10_4_SERVICE_MESH bit is for non IEEE802.11s Mesh.
Hence rename it to WMI_10_4_SERVICE_MESH_NON_11S.
Also add _11S as post-fix to each of WMI_SERVICE_MESH and
WMI_VDEV_SUBTYPE_MESH specifying the service is for 11s Mesh.
This will help users to distinguish 11s Mesh from non 11s Mesh.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |  4 ++--
 drivers/net/wireless/ath/ath10k/wmi.h | 16 +++++++++-------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ef0438d..1406b0f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4380,8 +4380,8 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		arvif->vdev_type = WMI_VDEV_TYPE_IBSS;
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
-		if (test_bit(WMI_SERVICE_MESH, ar->wmi.svc_map)) {
-			arvif->vdev_subtype = WMI_VDEV_SUBTYPE_MESH;
+		if (test_bit(WMI_SERVICE_MESH_11S, ar->wmi.svc_map)) {
+			arvif->vdev_subtype = WMI_VDEV_SUBTYPE_MESH_11S;
 		} else if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
 			ret = -EINVAL;
 			ath10k_warn(ar, "must load driver with rawmode=1 to add mesh interfaces\n");
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 806d4bb..0458bf6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -176,7 +176,8 @@ enum wmi_service {
 	WMI_SERVICE_AUX_CHAN_LOAD_INTF,
 	WMI_SERVICE_BSS_CHANNEL_INFO_64,
 	WMI_SERVICE_EXT_RES_CFG_SUPPORT,
-	WMI_SERVICE_MESH,
+	WMI_SERVICE_MESH_11S,
+	WMI_SERVICE_MESH_NON_11S,
 	WMI_SERVICE_PEER_STATS,
 
 	/* keep last */
@@ -296,7 +297,7 @@ enum wmi_10_4_service {
 	WMI_10_4_SERVICE_AUX_CHAN_LOAD_INTF,
 	WMI_10_4_SERVICE_BSS_CHANNEL_INFO_64,
 	WMI_10_4_SERVICE_EXT_RES_CFG_SUPPORT,
-	WMI_10_4_SERVICE_MESH,
+	WMI_10_4_SERVICE_MESH_NON_11S,
 };
 
 static inline char *wmi_service_name(int service_id)
@@ -387,7 +388,8 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_AUX_CHAN_LOAD_INTF);
 	SVCSTR(WMI_SERVICE_BSS_CHANNEL_INFO_64);
 	SVCSTR(WMI_SERVICE_EXT_RES_CFG_SUPPORT);
-	SVCSTR(WMI_SERVICE_MESH);
+	SVCSTR(WMI_SERVICE_MESH_11S);
+	SVCSTR(WMI_SERVICE_MESH_NON_11S);
 	SVCSTR(WMI_SERVICE_PEER_STATS);
 	default:
 		return NULL;
@@ -463,7 +465,7 @@ static inline void wmi_10x_svc_map(const __le32 *in, unsigned long *out,
 	SVCMAP(WMI_10X_SERVICE_BSS_CHANNEL_INFO_64,
 	       WMI_SERVICE_BSS_CHANNEL_INFO_64, len);
 	SVCMAP(WMI_10X_SERVICE_MESH,
-	       WMI_SERVICE_MESH, len);
+	       WMI_SERVICE_MESH_11S, len);
 	SVCMAP(WMI_10X_SERVICE_EXT_RES_CFG_SUPPORT,
 	       WMI_SERVICE_EXT_RES_CFG_SUPPORT, len);
 	SVCMAP(WMI_10X_SERVICE_PEER_STATS,
@@ -628,8 +630,8 @@ static inline void wmi_10_4_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_BSS_CHANNEL_INFO_64, len);
 	SVCMAP(WMI_10_4_SERVICE_EXT_RES_CFG_SUPPORT,
 	       WMI_SERVICE_EXT_RES_CFG_SUPPORT, len);
-	SVCMAP(WMI_10_4_SERVICE_MESH,
-	       WMI_SERVICE_MESH, len);
+	SVCMAP(WMI_10_4_SERVICE_MESH_NON_11S,
+	       WMI_SERVICE_MESH_NON_11S, len);
 }
 
 #undef SVCMAP
@@ -4287,7 +4289,7 @@ enum wmi_vdev_subtype {
 	WMI_VDEV_SUBTYPE_P2P_CLIENT = 2,
 	WMI_VDEV_SUBTYPE_P2P_GO     = 3,
 	WMI_VDEV_SUBTYPE_PROXY_STA	= 4,
-	WMI_VDEV_SUBTYPE_MESH		= 5,
+	WMI_VDEV_SUBTYPE_MESH_11S   = 5,
 };
 
 /* values for vdev_subtype */
-- 
1.9.1

