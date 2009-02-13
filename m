Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:33442 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbZBMFgv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 00:36:51 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 21:36:51 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 2/6] cfg80211: add wiphy_idx_valid to check for wiphy_idx sanity
Date: Thu, 12 Feb 2009 21:35:59 -0800
Message-ID: <1234503363-11014-3-git-send-email-lrodriguez@atheros.com> (sfid-20090213_063655_975217_CC8518B8)
In-Reply-To: <1234503363-11014-2-git-send-email-lrodriguez@atheros.com>
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
 <1234503363-11014-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will later be used by others.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/core.c |    2 +-
 net/wireless/core.h |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 2b3e786..55be3b0 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -225,7 +225,7 @@ struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv)
 
 	drv->wiphy_idx = wiphy_counter++;
 
-	if (unlikely(drv->wiphy_idx < 0)) {
+	if (!wiphy_idx_valid(drv->wiphy_idx)) {
 		wiphy_counter--;
 		mutex_unlock(&cfg80211_drv_mutex);
 		/* ugh, wrapped! */
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 36e2397..e24bc2a 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -62,6 +62,13 @@ struct cfg80211_registered_device *wiphy_to_dev(struct wiphy *wiphy)
 	return container_of(wiphy, struct cfg80211_registered_device, wiphy);
 }
 
+/* Note 0 is valid, hence phy0 */
+static inline
+bool wiphy_idx_valid(int wiphy_idx)
+{
+	return (likely(wiphy_idx >= 0));
+}
+
 extern struct mutex cfg80211_drv_mutex;
 extern struct list_head cfg80211_drv_list;
 
-- 
1.6.1.2.253.ga34a

