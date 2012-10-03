Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60120 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965457Ab2JCRwQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 13:52:16 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	mcgrof@qca.qualcomm.com
Subject: [PATCH 3.7 1/2] cfg80211: fix antenna gain handling
Date: Wed,  3 Oct 2012 19:51:46 +0200
Message-Id: <1349286707-64433-1-git-send-email-nbd@openwrt.org> (sfid-20121003_195336_691696_58D9AE39)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When not intersecting, orig->chan_mag is initialized to zero. Because of
that, the regulatory antenna gain limit never gets set.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@vger.kernel.org
---
 net/wireless/reg.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3b8cbbc..1a16f19 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -915,8 +915,7 @@ static void handle_channel(struct wiphy *wiphy,
 
 	chan->beacon_found = false;
 	chan->flags = flags | bw_flags | map_regdom_flags(reg_rule->flags);
-	chan->max_antenna_gain = min(chan->orig_mag,
-		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
+	chan->max_antenna_gain = (int) MBI_TO_DBI(power_rule->max_antenna_gain);
 	chan->max_reg_power = (int) MBM_TO_DBM(power_rule->max_eirp);
 	if (chan->orig_mpwr) {
 		/*
-- 
1.7.9.6 (Apple Git-31.1)

