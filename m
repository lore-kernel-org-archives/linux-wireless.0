Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:57049 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbYFMQsr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 12:48:47 -0400
Message-Id: <20080613164803.494173981@localhost> (sfid-20080613_184849_895280_FCCF7CCB)
References: <20080613164445.542630279@localhost>
Date: Fri, 13 Jun 2008 19:44:47 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] mac80211_hwsim: Minor cleanup
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unnecessary '__constant_' prefix and use the atomic version of
ieee80211_iterate_active_interfaces().

Signed-off-by: Jouni Malinen <j@w1.fi>


Index: wireless-testing/drivers/net/wireless/mac80211_hwsim.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c
@@ -121,10 +121,9 @@ static void mac80211_hwsim_monitor_rx(st
 	hdr->hdr.it_version = PKTHDR_RADIOTAP_VERSION;
 	hdr->hdr.it_pad = 0;
 	hdr->hdr.it_len = cpu_to_le16(sizeof(*hdr));
-	hdr->hdr.it_present = __constant_cpu_to_le32(
-	     (1 << IEEE80211_RADIOTAP_FLAGS) |
-	     (1 << IEEE80211_RADIOTAP_RATE) |
-	     (1 << IEEE80211_RADIOTAP_CHANNEL));
+	hdr->hdr.it_present = cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
+					  (1 << IEEE80211_RADIOTAP_RATE) |
+					  (1 << IEEE80211_RADIOTAP_CHANNEL));
 	hdr->rt_flags = 0;
 	hdr->rt_rate = txrate->bitrate / 5;
 	hdr->rt_channel = data->channel->center_freq;
@@ -139,7 +138,7 @@ static void mac80211_hwsim_monitor_rx(st
 	skb_set_mac_header(skb, 0);
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 	skb->pkt_type = PACKET_OTHERHOST;
-	skb->protocol = __constant_htons(ETH_P_802_2);
+	skb->protocol = htons(ETH_P_802_2);
 	memset(skb->cb, 0, sizeof(skb->cb));
 	netif_rx(skb);
 }
@@ -309,7 +308,8 @@ static void mac80211_hwsim_beacon(unsign
 	if (!data->started || !data->radio_enabled)
 		return;
 
-	ieee80211_iterate_active_interfaces(hw, mac80211_hwsim_beacon_tx, hw);
+	ieee80211_iterate_active_interfaces_atomic(
+		hw, mac80211_hwsim_beacon_tx, hw);
 
 	data->beacon_timer.expires = jiffies + data->beacon_int;
 	add_timer(&data->beacon_timer);

--

-- 
Jouni Malinen                                            PGP id EFC895FA
