Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52391 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab1GWOXW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 10:23:22 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 11/11] ath6kl: Cleanup void * in ath6kl_cfg80211_scan_node()
Date: Sat, 23 Jul 2011 19:43:17 +0530
Message-ID: <1311430397-4960-11-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110723_162325_154494_8D510DCC)
In-Reply-To: <1311430397-4960-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1311430397-4960-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    3 +--
 drivers/net/wireless/ath/ath6kl/common.h   |    1 -
 drivers/net/wireless/ath/ath6kl/core.h     |    1 +
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index d28e72a..dc299a6 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -721,9 +721,8 @@ static inline bool is_ch_11a(u16 ch)
 }
 
 /* struct ath6kl_node_table::nt_nodelock is locked when calling this */
-void ath6kl_cfg80211_scan_node(void *arg, struct bss *ni)
+void ath6kl_cfg80211_scan_node(struct wiphy *wiphy, struct bss *ni)
 {
-	struct wiphy *wiphy = (struct wiphy *)arg;
 	u16 size;
 	unsigned char *ieeemgmtbuf = NULL;
 	struct ieee80211_mgmt *mgmt;
diff --git a/drivers/net/wireless/ath/ath6kl/common.h b/drivers/net/wireless/ath/ath6kl/common.h
index ab03f44..6b0d456 100644
--- a/drivers/net/wireless/ath/ath6kl/common.h
+++ b/drivers/net/wireless/ath/ath6kl/common.h
@@ -177,5 +177,4 @@ struct ath6kl *ath6kl_core_alloc(struct device *sdev);
 int ath6kl_core_init(struct ath6kl *ar);
 int ath6kl_unavail_ev(struct ath6kl *ar);
 struct sk_buff *ath6kl_buf_alloc(int size);
-void ath6kl_cfg80211_scan_node(void *arg, struct bss *ni);
 #endif /* COMMON_H */
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index f3f588a..7417022 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -540,4 +540,5 @@ void aggr_recv_addba_req_evt(struct ath6kl *ar, u8 tid, u16 seq_no,
 void ath6kl_wakeup_event(void *dev);
 void ath6kl_target_failure(struct ath6kl *ar);
 
+void ath6kl_cfg80211_scan_node(struct wiphy *wiphy, struct bss *ni);
 #endif /* CORE_H */
-- 
1.7.0.4

