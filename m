Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:40286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbYEQSfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2008 14:35:33 -0400
Message-ID: <20080517203531.vus3gj5ce8ksskkc@imap.suse.de> (sfid-20080517_203542_365617_BB2B3F5B)
Date: Sat, 17 May 2008 20:35:31 +0200
From: Helmut Schaa <hschaa@suse.de>
To: John Linville <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCHv2] mac80211: fix NULL pointer dereference in
	ieee80211_compatible_rates
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a possible NULL pointer dereference in ieee80211_compatible_rates
introduced in the patch "mac80211: fix association with some APs".

Signed-off-by: Helmut Schaa <hschaa@suse.de>
---

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 76ad4ed..2642551 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -664,15 +664,22 @@ static int ieee80211_compatible_rates(struct  
ieee80211_sta_bss *bss,
  	int i, j, count;
  	*rates = 0;
  	count = 0;
-	for (i = 0; i < bss->supp_rates_len; i++) {
-		int rate = (bss->supp_rates[i] & 0x7F) * 5;

-		for (j = 0; j < sband->n_bitrates; j++)
-			if (sband->bitrates[j].bitrate == rate) {
-				*rates |= BIT(j);
-				count++;
-				break;
-			}
+	if (bss) {
+		for (i = 0; i < bss->supp_rates_len; i++) {
+			int rate = (bss->supp_rates[i] & 0x7F) * 5;
+
+			for (j = 0; j < sband->n_bitrates; j++)
+				if (sband->bitrates[j].bitrate == rate) {
+					*rates |= BIT(j);
+					count++;
+					break;
+				}
+		}
+	} else {
+		for (i = 0; i < sband->n_bitrates; i++)
+			*rates |= BIT(i);
+		count = sband->n_bitrates;
  	}

  	return count;

