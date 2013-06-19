Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53620 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935060Ab3FSVGx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 17:06:53 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH-WN 3/3] wireless: Add comments about bss refcounting.
Date: Wed, 19 Jun 2013 14:06:27 -0700
Message-Id: <1371675987-28732-3-git-send-email-greearb@candelatech.com> (sfid-20130619_230655_497525_151BE004)
In-Reply-To: <1371675987-28732-1-git-send-email-greearb@candelatech.com>
References: <1371675987-28732-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Should help the next person that tries to understand
the bss refcounting logic.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

This is against wireless-next.

 net/wireless/scan.c |    4 ++++
 net/wireless/sme.c  |    3 +++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index abb0399..d2f4db0 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -623,6 +623,7 @@ static int cmp_bss(struct cfg80211_bss *a,
 	}
 }
 
+/* Returned bss is reference counted and must be cleaned up appropriately. */
 struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 				      struct ieee80211_channel *channel,
 				      const u8 *bssid,
@@ -778,6 +779,7 @@ static bool cfg80211_combine_bsses(struct cfg80211_registered_device *dev,
 	return true;
 }
 
+/* Returned bss is reference counted and must be cleaned up appropriately. */
 static struct cfg80211_internal_bss *
 cfg80211_bss_update(struct cfg80211_registered_device *dev,
 		    struct cfg80211_internal_bss *tmp)
@@ -963,6 +965,7 @@ cfg80211_get_bss_channel(struct wiphy *wiphy, const u8 *ie, size_t ielen,
 	return channel;
 }
 
+/* Returned bss is reference counted and must be cleaned up appropriately. */
 struct cfg80211_bss*
 cfg80211_inform_bss(struct wiphy *wiphy,
 		    struct ieee80211_channel *channel,
@@ -1020,6 +1023,7 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(cfg80211_inform_bss);
 
+/* Returned bss is reference counted and must be cleaned up appropriately. */
 struct cfg80211_bss *
 cfg80211_inform_bss_frame(struct wiphy *wiphy,
 			  struct ieee80211_channel *channel,
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 32dac8c..1d3cfb1 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -239,6 +239,7 @@ void cfg80211_conn_work(struct work_struct *work)
 	rtnl_unlock();
 }
 
+/* Returned bss is reference counted and must be cleaned up appropriately. */
 static struct cfg80211_bss *cfg80211_get_conn_bss(struct wireless_dev *wdev)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -699,6 +700,7 @@ void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 }
 EXPORT_SYMBOL(cfg80211_connect_result);
 
+/* Consumes bss object one way or another */
 void __cfg80211_roamed(struct wireless_dev *wdev,
 		       struct cfg80211_bss *bss,
 		       const u8 *req_ie, size_t req_ie_len,
@@ -775,6 +777,7 @@ void cfg80211_roamed(struct net_device *dev,
 }
 EXPORT_SYMBOL(cfg80211_roamed);
 
+/* Consumes bss object one way or another */
 void cfg80211_roamed_bss(struct net_device *dev,
 			 struct cfg80211_bss *bss, const u8 *req_ie,
 			 size_t req_ie_len, const u8 *resp_ie,
-- 
1.7.3.4

