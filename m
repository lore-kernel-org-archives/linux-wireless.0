Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57263 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab2FRHnz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 03:43:55 -0400
Received: by wgbdr13 with SMTP id dr13so5313512wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 00:43:54 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kvalo@adurom.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2] mac80211: set only VO as a U-APSD enabled AC
Date: Mon, 18 Jun 2012 10:43:50 +0300
Message-Id: <1340005430-7655-1-git-send-email-arik@wizery.com> (sfid-20120618_094357_842519_65A746F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some APs experience problems when working with U-APSD. Decrease the
probability of that happening by using legacy mode for all ACs but VO.

The AP that caused us troubles was a Cisco 4410N. It ignores our
setting, and always treats non-VO ACs as legacy.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v2: added a comment explaining the change

 net/mac80211/ieee80211_i.h |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ddf768f..34af2e5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -55,11 +55,14 @@ struct ieee80211_local;
 #define TU_TO_JIFFIES(x)	(usecs_to_jiffies((x) * 1024))
 #define TU_TO_EXP_TIME(x)	(jiffies + TU_TO_JIFFIES(x))
 
+/*
+ * Some APs experience problems when working with U-APSD. Decrease the
+ * probability of that happening by using legacy mode for all ACs but VO.
+ * The AP that caused us trouble was a Cisco 4410N. It ignores our
+ * setting, and always treats non-VO ACs as legacy.
+ */
 #define IEEE80211_DEFAULT_UAPSD_QUEUES \
-	(IEEE80211_WMM_IE_STA_QOSINFO_AC_BK |	\
-	 IEEE80211_WMM_IE_STA_QOSINFO_AC_BE |	\
-	 IEEE80211_WMM_IE_STA_QOSINFO_AC_VI |	\
-	 IEEE80211_WMM_IE_STA_QOSINFO_AC_VO)
+	IEEE80211_WMM_IE_STA_QOSINFO_AC_VO
 
 #define IEEE80211_DEFAULT_MAX_SP_LEN		\
 	IEEE80211_WMM_IE_STA_QOSINFO_SP_ALL
-- 
1.7.9.5

