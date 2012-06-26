Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35971 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab2FZMDm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 08:03:42 -0400
Received: by weyu7 with SMTP id u7so3513634wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 05:03:41 -0700 (PDT)
From: Eyal Shapira <eyal@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: use legacy mode for all ACs
Date: Tue, 26 Jun 2012 15:03:33 +0300
Message-Id: <1340712213-10193-1-git-send-email-eyal@wizery.com> (sfid-20120626_140346_230062_438A3973)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AVM FritzBox 7390 has a weird behaviour where once we enable
U-APSD only on the VO AC it limits the rate of the packets
it sends to 39Mbps and doesn't do AMPDU aggregation.
This causes a big degradation in throughput obviously.
It's important to note that this isn't related to PS and happens
also when ACTIVE is forced. The traffic affected is sent in BE AC.
Once legacy mode for all ACs is used the AP begins using higher rates
as well as AMPDU aggregation which improves throughput significantly.

In order to deal with this AP and potentially others switch to
using legacy mode for all ACs by default.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
---
In case you're wondering what happens with U-APSD on all ACs
it breaks down as well and even worse, not only a TP issue but
broken PS functionality.

 net/mac80211/ieee80211_i.h |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 341d77d..370a646 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -57,13 +57,18 @@ struct ieee80211_local;
 #define TU_TO_EXP_TIME(x)	(jiffies + TU_TO_JIFFIES(x))
 
 /*
- * Some APs experience problems when working with U-APSD. Decrease the
- * probability of that happening by using legacy mode for all ACs but VO.
- * The AP that caused us trouble was a Cisco 4410N. It ignores our
- * setting, and always treats non-VO ACs as legacy.
+ * Some APs experience problems when working with U-APSD:
+ * Cisco 4410N - It ignores our setting, and always treats non-VO ACs as legacy.
+ *
+ * AVM FritzBox 7930 - Setting U-APSD on VO AC only (which solves the
+ * Cisco 4410N problem) causes the FritzBox to limit the rates of packets
+ * sent by it to 39Mbps and disables AMPDU aggregation. This causes a major
+ * througput degradation with this AP.
+ *
+ * Avoid these issues by using legacy mode for all ACs by default.
+ * U-APSD can still be configured from userspace.
  */
-#define IEEE80211_DEFAULT_UAPSD_QUEUES \
-	IEEE80211_WMM_IE_STA_QOSINFO_AC_VO
+#define IEEE80211_DEFAULT_UAPSD_QUEUES 0
 
 #define IEEE80211_DEFAULT_MAX_SP_LEN		\
 	IEEE80211_WMM_IE_STA_QOSINFO_SP_ALL
-- 
1.7.4.1

