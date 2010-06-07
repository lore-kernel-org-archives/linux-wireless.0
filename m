Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853Ab0FGKCi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 06:02:38 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: stable@kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/4 2.6.34.y] mac80211: fix supported rates IE if AP doesn't give us it's rates
Date: Mon,  7 Jun 2010 12:01:09 +0200
Message-Id: <1275904869-6634-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1275904869-6634-3-git-send-email-sgruszka@redhat.com>
References: <1275904869-6634-1-git-send-email-sgruszka@redhat.com>
 <1275904869-6634-2-git-send-email-sgruszka@redhat.com>
 <1275904869-6634-3-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 76f273640134f3eb8257179cd5b3bc6ba5fe4a96 upstream.

If AP do not provide us supported rates before assiociation, send
all rates we are supporting instead of empty information element.

v1 -> v2: Add comment.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
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

