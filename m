Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab0D1NgN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 09:36:13 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/2] mac80211: fix supported rates IE if AP doesn't give us it's rates
Date: Wed, 28 Apr 2010 15:17:04 +0200
Message-Id: <1272460624-3611-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1272460624-3611-1-git-send-email-sgruszka@redhat.com>
References: <1272460624-3611-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If AP do not provide us supported rates before assiociation, send
all rates we are supporting instead of empty information element.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/work.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 15e1ba9..f8f5c9a 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -213,15 +213,20 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 
 	sband = local->hw.wiphy->bands[wk->chan->band];
 
-	/*
-	 * Get all rates supported by the device and the AP as
-	 * some APs don't like getting a superset of their rates
-	 * in the association request (e.g. D-Link DAP 1353 in
-	 * b-only mode)...
-	 */
-	rates_len = ieee80211_compatible_rates(wk->assoc.supp_rates,
-					       wk->assoc.supp_rates_len,
-					       sband, &rates);
+	if (wk->assoc.supp_rates_len) {
+		/*
+		 * Get all rates supported by the device and the AP as
+		 * some APs don't like getting a superset of their rates
+		 * in the association request (e.g. D-Link DAP 1353 in
+		 * b-only mode)...
+		 */
+		rates_len = ieee80211_compatible_rates(wk->assoc.supp_rates,
+						       wk->assoc.supp_rates_len,
+						       sband, &rates);
+	} else {
+		rates = ~0;
+		rates_len = sband->n_bitrates;
+	}
 
 	skb = alloc_skb(local->hw.extra_tx_headroom +
 			sizeof(*mgmt) + /* bit too much but doesn't matter */
-- 
1.6.2.5

