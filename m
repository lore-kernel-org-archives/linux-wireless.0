Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab0FGKBx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 06:01:53 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: stable@kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 4/4 2.6.33.y] mac80211: fix supported rates IE if AP doesn't give us it's rates
Date: Mon,  7 Jun 2010 12:00:27 +0200
Message-Id: <1275904827-6598-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1275904827-6598-3-git-send-email-sgruszka@redhat.com>
References: <1275904827-6598-1-git-send-email-sgruszka@redhat.com>
 <1275904827-6598-2-git-send-email-sgruszka@redhat.com>
 <1275904827-6598-3-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 76f273640134f3eb8257179cd5b3bc6ba5fe4a96 upstream.

If AP do not provide us supported rates before assiociation, send
all rates we are supporting instead of empty information element.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/mlme.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 950088d..aa90100 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -270,12 +270,6 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 	if (wk->bss->wmm_used)
 		wmm = 1;
 
-	/* get all rates supported by the device and the AP as
-	 * some APs don't like getting a superset of their rates
-	 * in the association request (e.g. D-Link DAP 1353 in
-	 * b-only mode) */
-	rates_len = ieee80211_compatible_rates(wk->bss, sband, &rates);
-
 	if ((wk->bss->cbss.capability & WLAN_CAPABILITY_SPECTRUM_MGMT) &&
 	    (local->hw.flags & IEEE80211_HW_SPECTRUM_MGMT))
 		capab |= WLAN_CAPABILITY_SPECTRUM_MGMT;
@@ -310,6 +304,17 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 	*pos++ = wk->ssid_len;
 	memcpy(pos, wk->ssid, wk->ssid_len);
 
+	if (wk->bss->supp_rates_len) {
+		/* get all rates supported by the device and the AP as
+		 * some APs don't like getting a superset of their rates
+		 * in the association request (e.g. D-Link DAP 1353 in
+		 * b-only mode) */
+		rates_len = ieee80211_compatible_rates(wk->bss, sband, &rates);
+	} else {
+		rates = ~0;
+		rates_len = sband->n_bitrates;
+	}
+
 	/* add all rates which were marked to be used above */
 	supp_rates_len = rates_len;
 	if (supp_rates_len > 8)
-- 
1.6.2.5

