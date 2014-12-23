Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21144 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbaLWHsc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:48:32 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 10/22] wil6210: consider SNAP header in MTU calculations
Date: Tue, 23 Dec 2014 09:47:12 +0200
Message-Id: <1419320844-23989-11-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_091348_004700_700271BC)
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When encapsulating 802.3 frames into the 802.11 ones,
8-byte SNAP header added to save ethtype. SNAP is part of
the frame body, thus should be counted in MSDU. So,
MTU = MSDU - SNAP

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c    | 2 +-
 drivers/net/wireless/ath/wil6210/wil6210.h | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 0af51fc..71ebbc1 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -53,7 +53,7 @@ static int mtu_max_set(const char *val, const struct kernel_param *kp)
 	if (ret)
 		return ret;
 
-	if (mtu_max < 68 || mtu_max > IEEE80211_MAX_DATA_LEN_DMG)
+	if (mtu_max < 68 || mtu_max > WIL_MAX_ETH_MTU)
 		ret = -EINVAL;
 
 	return ret;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index bedb9ed..81309dc 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -77,6 +77,10 @@ static inline u32 wil_mtu2macbuf(u32 mtu)
 	return ALIGN(mtu + WIL_MAX_MPDU_OVERHEAD, 8);
 }
 
+/* MTU for Ethernet need to take into account 8-byte SNAP header
+ * to be added when encapsulating Ethernet frame into 802.11
+ */
+#define WIL_MAX_ETH_MTU		(IEEE80211_MAX_DATA_LEN_DMG - 8)
 /* Max supported by wil6210 value for interrupt threshold is 5sec. */
 #define WIL6210_ITR_TRSH_MAX (5000000)
 #define WIL6210_ITR_TRSH_DEFAULT	(300) /* usec */
-- 
2.1.0

