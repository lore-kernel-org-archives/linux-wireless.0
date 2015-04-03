Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34621 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbbDCVNQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2015 17:13:16 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/4] mac80211-hwsim: remove dmesg spam about get-survey.
Date: Fri,  3 Apr 2015 14:13:08 -0700
Message-Id: <1428095590-600-2-git-send-email-greearb@candelatech.com> (sfid-20150403_231320_379910_6088EF09)
In-Reply-To: <1428095590-600-1-git-send-email-greearb@candelatech.com>
References: <1428095590-600-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This message just fills up dmesg and/or kernel logs and does
not provide any useful information.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index d0e88b2..5089169 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1696,7 +1696,7 @@ static int mac80211_hwsim_get_survey(
 {
 	struct ieee80211_conf *conf = &hw->conf;
 
-	wiphy_debug(hw->wiphy, "%s (idx=%d)\n", __func__, idx);
+	/* wiphy_debug(hw->wiphy, "%s (idx=%d)\n", __func__, idx); */
 
 	if (idx != 0)
 		return -ENOENT;
-- 
1.7.11.7

