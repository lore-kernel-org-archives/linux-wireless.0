Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:4886 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102AbbJMLDN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 07:03:13 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 53/54] staging: wilc1000: rename u32Length of struct rcvd_net_info
Date: Tue, 13 Oct 2015 20:02:11 +0900
Message-ID: <1444734132-17858-8-git-send-email-tony.cho@atmel.com> (sfid-20151013_130321_567341_813DEBA6)
In-Reply-To: <1444734132-17858-1-git-send-email-tony.cho@atmel.com>
References: <1444734132-17858-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u32Length of struct rcvd_net_info to len to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 432b275..392bf08 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4439,7 +4439,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	msg.id = HOST_IF_MSG_RCVD_NTWRK_INFO;
 	msg.drv = hif_drv;
 
-	msg.body.net_info.u32Length = u32Length;
+	msg.body.net_info.len = u32Length;
 	msg.body.net_info.buffer = kmalloc(u32Length, GFP_KERNEL);
 	memcpy(msg.body.net_info.buffer, pu8Buffer, u32Length);
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 778dbf5..146a60f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -200,7 +200,7 @@ typedef void (*wilc_remain_on_chan_ready)(void *); /*Remain on channel callback
  */
 struct rcvd_net_info {
 	u8 *buffer;
-	u32 u32Length;
+	u32 len;
 };
 
 struct hidden_net_info {
-- 
1.9.1

