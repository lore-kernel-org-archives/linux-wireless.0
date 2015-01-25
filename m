Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31610 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbbAYIxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 03:53:32 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Shulman <QCA_shulmanv@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 05/10] wil6210: tuning rings size
Date: Sun, 25 Jan 2015 10:52:46 +0200
Message-Id: <1422175971-8075-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150125_095339_988688_08E09BCA)
In-Reply-To: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Shulman <qca_shulmanv@qca.qualcomm.com>

Tuning rings size for performance optimization.
Increasing Tx ring size, allows buffering more packets for HW, thus
eliminating idle periods which were observed with smaller ring at
high throughput, because HW was fetching packets faster than driver was
filling them into the TX ring. Rx ring was similarly increased to
avoid same problems in Rx.

Signed-off-by: Vladimir Shulman <qca_shulmanv@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wil6210.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index fc196bf..2521ba1 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -45,8 +45,8 @@ static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
 #define WIL6210_MEM_SIZE (2*1024*1024UL)
 
 #define WIL_TX_Q_LEN_DEFAULT		(4000)
-#define WIL_RX_RING_SIZE_ORDER_DEFAULT	(9)
-#define WIL_TX_RING_SIZE_ORDER_DEFAULT	(9)
+#define WIL_RX_RING_SIZE_ORDER_DEFAULT	(10)
+#define WIL_TX_RING_SIZE_ORDER_DEFAULT	(10)
 /* limit ring size in range [32..32k] */
 #define WIL_RING_SIZE_ORDER_MIN	(5)
 #define WIL_RING_SIZE_ORDER_MAX	(15)
-- 
2.1.0

