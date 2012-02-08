Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38157 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab2BHGxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 01:53:39 -0500
From: Naveen Gangadharan <ngangadh@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Fix firmware crash dump
Date: Tue, 7 Feb 2012 22:53:32 -0800
Message-ID: <1328684012-2209-1-git-send-email-ngangadh@qca.qualcomm.com> (sfid-20120208_075407_935448_61508D31)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed a bug when we dump the firmware crash log.

Signed-off-by: Naveen Gangadharan <ngangadh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/hif.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/hif.c b/drivers/net/wireless/ath/ath6kl/hif.c
index e911737..78d0018 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.c
+++ b/drivers/net/wireless/ath/ath6kl/hif.c
@@ -106,7 +106,7 @@ static void ath6kl_hif_dump_fw_crash(struct ath6kl *ar)
 
 	BUILD_BUG_ON(REG_DUMP_COUNT_AR6003 % 4);
 
-	for (i = 0; i < REG_DUMP_COUNT_AR6003 / 4; i++) {
+	for (i = 0; i < REG_DUMP_COUNT_AR6003; i += 4) {
 		ath6kl_info("%d: 0x%8.8x 0x%8.8x 0x%8.8x 0x%8.8x\n",
 			    4 * i,
 			    le32_to_cpu(regdump_val[i]),
-- 
1.7.0.4

