Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:17203 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933767AbbCDGvY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 01:51:24 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 2/2] ath10k: increase station kickout threshold
Date: Wed, 4 Mar 2015 12:20:47 +0530
Message-ID: <1425451847-14505-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150304_075204_587361_8A0D593C)
In-Reply-To: <1425451847-14505-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1425451847-14505-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the station kickout threshold is also counting software
reries (Default sw count in firmware is 16), increasing the threshold
to try with atleast 20 data frames before kicking out the station.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 7cba781..e43c453 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -50,8 +50,8 @@
 
 #define ATH10K_MAX_NUM_MGMT_PENDING 128
 
-/* number of failed packets */
-#define ATH10K_KICKOUT_THRESHOLD 50
+/* number of failed packets (20 packets with 16 sw reties each) */
+#define ATH10K_KICKOUT_THRESHOLD (20 * 16)
 
 /*
  * Use insanely high numbers to make sure that the firmware implementation
-- 
2.3.1

