Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:36747 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbbGUJMf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 05:12:35 -0400
Received: by lbbqi7 with SMTP id qi7so31047234lbb.3
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2015 02:12:33 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, nbd@openwrt.org, sujith@msujith.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v3 1/4] ath9k: advertise p2p dev support when chanctx
Date: Tue, 21 Jul 2015 11:11:40 +0200
Message-Id: <1437469903-32362-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150721_111238_808219_37EFCB7B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Advertise p2p device support when ath9k loaded with
use_chanctx=1.

This will fix problem, when first interface is an AP
and next we would like to run p2p_find.
Before p2p find (scan phase) failed with EOPNOTSUPP.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index eff0e53..89a457d 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -736,13 +736,14 @@ static const struct ieee80211_iface_limit if_limits_multi[] = {
 				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
 				 BIT(NL80211_IFTYPE_P2P_GO) },
 	{ .max = 1,	.types = BIT(NL80211_IFTYPE_ADHOC) },
+	{ .max = 1,	.types = BIT(NL80211_IFTYPE_P2P_DEVICE) },
 };
 
 static const struct ieee80211_iface_combination if_comb_multi[] = {
 	{
 		.limits = if_limits_multi,
 		.n_limits = ARRAY_SIZE(if_limits_multi),
-		.max_interfaces = 2,
+		.max_interfaces = 3,
 		.num_different_channels = 2,
 		.beacon_int_infra_match = true,
 	},
@@ -855,6 +856,10 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 			BIT(NL80211_IFTYPE_MESH_POINT) |
 			BIT(NL80211_IFTYPE_WDS);
 
+		if (ath9k_is_chanctx_enabled())
+			hw->wiphy->interface_modes |=
+					BIT(NL80211_IFTYPE_P2P_DEVICE);
+
 			hw->wiphy->iface_combinations = if_comb;
 			hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
 	}
-- 
1.9.1

