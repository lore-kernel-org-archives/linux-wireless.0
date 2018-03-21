Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:33844 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751825AbeCUKBq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 06:01:46 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] ath9k_htc: use non-QoS NDP for AP probing
Date: Wed, 21 Mar 2018 11:01:43 +0100
Message-Id: <20180321100143.28080-1-johannes@sipsolutions.net> (sfid-20180321_110149_938306_F6A004BC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When switching mac80211 to use QoS NDP, it turned out that
ath9k_htc is somehow broken by this, e.g. see
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=891060.

Fix this by using the new mac80211 flag to go back to the
old, incorrect, behaviour for this driver.

Fixes: 7b6ddeaf27ec ("mac80211: use QoS NDP for AP probing")
Reported-by: Ben Caradoc-Davies <ben@transient.nz>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index e89e5ef2c2a4..f246e9ed4a81 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -729,6 +729,7 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 	ieee80211_hw_set(hw, SPECTRUM_MGMT);
 	ieee80211_hw_set(hw, SIGNAL_DBM);
 	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
+	ieee80211_hw_set(hw, DOESNT_SUPPORT_QOS_NDP);
 
 	if (ath9k_ps_enable)
 		ieee80211_hw_set(hw, SUPPORTS_PS);
-- 
2.15.1
