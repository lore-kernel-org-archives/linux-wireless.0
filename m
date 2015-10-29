Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26928 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965429AbbJ2DEC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:04:02 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 38/64] staging: wilc1000: rename s8RSSI of struct rf_info
Date: Thu, 29 Oct 2015 12:05:30 +0900
Message-ID: <1446087956-19054-5-git-send-email-glen.lee@atmel.com> (sfid-20151029_040406_109466_3BBF3A44)
In-Reply-To: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
References: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames s8RSSI of struct rf_info to rssi
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 2 +-
 drivers/staging/wilc1000/host_interface.h         | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5399115..bee1f7f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2144,7 +2144,7 @@ s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatis
 	strWIDList[u32WidsCount].id = WID_RSSI;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].val = (s8 *)&pstrStatistics->s8RSSI;
+	strWIDList[u32WidsCount].val = (s8 *)&pstrStatistics->rssi;
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_SUCCESS_FRAME_COUNT;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index cef952a..25f748f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -54,7 +54,7 @@
 
 struct rf_info {
 	u8 link_speed;
-	s8 s8RSSI;
+	s8 rssi;
 	u32 u32TxCount;
 	u32 u32RxCount;
 	u32 u32TxFailureCount;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 29b769f..632daa8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1566,7 +1566,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 						BIT(NL80211_STA_INFO_TX_FAILED) |
 						BIT(NL80211_STA_INFO_TX_BITRATE);
 
-		sinfo->signal		=  strStatistics.s8RSSI;
+		sinfo->signal = strStatistics.rssi;
 		sinfo->rx_packets   =  strStatistics.u32RxCount;
 		sinfo->tx_packets   =  strStatistics.u32TxCount + strStatistics.u32TxFailureCount;
 		sinfo->tx_failed	=  strStatistics.u32TxFailureCount;
-- 
1.9.1

