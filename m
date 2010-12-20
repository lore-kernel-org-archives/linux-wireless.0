Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63459 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891Ab0LTRCv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 12:02:51 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 09:02:35 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <kathy.giori@atheros.com>, <amod.bodas@atheros.com>,
	<david.quan@atheros.com>, <michael.green@atheros.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/2] cfg80211: pass DFS region to drivers through reg_notifier()
Date: Mon, 20 Dec 2010 12:02:29 -0500
Message-ID: <1292864555-28661-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1292864555-28661-1-git-send-email-lrodriguez@atheros.com>
References: <1292864555-28661-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This grants drivers access to the DFS region that a
regulatory domain belongs to.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/regulatory.h |    5 +++++
 net/wireless/reg.c       |    4 ++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index 9fcb603..3ed16c5 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -40,6 +40,10 @@ enum environment_cap {
  * 	99 - built by driver but a specific alpha2 cannot be determined
  * 	98 - result of an intersection between two regulatory domains
  *	97 - regulatory domain has not yet been configured
+ * @dfs_region: If CRDA responded with a regulatory domain that requires
+ *	DFS master operation on a known DFS region (NL80211_CFLAG_DFS_*),
+ *	dfs_region represents that region. Drivers can use this and the
+ *	@alpha2 to adjust their device's DFS parameters as they wish.
  * @intersect: indicates whether the wireless core should intersect
  * 	the requested regulatory domain with the presently set regulatory
  * 	domain.
@@ -59,6 +63,7 @@ struct regulatory_request {
 	int wiphy_idx;
 	enum nl80211_reg_initiator initiator;
 	char alpha2[2];
+	u8 dfs_region;
 	bool intersect;
 	bool processed;
 	enum environment_cap country_ie_env;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a3731d2..fc842a2 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1127,8 +1127,12 @@ void wiphy_update_regulatory(struct wiphy *wiphy,
 {
 	enum ieee80211_band band;
 
+	last_request->dfs_region = (cfg80211_regdomain->flags &
+				    NL80211_CFLAG_ALL_DFS_FLAGS);
+
 	if (ignore_reg_update(wiphy, initiator))
 		goto out;
+
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (wiphy->bands[band])
 			handle_band(wiphy, band, initiator);
-- 
1.7.3.2.90.gd4c43

