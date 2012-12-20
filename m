Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:38566 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab2LVOxP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 09:53:15 -0500
Received: by mail-we0-f178.google.com with SMTP id x43so2595202wey.23
        for <linux-wireless@vger.kernel.org>; Sat, 22 Dec 2012 06:53:14 -0800 (PST)
Message-Id: <078ea2f0ee742e6e3c0737a52649fb9e90d3bd69.1356186145.git.chunkeey@googlemail.com> (sfid-20121222_155318_799278_90BAD953)
In-Reply-To: <8f92b38a456c1dd901ce2022fcb66609a5b8ac4b.1356186145.git.chunkeey@googlemail.com>
References: <8f92b38a456c1dd901ce2022fcb66609a5b8ac4b.1356186145.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Thu, 20 Dec 2012 02:44:29 +0100
Subject: [PATCH 7/8] carl9170: remove custom NUM_TID and friends
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit: "mac80211: introduce IEEE80211_NUM_TIDS and use it"
introduced a generic NUM_TID definitions for all everyone.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/carl9170.h |   18 ++++++------------
 drivers/net/wireless/ath/carl9170/main.c     |    4 ++--
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index c77874c..2559974 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -85,20 +85,14 @@ enum carl9170_device_state {
 	CARL9170_STARTED,
 };
 
-#define CARL9170_NUM_TID		16
 #define WME_BA_BMP_SIZE			64
 #define CARL9170_TX_USER_RATE_TRIES	3
 
-#define WME_AC_BE   2
-#define WME_AC_BK   3
-#define WME_AC_VI   1
-#define WME_AC_VO   0
-
 #define TID_TO_WME_AC(_tid)				\
-	((((_tid) == 0) || ((_tid) == 3)) ? WME_AC_BE :	\
-	 (((_tid) == 1) || ((_tid) == 2)) ? WME_AC_BK :	\
-	 (((_tid) == 4) || ((_tid) == 5)) ? WME_AC_VI :	\
-	 WME_AC_VO)
+	((((_tid) == 0) || ((_tid) == 3)) ? IEEE80211_AC_BE :	\
+	 (((_tid) == 1) || ((_tid) == 2)) ? IEEE80211_AC_BK :	\
+	 (((_tid) == 4) || ((_tid) == 5)) ? IEEE80211_AC_VI :	\
+	 IEEE80211_AC_VO)
 
 #define SEQ_DIFF(_start, _seq) \
 	(((_start) - (_seq)) & 0x0fff)
@@ -494,8 +488,8 @@ struct carl9170_sta_info {
 	bool sleeping;
 	atomic_t pending_frames;
 	unsigned int ampdu_max_len;
-	struct carl9170_sta_tid __rcu *agg[CARL9170_NUM_TID];
-	struct carl9170_ba_stats stats[CARL9170_NUM_TID];
+	struct carl9170_sta_tid __rcu *agg[IEEE80211_NUM_TIDS];
+	struct carl9170_ba_stats stats[IEEE80211_NUM_TIDS];
 };
 
 struct carl9170_tx_info {
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 79888c9..717d14c 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1330,7 +1330,7 @@ static int carl9170_op_sta_add(struct ieee80211_hw *hw,
 			return 0;
 		}
 
-		for (i = 0; i < CARL9170_NUM_TID; i++)
+		for (i = 0; i < ARRAY_SIZE(sta_info->agg); i++)
 			RCU_INIT_POINTER(sta_info->agg[i], NULL);
 
 		sta_info->ampdu_max_len = 1 << (3 + sta->ht_cap.ampdu_factor);
@@ -1354,7 +1354,7 @@ static int carl9170_op_sta_remove(struct ieee80211_hw *hw,
 		sta_info->ht_sta = false;
 
 		rcu_read_lock();
-		for (i = 0; i < CARL9170_NUM_TID; i++) {
+		for (i = 0; i < ARRAY_SIZE(sta_info->agg); i++) {
 			struct carl9170_sta_tid *tid_info;
 
 			tid_info = rcu_dereference(sta_info->agg[i]);
-- 
1.7.10.4

