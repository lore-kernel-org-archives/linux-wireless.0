Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3974 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbXJZVHU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 17:07:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: stable@kernel.org
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: only honor IW_SCAN_THIS_ESSID in STA, IBSS, and AP modes
Date: Fri, 26 Oct 2007 17:04:34 -0400
Message-Id: <11934326821301-git-send-email-linville@tuxdriver.com> (sfid-20071026_220725_634483_438DA456)
In-Reply-To: <11934326823646-git-send-email-linville@tuxdriver.com>
References: <11934326793639-git-send-email-linville@tuxdriver.com>
 <11934326801557-git-send-email-linville@tuxdriver.com>
 <11934326803769-git-send-email-linville@tuxdriver.com>
 <11934326803330-git-send-email-linville@tuxdriver.com>
 <11934326811535-git-send-email-linville@tuxdriver.com>
 <11934326813508-git-send-email-linville@tuxdriver.com>
 <1193432681145-git-send-email-linville@tuxdriver.com>
 <11934326812028-git-send-email-linville@tuxdriver.com>
 <11934326813245-git-send-email-linville@tuxdriver.com>
 <11934326823646-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: John W. Linville <linville@tuxdriver.com>

The previous IW_SCAN_THIS_ESSID patch left a hole allowing scan
requests on interfaces in inappropriate modes.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/ieee80211_ioctl.c |   37 +++++++++++++++++++------------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index 5bd103a..7b5b801 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -698,29 +698,30 @@ static int ieee80211_ioctl_siwscan(struct net_device *dev,
 	if (!netif_running(dev))
 		return -ENETDOWN;
 
+	switch (sdata->type) {
+	case IEEE80211_IF_TYPE_STA:
+	case IEEE80211_IF_TYPE_IBSS:
+		if (local->scan_flags & IEEE80211_SCAN_MATCH_SSID) {
+			ssid = sdata->u.sta.ssid;
+			ssid_len = sdata->u.sta.ssid_len;
+		}
+		break;
+	case IEEE80211_IF_TYPE_AP:
+		if (local->scan_flags & IEEE80211_SCAN_MATCH_SSID) {
+			ssid = sdata->u.ap.ssid;
+			ssid_len = sdata->u.ap.ssid_len;
+		}
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	/* if SSID was specified explicitly then use that */
 	if (wrqu->data.length == sizeof(struct iw_scan_req) &&
 	    wrqu->data.flags & IW_SCAN_THIS_ESSID) {
 		req = (struct iw_scan_req *)extra;
 		ssid = req->essid;
 		ssid_len = req->essid_len;
-	} else {
-		switch (sdata->type) {
-		case IEEE80211_IF_TYPE_STA:
-		case IEEE80211_IF_TYPE_IBSS:
-			if (local->scan_flags & IEEE80211_SCAN_MATCH_SSID) {
-				ssid = sdata->u.sta.ssid;
-				ssid_len = sdata->u.sta.ssid_len;
-			}
-			break;
-		case IEEE80211_IF_TYPE_AP:
-			if (local->scan_flags & IEEE80211_SCAN_MATCH_SSID) {
-				ssid = sdata->u.ap.ssid;
-				ssid_len = sdata->u.ap.ssid_len;
-			}
-			break;
-		default:
-			return -EOPNOTSUPP;
-		}
 	}
 
 	return ieee80211_sta_req_scan(dev, ssid, ssid_len);
-- 
1.5.2.4

