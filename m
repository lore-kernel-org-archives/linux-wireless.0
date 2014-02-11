Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50539 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbaBKO40 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 09:56:26 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3.14] mac80211: send control port protocol frames to the VO queue
Date: Tue, 11 Feb 2014 15:56:23 +0100
Message-Id: <1392130583-84601-1-git-send-email-nbd@openwrt.org> (sfid-20140211_155629_826768_3DB83E6D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Improves reliability of wifi connections with WPA, since authentication
frames are prioritized over normal traffic and also typically exempt
from aggregation.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/wme.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 21211c6..2656969 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -107,6 +107,7 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 	const u8 *ra = NULL;
 	bool qos = false;
 	struct mac80211_qos_map *qos_map;
+	struct ethhdr *ehdr = (struct ethhdr *) skb->data;
 
 	if (local->hw.queues < IEEE80211_NUM_ACS || skb->len < 6) {
 		skb->priority = 0; /* required for correct WPA/11i MIC */
@@ -154,6 +155,11 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 		return IEEE80211_AC_BE;
 	}
 
+	if (ehdr->h_proto == sdata->control_port_protocol) {
+		skb->priority = 7;
+		return ieee80211_downgrade_queue(sdata, skb);
+	}
+
 	/* use the data classifier to determine what 802.1d tag the
 	 * data frame has */
 	rcu_read_lock();
-- 
1.8.3.4 (Apple Git-47)

