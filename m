Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46288 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653Ab0IHXep (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 19:34:45 -0400
Received: by pvg2 with SMTP id 2so255484pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 16:34:45 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	Steve deRosier <steve@cozybit.com>
Subject: [PATCH 1/2] libertas_tf: Fixed mesh mode to get mesh established
Date: Wed,  8 Sep 2010 16:34:31 -0700
Message-Id: <1283988872-44843-2-git-send-email-steve@cozybit.com>
In-Reply-To: <1283988872-44843-1-git-send-email-steve@cozybit.com>
References: <1283988872-44843-1-git-send-email-steve@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Along with some firmware changes, slight adjustments were needed
the driver to get mesh beacons through the firmware in mesh mode.

Signed-off-by: Steve deRosier <steve@cozybit.com>
---
 drivers/net/wireless/libertas_tf/main.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index 0b03fd5..647d195 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -428,6 +428,7 @@ static int lbtf_op_add_interface(struct ieee80211_hw *hw,
 	switch (vif->type) {
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_ADHOC:
 		lbtf_set_mode(priv, LBTF_AP_MODE);
 		break;
 	case NL80211_IFTYPE_STATION:
@@ -485,6 +486,7 @@ static u64 lbtf_op_prepare_multicast(struct ieee80211_hw *hw,
 	int i;
 	struct netdev_hw_addr *ha;
 	int mc_count = netdev_hw_addr_list_count(mc_list);
+	lbtf_deb_enter(LBTF_DEB_MACOPS);
 
 	if (!mc_count || mc_count > MRVDRV_MAX_MULTICAST_LIST_SIZE)
 		return mc_count;
@@ -494,6 +496,7 @@ static u64 lbtf_op_prepare_multicast(struct ieee80211_hw *hw,
 	netdev_hw_addr_list_for_each(ha, mc_list)
 		memcpy(&priv->multicastlist[i++], ha->addr, ETH_ALEN);
 
+	lbtf_deb_leave_args(LBTF_DEB_MACOPS, "count: %d", mc_count);
 	return mc_count;
 }
 
@@ -512,10 +515,13 @@ static void lbtf_op_configure_filter(struct ieee80211_hw *hw,
 	*new_flags &= SUPPORTED_FIF_FLAGS;
 
 	if (!changed_flags) {
+		lbtf_deb_macops("no flags changed");
 		lbtf_deb_leave(LBTF_DEB_MACOPS);
 		return;
 	}
 
+	lbtf_deb_macops("New flags 0x%x", *new_flags);
+
 	if (*new_flags & (FIF_PROMISC_IN_BSS))
 		priv->mac_control |= CMD_ACT_MAC_PROMISCUOUS_ENABLE;
 	else
@@ -566,7 +572,6 @@ static void lbtf_op_bss_info_changed(struct ieee80211_hw *hw,
 				kfree_skb(beacon);
 				priv->beacon_enable = bss_conf->enable_beacon;
 				priv->beacon_int = bss_conf->beacon_int;
-				lbtf_set_bssid(priv, 1, bss_conf->bssid);
 				lbtf_beacon_ctrl(priv, bss_conf->enable_beacon,
 						 bss_conf->beacon_int);
 			}
-- 
1.7.0

