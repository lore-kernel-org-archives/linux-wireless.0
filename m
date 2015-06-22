Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:36728 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609AbbFVLng (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 07:43:36 -0400
Received: by lbbpo10 with SMTP id po10so7255616lbb.3
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 04:43:35 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, nbd@openwrt.org, sujith@msujith.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 3/3] ath9k: advertise p2p dev support when chanctx
Date: Mon, 22 Jun 2015 13:43:05 +0200
Message-Id: <1434973385-15865-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150622_134341_754859_C3B9B5AE)
In-Reply-To: <1434973385-15865-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1434973385-15865-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Advertise p2p device support when ath9k loaded with
use_chanctx=1.

This will fix problem, when first interface is an AP
and next we would like to run p2p_find.
Before p2p find (scan phase) failed with EOPNOTSUPP.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index f8d11ef..7da1a17 100644
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
@@ -855,6 +856,9 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 			BIT(NL80211_IFTYPE_MESH_POINT) |
 			BIT(NL80211_IFTYPE_WDS);
 
+		if (ath9k_is_chanctx_enabled())
+			hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_P2P_DEVICE);
+
 			hw->wiphy->iface_combinations = if_comb;
 			hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
 	}
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
