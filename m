Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db3on0128.outbound.protection.outlook.com ([157.55.234.128]:41027
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751798AbbFPHdq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 03:33:46 -0400
From: "Abdul, Hussain (H.)" <habdul@visteon.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Ravindran, Madhusudhanan (M.)" <mravindr@visteon.com>,
	"Dighe, Niranjan (N.)" <ndighe@visteon.com>,
	"johnny.kim@atmel.com" <johnny.kim@atmel.com>,
	"rachel.kim@atmel.com" <rachel.kim@atmel.com>,
	"dean.lee@atmel.com" <dean.lee@atmel.com>,
	"chris.park@atmel.com" <chris.park@atmel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] Staging: wilc1000: Boolean tests don't need comparisons
Date: Tue, 16 Jun 2015 07:33:42 +0000
Message-ID: <1434439941-6369-1-git-send-email-habdul@visteon.com> (sfid-20150616_093406_541216_78459347)
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abdul Hussain <habdul@visteon.com>

This patch removes unwanted true and false from boolean tests.

Signed-off-by: Abdul Hussain <habdul@visteon.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       | 8 ++++----
 drivers/staging/wilc1000/host_interface.c         | 2 +-
 drivers/staging/wilc1000/linux_mon.c              | 2 +-
 drivers/staging/wilc1000/linux_wlan.c             | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 drivers/staging/wilc1000/wilc_wlan.c              | 4 ++--
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 9abc73d..616cf6d 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -1717,7 +1717,7 @@ s32 ParseResponse(u8 *resp, tstrWID *pstrWIDcfgResult)
 			idx++;
 		}
 		idx += 3;
-		if ((u16WIDid == g_wid_num) && (num_wid_processed == false)) {
+		if ((u16WIDid == g_wid_num) && (!num_wid_processed)) {
 			num_wid_processed = true;
 
 			if (-2 == further_process_response(&resp[idx], u16WIDid, cfg_len, true, 0, &pstrWIDcfgResult[ResCnt])) {
@@ -1923,7 +1923,7 @@ s32 ConfigWaitResponse(WILC_Char *pcRespBuffer, s32 s32MaxRespBuffLen, s32 *ps32
 	 * gstrConfigPktInfo.bRespRequired = bRespRequired;*/
 
 
-	if (gstrConfigPktInfo.bRespRequired == true) {
+	if (gstrConfigPktInfo.bRespRequired) {
 		down(&SemHandlePktResp);
 
 		*ps32BytesRead = gstrConfigPktInfo.s32BytesRead;
@@ -1984,7 +1984,7 @@ s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
 	ConfigWaitResponse(gps8ConfigPacket, MAX_PACKET_BUFF_SIZE, &s32RcvdRespLen, bRespRequired);
 
 
-	if (bRespRequired == true)	{
+	if (bRespRequired)	{
 		/* If the operating Mode is GET, then we expect a response frame from */
 		/* the driver. Hence start listening to the port for response         */
 		if (g_oper_mode == GET_CFG) {
@@ -2021,7 +2021,7 @@ s32 ConfigProvideResponse(WILC_Char *pcRespBuffer, s32 s32RespLen)
 {
 	s32 s32Error = WILC_SUCCESS;
 
-	if (gstrConfigPktInfo.bRespRequired == true) {
+	if (gstrConfigPktInfo.bRespRequired) {
 		if (s32RespLen <= gstrConfigPktInfo.s32MaxRespBuffLen) {
 			WILC_memcpy(gstrConfigPktInfo.pcRespBuffer, pcRespBuffer, s32RespLen);
 			gstrConfigPktInfo.s32BytesRead = s32RespLen;
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 17ab5cd..be1f6bf 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -7816,7 +7816,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 					pNewJoinBssParam->rsn_cap[1] = pu8IEs[rsnIndex + 1];
 					rsnIndex += 2;
 				}
-				pNewJoinBssParam->rsn_found = 1;
+				pNewJoinBssParam->rsn_found = true;
 				index += pu8IEs[index + 1] + 2; /* ID,Length bytes and IE body */
 				continue;
 			} else
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 8cba13c..30d1c76 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -452,7 +452,7 @@ void WILC_mgm_HOSTAPD_ACK(void *priv, bool bStatus)
 		cb_hdr->rate = 5; /* txrate->bitrate / 5; */
 
 
-		if (true == bStatus) {
+		if (bStatus) {
 			/* success */
 			cb_hdr->tx_flags = IEEE80211_RADIOTAP_F_TX_RTS;
 		} else {
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index c1e9272..c1cf5be 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -309,7 +309,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 
 
 
-		if (bEnablePS	 == true)
+		if (bEnablePS)
 			host_int_set_power_mgmt((WILC_WFIDrvHandle)pstrWFIDrv, 1, 0);
 
 		PRINT_D(GENERIC_DBG, "[%s] Up IP\n", dev_iface->ifa_label);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 9861476..db0b782 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -624,7 +624,7 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 				}
 			}
 
-			if (bNeedScanRefresh == true) {
+			if (bNeedScanRefresh) {
 				/*BugID_5418*/
 				/*Also, refrsh DIRECT- results if */
 				refresh_scan(priv, 1, true);
@@ -2817,7 +2817,7 @@ int WILC_WFI_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 		return -EIO;
 	}
 
-	if (bEnablePS	 == true)
+	if (bEnablePS)
 		host_int_set_power_mgmt(priv->hWILCWFIDrv, enabled, timeout);
 
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 762470c..db9e717 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -559,7 +559,7 @@ static int wilc_wlan_txq_add_net_pkt(void *priv, uint8_t *buffer, uint32_t buffe
 #ifdef TCP_ACK_FILTER
 	tqe->tcp_PendingAck_index = NOT_TCP_ACK;
 #ifdef TCP_ENHANCEMENTS
-	if (is_TCP_ACK_Filter_Enabled() == true)
+	if (is_TCP_ACK_Filter_Enabled())
 #endif
 	tcp_process(tqe);
 #endif
@@ -2337,7 +2337,7 @@ u16 Set_machw_change_vir_if(bool bValue)
 		PRINT_ER("Error while Reading reg WILC_CHANGING_VIR_IF\n");
 	}
 
-	if (bValue == true) {
+	if (bValue) {
 		reg |= (BIT31);
 	} else {
 		reg &= ~(BIT31);
-- 
1.9.1
