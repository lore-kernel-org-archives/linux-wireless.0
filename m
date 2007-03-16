Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41194 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbXCPDk4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2007 23:40:56 -0400
Subject: [PATCH 1/5] mac80211: fix wrong keyidx will change default key
From: Hong Liu <hong.liu@intel.com>
To: Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Message-Id: <1174015695.3408.35.camel@devlinux-hong>
Mime-Version: 1.0
Date: Fri, 16 Mar 2007 11:28:15 +0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hong Liu <hong.liu@intel.com>

---

 net/mac80211/ieee80211_ioctl.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

e0f38f2908fb5f32bdf4eb1dc197c81fae61fbe1
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index ae224c6..aa8b789 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -2919,19 +2919,17 @@ static int ieee80211_ioctl_siwencode(str
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
1.3.3

