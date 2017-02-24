Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58758 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751809AbdBXA3L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 19:29:11 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 161/306] mac80211-hwsim: Improve logging.
Date: Thu, 23 Feb 2017 16:28:28 -0800
Message-Id: <1487896109-23851-6-git-send-email-greearb@candelatech.com> (sfid-20170224_012924_068303_22EAD8CA)
In-Reply-To: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index aaba126..48ddf5d 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1643,7 +1643,7 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (conf->chandef.chan)
 		wiphy_debug(hw->wiphy,
-			    "%s (freq=%d(%d - %d)/%s idle=%d ps=%d smps=%s)\n",
+			    "%s (chandef-chan freq=%d(%d - %d)/%s idle=%d ps=%d smps=%s)\n",
 			    __func__,
 			    conf->chandef.chan->center_freq,
 			    conf->chandef.center_freq1,
@@ -1654,7 +1654,7 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 			    smps_modes[conf->smps_mode]);
 	else
 		wiphy_debug(hw->wiphy,
-			    "%s (freq=0 idle=%d ps=%d smps=%s)\n",
+			    "%s (no-chandef-chan freq=0 idle=%d ps=%d smps=%s)\n",
 			    __func__,
 			    !!(conf->flags & IEEE80211_CONF_IDLE),
 			    !!(conf->flags & IEEE80211_CONF_PS),
@@ -3061,9 +3061,12 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 	/* check if radio is configured properly */
 
 	if (data2->idle || !data2->started) {
-		if (net_ratelimit())
-			printk(KERN_DEBUG " hwsim rx-nl: radio %pM idle: %d or not started: %d\n",
-			       dst, data2->idle, !data2->started);
+		static unsigned int cnt = 0;
+		/* This is fairly common, and usually not a bug.  So, print errors
+		   rarely. */
+		if (((cnt++ & 0x3FF) == 0x3FF) && net_ratelimit())
+			printk(KERN_DEBUG " hwsim rx-nl: radio %pM idle: %d or not started: %d cnt: %d\n",
+			       dst, data2->idle, !data2->started, cnt);
 		goto out;
 	}
 
-- 
2.4.11
