Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41967 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbYEWRP2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 13:15:28 -0400
From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Subject: [PATCH] mac80211 : Fixes the status message for iwconfig
Date: Fri, 23 May 2008 10:15:26 -0700
Message-Id: <1211562926905-git-send-email-abhijeet.kolekar@intel.com> (sfid-20080523_191534_145110_FED2DADB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwconfig was showing incorrect status messages when disassociated.
Patch fixes this by always checking for association status in 
ioctl calls for getting ap address.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
---
 net/mac80211/wext.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index c2e2378..1a35562 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -501,9 +501,14 @@ static int ieee80211_ioctl_giwap(struct net_device *dev,
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
 	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
-		ap_addr->sa_family = ARPHRD_ETHER;
-		memcpy(&ap_addr->sa_data, sdata->u.sta.bssid, ETH_ALEN);
-		return 0;
+		if (sdata->u.sta.state == IEEE80211_ASSOCIATED) {
+			ap_addr->sa_family = ARPHRD_ETHER;
+			memcpy(&ap_addr->sa_data, sdata->u.sta.bssid, ETH_ALEN);
+			return 0;
+		} else {
+			memset(&ap_addr->sa_data, 0, ETH_ALEN);
+			return 0;
+		}
 	} else if (sdata->vif.type == IEEE80211_IF_TYPE_WDS) {
 		ap_addr->sa_family = ARPHRD_ETHER;
 		memcpy(&ap_addr->sa_data, sdata->u.wds.remote_addr, ETH_ALEN);
-- 
1.5.2.5

