Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:46786 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbbBJLud (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2015 06:50:33 -0500
Received: by lams18 with SMTP id s18so19651751lam.13
        for <linux-wireless@vger.kernel.org>; Tue, 10 Feb 2015 03:50:32 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] mac80211: disable u-APSD queues by default
Date: Tue, 10 Feb 2015 12:48:44 +0100
Message-Id: <1423568924-11895-1-git-send-email-michal.kazior@tieto.com> (sfid-20150210_125036_697510_C6A88C7A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some APs experience problems when working with
U-APSD. Decreasing the probability of that
happening by using legacy mode for all ACs but VO
isn't enough.

Cisco 4410N originally forced us to enable VO by
default only because it treated non-VO ACs as
legacy.

However some APs (notably Netgear R7000) silently
reclassify packets to different ACs. Since u-APSD
ACs require trigger frames for frame retrieval
clients would never see some frames (e.g. ARP
responses) or would fetch them accidentally after
a long time.

It makes little sense to enable u-APSD queues by
default because it needs userspace applications to
be aware of it to actually take advantage of the
possible additional powersavings. Implicitly
depending on driver autotrigger frame support
doesn't make much sense.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/ieee80211_i.h | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3afe368..c0e089c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -58,13 +58,24 @@ struct ieee80211_local;
 #define IEEE80211_UNSET_POWER_LEVEL	INT_MIN
 
 /*
- * Some APs experience problems when working with U-APSD. Decrease the
- * probability of that happening by using legacy mode for all ACs but VO.
- * The AP that caused us trouble was a Cisco 4410N. It ignores our
- * setting, and always treats non-VO ACs as legacy.
+ * Some APs experience problems when working with U-APSD. Decreasing the
+ * probability of that happening by using legacy mode for all ACs but VO isn't
+ * enough.
+ *
+ * Cisco 4410N originally forced us to enable VO by default only because it
+ * treated non-VO ACs as legacy.
+ *
+ * However some APs (notably Netgear R7000) silently reclassify packets to
+ * different ACs. Since u-APSD ACs require trigger frames for frame retrieval
+ * clients would never see some frames (e.g. ARP responses) or would fetch them
+ * accidentally after a long time.
+ *
+ * It makes little sense to enable u-APSD queues by default because it needs
+ * userspace applications to be aware of it to actually take advantage of the
+ * possible additional powersavings. Implicitly depending on driver autotrigger
+ * frame support doesn't make much sense.
  */
-#define IEEE80211_DEFAULT_UAPSD_QUEUES \
-	IEEE80211_WMM_IE_STA_QOSINFO_AC_VO
+#define IEEE80211_DEFAULT_UAPSD_QUEUES 0
 
 #define IEEE80211_DEFAULT_MAX_SP_LEN		\
 	IEEE80211_WMM_IE_STA_QOSINFO_SP_ALL
-- 
1.8.5.3

