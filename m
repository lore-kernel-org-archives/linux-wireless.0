Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49037 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbZBTGFJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 01:05:09 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	marcel@holtmann.org, kalle.valo@nokia.com, kyle@mcmartin.ca
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/5] cfg80211: enable active-scan / beaconing on Ch 1-11 for world regdom
Date: Fri, 20 Feb 2009 01:04:30 -0500
Message-Id: <1235109874-3966-2-git-send-email-lrodriguez@atheros.com> (sfid-20090220_070524_602206_25A2A1B7)
In-Reply-To: <1235109874-3966-1-git-send-email-lrodriguez@atheros.com>
References: <1235109874-3966-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This enables active scan and beaconing on Channels 1 through 11
on the static world regulatory domain.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 605299f..8f64575 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -76,9 +76,8 @@ static const struct ieee80211_regdomain world_regdom = {
 	.n_reg_rules = 1,
 	.alpha2 =  "00",
 	.reg_rules = {
-		REG_RULE(2412-10, 2462+10, 40, 6, 20,
-			NL80211_RRF_PASSIVE_SCAN |
-			NL80211_RRF_NO_IBSS),
+		/* IEEE 802.11b/g, channels 1..11 */
+		REG_RULE(2412-10, 2462+10, 40, 6, 20, 0),
 	}
 };
 
-- 
1.6.0.3

