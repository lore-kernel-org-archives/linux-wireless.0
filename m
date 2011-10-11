Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54017 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab1JKSBr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 14:01:47 -0400
Received: by qadb15 with SMTP id b15so4948534qad.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 11:01:47 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 6/6] cfg80211: pass DFS region to drivers through reg_notifier()
Date: Tue, 11 Oct 2011 10:59:03 -0700
Message-Id: <1318355944-24708-7-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111011_200150_714274_0D69E90F)
In-Reply-To: <1318355944-24708-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1318355944-24708-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This grants drivers access to the DFS region that a
regulatory domain belongs to.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 include/net/regulatory.h |    5 +++++
 net/wireless/reg.c       |    2 ++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index 7399c93..a5f7993 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -48,6 +48,10 @@ enum environment_cap {
  * 	99 - built by driver but a specific alpha2 cannot be determined
  * 	98 - result of an intersection between two regulatory domains
  *	97 - regulatory domain has not yet been configured
+ * @dfs_region: If CRDA responded with a regulatory domain that requires
+ *	DFS master operation on a known DFS region (NL80211_DFS_*),
+ *	dfs_region represents that region. Drivers can use this and the
+ *	@alpha2 to adjust their device's DFS parameters as required.
  * @intersect: indicates whether the wireless core should intersect
  * 	the requested regulatory domain with the presently set regulatory
  * 	domain.
@@ -67,6 +71,7 @@ struct regulatory_request {
 	int wiphy_idx;
 	enum nl80211_reg_initiator initiator;
 	char alpha2[2];
+	u8 dfs_region;
 	bool intersect;
 	bool processed;
 	enum environment_cap country_ie_env;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 69141ed..b66444d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1121,6 +1121,8 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 	if (ignore_reg_update(wiphy, initiator))
 		return;
 
+	last_request->dfs_region = cfg80211_regdomain->dfs_region;
+
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (wiphy->bands[band])
 			handle_band(wiphy, band, initiator);
-- 
1.7.4.15.g7811d

