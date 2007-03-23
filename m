Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:49001 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992555AbXCWUnm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:43:42 -0400
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070323214400.642621638.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 15/19] mac80211: fix wrong keyidx will change default key
Message-Id: <20070323204458.25F2548589@silver.suse.cz>
Date: Fri, 23 Mar 2007 21:44:58 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hong Liu <hong.liu@intel.com>

Signed-off-by: Hong Liu <hong.liu@intel.com>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/mac80211/ieee80211_ioctl.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

1485998df4d688be3e0907423a774dadbf90a631
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index 21a17eb..b28e794 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -2924,19 +2924,17 @@ static int ieee80211_ioctl_siwencode(str
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	idx = erq->flags & IW_ENCODE_INDEX;
-	if (idx < 1 || idx > 4) {
-		idx = -1;
-		if (!sdata->default_key)
-			idx = 0;
-		else for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
-			if (sdata->default_key == sdata->keys[i]) {
-				idx = i;
-				break;
+	if (idx == 0) {
+		if (sdata->default_key)
+			for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
+				if (sdata->default_key == sdata->keys[i]) {
+					idx = i;
+					break;
+				}
 			}
-		}
-		if (idx < 0)
-			return -EINVAL;
-	} else
+	} else if (idx < 1 || idx > 4)
+		return -EINVAL;
+	else
 		idx--;
 
 	if (erq->flags & IW_ENCODE_DISABLED)
-- 
1.3.0

