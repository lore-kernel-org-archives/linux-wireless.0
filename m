Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54562 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1956646AbdDZH7P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 03:59:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 26 Apr 2017 10:58:54 +0300
Message-Id: <20170426075854.13546-10-luca@coelho.fi> (sfid-20170426_095928_573614_104D462E)
In-Reply-To: <20170426075854.13546-1-luca@coelho.fi>
References: <20170426075854.13546-1-luca@coelho.fi>
Subject: [PATCH 9/9] mac80211: make multicast variable a bool in ieee80211_accept_frame()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The multicast variable in the ieee80211_accept_frame() function is
treated as a boolean, but defined as int.  Fix that.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 0094f3c0af64..fe6a760aa1ee 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3574,7 +3574,7 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	u8 *bssid = ieee80211_get_bssid(hdr, skb->len, sdata->vif.type);
-	int multicast = is_multicast_ether_addr(hdr->addr1);
+	bool multicast = is_multicast_ether_addr(hdr->addr1);
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_STATION:
-- 
2.11.0
