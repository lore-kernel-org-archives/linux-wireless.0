Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19371 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621AbZAMT6Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 14:58:25 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 11:58:25 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 02/12] cfg80211: add helper to indicate when to follow the driver regd
Date: Tue, 13 Jan 2009 11:57:45 -0800
Message-ID: <1231876675-20518-3-git-send-email-lrodriguez@atheros.com> (sfid-20090113_205827_950119_756FF343)
In-Reply-To: <1231876675-20518-2-git-send-email-lrodriguez@atheros.com>
References: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a helper which which tells us when we need to follow
the driver's own regulatory domain. This will later be expanded.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ec8b3d9..1a5b37a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -782,6 +782,16 @@ static u32 map_regdom_flags(u32 rd_flags)
 	return channel_flags;
 }
 
+/* Follow the driver's regulatory domain, if present, unless a country
+ * IE has been processed */
+static int reg_follow_driver_regd(struct wiphy *wiphy)
+{
+	if (last_request->initiator != REGDOM_SET_BY_COUNTRY_IE &&
+	    wiphy->regd)
+		return true;
+	return false;
+}
+
 /**
  * freq_reg_info - get regulatory information for the given frequency
  * @wiphy: the wiphy for which we want to process this rule for
@@ -813,10 +823,7 @@ static int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 *bandwidth,
 
 	regd = cfg80211_regdomain;
 
-	/* Follow the driver's regulatory domain, if present, unless a country
-	 * IE has been processed */
-	if (last_request->initiator != REGDOM_SET_BY_COUNTRY_IE &&
-	    wiphy->regd)
+	if (reg_follow_driver_regd(wiphy))
 		regd = wiphy->regd;
 
 	if (!regd)
-- 
1.6.1.rc3.51.g5832d

