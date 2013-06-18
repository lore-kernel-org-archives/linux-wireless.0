Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43608 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab3FRWE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 18:04:27 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 6/6] wireless:  Add comments about bss refcounting.
Date: Tue, 18 Jun 2013 15:03:37 -0700
Message-Id: <1371593017-10985-6-git-send-email-greearb@candelatech.com> (sfid-20130619_000430_250528_BA838543)
In-Reply-To: <1371593017-10985-1-git-send-email-greearb@candelatech.com>
References: <1371593017-10985-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Should help the next person that tries to understand
the bss refcounting logic.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/wireless/scan.c |    4 ++++
 net/wireless/sme.c  |    3 +++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 542ff6d..834d2f9 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -622,6 +622,7 @@ static int cmp_bss(struct cfg80211_bss *a,
 	}
 }
 
+/** Returned bss is reference counted and must be cleaned up appropriately. */
 struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 				      struct ieee80211_channel *channel,
 				      const u8 *bssid,
@@ -777,6 +778,7 @@ static bool cfg80211_combine_bsses(struct cfg80211_registered_device *dev,
 	return true;
 }
 
+/** Returned bss is reference counted and must be cleaned up appropriately. */
 static struct cfg80211_internal_bss *
 cfg80211_bss_update(struct cfg80211_registered_device *dev,
 		    struct cfg80211_internal_bss *tmp)
@@ -962,6 +964,7 @@ cfg80211_get_bss_channel(struct wiphy *wiphy, const u8 *ie, size_t ielen,
 	return channel;
 }
 
+/** Returned bss is reference counted and must be cleaned up appropriately. */
 struct cfg80211_bss*
 cfg80211_inform_bss(struct wiphy *wiphy,
 		    struct ieee80211_channel *channel,
@@ -1019,6 +1022,7 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(cfg80211_inform_bss);
 
+/** Returned bss is reference counted and must be cleaned up appropriately. */
 struct cfg80211_bss *
 cfg80211_inform_bss_frame(struct wiphy *wiphy,
 			  struct ieee80211_channel *channel,
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index ea2ce33..d26cd68 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -263,6 +263,7 @@ void cfg80211_conn_work(struct work_struct *work)
 	rtnl_unlock();
 }
 
+/** Returned bss is reference counted and must be cleaned up appropriately. */
 static struct cfg80211_bss *cfg80211_get_conn_bss(struct wireless_dev *wdev)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -579,6 +580,7 @@ void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 }
 EXPORT_SYMBOL(cfg80211_connect_result);
 
+/** Consumes bss object one way or another */
 void __cfg80211_roamed(struct wireless_dev *wdev,
 		       struct cfg80211_bss *bss,
 		       const u8 *req_ie, size_t req_ie_len,
@@ -662,6 +664,7 @@ void cfg80211_roamed(struct net_device *dev,
 }
 EXPORT_SYMBOL(cfg80211_roamed);
 
+/** Consumes bss object one way or another */
 void cfg80211_roamed_bss(struct net_device *dev,
 			 struct cfg80211_bss *bss, const u8 *req_ie,
 			 size_t req_ie_len, const u8 *resp_ie,
-- 
1.7.3.4

