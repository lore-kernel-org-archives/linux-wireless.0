Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818Ab0FGKBK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 06:01:10 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: stable@kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/2 2.6.32.y] mac80211: do not wip out old supported rates
Date: Mon,  7 Jun 2010 11:59:42 +0200
Message-Id: <1275904783-6563-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use old supported rates, if some buggy AP do not provide
supported rates information element in managment frame.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/scan.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index fd6411d..169111a 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -62,7 +62,7 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 			  bool beacon)
 {
 	struct ieee80211_bss *bss;
-	int clen;
+	int clen, srlen;
 	s32 signal = 0;
 
 	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
@@ -94,23 +94,24 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	if (bss->dtim_period == 0)
 		bss->dtim_period = 1;
 
-	bss->supp_rates_len = 0;
+	/* replace old supported rates if we get new values */
+	srlen = 0;
 	if (elems->supp_rates) {
-		clen = IEEE80211_MAX_SUPP_RATES - bss->supp_rates_len;
+		clen = IEEE80211_MAX_SUPP_RATES;
 		if (clen > elems->supp_rates_len)
 			clen = elems->supp_rates_len;
-		memcpy(&bss->supp_rates[bss->supp_rates_len], elems->supp_rates,
-		       clen);
-		bss->supp_rates_len += clen;
+		memcpy(bss->supp_rates, elems->supp_rates, clen);
+		srlen += clen;
 	}
 	if (elems->ext_supp_rates) {
-		clen = IEEE80211_MAX_SUPP_RATES - bss->supp_rates_len;
+		clen = IEEE80211_MAX_SUPP_RATES - srlen;
 		if (clen > elems->ext_supp_rates_len)
 			clen = elems->ext_supp_rates_len;
-		memcpy(&bss->supp_rates[bss->supp_rates_len],
-		       elems->ext_supp_rates, clen);
-		bss->supp_rates_len += clen;
+		memcpy(bss->supp_rates + srlen, elems->ext_supp_rates, clen);
+		srlen += clen;
 	}
+	if (srlen)
+		bss->supp_rates_len = srlen;
 
 	bss->wmm_used = elems->wmm_param || elems->wmm_info;
 
-- 
1.6.2.5

