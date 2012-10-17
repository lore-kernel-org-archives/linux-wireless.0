Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42522 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756723Ab2JQL4f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2012 07:56:35 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	mcgrof@qca.qualcomm.com
Subject: [PATCH v3 3.7 2/2] cfg80211: fix initialization of chan->max_reg_power
Date: Wed, 17 Oct 2012 13:56:20 +0200
Message-Id: <1350474980-59623-2-git-send-email-nbd@openwrt.org> (sfid-20121017_135642_546894_B59A2C6D)
In-Reply-To: <1350474980-59623-1-git-send-email-nbd@openwrt.org>
References: <1350474980-59623-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few places touch chan->max_power based on updated tx power rules, but
forget to do the same to chan->max_reg_power.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/wireless/reg.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3b8cbbc..bcc7d7e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -908,7 +908,7 @@ static void handle_channel(struct wiphy *wiphy,
 			map_regdom_flags(reg_rule->flags) | bw_flags;
 		chan->max_antenna_gain = chan->orig_mag =
 			(int) MBI_TO_DBI(power_rule->max_antenna_gain);
-		chan->max_power = chan->orig_mpwr =
+		chan->max_reg_power = chan->max_power = chan->orig_mpwr =
 			(int) MBM_TO_DBM(power_rule->max_eirp);
 		return;
 	}
@@ -1331,7 +1331,8 @@ static void handle_channel_custom(struct wiphy *wiphy,
 
 	chan->flags |= map_regdom_flags(reg_rule->flags) | bw_flags;
 	chan->max_antenna_gain = (int) MBI_TO_DBI(power_rule->max_antenna_gain);
-	chan->max_power = (int) MBM_TO_DBM(power_rule->max_eirp);
+	chan->max_reg_power = chan->max_power =
+		(int) MBM_TO_DBM(power_rule->max_eirp);
 }
 
 static void handle_band_custom(struct wiphy *wiphy, enum ieee80211_band band,
-- 
1.7.12.2

