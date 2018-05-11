Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:39517 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753143AbeEKOzC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 10:55:02 -0400
Received: by mail-pf0-f196.google.com with SMTP id a22-v6so2848857pfn.6
        for <linux-wireless@vger.kernel.org>; Fri, 11 May 2018 07:55:02 -0700 (PDT)
From: Sushant Kumar Mishra <sushant2k1513@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
Subject: [PATCH 3/3] rsi: Set wowlan flag while writing wowlan config parameters
Date: Fri, 11 May 2018 20:27:53 +0530
Message-Id: <1526050673-7026-4-git-send-email-sushant2k1513@gmail.com> (sfid-20180511_165505_464368_C3145124)
In-Reply-To: <1526050673-7026-1-git-send-email-sushant2k1513@gmail.com>
References: <1526050673-7026-1-git-send-email-sushant2k1513@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

As wowlan enable flag did not set, while writing wowlan parameters to
card using rsi_send_vap_dynamic_update, which results firmware is unable to
set wowlan configurations. Hence, setting wowlan flag before sending
parameters.

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Signed-off-by: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 743706e..3faa044 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1818,6 +1818,7 @@ int rsi_config_wowlan(struct rsi_hw *adapter, struct cfg80211_wowlan *wowlan)
 		return -EINVAL;
 	}
 
+	common->wow_flags |= RSI_WOW_ENABLED;
 	triggers = rsi_wow_map_triggers(common, wowlan);
 	if (!triggers) {
 		rsi_dbg(ERR_ZONE, "%s:No valid WoW triggers\n", __func__);
@@ -1840,7 +1841,6 @@ int rsi_config_wowlan(struct rsi_hw *adapter, struct cfg80211_wowlan *wowlan)
 
 	rx_filter_word = (ALLOW_DATA_ASSOC_PEER | DISALLOW_BEACONS);
 	rsi_send_rx_filter_frame(common, rx_filter_word);
-	common->wow_flags |= RSI_WOW_ENABLED;
 
 	return 0;
 }
-- 
2.5.5
