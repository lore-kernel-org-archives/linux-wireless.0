Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f68.google.com ([209.85.192.68]:34451 "EHLO
	mail-qg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbbLBCuP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 21:50:15 -0500
Received: by qgeb1 with SMTP id b1so2283878qge.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2015 18:50:14 -0800 (PST)
From: "Mario J. Rugiero" <mrugiero@gmail.com>
To: devel@driverdev.osuosl.org
Cc: mrugiero@gmail.com, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	austin.shin@atmel.com, chris.park@atmel.com, tony.cho@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com
Subject: [PATCH 1/1] staging: Fix bitshifts by wrong offsets in wilc1000/host_interface.c
Date: Tue,  1 Dec 2015 23:49:55 -0300
Message-Id: <1449024595-20290-1-git-send-email-mrugiero@gmail.com> (sfid-20151202_035019_722278_C1D9BBA9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct set_multicast uses (implicitly) sizeof(bool) to determine how many bytes to copy in
Handle_SetMulticastFilter. Since that is implementation defined, it triggered sparse to
rightfully complain about shifting a bigger value than supported.
Since it was used as if assuming it was 32 bits, I replaced the bool member by a u32.
Also, time_out and buf_size members of ba_session_info are u16, but while copying their
bytes into ptr in Handle_AddBASession shift 16 bits for the second byte instead of 8 bits.
This patch fixes those two issues.

Signed-off-by: Mario J. Rugiero <mrugiero@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0c87f6c..fcfd70a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -142,7 +142,7 @@ struct beacon_attr {
 };
 
 struct set_multicast {
-	bool enabled;
+	u32 enabled;
 	u32 cnt;
 };
 
@@ -2752,9 +2752,9 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = strHostIfBASessionInfo->tid;
 	*ptr++ = 1;
 	*ptr++ = (strHostIfBASessionInfo->buf_size & 0xFF);
-	*ptr++ = ((strHostIfBASessionInfo->buf_size >> 16) & 0xFF);
+	*ptr++ = ((strHostIfBASessionInfo->buf_size >> 8) & 0xFF);
 	*ptr++ = (strHostIfBASessionInfo->time_out & 0xFF);
-	*ptr++ = ((strHostIfBASessionInfo->time_out >> 16) & 0xFF);
+	*ptr++ = ((strHostIfBASessionInfo->time_out >> 8) & 0xFF);
 	*ptr++ = (AddbaTimeout & 0xFF);
 	*ptr++ = ((AddbaTimeout >> 16) & 0xFF);
 	*ptr++ = 8;
@@ -2777,7 +2777,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = strHostIfBASessionInfo->tid;
 	*ptr++ = 8;
 	*ptr++ = (strHostIfBASessionInfo->buf_size & 0xFF);
-	*ptr++ = ((strHostIfBASessionInfo->time_out >> 16) & 0xFF);
+	*ptr++ = ((strHostIfBASessionInfo->time_out >> 8) & 0xFF);
 	*ptr++ = 3;
 	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
-- 
2.6.2

