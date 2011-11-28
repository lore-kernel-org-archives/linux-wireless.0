Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61184 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1K1VbV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 16:31:21 -0500
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 2/2] cfg80211: amend regulatory NULL dereference fix
Date: Mon, 28 Nov 2011 16:31:10 -0500
Message-Id: <1322515870-3392-3-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111128_223125_012773_6F6C9D93)
In-Reply-To: <1322515870-3392-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1322515870-3392-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes' patch for "cfg80211: fix regulatory NULL dereference"
broke user regulaotry hints and it did not address the fact that
last_request was left populated even if the previous regulatory
hint was stale due to the wiphy disappearing.

Fix user reguluatory hints by only bailing out if for those
regulatory hints where a request_wiphy is expected. The stale last_request
considerations are addressed through the previous fixes on last_request
where we reset the last_request to a static world regdom request upon
reset_regdomains(). In this case though we further enhance the effect
by simply restoring reguluatory settings completely.

Cc: stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 net/wireless/reg.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 09b753b..d9ba091 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2094,8 +2094,10 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	}
 
 	request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
-	if (!request_wiphy) {
-		reg_set_request_processed();
+	if (!request_wiphy &&
+	    (last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER ||
+	     last_request->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE)) {
+		schedule_delayed_work(&reg_timeout, 0);
 		return -ENODEV;
 	}
 
-- 
1.7.4.15.g7811d

