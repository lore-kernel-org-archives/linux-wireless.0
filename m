Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:60491 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932395Ab0KWBXI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 20:23:08 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 17:22:55 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/3] mac80211: make ieee802_1d_to_ac avilable to drivers
Date: Mon, 22 Nov 2010 17:23:01 -0800
Message-ID: <1290475383-26911-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be used by ath9k's RC next.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/mac80211.h |   15 +++++++++++++++
 net/mac80211/wme.c     |   14 --------------
 net/mac80211/wme.h     |    2 --
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5b0fff2..209c858 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -110,6 +110,21 @@ enum ieee80211_ac_numbers {
 	IEEE80211_AC_BK		= 3,
 };
 
+/*
+ * Default mapping in classifier to work with default
+ * queue setup.
+ */
+static const int ieee802_1d_to_ac[8] = {
+	IEEE80211_AC_BE,
+	IEEE80211_AC_BK,
+	IEEE80211_AC_BK,
+	IEEE80211_AC_BE,
+	IEEE80211_AC_VI,
+	IEEE80211_AC_VI,
+	IEEE80211_AC_VO,
+	IEEE80211_AC_VO
+};
+
 /**
  * struct ieee80211_tx_queue_params - transmit queue configuration
  *
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 58e75bb..43d9a0e 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -18,20 +18,6 @@
 #include "ieee80211_i.h"
 #include "wme.h"
 
-/* Default mapping in classifier to work with default
- * queue setup.
- */
-const int ieee802_1d_to_ac[8] = {
-	IEEE80211_AC_BE,
-	IEEE80211_AC_BK,
-	IEEE80211_AC_BK,
-	IEEE80211_AC_BE,
-	IEEE80211_AC_VI,
-	IEEE80211_AC_VI,
-	IEEE80211_AC_VO,
-	IEEE80211_AC_VO
-};
-
 static int wme_downgrade_ac(struct sk_buff *skb)
 {
 	switch (skb->priority) {
diff --git a/net/mac80211/wme.h b/net/mac80211/wme.h
index 6053b1c..c5501b5 100644
--- a/net/mac80211/wme.h
+++ b/net/mac80211/wme.h
@@ -18,8 +18,6 @@
 
 #define QOS_CONTROL_ACK_POLICY_SHIFT 5
 
-extern const int ieee802_1d_to_ac[8];
-
 u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 			   struct sk_buff *skb);
 void ieee80211_set_qos_hdr(struct ieee80211_local *local, struct sk_buff *skb);
-- 
1.7.3.2.90.gd4c43

