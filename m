Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41194 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbXCPDlH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2007 23:41:07 -0400
Subject: [PATCH 3/5] mac80211: fix key restricted/open display
From: Hong Liu <hong.liu@intel.com>
To: Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Message-Id: <1174015698.3408.41.camel@devlinux-hong>
Mime-Version: 1.0
Date: Fri, 16 Mar 2007 11:28:24 +0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hong Liu <hong.liu@intel.com>

---

 net/mac80211/ieee80211_ioctl.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

26742fdf9c5835a0abcb75a364840beee08953f8
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index f57e48f..46fd125 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -2934,6 +2934,14 @@ static int ieee80211_ioctl_siwencode(str
 	else
 		idx--;
 
+	if (erq->flags & (IW_ENCODE_OPEN | IW_ENCODE_RESTRICTED))
+		if (sdata->type == IEEE80211_IF_TYPE_STA ||
+		    sdata->type == IEEE80211_IF_TYPE_IBSS)
+			sdata->u.sta.auth_algs =
+				(erq->flags & IW_ENCODE_RESTRICTED) ?
+				IEEE80211_AUTH_ALG_SHARED_KEY :
+				IEEE80211_AUTH_ALG_OPEN;
+
 	if (erq->flags & IW_ENCODE_DISABLED)
 		alg = ALG_NONE;
 	else if (erq->length == 0) {
@@ -2993,6 +3001,14 @@ static int ieee80211_ioctl_giwencode(str
 	erq->length = sdata->keys[idx]->keylen;
 	erq->flags |= IW_ENCODE_ENABLED;
 
+	if (sdata->type == IEEE80211_IF_TYPE_STA ||
+	    sdata->type == IEEE80211_IF_TYPE_IBSS) {
+		if (sdata->u.sta.auth_algs & IEEE80211_AUTH_ALG_OPEN)
+			erq->flags |= IW_ENCODE_OPEN;
+		else if (sdata->u.sta.auth_algs & IEEE80211_AUTH_ALG_SHARED_KEY)
+			erq->flags |= IW_ENCODE_RESTRICTED;
+	}
+
 	return 0;
 }
 
-- 
1.3.3

