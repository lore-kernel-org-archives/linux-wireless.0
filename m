Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34296 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab2BVGeU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 01:34:20 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Lower SDIO pad drive strength for hw2.1.1 board
Date: Wed, 22 Feb 2012 12:03:51 +0530
Message-ID: <1329892431-1499-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20120222_073436_915148_EE5A06FD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Without this change, SDIO shuts down due to CRC error during
data communication to the firmware in some of the platform.
for example, scan request issued to the firmware doesn't
return scan completed events and cause the socket interface
to always return -16 (device busy).

SDIO pad drive strength should be reduced for hw2.1.1 board
to avoid such errors.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 72f1b4f..6033946 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1406,7 +1406,8 @@ static int ath6kl_init_upload(struct ath6kl *ar)
 		return status;
 
 	/* WAR to avoid SDIO CRC err */
-	if (ar->version.target_ver == AR6003_HW_2_0_VERSION) {
+	if (ar->version.target_ver == AR6003_HW_2_0_VERSION ||
+	    ar->version.target_ver == AR6003_HW_2_1_1_VERSION) {
 		ath6kl_err("temporary war to avoid sdio crc error\n");
 
 		param = 0x20;
-- 
1.7.1

