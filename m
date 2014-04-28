Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46057 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbaD1IWv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2014 04:22:51 -0400
Date: Mon, 28 Apr 2014 11:22:46 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] mac80211_hwsim: Advertise support for AP mode channel
 width changes
Message-ID: <20140428082246.GA15478@jouni.qca.qualcomm.com> (sfid-20140428_102257_085384_91256420)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 takes care of all the needed steps for hwsim, so indicate
support for this capability.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 9d7a52f..a23c8d6 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2056,6 +2056,7 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 			    WIPHY_FLAG_AP_UAPSD |
 			    WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 	hw->wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
+	hw->wiphy->features |= NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE;
 
 	/* ask mac80211 to reserve space for magic */
 	hw->vif_data_size = sizeof(struct hwsim_vif_priv);
-- 
1.7.9.5


-- 
Jouni Malinen                                            PGP id EFC895FA
