Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60013 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab0F2TPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:15:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Holger Schurig <holgerschurig@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: remove unnecessary check in ieee80211_dump_survey
Date: Tue, 29 Jun 2010 15:00:19 -0400
Message-Id: <1277838019-13829-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1274906612.3658.58.camel@jlt3.sipsolutions.net>
References: <1274906612.3658.58.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This check is duplicated in drv_get_survey.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/cfg.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f4efbfa..e55970b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -413,9 +413,6 @@ static int ieee80211_dump_survey(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
-	if (!local->ops->get_survey)
-		return -EOPNOTSUPP;
-
 	return drv_get_survey(local, idx, survey);
 }
 
-- 
1.7.0.1

