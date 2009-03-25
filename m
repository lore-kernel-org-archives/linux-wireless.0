Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58643 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733AbZCYBVM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 21:21:12 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org
Subject: [PATCH] cfg80211: fix NULL pointer deference in reg_device_remove()
Date: Tue, 24 Mar 2009 21:21:08 -0400
Message-Id: <1237944068-3682-2-git-send-email-lrodriguez@atheros.com> (sfid-20090325_022118_865117_2D496177)
In-Reply-To: <1237944068-3682-1-git-send-email-lrodriguez@atheros.com>
References: <1237944068-3682-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We won't ever get here as regulatory_hint_core() can only fail
on -ENOMEM and in that case we don't initialize cfg80211 but this is
technically correct code.

This is actually good for stable, where we don't check for -ENOMEM
failure on __regulatory_hint()'s failure.

Cc: stable@kernel.org
Reported-by: Quentin Armitage <Quentin@armitage.org.uk>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6327e16..6c1993d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2095,11 +2095,12 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 /* Caller must hold cfg80211_mutex */
 void reg_device_remove(struct wiphy *wiphy)
 {
-	struct wiphy *request_wiphy;
+	struct wiphy *request_wiphy = NULL;
 
 	assert_cfg80211_lock();
 
-	request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
+	if (last_request)
+		request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
 
 	kfree(wiphy->regd);
 	if (!last_request || !request_wiphy)
-- 
1.6.0.6

