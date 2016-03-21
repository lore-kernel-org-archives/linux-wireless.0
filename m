Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48569 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194AbcCUWmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2016 18:42:14 -0400
From: Colin King <colin.king@canonical.com>
To: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: fix a couple of memory leaks
Date: Mon, 21 Mar 2016 22:42:11 +0000
Message-Id: <1458600131-5286-1-git-send-email-colin.king@canonical.com> (sfid-20160321_234237_124600_E3AB103B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The ENOMEM error return paths are not free'ing allocated memory
resulting in a memory leak of allocated structures. Perform the
required kfree to fix the memory leaks.

Issue discovered with static analysis using CoverityScan

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 2c4ae1f..4b51c0a 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -338,8 +338,10 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 
 		if (ies_len > 0) {
 			network_info->ies = kmemdup(ies, ies_len, GFP_KERNEL);
-			if (!network_info->ies)
+			if (!network_info->ies) {
+				kfree(network_info);
 				return -ENOMEM;
+			}
 		}
 		network_info->ies_len = ies_len;
 	}
@@ -373,8 +375,10 @@ s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
 					    AID_LEN);
 
 		connect_resp_info->ies = kmemdup(ies, ies_len, GFP_KERNEL);
-		if (!connect_resp_info->ies)
+		if (!connect_resp_info->ies) {
+			kfree(connect_resp_info);
 			return -ENOMEM;
+		}
 
 		connect_resp_info->ies_len = ies_len;
 	}
-- 
2.7.3

