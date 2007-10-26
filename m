Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3990 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbXJZVHn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 17:07:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: stable@kernel.org
Cc: linux-wireless@vger.kernel.org, Bill Moss <bmoss@clemson.edu>,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: honor IW_SCAN_THIS_ESSID in siwscan ioctl
Date: Fri, 26 Oct 2007 17:04:33 -0400
Message-Id: <11934326823646-git-send-email-linville@tuxdriver.com> (sfid-20071026_220745_964063_88F9C558)
In-Reply-To: <11934326813245-git-send-email-linville@tuxdriver.com>
References: <11934326793639-git-send-email-linville@tuxdriver.com>
 <11934326801557-git-send-email-linville@tuxdriver.com>
 <11934326803769-git-send-email-linville@tuxdriver.com>
 <11934326803330-git-send-email-linville@tuxdriver.com>
 <11934326811535-git-send-email-linville@tuxdriver.com>
 <11934326813508-git-send-email-linville@tuxdriver.com>
 <1193432681145-git-send-email-linville@tuxdriver.com>
 <11934326812028-git-send-email-linville@tuxdriver.com>
 <11934326813245-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bill Moss <bmoss@clemson.edu>

This patch fixes the problem of associating with wpa_secured hidden
AP.  Please try out.

The original author of this patch is Bill Moss <bmoss@clemson.edu>

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/ieee80211_ioctl.c |   40 ++++++++++++++++++++++++----------------
 1 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index e7904db..5bd103a 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -687,32 +687,40 @@ static int ieee80211_ioctl_giwap(struct net_device *dev,
 
 static int ieee80211_ioctl_siwscan(struct net_device *dev,
 				   struct iw_request_info *info,
-				   struct iw_point *data, char *extra)
+				   union iwreq_data *wrqu, char *extra)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct iw_scan_req *req = NULL;
 	u8 *ssid = NULL;
 	size_t ssid_len = 0;
 
 	if (!netif_running(dev))
 		return -ENETDOWN;
 
-	switch (sdata->type) {
-	case IEEE80211_IF_TYPE_STA:
-	case IEEE80211_IF_TYPE_IBSS:
-		if (local->scan_flags & IEEE80211_SCAN_MATCH_SSID) {
-			ssid = sdata->u.sta.ssid;
-			ssid_len = sdata->u.sta.ssid_len;
-		}
-		break;
-	case IEEE80211_IF_TYPE_AP:
-		if (local->scan_flags & IEEE80211_SCAN_MATCH_SSID) {
-			ssid = sdata->u.ap.ssid;
-			ssid_len = sdata->u.ap.ssid_len;
+	if (wrqu->data.length == sizeof(struct iw_scan_req) &&
+	    wrqu->data.flags & IW_SCAN_THIS_ESSID) {
+		req = (struct iw_scan_req *)extra;
+		ssid = req->essid;
+		ssid_len = req->essid_len;
+	} else {
+		switch (sdata->type) {
+		case IEEE80211_IF_TYPE_STA:
+		case IEEE80211_IF_TYPE_IBSS:
+			if (local->scan_flags & IEEE80211_SCAN_MATCH_SSID) {
+				ssid = sdata->u.sta.ssid;
+				ssid_len = sdata->u.sta.ssid_len;
+			}
+			break;
+		case IEEE80211_IF_TYPE_AP:
+			if (local->scan_flags & IEEE80211_SCAN_MATCH_SSID) {
+				ssid = sdata->u.ap.ssid;
+				ssid_len = sdata->u.ap.ssid_len;
+			}
+			break;
+		default:
+			return -EOPNOTSUPP;
 		}
-		break;
-	default:
-		return -EOPNOTSUPP;
 	}
 
 	return ieee80211_sta_req_scan(dev, ssid, ssid_len);
-- 
1.5.2.4

