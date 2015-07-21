Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44089 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbbGUFZ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 01:25:28 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 2/2] ath10k: Increase max client to 512 in qca99x0
Date: Tue, 21 Jul 2015 10:52:58 +0530
Message-ID: <1437456178-7862-2-git-send-email-rmani@qti.qualcomm.com> (sfid-20150721_072531_259823_4E6653B4)
In-Reply-To: <1437456178-7862-1-git-send-email-rmani@qti.qualcomm.com>
References: <1437456178-7862-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When max client was set to 512 in qca99x0, there was host memory
alloc failure during wmi service ready event handling. This issue
got resolved now, increasing max client limit from 256 to 512.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/hw.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 9172285..a43105d 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -363,10 +363,7 @@ enum ath10k_hw_rate_cck {
 						 (TARGET_10_4_NUM_VDEVS))
 #define TARGET_10_4_ACTIVE_PEERS		0
 
-/* TODO: increase qcache max client limit to 512 after
- * testing with 512 client.
- */
-#define TARGET_10_4_NUM_QCACHE_PEERS_MAX	256
+#define TARGET_10_4_NUM_QCACHE_PEERS_MAX	512
 #define TARGET_10_4_QCACHE_ACTIVE_PEERS		50
 #define TARGET_10_4_NUM_OFFLOAD_PEERS		0
 #define TARGET_10_4_NUM_OFFLOAD_REORDER_BUFFS	0
-- 
1.8.1.2

