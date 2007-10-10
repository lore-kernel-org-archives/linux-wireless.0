Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4912 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233AbXJJVIs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 17:08:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: dana.r.ferguson@intel.com, dcbw@redhat.com,
	ipw3945-devel@lists.sourceforge.net, Bill Moss <bmoss@clemson.edu>,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] [PATCH] mac80211: honor IW_SCAN_THIS_ESSID in siwscan ioctl
Date: Wed, 10 Oct 2007 16:34:56 -0400
Message-Id: <1192048496718-git-send-email-linville@tuxdriver.com> (sfid-20071010_220853_027330_25461BBA)
In-Reply-To: 20071010202422.GN5962@tuxdriver.com
References: 20071010202422.GN5962@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bill Moss <bmoss@clemson.edu>

This patch fixes the problem of associating with wpa_secured hidden
AP.  Please try out.

The original author of this patch is Bill Moss <bmoss@clemson.edu>

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/ieee80211_ioctl.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index f95d488..331048f 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -507,10 +507,11 @@ static int ieee80211_ioctl_giwap(struct net_device *dev,
 
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
 
@@ -519,6 +520,14 @@ static int ieee80211_ioctl_siwscan(struct net_device *dev,
 
 	switch (sdata->type) {
 	case IEEE80211_IF_TYPE_STA:
+		if (wrqu->data.length == sizeof(struct iw_scan_req) &&
+		    wrqu->data.flags & IW_SCAN_THIS_ESSID) {
+			req = (struct iw_scan_req *)extra;
+			ssid = req->essid;
+			ssid_len = req->essid_len;
+			break;
+		}
+		/* else fall-through */
 	case IEEE80211_IF_TYPE_IBSS:
 		if (local->scan_flags & IEEE80211_SCAN_MATCH_SSID) {
 			ssid = sdata->u.sta.ssid;
-- 
1.5.2.4

