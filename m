Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:34769 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbbHJF6u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 01:58:50 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<glen.lee@atmel.com>, <leo.kim@atmel.com>, <jude.lee@atmel.com>,
	<robin.hwang@atmel.com>, <tony.cho@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 2/5] staging: wilc1000: change void pointer type to real type
Date: Mon, 10 Aug 2015 14:58:21 +0900
Message-ID: <1439186304-3480-3-git-send-email-tony.cho@atmel.com> (sfid-20150810_075852_930987_5E8BCE98)
In-Reply-To: <1439186304-3480-1-git-send-email-tony.cho@atmel.com>
References: <1439186304-3480-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johnny Kim <johnny.kim@atmel.com>

This patch changes the void pointer member of the tstrHostIFmsg to the
real data type because the void pointer type is ambiguous and not
readable.

Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 20a554f..b5afc82 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -466,7 +466,7 @@ typedef union _tuniHostIFmsgBody {
 typedef struct _tstrHostIFmsg {
 	u16 u16MsgId;                                           /*!< Message ID */
 	tuniHostIFmsgBody uniHostIFmsgBody;             /*!< Message body */
-	void *drvHandler;
+	tstrWILC_WFIDrv *drvHandler;
 } tstrHostIFmsg;
 
 #ifdef CONNECT_DIRECT
-- 
1.9.1

