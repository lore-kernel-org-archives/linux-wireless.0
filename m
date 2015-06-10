Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35425 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbbFJFKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 01:10:51 -0400
Received: by wiga1 with SMTP id a1so35700174wig.0
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2015 22:10:50 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, nbd@openwrt.org, sujith@msujith.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC] ath9k: advertise p2p dev support when chanctx
Date: Wed, 10 Jun 2015 07:10:34 +0200
Message-Id: <1433913034-17801-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150610_071054_892118_EE176763)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add p2p dev support when ath9k loaded with
use_chanctx=1. This will fix problem, when first
interface is an AP and next we would like to run
p2p_find. Before p2p scan failed.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
@Felix, Sujith please review. I am not sure if didn't miss some
case for NL80211_IFTYPE_P2P_DEVICE (special handling required?).

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

