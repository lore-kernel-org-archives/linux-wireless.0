Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45413 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab2FRHTh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 03:19:37 -0400
Received: by wibhj8 with SMTP id hj8so1718340wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 00:19:36 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kvalo@adurom.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: set only VO as a U-APSD enabled AC
Date: Mon, 18 Jun 2012 10:19:31 +0300
Message-Id: <1340003971-7037-1-git-send-email-arik@wizery.com> (sfid-20120618_091940_323018_5161AE6F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some APs experience problems when working with U-APSD. Decrease the
probability of that happening by using legacy mode for all ACs but VO.

The AP that caused us troubles was a Cisco 4410N. It ignores our
setting, and always treats non-VO ACs as legacy.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/ieee80211_i.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ddf768f..58436c3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -56,10 +56,7 @@ struct ieee80211_local;
 #define TU_TO_EXP_TIME(x)	(jiffies + TU_TO_JIFFIES(x))
 
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

