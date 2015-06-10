Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:30068 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933418AbbFJIHI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 04:07:08 -0400
From: Johnny Kim <johnny.kim@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<Rachel.kim@atmel.com>, <dean.lee@atmel.com>, <tony.cho@atmel.com>
Subject: [PATCH 2/4] staging: wilc1000: add syntax for 64-bit machine
Date: Wed, 10 Jun 2015 17:06:45 +0900
Message-ID: <1433923607-20927-3-git-send-email-johnny.kim@atmel.com> (sfid-20150610_100719_319374_ED45E580)
In-Reply-To: <1433923607-20927-1-git-send-email-johnny.kim@atmel.com>
References: <1433923607-20927-1-git-send-email-johnny.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver take pointer value to integer value for message packet.
So, The driver was fixed to save and load the address
on 64-bit machine.

Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 24 ++++++++++++++++++++----
 drivers/staging/wilc1000/wilc_wlan.c      | 19 +++++++++++++++----
 drivers/staging/wilc1000/wilc_wlan.h      |  6 +++++-
 3 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index cfe3364..4b005fa 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -6918,9 +6918,14 @@ void NetworkInfoReceived(u8 *pu8Buffer, WILC_Uint32 u32Length)
 {
 	WILC_Sint32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
-	size_t drvHandler;
+	size_t drvHandler = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
+#ifdef CONFIG_64BIT
+	drvHandler = ((pu8Buffer[u32Length - 8]) | (pu8Buffer[u32Length - 7] << 8) | (pu8Buffer[u32Length - 6] << 16) | (pu8Buffer[u32Length - 5] << 24));
+	drvHandler <<= 32;
+#endif
+
 	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
 	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
@@ -6968,13 +6973,18 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, WILC_Uint32 u32Length)
 {
 	WILC_Sint32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
-	size_t drvHandler;
+	size_t drvHandler = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
 	/*BugID_5348*/
 	down(&hSemHostIntDeinit);
 
-	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
+#ifdef CONFIG_64BIT
+	drvHandler = ((pu8Buffer[u32Length - 8]) | (pu8Buffer[u32Length - 7] << 8) | (pu8Buffer[u32Length - 6] << 16) | (pu8Buffer[u32Length - 5] << 24));
+	drvHandler <<= 32;
+#endif
+
+	drvHandler |= ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
 	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 	PRINT_D(HOSTINF_DBG, "General asynchronous info packet received \n");
 
@@ -7031,8 +7041,14 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, WILC_Uint32 u32Length)
 {
 	WILC_Sint32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
-	size_t drvHandler;
+	size_t drvHandler = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
+
+#ifdef CONFIG_64BIT
+	drvHandler = ((pu8Buffer[u32Length - 8]) | (pu8Buffer[u32Length - 7] << 8) | (pu8Buffer[u32Length - 6] << 16) | (pu8Buffer[u32Length - 5] << 24));
+	drvHandler <<= 32;
+#endif
+
 	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
 	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 739be55..d20ffe0 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1867,7 +1867,7 @@ static int wilc_wlan_cfg_commit(int type, size_t drvHandler)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	wilc_cfg_frame_t *cfg = &p->cfg_frame;
-	int total_len = p->cfg_frame_offset + 4 + DRIVER_HANDLER_SIZE;
+	int total_len = p->cfg_frame_offset + sizeof(size_t) + DRIVER_HANDLER_SIZE;
 	int seq_no = p->cfg_seq_no % 256;
 	size_t driver_handler = (size_t)drvHandler;
 
@@ -1883,10 +1883,21 @@ static int wilc_wlan_cfg_commit(int type, size_t drvHandler)
 	cfg->wid_header[1] = seq_no;    /* sequence number */
 	cfg->wid_header[2] = (uint8_t)total_len;
 	cfg->wid_header[3] = (uint8_t)(total_len >> 8);
+#ifdef CONFIG_64BIT
 	cfg->wid_header[4] = (uint8_t)driver_handler;
-	cfg->wid_header[5] = (uint8_t)(driver_handler >> 8);
-	cfg->wid_header[6] = (uint8_t)(driver_handler >> 16);
-	cfg->wid_header[7] = (uint8_t)(driver_handler >> 24);
+	cfg->wid_header[5] = (uint8_t)(driver_handler >> 8L);
+	cfg->wid_header[6] = (uint8_t)(driver_handler >> 16L);
+	cfg->wid_header[7] = (uint8_t)(driver_handler >> 24L);
+	cfg->wid_header[8] = (uint8_t)(driver_handler >> 32L);
+	cfg->wid_header[9] = (uint8_t)(driver_handler >> 40L);
+	cfg->wid_header[10] = (uint8_t)(driver_handler >> 48L);
+	cfg->wid_header[11] = (uint8_t)(driver_handler >> 56L);
+#else
+	cfg->wid_header[4] = (uint8_t)driver_handler;
+	cfg->wid_header[5] = (uint8_t)(driver_handler >> 8L);
+	cfg->wid_header[6] = (uint8_t)(driver_handler >> 16L);
+	cfg->wid_header[7] = (uint8_t)(driver_handler >> 24L);
+#endif
 	p->cfg_seq_no = seq_no;
 
 	/**
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 0ba7ec6..e026baf 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -15,7 +15,11 @@
 #define DRIVER_HANDLER_SIZE 4
 #define MAX_MAC_HDR_LEN         26 /* QOS_MAC_HDR_LEN */
 #define SUB_MSDU_HEADER_LENGTH  14
+#ifdef CONFIG_64BIT
+#define SNAP_HDR_LEN            12
+#else
 #define SNAP_HDR_LEN            8
+#endif
 #define ETHERNET_HDR_LEN          14
 #define WORD_ALIGNMENT_PAD        0
 
@@ -297,7 +301,7 @@ typedef struct {
 	uint8_t ether_header[14];
 	uint8_t ip_header[20];
 	uint8_t udp_header[8];
-	uint8_t wid_header[8];
+	uint8_t wid_header[4+sizeof(uintptr_t)];
 	uint8_t frame[MAX_CFG_FRAME_SIZE];
 } wilc_cfg_frame_t;
 
-- 
1.9.1

