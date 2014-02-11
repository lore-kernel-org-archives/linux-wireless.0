Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50899 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbaBKPCu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 10:02:50 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH v2 3.14] mac80211: send control port protocol frames to the VO queue
Date: Tue, 11 Feb 2014 16:02:47 +0100
Message-Id: <1392130967-9624-1-git-send-email-nbd@openwrt.org> (sfid-20140211_160253_588368_1E1A4AD0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Improves reliability of wifi connections with WPA, since authentication
frames are prioritized over normal traffic and also typically exempt
from aggregation.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/wme.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 21211c6..d51422c 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -154,6 +154,11 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 		return IEEE80211_AC_BE;
 	}
 
+	if (skb->protocol == sdata->control_port_protocol) {
+		skb->priority = 7;
+		return ieee80211_downgrade_queue(sdata, skb);
+	}
+
 	/* use the data classifier to determine what 802.1d tag the
 	 * data frame has */
 	rcu_read_lock();
-- 
1.8.3.4 (Apple Git-47)

