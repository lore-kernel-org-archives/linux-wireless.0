Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65446 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126AbaDHIgx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 04:36:53 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 5/5] wil6210: Use larger Tx rings
Date: Tue, 8 Apr 2014 11:36:19 +0300
Message-ID: <1396946179-11677-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140408_103705_041238_5D96EBB6)
In-Reply-To: <1396946179-11677-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1396946179-11677-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using scatter-gather, more descriptor entries get used.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wil6210.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index f881aee..d3b8659 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -35,7 +35,7 @@ static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
 #define WIL6210_MEM_SIZE (2*1024*1024UL)
 
 #define WIL6210_RX_RING_SIZE	(128)
-#define WIL6210_TX_RING_SIZE	(128)
+#define WIL6210_TX_RING_SIZE	(512)
 #define WIL6210_MAX_TX_RINGS	(24) /* HW limit */
 #define WIL6210_MAX_CID		(8) /* HW limit */
 #define WIL6210_NAPI_BUDGET	(16) /* arbitrary */
-- 
1.8.3.2

