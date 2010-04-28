Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab0D1PE6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 11:04:58 -0400
Date: Wed, 28 Apr 2010 17:03:15 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2/2 v2] mac80211: fix supported rates IE if AP doesn't give
	us it's rates
Message-ID: <20100428150315.GA3650@dhcp-lab-161.englab.brq.redhat.com>
References: <1272460624-3611-1-git-send-email-sgruszka@redhat.com> <1272460624-3611-2-git-send-email-sgruszka@redhat.com> <1272461964.3565.21.camel@jlt3.sipsolutions.net> <20100428155755.75f1dc5a@dhcp-lab-109.englab.brq.redhat.com> <1272463157.3565.22.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1272463157.3565.22.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If AP do not provide us supported rates before assiociation, send
all rates we are supporting instead of empty information element.

v1 -> v2: Add comment.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/work.c |   28 +++++++++++++++++++---------
 1 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 15e1ba9..949c2d1 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -213,15 +213,25 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 
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
+		/*
+		 * In case AP not provide any supported rates information
+		 * before association, we send information element(s) with
+		 * all rates that we support.
+		 */
+		rates = ~0;
+		rates_len = sband->n_bitrates;
+	}
 
 	skb = alloc_skb(local->hw.extra_tx_headroom +
 			sizeof(*mgmt) + /* bit too much but doesn't matter */
-- 
1.6.2.5

