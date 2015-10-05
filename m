Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8621 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbbJEG0P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 02:26:15 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 02/18] staging: wilc1000: remove typedef from tstrHiddenNetwork
Date: Mon, 5 Oct 2015 15:25:37 +0900
Message-ID: <1444026353-29024-2-git-send-email-tony.cho@atmel.com> (sfid-20151005_082618_650716_9CDFD591)
In-Reply-To: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
References: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the struct tstrHiddenNetwork.
And, rename it to hidden_network.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 5 +++--
 drivers/staging/wilc1000/host_interface.h         | 8 ++++----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 86fa968..b9b57ca 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -169,7 +169,7 @@ struct scan_attr {
 	size_t IEsLen;
 	wilc_scan_result pfScanResult;
 	void *pvUserArg;
-	tstrHiddenNetwork strHiddenNetwork;
+	struct hidden_network strHiddenNetwork;
 };
 
 /*!
@@ -5716,7 +5716,8 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 			  u8 u8ScanType, u8 *pu8ChnlFreqList,
 			  u8 u8ChnlListLen, const u8 *pu8IEs,
 			  size_t IEsLen, wilc_scan_result ScanResult,
-			  void *pvUserArg, tstrHiddenNetwork  *pstrHiddenNetwork)
+			  void *pvUserArg,
+			  struct hidden_network *pstrHiddenNetwork)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index c9ea34e..458b1e1 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -219,12 +219,11 @@ typedef struct _tstrHiddenNetworkInfo {
 
 } tstrHiddenNetworkInfo;
 
-typedef struct _tstrHiddenNetwork {
+struct hidden_network {
 	/* MAX_SSID_LEN */
 	tstrHiddenNetworkInfo *pstrHiddenNetworkInfo;
 	u8 u8ssidnum;
-
-} tstrHiddenNetwork;
+};
 
 typedef struct {
 	/* Scan user call back function */
@@ -873,7 +872,8 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 			  u8 u8ScanType, u8 *pu8ChnlFreqList,
 			  u8 u8ChnlListLen, const u8 *pu8IEs,
 			  size_t IEsLen, wilc_scan_result ScanResult,
-			  void *pvUserArg, tstrHiddenNetwork *pstrHiddenNetwork);
+			  void *pvUserArg,
+			  struct hidden_network *pstrHiddenNetwork);
 /**
  *  @brief              sets configuration wids values
  *  @details
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 04838f1..f3720e7 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -698,7 +698,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 	u32 i;
 	s32 s32Error = 0;
 	u8 au8ScanChanList[MAX_NUM_SCANNED_NETWORKS];
-	tstrHiddenNetwork strHiddenNetwork;
+	struct hidden_network strHiddenNetwork;
 
 	priv = wiphy_priv(wiphy);
 
@@ -727,7 +727,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 		if (request->n_ssids >= 1) {
 
 
-			strHiddenNetwork.pstrHiddenNetworkInfo = kmalloc(request->n_ssids * sizeof(tstrHiddenNetwork), GFP_KERNEL);
+			strHiddenNetwork.pstrHiddenNetworkInfo = kmalloc(request->n_ssids * sizeof(struct hidden_network), GFP_KERNEL);
 			strHiddenNetwork.u8ssidnum = request->n_ssids;
 
 
-- 
1.9.1

