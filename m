Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:44455 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbbCZTrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 15:47:15 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: linux-wireless@vger.kernel.org
Cc: projekt-wlan@fem.tu-ilmenau.de,
	Michael Braun <michael-dev@fami-braun.de>
Subject: [RFC] mac80211: check A-MSDU inner frame source address on AP interfaces.
Date: Thu, 26 Mar 2015 20:40:23 +0100
Message-Id: <1427398823-30321-1-git-send-email-michael-dev@fami-braun.de> (sfid-20150326_204718_452345_B3C0C9FE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using WPA security, the station and thus the required key is
identified by its mac address when packets are received. So a
station usually cannot spoof its source mac address.

But when a station sends an A-MSDU frame, port control and crypto
is done using the outer mac address, while the packets delivered
and forwarded use the inner mac address.

IEEE 802.11-2012 mandates that the outer source mac address should
match the inner source address (section 8.3.2.2). For the
destination mac address, matching is not required (section 10.23.15).

So I was wondering whether some checking would be useful?

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 net/mac80211/rx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 944bdc0..e34e0b2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2023,6 +2023,12 @@ static bool ieee80211_frame_allowed(struct ieee80211_rx_data *rx, __le16 fc)
 	     ether_addr_equal(ehdr->h_dest, pae_group_addr)))
 		return true;
 
+	/* Do not allow source MAC spoofing */
+	if (rx->sdata && (rx->sdata->vif.type == NL80211_IFTYPE_AP ||
+	    rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
+	    rx->sta && !ether_addr_equal(ehdr->h_source, rx->sta->sta.addr))
+		return false;
+
 	if (ieee80211_802_1x_port_control(rx) ||
 	    ieee80211_drop_unencrypted(rx, fc))
 		return false;
-- 
1.9.1

