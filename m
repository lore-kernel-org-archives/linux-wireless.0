Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37304 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdB1EdD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 23:33:03 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 2/4] mac80211-hwsim: remove dmesg spam about get-survey.
Date: Mon, 27 Feb 2017 13:56:30 -0800
Message-Id: <1488232593-2552-1-git-send-email-greearb@candelatech.com> (sfid-20170228_053305_459096_431BA062)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This message just fills up dmesg and/or kernel logs and does
not provide any useful information.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 12e9333..635ad03 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1860,8 +1860,6 @@ static int mac80211_hwsim_get_survey(
 {
 	struct ieee80211_conf *conf = &hw->conf;
 
-	wiphy_debug(hw->wiphy, "%s (idx=%d)\n", __func__, idx);
-
 	if (idx != 0)
 		return -ENOENT;
 
-- 
2.4.11
