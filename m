Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:55740 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756329AbdCWX0Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Mar 2017 19:26:25 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 2/4] mac80211-hwsim: remove dmesg spam about get-survey.
Date: Thu, 23 Mar 2017 16:26:16 -0700
Message-Id: <1490311578-18926-2-git-send-email-greearb@candelatech.com> (sfid-20170324_002702_015076_05D3E672)
In-Reply-To: <1490311578-18926-1-git-send-email-greearb@candelatech.com>
References: <1490311578-18926-1-git-send-email-greearb@candelatech.com>
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
index f1ad908..234df8c 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1893,8 +1893,6 @@ static int mac80211_hwsim_get_survey(struct ieee80211_hw *hw, int idx,
 {
 	struct mac80211_hwsim_data *hwsim = hw->priv;
 
-	wiphy_debug(hw->wiphy, "%s (idx=%d)\n", __func__, idx);
-
 	if (idx < 0 || idx >= ARRAY_SIZE(hwsim->survey_data))
 		return -ENOENT;
 
-- 
2.4.11
