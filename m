Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54061 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbZBUFUr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 00:20:47 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 1/5] cfg80211: enable active-scan / beaconing on Ch 1-11 for world regdom
Date: Sat, 21 Feb 2009 00:20:37 -0500
Message-Id: <1235193641-17993-2-git-send-email-lrodriguez@atheros.com> (sfid-20090221_062055_695172_8E64A188)
In-Reply-To: <1235193641-17993-1-git-send-email-lrodriguez@atheros.com>
References: <1235193641-17993-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This enables active scan and beaconing on Channels 1 through 11
on the static world regulatory domain.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3bd2ea2..85c2c31 100644
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

