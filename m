Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2850 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272AbbJMKwe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:52:34 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 18/54] staging: wilc1000: rename IEsLen of struct scan_attr
Date: Tue, 13 Oct 2015 19:49:43 +0900
Message-ID: <1444733419-17679-18-git-send-email-tony.cho@atmel.com> (sfid-20151013_125237_431114_6CB30FA9)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames IEsLen of struct scan_attr to ies_len to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4a33d16..a390dee 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -101,7 +101,7 @@ struct scan_attr {
 	u8 *ch_freq_list;
 	u8 ch_list_len;
 	u8 *ies;
-	size_t IEsLen;
+	size_t ies_len;
 	wilc_scan_result pfScanResult;
 	void *pvUserArg;
 	struct hidden_network strHiddenNetwork;
@@ -892,7 +892,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 		strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_PROBE;
 		strWIDList[u32WidsCount].type = WID_BIN_DATA;
 		strWIDList[u32WidsCount].val = pstrHostIFscanAttr->ies;
-		strWIDList[u32WidsCount].size = pstrHostIFscanAttr->IEsLen;
+		strWIDList[u32WidsCount].size = pstrHostIFscanAttr->ies_len;
 		u32WidsCount++;
 	}
 
@@ -4066,7 +4066,7 @@ s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 	msg.body.scan_info.ch_freq_list = kmalloc(u8ChnlListLen, GFP_KERNEL);
 	memcpy(msg.body.scan_info.ch_freq_list, pu8ChnlFreqList, u8ChnlListLen);
 
-	msg.body.scan_info.IEsLen = IEsLen;
+	msg.body.scan_info.ies_len = IEsLen;
 	msg.body.scan_info.ies = kmalloc(IEsLen, GFP_KERNEL);
 	memcpy(msg.body.scan_info.ies, pu8IEs, IEsLen);
 
-- 
1.9.1

