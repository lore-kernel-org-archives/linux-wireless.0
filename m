Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37199 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab2FNHtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 03:49:13 -0400
Received: by wibhj8 with SMTP id hj8so6195622wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2012 00:49:12 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kvalo@adurom.com>, Arik Nemtsov <arik@wizery.com>
Subject: [RFC] mac80211: set only VO as a U-APSD enabled AC
Date: Thu, 14 Jun 2012 10:49:06 +0300
Message-Id: <1339660146-21030-1-git-send-email-arik@wizery.com> (sfid-20120614_094916_792399_D0F652E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some APs experience problems when working with U-APSD. Decrease the
probability of that happening by using legacy mode for all ACs but VO.

The AP that caused us troubles was a Cisco 4410N. It ignores our
setting, and always treats non-VO ACs as legacy.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
Let's have another go at this :)

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

