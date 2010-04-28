Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab0D1NTF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 09:19:05 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/2] mac80211: do not wip out old supported rates
Date: Wed, 28 Apr 2010 15:17:03 +0200
Message-Id: <1272460624-3611-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use old supported rates, if AP do not provide supported rates
information element in a new managment frame.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/scan.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 85507bd..151d933 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -83,7 +83,7 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 {
 	struct cfg80211_bss *cbss;
 	struct ieee80211_bss *bss;
-	int clen;
+	int clen, srlen;
 	s32 signal = 0;
 
 	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
@@ -112,23 +112,24 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 		bss->dtim_period = tim_ie->dtim_period;
 	}
 
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
 	bss->uapsd_supported = is_uapsd_supported(elems);
-- 
1.6.2.5

