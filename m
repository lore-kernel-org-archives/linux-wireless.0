Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhcavuit02.kulnet.kuleuven.be ([134.58.240.130]:48173 "EHLO
	cavuit02.kulnet.kuleuven.be" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753308AbbHEOCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 10:02:45 -0400
From: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
Subject: [PATCH 3/5] mac80211: Create STA when transmitting to unknown station in OCB mode
Date: Wed,  5 Aug 2015 16:02:33 +0200
Message-Id: <1438783353-5685-1-git-send-email-bertold.vandenbergh@esat.kuleuven.be> (sfid-20150805_160249_759695_FCB65F13)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create a new STA when requested to unicast a frame to an unknown station.
This is needed to make ratecontrol work in the case where data is sent
from sta A to B and sta B never replies. Currently, sta B will stay unknown
to mac80211 and the default rate will always be used.

Signed-off-by: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
---
 net/mac80211/tx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 84e0e8c..eb8dba6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1209,6 +1209,10 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 	} else
 		tx->flags |= IEEE80211_TX_UNICAST;
 
+	if ((sdata->vif.type == NL80211_IFTYPE_OCB) && (!tx->sta) &&
+	    (tx->flags & IEEE80211_TX_UNICAST))
+		ieee80211_ocb_rx_no_sta(sdata, NULL, hdr->addr1, 0);
+
 	if (!(info->flags & IEEE80211_TX_CTL_DONTFRAG)) {
 		if (!(tx->flags & IEEE80211_TX_UNICAST) ||
 		    skb->len + FCS_LEN <= local->hw.wiphy->frag_threshold ||
-- 
1.9.1

