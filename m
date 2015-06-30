Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:38680 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbbF3IgZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 04:36:25 -0400
From: Dean Lee <dean.lee@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <dean.lee@atmel.com>,
	<nicolas.ferre@atmel.com>
Subject: [PATCH 5/6] staging: wilc1000: fix initialize warning issue.
Date: Tue, 30 Jun 2015 17:34:37 +0900
Message-ID: <1435653278-5168-5-git-send-email-dean.lee@atmel.com> (sfid-20150630_103629_817235_4D112DD8)
In-Reply-To: <1435653278-5168-1-git-send-email-dean.lee@atmel.com>
References: <1435653278-5168-1-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

modify it

Signed-off-by: Dean Lee <dean.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 3 ++-
 drivers/staging/wilc1000/linux_wlan.c     | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 1e40dca..a2e9b6d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -7162,7 +7162,7 @@ s32 host_int_add_beacon(void *hWFIDrv, u32 u32Interval,
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
-	tstrHostIFSetBeacon *pstrSetBeaconParam = &strHostIFmsg.uniHostIFmsgBody.strHostIFSetBeacon;
+	tstrHostIFSetBeacon *pstrSetBeaconParam = NULL;
 
 	if (hWFIDrv == NULL) {
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
@@ -7172,6 +7172,7 @@ s32 host_int_add_beacon(void *hWFIDrv, u32 u32Interval,
 
 	PRINT_D(HOSTINF_DBG, "Setting adding beacon message queue params\n");
 
+	pstrSetBeaconParam = &strHostIFmsg.uniHostIFmsgBody.strHostIFSetBeacon;
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_ADD_BEACON;
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 659b70a..1b8991a 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -2463,7 +2463,7 @@ void frmw_to_linux(uint8_t *buff, uint32_t size, uint32_t pkt_offset)
 			return;
 		}
 
-		skb_reserve(skb, (unsigned int)skb->data & 0x3);
+		skb_reserve(skb, (uintptr_t)skb->data & 0x3);
 
 		if (g_linux_wlan == NULL || wilc_netdev == NULL) {
 			PRINT_ER("wilc_netdev in g_linux_wlan is NULL");
-- 
2.4.4

