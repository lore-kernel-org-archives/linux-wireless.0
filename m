Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27447 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbZBNFee (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Feb 2009 00:34:34 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 21:34:34 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 02/10] cfg80211: add wiphy_idx_valid to check for wiphy_idx sanity
Date: Fri, 13 Feb 2009 21:33:39 -0800
Message-ID: <1234589627-16977-3-git-send-email-lrodriguez@atheros.com> (sfid-20090214_063438_916678_4B26F60D)
In-Reply-To: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will later be used by others, for now make use of it in
cfg80211_drv_by_wiphy_idx() to return early if an invalid
wiphy_idx has been provided.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/core.c |    5 ++++-
 net/wireless/core.h |    7 +++++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 2b3e786..35d457b 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -42,6 +42,9 @@ cfg80211_drv_by_wiphy_idx(int wiphy_idx)
 {
 	struct cfg80211_registered_device *result = NULL, *drv;
 
+	if (!wiphy_idx_valid(wiphy_idx))
+		return NULL;
+
 	list_for_each_entry(drv, &cfg80211_drv_list, list) {
 		if (drv->wiphy_idx == wiphy_idx) {
 			result = drv;
@@ -225,7 +228,7 @@ struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv)
 
 	drv->wiphy_idx = wiphy_counter++;
 
-	if (unlikely(drv->wiphy_idx < 0)) {
+	if (unlikely(!wiphy_idx_valid(drv->wiphy_idx))) {
 		wiphy_counter--;
 		mutex_unlock(&cfg80211_drv_mutex);
 		/* ugh, wrapped! */
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 36e2397..505fc10 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -62,6 +62,13 @@ struct cfg80211_registered_device *wiphy_to_dev(struct wiphy *wiphy)
 	return container_of(wiphy, struct cfg80211_registered_device, wiphy);
 }
 
+/* Note 0 is valid, hence phy0 */
+static inline
+bool wiphy_idx_valid(int wiphy_idx)
+{
+	return (wiphy_idx >= 0);
+}
+
 extern struct mutex cfg80211_drv_mutex;
 extern struct list_head cfg80211_drv_list;
 
-- 
1.6.1.2.253.ga34a

