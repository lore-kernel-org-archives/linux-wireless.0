Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:35815 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752189AbdDEW1C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 18:27:02 -0400
Received: by mail-pg0-f53.google.com with SMTP id 81so17190642pgh.2
        for <linux-wireless@vger.kernel.org>; Wed, 05 Apr 2017 15:27:02 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Cc: <linux-kernel@vger.kernel.org>, Kalle Valo <kvalo@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH] mwifiex: MAC randomization should not be persistent
Date: Wed,  5 Apr 2017 15:26:40 -0700
Message-Id: <20170405222640.4494-1-briannorris@chromium.org> (sfid-20170406_002855_349527_E7D6EBC2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

nl80211 provides the NL80211_SCAN_FLAG_RANDOM_ADDR for every scan
request that should be randomized; the absence of such a flag means we
should not randomize. However, mwifiex was stashing the latest
randomization request and *always* using it for future scans, even those
that didn't set the flag.

Let's zero out the randomization info whenever we get a scan request
without NL80211_SCAN_FLAG_RANDOM_ADDR. I'd prefer to remove
priv->random_mac entirely (and plumb the randomization MAC properly
through the call sequence), but the spaghetti is a little difficult to
unravel here for me.

Fixes: c2a8f0ff9c6c ("mwifiex: support random MAC address for scanning")
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
Should this be tagged for -stable?

 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 1e3bd435a694..2d7e8a372bf1 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2528,9 +2528,11 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 			priv->random_mac[i] |= get_random_int() &
 					       ~(request->mac_addr_mask[i]);
 		}
+		ether_addr_copy(user_scan_cfg->random_mac, priv->random_mac);
+	} else {
+		eth_zero_addr(priv->random_mac);
 	}
 
-	ether_addr_copy(user_scan_cfg->random_mac, priv->random_mac);
 	user_scan_cfg->num_ssids = request->n_ssids;
 	user_scan_cfg->ssid_list = request->ssids;
 
-- 
2.12.2.715.g7642488e1d-goog
