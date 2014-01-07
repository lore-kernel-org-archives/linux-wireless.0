Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41875 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbaAGLLr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 06:11:47 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/2] mac80211: simplify code in ieee80211_prepare_and_rx_handle
Date: Tue,  7 Jan 2014 13:10:20 +0200
Message-Id: <1389093020-12005-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140107_121149_666438_F149886B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to assign the return value of prepare_for_handlers
to a variable if the only usage is to test it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/rx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 274f43c..9dea249 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3191,13 +3191,11 @@ static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (void *)skb->data;
-	int prepares;
 
 	rx->skb = skb;
 	status->rx_flags |= IEEE80211_RX_RA_MATCH;
-	prepares = prepare_for_handlers(rx, hdr);
 
-	if (!prepares)
+	if (!prepare_for_handlers(rx, hdr))
 		return false;
 
 	if (!consume) {
-- 
1.8.3.2

