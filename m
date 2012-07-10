Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26001 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab2GJRYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 13:24:44 -0400
Cc: <linux-wireless@vger.kernel.org>, <kvalo@qca.qualcomm.com>,
	<arend@broadcom.com>, <henry@logout.com>,
	<senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <johannes@sipsolutions.net>, <linville@tuxdriver.com>
Subject: [PATCH v4 5/5] cfg80211: remove regulatory_update()
Date: Tue, 10 Jul 2012 10:23:11 -0700
Message-ID: <1341940991-11234-6-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120710_192447_013697_71D83DA7)
In-Reply-To: <1341940991-11234-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1341940991-11234-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>

regulatory_update() just calls wiphy_update_regulatory().
wiphy_update_regulatory() assumes you already have
the reg_mutex held so just move the call within locking
context and kill the superfluous regulatory_update().

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 net/wireless/reg.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b0a09b2..6d57e18 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1232,14 +1232,6 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 		wiphy->reg_notifier(wiphy, last_request);
 }
 
-static void regulatory_update(struct wiphy *wiphy,
-			      enum nl80211_reg_initiator setby)
-{
-	mutex_lock(&reg_mutex);
-	wiphy_update_regulatory(wiphy, setby);
-	mutex_unlock(&reg_mutex);
-}
-
 static void update_all_wiphy_regulatory(enum nl80211_reg_initiator initiator)
 {
 	struct cfg80211_registered_device *rdev;
@@ -2384,9 +2376,9 @@ void wiphy_regulatory_register(struct wiphy *wiphy)
 	if (!reg_dev_ignore_cell_hint(wiphy))
 		reg_num_devs_support_basehint++;
 
-	mutex_unlock(&reg_mutex);
+	wiphy_update_regulatory(wiphy, NL80211_REGDOM_SET_BY_CORE);
 
-	regulatory_update(wiphy, NL80211_REGDOM_SET_BY_CORE);
+	mutex_unlock(&reg_mutex);
 }
 
 /* Caller must hold cfg80211_mutex */
-- 
1.7.10.rc1.22.gf5241

