Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3021 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbbJMKx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:53:26 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 26/54] staging: wilc1000: rename ssidLen of struct connect_attr
Date: Tue, 13 Oct 2015 19:49:51 +0900
Message-ID: <1444733419-17679-26-git-send-email-tony.cho@atmel.com> (sfid-20151013_125329_071421_65327AC4)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames ssidLen of struct connect_attr to ssid_len to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3c044d2..80ac60a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -110,7 +110,7 @@ struct scan_attr {
 struct connect_attr {
 	u8 *bssid;
 	u8 *ssid;
-	size_t ssidLen;
+	size_t ssid_len;
 	u8 *pu8IEs;
 	size_t IEsLen;
 	u8 u8security;
@@ -1036,12 +1036,12 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		memcpy(hif_drv->strWILC_UsrConnReq.pu8bssid, pstrHostIFconnectAttr->bssid, 6);
 	}
 
-	hif_drv->strWILC_UsrConnReq.ssidLen = pstrHostIFconnectAttr->ssidLen;
+	hif_drv->strWILC_UsrConnReq.ssidLen = pstrHostIFconnectAttr->ssid_len;
 	if (pstrHostIFconnectAttr->ssid != NULL) {
-		hif_drv->strWILC_UsrConnReq.pu8ssid = kmalloc(pstrHostIFconnectAttr->ssidLen + 1, GFP_KERNEL);
+		hif_drv->strWILC_UsrConnReq.pu8ssid = kmalloc(pstrHostIFconnectAttr->ssid_len + 1, GFP_KERNEL);
 		memcpy(hif_drv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->ssid,
-			    pstrHostIFconnectAttr->ssidLen);
-		hif_drv->strWILC_UsrConnReq.pu8ssid[pstrHostIFconnectAttr->ssidLen] = '\0';
+			    pstrHostIFconnectAttr->ssid_len);
+		hif_drv->strWILC_UsrConnReq.pu8ssid[pstrHostIFconnectAttr->ssid_len] = '\0';
 	}
 
 	hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = pstrHostIFconnectAttr->IEsLen;
@@ -1132,8 +1132,8 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 
 
 	if (pstrHostIFconnectAttr->ssid != NULL) {
-		memcpy(pu8CurrByte, pstrHostIFconnectAttr->ssid, pstrHostIFconnectAttr->ssidLen);
-		pu8CurrByte[pstrHostIFconnectAttr->ssidLen] = '\0';
+		memcpy(pu8CurrByte, pstrHostIFconnectAttr->ssid, pstrHostIFconnectAttr->ssid_len);
+		pu8CurrByte[pstrHostIFconnectAttr->ssid_len] = '\0';
 	}
 	pu8CurrByte += MAX_SSID_LEN;
 	*(pu8CurrByte++) = INFRASTRUCTURE;
@@ -3625,7 +3625,7 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 	}
 
 	if (pu8ssid != NULL) {
-		msg.body.con_info.ssidLen = ssidLen;
+		msg.body.con_info.ssid_len = ssidLen;
 		msg.body.con_info.ssid = kmalloc(ssidLen, GFP_KERNEL);
 		memcpy(msg.body.con_info.ssid, pu8ssid, ssidLen);
 	}
-- 
1.9.1

