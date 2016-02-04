Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:58732 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbcBDJcL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:32:11 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 47/70] staging: wilc1000: remove typedef from tstrConnectRespInfo
Date: Thu, 4 Feb 2016 18:24:08 +0900
Message-ID: <1454577871-667-8-git-send-email-glen.lee@atmel.com> (sfid-20160204_103216_950028_8CE49C07)
In-Reply-To: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
References: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the struct tstrConnectRespInfo and
renames it to connect_resp_info.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 6 +++---
 drivers/staging/wilc1000/coreconfigurator.h | 6 +++---
 drivers/staging/wilc1000/host_interface.c   | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index c86278d..c456a32 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -354,14 +354,14 @@ s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info)
 }
 
 s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
-			       tstrConnectRespInfo **ret_connect_resp_info)
+			       struct connect_resp_info **ret_connect_resp_info)
 {
-	tstrConnectRespInfo *connect_resp_info = NULL;
+	struct connect_resp_info *connect_resp_info = NULL;
 	u16 assoc_resp_len = 0;
 	u8 *ies = NULL;
 	u16 ies_len = 0;
 
-	connect_resp_info = kzalloc(sizeof(tstrConnectRespInfo), GFP_KERNEL);
+	connect_resp_info = kzalloc(sizeof(*connect_resp_info), GFP_KERNEL);
 	if (!connect_resp_info)
 		return -ENOMEM;
 
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index d42f47c..611486b 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -97,13 +97,13 @@ typedef struct {
 	u64 u64Tsf;
 } tstrNetworkInfo;
 
-typedef struct {
+struct connect_resp_info {
 	u16 u16capability;
 	u16 u16ConnectStatus;
 	u16 u16AssocID;
 	u8 *pu8RespIEs;
 	u16 u16RespIEsLen;
-} tstrConnectRespInfo;
+};
 
 typedef struct {
 	u8 au8bssid[6];
@@ -122,7 +122,7 @@ typedef struct {
 
 s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info);
 s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
-			       tstrConnectRespInfo **ret_connect_resp_info);
+			       struct connect_resp_info **ret_connect_resp_info);
 void wilc_scan_complete_received(struct wilc *wilc, u8 *pu8Buffer,
 				 u32 u32Length);
 void wilc_network_info_received(struct wilc *wilc, u8 *pu8Buffer,
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 30b93d0..513b1f0 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1471,7 +1471,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 		u8MacStatusAdditionalInfo = pstrRcvdGnrlAsyncInfo->buffer[9];
 		if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) {
 			u32 u32RcvdAssocRespInfoLen = 0;
-			tstrConnectRespInfo *pstrConnectRespInfo = NULL;
+			struct connect_resp_info *pstrConnectRespInfo = NULL;
 
 			memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
 
-- 
1.9.1

