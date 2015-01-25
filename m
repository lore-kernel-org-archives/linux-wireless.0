Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31610 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbbAYIxe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 03:53:34 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Shulman <QCA_shulmanv@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 06/10] wil6210: interrupt moderation configuration update
Date: Sun, 25 Jan 2015 10:52:47 +0200
Message-Id: <1422175971-8075-7-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150125_095341_395118_0DFB4966)
In-Reply-To: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Shulman <qca_shulmanv@qca.qualcomm.com>

Due to HW limitation, inter-packet gap timeout max value is 13 usec.
Update of current thresholds from 15 to 13 usec.

Signed-off-by: Vladimir Shulman <qca_shulmanv@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wil6210.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 2521ba1..3575b5d 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -78,8 +78,8 @@ static inline u32 wil_mtu2macbuf(u32 mtu)
 #define WIL_MAX_ETH_MTU		(IEEE80211_MAX_DATA_LEN_DMG - 8)
 /* Max supported by wil6210 value for interrupt threshold is 5sec. */
 #define WIL6210_ITR_TRSH_MAX (5000000)
-#define WIL6210_ITR_TX_INTERFRAME_TIMEOUT_DEFAULT (15) /* usec */
-#define WIL6210_ITR_RX_INTERFRAME_TIMEOUT_DEFAULT (15) /* usec */
+#define WIL6210_ITR_TX_INTERFRAME_TIMEOUT_DEFAULT (13) /* usec */
+#define WIL6210_ITR_RX_INTERFRAME_TIMEOUT_DEFAULT (13) /* usec */
 #define WIL6210_ITR_TX_MAX_BURST_DURATION_DEFAULT (500) /* usec */
 #define WIL6210_ITR_RX_MAX_BURST_DURATION_DEFAULT (500) /* usec */
 #define WIL6210_FW_RECOVERY_RETRIES	(5) /* try to recover this many times */
-- 
2.1.0

