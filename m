Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:40177 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab2GLSts (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 14:49:48 -0400
Received: by ghrr11 with SMTP id r11so2767419ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jul 2012 11:49:48 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH v5 5/5] cfg80211: remove regulatory_update()
Date: Thu, 12 Jul 2012 11:49:21 -0700
Message-Id: <1342118961-13008-6-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20120712_204951_602849_7926B7FD)
In-Reply-To: <1342118961-13008-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1342118961-13008-1-git-send-email-mcgrof@qca.qualcomm.com>
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

