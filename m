Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40168 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750928AbdGYIZf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 04:25:35 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, andrei.otcheretianski@intel.com,
        Beni Lev <beni.lev@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Jul 2017 11:25:25 +0300
Message-Id: <20170725082525.10839-1-luca@coelho.fi> (sfid-20170725_102539_613658_6484CEB8)
Subject: [PATCH] mac80211_hwsim: Use proper TX power
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Beni Lev <beni.lev@intel.com>

In struct ieee80211_tx_info, control.vif pointer and rate_driver_data[0]
falls on the same place, depending on the union usage.
During the whole TX process, the union is referred to as a control struct,
which holds the vif that is later used in the tx flow, especially in order
to derive the used tx power.
Referring direcly to rate_driver_data[0] and assigning a value to it,
overwrites the vif pointer, hence making all later references irrelevant.
Moreover, rate_driver_data[0] isn't used later in the flow in order to
retrieve the channel that it is pointing to.

Signed-off-by: Beni Lev <beni.lev@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index c8852acc1462..6467ffac9811 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1362,8 +1362,6 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 				       txi->control.rates,
 				       ARRAY_SIZE(txi->control.rates));
 
-	txi->rate_driver_data[0] = channel;
-
 	if (skb->len >= 24 + 8 &&
 	    ieee80211_is_probe_resp(hdr->frame_control)) {
 		/* fake header transmission time */
-- 
2.13.2
