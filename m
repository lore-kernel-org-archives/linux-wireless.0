Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59310 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759790Ab3B0MDC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 07:03:02 -0500
Received: by mail-wi0-f181.google.com with SMTP id hm6so539575wib.14
        for <linux-wireless@vger.kernel.org>; Wed, 27 Feb 2013 04:03:00 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH 2/2] mac80211: fix the check for mcs rates masking
Date: Wed, 27 Feb 2013 13:00:34 +0100
Message-Id: <1361966434-28343-2-git-send-email-karl.beldan@gmail.com> (sfid-20130227_130306_989968_06E5A2D1)
In-Reply-To: <1361966434-28343-1-git-send-email-karl.beldan@gmail.com>
References: <1361966434-28343-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Currently the mcs bitrates mask rate_idx_mcs_mask is only applied when
the pre-ht bitrates mask rate_idx_mask of the same band differs from the
default mask.
Fix it by comparing the rate_idx_mcs_mask with the ht_cap.mcs.rx_mask, the
copy of the rate_idx_mcs_mask is now done if the check succeeds.
This results, when no pre-ht bitrates is disabled && an mcs idx is, to
one more memcmp, otherwise the cost remains identical.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/rate.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index cfbd7d5..4c0a14d 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -460,8 +460,11 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 	 * the common case.
 	 */
 	mask = txrc->rate_idx_mask;
-	memcpy(mcs_mask, txrc->rate_idx_mcs_mask, sizeof(mcs_mask));
-	if (mask != (1 << txrc->sband->n_bitrates) - 1) {
+	if (mask != (1 << txrc->sband->n_bitrates) - 1 ||
+		memcmp(txrc->sband->ht_cap.mcs.rx_mask, txrc->rate_idx_mcs_mask,
+		       sizeof(txrc->rate_idx_mcs_mask))) {
+		memcpy(mcs_mask, txrc->rate_idx_mcs_mask, sizeof(mcs_mask));
+
 		if (sta) {
 			/* Filter out rates that the STA does not support */
 			mask &= sta->sta.supp_rates[info->band];
-- 
1.7.10.GIT

