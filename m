Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33282 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZFSApu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 20:45:50 -0400
Subject: [PATCH] cfg80211: send wext MLME-MICHAELMICFAILURE.indication
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 19 Jun 2009 02:45:21 +0200
Message-Id: <1245372321.16399.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of having mac80211 do it itself.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/event.c |   18 +-----------------
 net/wireless/mlme.c  |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 17 deletions(-)

--- wireless-testing.orig/net/mac80211/event.c	2009-06-19 02:44:17.000000000 +0200
+++ wireless-testing/net/mac80211/event.c	2009-06-19 02:44:23.000000000 +0200
@@ -7,8 +7,7 @@
  *
  * mac80211 - events
  */
-
-#include <net/iw_handler.h>
+#include <net/cfg80211.h>
 #include "ieee80211_i.h"
 
 /*
@@ -19,21 +18,6 @@
 void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int keyidx,
 				     struct ieee80211_hdr *hdr, const u8 *tsc)
 {
-	union iwreq_data wrqu;
-	char *buf = kmalloc(128, GFP_ATOMIC);
-
-	if (buf) {
-		/* TODO: needed parameters: count, key type, TSC */
-		sprintf(buf, "MLME-MICHAELMICFAILURE.indication("
-			"keyid=%d %scast addr=%pM)",
-			keyidx, hdr->addr1[0] & 0x01 ? "broad" : "uni",
-			hdr->addr2);
-		memset(&wrqu, 0, sizeof(wrqu));
-		wrqu.data.length = strlen(buf);
-		wireless_send_event(sdata->dev, IWEVCUSTOM, &wrqu, buf);
-		kfree(buf);
-	}
-
 	cfg80211_michael_mic_failure(sdata->dev, hdr->addr2,
 				     (hdr->addr1[0] & 0x01) ?
 				     NL80211_KEYTYPE_GROUP :
--- wireless-testing.orig/net/wireless/mlme.c	2009-06-19 02:44:21.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2009-06-19 02:44:23.000000000 +0200
@@ -77,6 +77,22 @@ void cfg80211_michael_mic_failure(struct
 {
 	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+#ifdef CONFIG_WIRELESS_EXT
+	union iwreq_data wrqu;
+	char *buf = kmalloc(128, GFP_ATOMIC);
+
+	if (buf) {
+		sprintf(buf, "MLME-MICHAELMICFAILURE.indication("
+			"keyid=%d %scast addr=%pM)", key_id,
+			key_type == NL80211_KEYTYPE_GROUP ? "broad" : "uni",
+			addr);
+		memset(&wrqu, 0, sizeof(wrqu));
+		wrqu.data.length = strlen(buf);
+		wireless_send_event(dev, IWEVCUSTOM, &wrqu, buf);
+		kfree(buf);
+	}
+#endif
+
 	nl80211_michael_mic_failure(rdev, dev, addr, key_type, key_id, tsc);
 }
 EXPORT_SYMBOL(cfg80211_michael_mic_failure);


