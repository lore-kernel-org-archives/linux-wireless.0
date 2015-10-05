Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8924 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbbJEG11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 02:27:27 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 13/18] staging: wilc1000: remove typedef from CURRENT_TX_RATE_T
Date: Mon, 5 Oct 2015 15:25:48 +0900
Message-ID: <1444026353-29024-13-git-send-email-tony.cho@atmel.com> (sfid-20151005_082744_717095_12839E4D)
In-Reply-To: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
References: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch remove typedef from the enum CURRENT_TX_RATE_T.
And rename it to CURRENT_TXRATE.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 drivers/staging/wilc1000/host_interface.h | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 073a724..4dbb970 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1155,7 +1155,7 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler,
 		u8WidCnt++;
 	}
 	if (strHostIFCfgParamAttr->pstrCfgParamVal.u32SetCfgFlag & CURRENT_TX_RATE) {
-		CURRENT_TX_RATE_T curr_tx_rate = strHostIFCfgParamAttr->pstrCfgParamVal.curr_tx_rate;
+		enum CURRENT_TXRATE curr_tx_rate = strHostIFCfgParamAttr->pstrCfgParamVal.curr_tx_rate;
 		/*----------------------------------------------------------------------*/
 		/*Rates:		1   2   5.5   11   6  9  12  18  24  36  48   54  Auto	*/
 		/*InputValues:	1   2     3    4   5  6   7   8   9  10  11   12  0		*/
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 1ed21a2..5993cd8 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -93,7 +93,7 @@ struct host_if_pmkid_attr {
 	struct host_if_pmkid pmkidlist[WILC_MAX_NUM_PMKIDS];
 };
 
-typedef enum {
+enum CURRENT_TXRATE {
 	AUTORATE	= 0,
 	MBPS_1		= 1,
 	MBPS_2		= 2,
@@ -107,7 +107,7 @@ typedef enum {
 	MBPS_36		= 36,
 	MBPS_48		= 48,
 	MBPS_54		= 54
-} CURRENT_TX_RATE_T;
+};
 
 struct cfg_param_val {
 	u32 u32SetCfgFlag;
@@ -130,7 +130,7 @@ struct cfg_param_val {
 	u8 scan_source;
 	u16 active_scan_time;
 	u16 passive_scan_time;
-	CURRENT_TX_RATE_T curr_tx_rate;
+	enum CURRENT_TXRATE curr_tx_rate;
 
 };
 
-- 
1.9.1

