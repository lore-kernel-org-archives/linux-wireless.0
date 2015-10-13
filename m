Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3246 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbbJMKyc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:54:32 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 36/54] staging: wilc1000: rename u32Length of struct rcvd_async_info
Date: Tue, 13 Oct 2015 19:50:01 +0900
Message-ID: <1444733419-17679-36-git-send-email-tony.cho@atmel.com> (sfid-20151013_125434_865891_68C8CC84)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u32Length of struct rcvd_async_info to len to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7a91010..3d0796f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -123,7 +123,7 @@ struct connect_attr {
 
 struct rcvd_async_info {
 	u8 *buffer;
-	u32 u32Length;
+	u32 len;
 };
 
 struct channel_attr {
@@ -4482,8 +4482,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	msg.id = HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO;
 	msg.drv = hif_drv;
 
-
-	msg.body.async_info.u32Length = u32Length;
+	msg.body.async_info.len = u32Length;
 	msg.body.async_info.buffer = kmalloc(u32Length, GFP_KERNEL);
 	memcpy(msg.body.async_info.buffer, pu8Buffer, u32Length);
 
-- 
1.9.1

