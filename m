Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9931 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbcBBMIe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 07:08:34 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 26/26] staging: wilc1000: remove warnings line over 80 characters
Date: Tue, 2 Feb 2016 21:02:36 +0900
Message-ID: <1454414556-9822-26-git-send-email-leo.kim@atmel.com> (sfid-20160202_130837_078200_20ECB0F8)
In-Reply-To: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
References: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the warnings reported by checkpatch.pl
for line over 80 characters.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index d481719..3a76586 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -4,7 +4,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #define TAG_PARAM_OFFSET	(MAC_HDR_LEN + TIME_STAMP_LEN + \
-							BEACON_INTERVAL_LEN + CAP_INFO_LEN)
+				 BEACON_INTERVAL_LEN + CAP_INFO_LEN)
 
 enum basic_frame_type {
 	FRAME_TYPE_CONTROL     = 0x04,
@@ -337,8 +337,10 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 		tim_elm = get_tim_elm(msa, rx_len + FCS_LEN, index);
 		if (tim_elm)
 			network_info->dtim_period = tim_elm[3];
-		ies = &msa[MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN];
-		ies_len = rx_len - (MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN);
+		ies = &msa[MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN +
+			   CAP_INFO_LEN];
+		ies_len = rx_len - (MAC_HDR_LEN + TIME_STAMP_LEN +
+				    BEACON_INTERVAL_LEN + CAP_INFO_LEN);
 
 		if (ies_len > 0) {
 			network_info->ies = kmemdup(ies, ies_len, GFP_KERNEL);
@@ -373,7 +375,8 @@ s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
 		connect_resp_info->assoc_id = get_asoc_id(buffer);
 
 		ies = &buffer[CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN];
-		ies_len = assoc_resp_len - (CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN);
+		ies_len = assoc_resp_len - (CAP_INFO_LEN + STATUS_CODE_LEN +
+					    AID_LEN);
 
 		connect_resp_info->ies = kmemdup(ies, ies_len, GFP_KERNEL);
 		if (!connect_resp_info->ies)
-- 
1.9.1

