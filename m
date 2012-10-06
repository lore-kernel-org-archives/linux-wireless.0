Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46405 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805Ab2JFMlE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2012 08:41:04 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	johannes@sipsolutions.net, arend@broadcom.com
Subject: [PATCH v2 3.7 2/2] cfg80211: fix initialization of chan->max_reg_power
Date: Sat,  6 Oct 2012 14:40:54 +0200
Message-Id: <1349527254-41080-2-git-send-email-nbd@openwrt.org> (sfid-20121006_144110_985192_FFF48A78)
In-Reply-To: <1349527254-41080-1-git-send-email-nbd@openwrt.org>
References: <1349527254-41080-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few places touch chan->max_power based on updated tx power rules, but
forget to do the same to chan->max_reg_power.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@vger.kernel.org
---
 net/wireless/reg.c |    5 +++--
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
1.7.9.6 (Apple Git-31.1)

