Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:60820 "HELO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751097Ab2BQJrK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 04:47:10 -0500
Received: by mail-lpp01m010-f50.google.com with SMTP id m13so4739005lah.37
        for <linux-wireless@vger.kernel.org>; Fri, 17 Feb 2012 01:47:08 -0800 (PST)
MIME-Version: 1.0
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@gmail.com
Subject: [PATCH] compat: move skb_complete_wifi_ack() function to compat-3.2.h
Date: Fri, 17 Feb 2012 11:46:59 +0200
Message-Id: <1329472019-28688-1-git-send-email-coelho@ti.com> (sfid-20120217_104719_771040_EB7C7B5E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems that the skb_complete_wifi_ack() function was introduced in
3.2-rc2.  So the dummy implementation of this function in compat
should not be in compat-3.3.h anymore, but in compat-3.2.h.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 include/linux/compat-3.2.h |    5 +++++
 include/linux/compat-3.3.h |    4 ----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/compat-3.2.h b/include/linux/compat-3.2.h
index cb14f0b..9ca3727 100644
--- a/include/linux/compat-3.2.h
+++ b/include/linux/compat-3.2.h
@@ -10,6 +10,11 @@
 
 #define PMSG_IS_AUTO(msg)	(((msg).event & PM_EVENT_AUTO) != 0)
 
+static inline void skb_complete_wifi_ack(struct sk_buff *skb, bool acked)
+{
+	WARN_ON(1);
+}
+
 /**
  * skb_frag_page - retrieve the page refered to by a paged fragment
  * @frag: the paged fragment
diff --git a/include/linux/compat-3.3.h b/include/linux/compat-3.3.h
index 4965f23..325d488 100644
--- a/include/linux/compat-3.3.h
+++ b/include/linux/compat-3.3.h
@@ -8,10 +8,6 @@
 /* include to override NL80211_FEATURE_SK_TX_STATUS */
 #include <linux/nl80211.h>
 
-static inline void skb_complete_wifi_ack(struct sk_buff *skb, bool acked)
-{
-	WARN_ON(1);
-}
 #define NL80211_FEATURE_SK_TX_STATUS 0
 
 typedef u32 netdev_features_t;
-- 
1.7.5.4

