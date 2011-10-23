Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:50540 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751538Ab1JWTpm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Oct 2011 15:45:42 -0400
Date: Sun, 23 Oct 2011 22:45:27 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211_hwsim: Claim support for TDLS
Message-ID: <20111023194527.GA18416@jm.kir.nu> (sfid-20111023_214545_961355_F1637FF6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jouni Malinen <j@w1.fi>
---
 drivers/net/wireless/mac80211_hwsim.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

Note: Before even thinking of testing this, please take a look at the
RFC patch for handling supported rates configuration unless you want to
crash and burn your kernel.. Anyway, it is useful to get hwsim ready for
TDLS testing and the mac80211 issue is not specific to hwsim and people
who use hwsim are normally capable of patching kernel and familiar with
this mailing list in the first place.. ;-)

With the RFC "mac80211: Fix STA supported rate configuration with dummy
entry" patch in place, I was able to get the TDLS link running in
mac80211_hwsim environment between two WPA2 stations.


diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 68455a2..477100d 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1747,6 +1747,8 @@ static int __init init_mac80211_hwsim(void)
 			    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
 			    IEEE80211_HW_AMPDU_AGGREGATION;
 
+		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
+
 		/* ask mac80211 to reserve space for magic */
 		hw->vif_data_size = sizeof(struct hwsim_vif_priv);
 		hw->sta_data_size = sizeof(struct hwsim_sta_priv);
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
