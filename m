Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44234 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab1AONie (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Jan 2011 08:38:34 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] mac80211: drop non-auth 3-addr data frames when running as a 4-addr station
Date: Sat, 15 Jan 2011 14:38:28 +0100
Message-Id: <1295098708-99081-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When running as a 4-addr station against an AP that has the 4-addr VLAN
interface and the main 3-addr AP interface bridged together, sometimes
frames originating from the station were looping back from the 3-addr AP
interface, causing the bridge code to emit warnings about receiving frames
with its own source address.
I'm not sure why this is happening yet, but I think it's a good idea to
drop all frames (except 802.1x/EAP frames) that do not match the configured
addressing mode, including 4-address frames sent to a 3-address station.
User test reports indicate that the problem goes away with this patch.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rx.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a6701ed..54e3108 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1561,9 +1561,13 @@ __ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN && !sdata->u.vlan.sta)
 		return -1;
 
+	if (!ieee80211_802_1x_port_control(rx) &&
+	    sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    !!sdata->u.mgd.use_4addr != !!ieee80211_has_a4(hdr->frame_control))
+		return -1;
+
 	if (is_multicast_ether_addr(hdr->addr1) &&
-	    ((sdata->vif.type == NL80211_IFTYPE_AP_VLAN && sdata->u.vlan.sta) ||
-	     (sdata->vif.type == NL80211_IFTYPE_STATION && sdata->u.mgd.use_4addr)))
+	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN && sdata->u.vlan.sta)
 		return -1;
 
 	return ieee80211_data_to_8023(rx->skb, sdata->vif.addr, sdata->vif.type);
-- 
1.7.3.2

