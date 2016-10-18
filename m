Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54817 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932620AbcJRI3G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 04:29:06 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        b43-dev@lists.infradead.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        ath9k-devel@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wireless: deprecate WDS and disable by default
Date: Tue, 18 Oct 2016 10:28:57 +0200
Message-Id: <1476779337-3520-1-git-send-email-johannes@sipsolutions.net> (sfid-20161018_102912_182287_E2A37904)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The old WDS 4-addr frame support is very limited, e.g.
 * no encryption is possible on such links
 * it cannot support rate/HT/VHT negotiation
 * management APIs are very restricted

These make the WDS legacy mode useless in practice.

All of these are resolved by the 4-addr AP/client support,
so there's also no reason to improve WDS in the future.

Therefore, add a Kconfig option to disable legacy WDS.
This gives people an "emergency valve" while they migrate
to the better-supported 4-addr AP/client option; we plan
to remove it (and the associated cfg80211/mac80211 code,
which is the ultimate goal) in the future.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/Kconfig                   | 13 +++++++++++++
 drivers/net/wireless/ath/ath9k/init.c          |  6 ++++++
 drivers/net/wireless/broadcom/b43/main.c       |  2 ++
 drivers/net/wireless/broadcom/b43legacy/main.c |  2 ++
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c |  6 ++++--
 net/wireless/core.c                            | 10 ++++++++++
 6 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 8c8edaf1bba6..fa9c4fa9477e 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -17,6 +17,19 @@ menuconfig WLAN
 
 if WLAN
 
+config WIRELESS_WDS
+	bool "mac80211-based legacy WDS support"
+	help
+	  This option enables the deprecated WDS support, the newer
+	  mac80211-based 4-addr AP/client support supersedes it with
+	  a much better feature set (HT, VHT, ...)
+
+	  We plan to remove this option and code, so if you find
+	  that you have to enable it, please let us know on the
+	  linux-wireless@vger.kernel.org mailing list, so we can
+	  help you migrate to 4-addr AP/client (or, if it's really
+	  necessary, give up on our plan of removing it).
+
 source "drivers/net/wireless/admtek/Kconfig"
 source "drivers/net/wireless/ath/Kconfig"
 source "drivers/net/wireless/atmel/Kconfig"
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index cfa3fe82ade3..368d9b313823 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -734,9 +734,11 @@ static const struct ieee80211_iface_limit if_limits[] = {
 				 BIT(NL80211_IFTYPE_P2P_GO) },
 };
 
+#ifdef CONFIG_WIRELESS_WDS
 static const struct ieee80211_iface_limit wds_limits[] = {
 	{ .max = 2048,	.types = BIT(NL80211_IFTYPE_WDS) },
 };
+#endif
 
 #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
 
@@ -774,6 +776,7 @@ static const struct ieee80211_iface_combination if_comb[] = {
 					BIT(NL80211_CHAN_WIDTH_40),
 #endif
 	},
+#ifdef CONFIG_WIRELESS_WDS
 	{
 		.limits = wds_limits,
 		.n_limits = ARRAY_SIZE(wds_limits),
@@ -781,6 +784,7 @@ static const struct ieee80211_iface_combination if_comb[] = {
 		.num_different_channels = 1,
 		.beacon_int_infra_match = true,
 	},
+#endif
 };
 
 #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
@@ -851,7 +855,9 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 			BIT(NL80211_IFTYPE_STATION) |
 			BIT(NL80211_IFTYPE_ADHOC) |
 			BIT(NL80211_IFTYPE_MESH_POINT) |
+#ifdef CONFIG_WIRELESS_WDS
 			BIT(NL80211_IFTYPE_WDS) |
+#endif
 			BIT(NL80211_IFTYPE_OCB);
 
 		if (ath9k_is_chanctx_enabled())
diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
index 6e5d9095b195..52f3541ecbcf 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -5591,7 +5591,9 @@ static struct b43_wl *b43_wireless_init(struct b43_bus_dev *dev)
 		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_MESH_POINT) |
 		BIT(NL80211_IFTYPE_STATION) |
+#ifdef CONFIG_WIRELESS_WDS
 		BIT(NL80211_IFTYPE_WDS) |
+#endif
 		BIT(NL80211_IFTYPE_ADHOC);
 
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
index 83770d2ea057..e97ab2b91663 100644
--- a/drivers/net/wireless/broadcom/b43legacy/main.c
+++ b/drivers/net/wireless/broadcom/b43legacy/main.c
@@ -3838,7 +3838,9 @@ static int b43legacy_wireless_init(struct ssb_device *dev)
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_STATION) |
+#ifdef CONFIG_WIRELESS_WDS
 		BIT(NL80211_IFTYPE_WDS) |
+#endif
 		BIT(NL80211_IFTYPE_ADHOC);
 	hw->queues = 1; /* FIXME: hardware has more queues */
 	hw->max_rates = 2;
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 4e0c5653054b..236f790e097a 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -1362,11 +1362,13 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	if (rt2x00dev->bcn->limit > 0)
 		rt2x00dev->hw->wiphy->interface_modes |=
 		    BIT(NL80211_IFTYPE_ADHOC) |
-		    BIT(NL80211_IFTYPE_AP) |
 #ifdef CONFIG_MAC80211_MESH
 		    BIT(NL80211_IFTYPE_MESH_POINT) |
 #endif
-		    BIT(NL80211_IFTYPE_WDS);
+#ifdef CONFIG_WIRELESS_WDS
+		    BIT(NL80211_IFTYPE_WDS) |
+#endif
+		    BIT(NL80211_IFTYPE_AP);
 
 	rt2x00dev->hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 8201e6d7449e..f433f15f9222 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -571,6 +571,11 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 				return -EINVAL;
 		}
 
+#ifndef CONFIG_WIRELESS_WDS
+		if (WARN_ON(all_iftypes & BIT(NL80211_IFTYPE_WDS)))
+			return -EINVAL;
+#endif
+
 		/* You can't even choose that many! */
 		if (WARN_ON(cnt < c->max_interfaces))
 			return -EINVAL;
@@ -609,6 +614,11 @@ int wiphy_register(struct wiphy *wiphy)
 		     !rdev->ops->add_nan_func || !rdev->ops->del_nan_func)))
 		return -EINVAL;
 
+#ifndef CONFIG_WIRELESS_WDS
+	if (WARN_ON(wiphy->interface_modes & BIT(NL80211_IFTYPE_WDS)))
+		return -EINVAL;
+#endif
+
 	/*
 	 * if a wiphy has unsupported modes for regulatory channel enforcement,
 	 * opt-out of enforcement checking
-- 
2.8.1
