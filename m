Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39623 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756168Ab1DLRPv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 13:15:51 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH v2] mac80211: receive EAP frames from a station in an AP VLAN on the main AP
Date: Tue, 12 Apr 2011 19:15:22 +0200
Message-Id: <1302628522-65573-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1302196736-30656-1-git-send-email-nbd@openwrt.org>
References: <1302196736-30656-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it easier to handle moving stations to VLAN interfaces that are
part of a different bridge.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rx.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index fc2ff78..92f261a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1585,7 +1585,7 @@ ieee80211_drop_unencrypted_mgmt(struct ieee80211_rx_data *rx)
 }
 
 static int
-__ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
+__ieee80211_data_to_8023(struct ieee80211_rx_data *rx, bool *port_control)
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
@@ -1593,6 +1593,7 @@ __ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 	struct ethhdr *ehdr;
 	int ret;
 
+	*port_control = false;
 	if (ieee80211_has_a4(hdr->frame_control) &&
 	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN && !sdata->u.vlan.sta)
 		return -1;
@@ -1611,11 +1612,13 @@ __ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 		return -1;
 
 	ret = ieee80211_data_to_8023(rx->skb, sdata->vif.addr, sdata->vif.type);
-	if (ret < 0 || !check_port_control)
+	if (ret < 0)
 		return ret;
 
 	ehdr = (struct ethhdr *) rx->skb->data;
-	if (ehdr->h_proto != rx->sdata->control_port_protocol)
+	if (ehdr->h_proto == rx->sdata->control_port_protocol)
+		*port_control = true;
+	else if (check_port_control)
 		return -1;
 
 	return 0;
@@ -1916,6 +1919,7 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 	struct net_device *dev = sdata->dev;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	__le16 fc = hdr->frame_control;
+	bool port_control;
 	int err;
 
 	if (unlikely(!ieee80211_is_data(hdr->frame_control)))
@@ -1932,13 +1936,21 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 	    sdata->vif.type == NL80211_IFTYPE_AP)
 		return RX_DROP_MONITOR;
 
-	err = __ieee80211_data_to_8023(rx);
+	err = __ieee80211_data_to_8023(rx, &port_control);
 	if (unlikely(err))
 		return RX_DROP_UNUSABLE;
 
 	if (!ieee80211_frame_allowed(rx, fc))
 		return RX_DROP_MONITOR;
 
+	if (rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+	    unlikely(port_control) && sdata->bss) {
+		sdata = container_of(sdata->bss, struct ieee80211_sub_if_data,
+				     u.ap);
+		dev = sdata->dev;
+		rx->sdata = sdata;
+	}
+
 	rx->skb->dev = dev;
 
 	dev->stats.rx_packets++;
-- 
1.7.3.2

