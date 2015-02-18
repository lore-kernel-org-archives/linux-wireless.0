Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34158 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbbBRAM1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2015 19:12:27 -0500
Received: by pabrd3 with SMTP id rd3so10165233pab.1
        for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2015 16:12:27 -0800 (PST)
From: Jason Abele <jason.abele@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] cfg80211: fix n_reg_rules to match world_regdom
Date: Tue, 17 Feb 2015 16:10:41 -0800
Message-Id: <1424218241-15747-1-git-send-email-jason.abele@gmail.com> (sfid-20150218_011230_998311_72EDD8BA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jason Abele <jason@aether.com>

There are currently 8 rules in the world_regdom, but only the first 6
are applied due to an incorrect value for n_reg_rules.  This causes
channels 149-165 and 60GHz to be disabled.

Signed-off-by: Jason Abele <jason@aether.com>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index d39d1cb..277be15 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -228,7 +228,7 @@ static DECLARE_DELAYED_WORK(reg_timeout, reg_timeout_work);
 
 /* We keep a static world regulatory domain in case of the absence of CRDA */
 static const struct ieee80211_regdomain world_regdom = {
-	.n_reg_rules = 6,
+	.n_reg_rules = 8,
 	.alpha2 =  "00",
 	.reg_rules = {
 		/* IEEE 802.11b/g, channels 1..11 */
-- 
1.9.1

