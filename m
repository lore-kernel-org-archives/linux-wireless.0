Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26001 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab2GJRYj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 13:24:39 -0400
Cc: <linux-wireless@vger.kernel.org>, <kvalo@qca.qualcomm.com>,
	<arend@broadcom.com>, <henry@logout.com>,
	<senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <johannes@sipsolutions.net>, <linville@tuxdriver.com>
Subject: [PATCH v4 4/5] cfg80211: make regulatory_update() static
Date: Tue, 10 Jul 2012 10:23:10 -0700
Message-ID: <1341940991-11234-5-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120710_192441_782289_ED5485CE)
In-Reply-To: <1341940991-11234-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1341940991-11234-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>

Now that we have wiphy_regulatory_register() we can
tuck away the core's regulatory_update() call there
and make it static.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 net/wireless/core.c |    1 -
 net/wireless/reg.c  |    6 ++++--
 net/wireless/reg.h  |    1 -
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5b4463e..b7dc646 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -538,7 +538,6 @@ int wiphy_register(struct wiphy *wiphy)
 
 	/* set up regulatory info */
 	wiphy_regulatory_register(wiphy);
-	regulatory_update(wiphy, NL80211_REGDOM_SET_BY_CORE);
 
 	list_add_rcu(&rdev->list, &cfg80211_rdev_list);
 	cfg80211_rdev_list_generation++;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 43b7750..b0a09b2 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1232,8 +1232,8 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 		wiphy->reg_notifier(wiphy, last_request);
 }
 
-void regulatory_update(struct wiphy *wiphy,
-		       enum nl80211_reg_initiator setby)
+static void regulatory_update(struct wiphy *wiphy,
+			      enum nl80211_reg_initiator setby)
 {
 	mutex_lock(&reg_mutex);
 	wiphy_update_regulatory(wiphy, setby);
@@ -2385,6 +2385,8 @@ void wiphy_regulatory_register(struct wiphy *wiphy)
 		reg_num_devs_support_basehint++;
 
 	mutex_unlock(&reg_mutex);
+
+	regulatory_update(wiphy, NL80211_REGDOM_SET_BY_CORE);
 }
 
 /* Caller must hold cfg80211_mutex */
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index f36b15f..f023c8a 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -34,7 +34,6 @@ void regulatory_exit(void);
 
 int set_regdom(const struct ieee80211_regdomain *rd);
 
-void regulatory_update(struct wiphy *wiphy, enum nl80211_reg_initiator setby);
 bool reg_last_request_cell_base(void);
 
 /**
-- 
1.7.10.rc1.22.gf5241

