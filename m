Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:20557 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752785AbeEKIPg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 04:15:36 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 30/30] staging: wilc1000: refactor host_int_parse_assoc_resp_info() to remove unused code
Date: Fri, 11 May 2018 13:43:31 +0530
Message-ID: <1526026411-11058-31-git-send-email-ajay.kathat@microchip.com> (sfid-20180511_103236_078412_B8EDF6C4)
In-Reply-To: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
References: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove 'connect_resp_info' structure as most of its elements are not used.

Modified wilc_parse_assoc_resp_info() to directly parse and fill value
in connect_info structure variable. Remove use of 'assoc_resp_len' variable.
get_assoc_resp_cap_info() & get_asoc_id() functions are remove as its
not used anymore.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 51 +++++------------------------
 drivers/staging/wilc1000/coreconfigurator.h | 10 +-----
 drivers/staging/wilc1000/host_interface.c   | 20 ++---------
 3 files changed, 11 insertions(+), 70 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 9f9ca76..4481602 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -207,16 +207,6 @@ static inline u16 get_cap_info(u8 *data)
 	return cap_info;
 }
 
-static inline u16 get_assoc_resp_cap_info(u8 *data)
-{
-	u16 cap_info;
-
-	cap_info  = data[0];
-	cap_info |= (data[1] << 8);
-
-	return cap_info;
-}
-
 static inline u16 get_asoc_status(u8 *data)
 {
 	u16 asoc_status;
@@ -225,16 +215,6 @@ static inline u16 get_asoc_status(u8 *data)
 	return (asoc_status << 8) | data[2];
 }
 
-static inline u16 get_asoc_id(u8 *data)
-{
-	u16 asoc_id;
-
-	asoc_id  = data[4];
-	asoc_id |= (data[5] << 8);
-
-	return asoc_id;
-}
-
 static u8 *get_tim_elm(u8 *msa, u16 rx_len, u16 tag_param_offset)
 {
 	u16 index;
@@ -338,38 +318,23 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 }
 
 s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
-			       struct connect_resp_info **ret_connect_resp_info)
+			       struct connect_info *ret_conn_info)
 {
-	struct connect_resp_info *connect_resp_info = NULL;
-	u16 assoc_resp_len = 0;
 	u8 *ies = NULL;
 	u16 ies_len = 0;
 
-	connect_resp_info = kzalloc(sizeof(*connect_resp_info), GFP_KERNEL);
-	if (!connect_resp_info)
-		return -ENOMEM;
-
-	assoc_resp_len = (u16)buffer_len;
-
-	connect_resp_info->status = get_asoc_status(buffer);
-	if (connect_resp_info->status == SUCCESSFUL_STATUSCODE) {
-		connect_resp_info->capability = get_assoc_resp_cap_info(buffer);
-		connect_resp_info->assoc_id = get_asoc_id(buffer);
-
+	ret_conn_info->status = get_asoc_status(buffer);
+	if (ret_conn_info->status == SUCCESSFUL_STATUSCODE) {
 		ies = &buffer[CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN];
-		ies_len = assoc_resp_len - (CAP_INFO_LEN + STATUS_CODE_LEN +
-					    AID_LEN);
+		ies_len = buffer_len - (CAP_INFO_LEN + STATUS_CODE_LEN +
+					AID_LEN);
 
-		connect_resp_info->ies = kmemdup(ies, ies_len, GFP_KERNEL);
-		if (!connect_resp_info->ies) {
-			kfree(connect_resp_info);
+		ret_conn_info->resp_ies = kmemdup(ies, ies_len, GFP_KERNEL);
+		if (!ret_conn_info->resp_ies)
 			return -ENOMEM;
-		}
 
-		connect_resp_info->ies_len = ies_len;
+		ret_conn_info->resp_ies_len = ies_len;
 	}
 
-	*ret_connect_resp_info = connect_resp_info;
-
 	return 0;
 }
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index a58f44e..55b5531 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -71,14 +71,6 @@ struct network_info {
 	u64 tsf_hi;
 };
 
-struct connect_resp_info {
-	u16 capability;
-	u16 status;
-	u16 assoc_id;
-	u8 *ies;
-	u16 ies_len;
-};
-
 struct connect_info {
 	u8 bssid[6];
 	u8 *req_ies;
@@ -97,7 +89,7 @@ struct disconnect_info {
 s32 wilc_parse_network_info(u8 *msg_buffer,
 			    struct network_info **ret_network_info);
 s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
-			       struct connect_resp_info **ret_connect_resp_info);
+			       struct connect_info *ret_conn_info);
 void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer, u32 length);
 void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length);
 void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length);
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4274efb..a2f82c8 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1297,7 +1297,6 @@ static inline void host_int_free_user_conn_req(struct host_if_drv *hif_drv)
 static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
 						  u8 mac_status)
 {
-	struct connect_resp_info *connect_resp_info = NULL;
 	struct connect_info conn_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
@@ -1317,26 +1316,11 @@ static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
 
 			err = wilc_parse_assoc_resp_info(rcv_assoc_resp,
 							 assoc_resp_info_len,
-							 &connect_resp_info);
-			if (err) {
+							 &conn_info);
+			if (err)
 				netdev_err(vif->ndev,
 					   "wilc_parse_assoc_resp_info() returned error %d\n",
 					   err);
-			} else {
-				conn_info.status = connect_resp_info->status;
-
-				if (conn_info.status == SUCCESSFUL_STATUSCODE &&
-				    connect_resp_info->ies) {
-					conn_info.resp_ies = kmemdup(connect_resp_info->ies,
-								     connect_resp_info->ies_len,
-								     GFP_KERNEL);
-					if (conn_info.resp_ies)
-						conn_info.resp_ies_len = connect_resp_info->ies_len;
-				}
-
-				kfree(connect_resp_info->ies);
-				kfree(connect_resp_info);
-			}
 		}
 	}
 
-- 
2.7.4
