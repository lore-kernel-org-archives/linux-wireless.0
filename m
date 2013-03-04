Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:39166 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab3CDSaG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 13:30:06 -0500
Received: by mail-wg0-f47.google.com with SMTP id dr13so4501441wgb.14
        for <linux-wireless@vger.kernel.org>; Mon, 04 Mar 2013 10:30:05 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH v2 2/2] mac80211: fix the check for mcs rates masking
Date: Mon,  4 Mar 2013 19:27:15 +0100
Message-Id: <1362421635-28008-2-git-send-email-karl.beldan@gmail.com> (sfid-20130304_193011_836511_01E9C672)
In-Reply-To: <1362421635-28008-1-git-send-email-karl.beldan@gmail.com>
References: <1362421635-28008-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Currently the mcs bitrates mask rate_idx_mcs_mask is only applied when
the pre-ht bitrates mask rate_idx_mask of the same band differs from the
default mask.
Fix it by comparing the rate_idx_mcs_mask with the driver ht caps.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/rate.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index c1e5f25..28f1936 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -455,13 +455,15 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 	ref->ops->get_rate(ref->priv, ista, priv_sta, txrc);
 
 	/*
-	 * Try to enforce the rateidx mask the user wanted. skip this if the
-	 * default mask (allow all rates) is used to save some processing for
-	 * the common case.
+	 * Try to enforce the rateidx masks the user wanted. Skip this if mask
+	 * is the default mask (allow all rates) and mcs_mask does not differ
+	 * from the driver ht caps to save some processing for the common case.
 	 */
 	mask = &txrc->rate_idx_mask;
 	mcs_mask = txrc->rate_idx_mcs_mask;
-	if (*mask != (1 << txrc->sband->n_bitrates) - 1) {
+	if (*mask != (1 << txrc->sband->n_bitrates) - 1 ||
+		memcmp(txrc->sband->ht_cap.mcs.rx_mask, txrc->rate_idx_mcs_mask,
+		       sizeof(txrc->rate_idx_mcs_mask))) {
 		if (sta) {
 			/* Filter out rates that the STA does not support */
 			*mask &= sta->sta.supp_rates[info->band];
-- 
1.7.10.GIT

