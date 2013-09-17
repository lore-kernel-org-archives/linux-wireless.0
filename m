Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50424 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab3IQJPu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 05:15:50 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 3.12] mac80211: drop spoofed packets in ad-hoc mode
Date: Tue, 17 Sep 2013 11:15:43 +0200
Message-Id: <1379409343-38116-1-git-send-email-nbd@openwrt.org> (sfid-20130917_111556_255674_9702E919)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If an Ad-Hoc node receives packets with the Cell ID or its own MAC
address as source address, it hits a WARN_ON in sta_info_insert_check()
With many packets, this can massively spam the logs. One way that this
can easily happen is through having Cisco APs in the area with rouge AP
detection and countermeasures enabled.
Such Cisco APs will regularly send fake beacons, disassoc and deauth
packets that trigger these warnings.

To fix this issue, drop such spoofed packets early in the rx path.

Cc: stable@vger.kernel.org
Reported-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 54395d7..674eac1 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3056,6 +3056,9 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 	case NL80211_IFTYPE_ADHOC:
 		if (!bssid)
 			return 0;
+		if (ether_addr_equal(sdata->vif.addr, hdr->addr2) ||
+		    ether_addr_equal(sdata->u.ibss.bssid, hdr->addr2))
+			return 0;
 		if (ieee80211_is_beacon(hdr->frame_control)) {
 			return 1;
 		} else if (!ieee80211_bssid_match(bssid, sdata->u.ibss.bssid)) {
-- 
1.8.0.2

