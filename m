Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51414 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757414Ab3B0MC7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 07:02:59 -0500
Received: by mail-wi0-f174.google.com with SMTP id hi8so6137300wib.7
        for <linux-wireless@vger.kernel.org>; Wed, 27 Feb 2013 04:02:58 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH 1/2] mac80211: get the rates masks from the txrc in rate_control_get_rate
Date: Wed, 27 Feb 2013 13:00:33 +0100
Message-Id: <1361966434-28343-1-git-send-email-karl.beldan@gmail.com> (sfid-20130227_130303_824983_6A648A12)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Currently it gets it from the sdata, the behavior remains unchanged.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/rate.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index dd88381..cfbd7d5 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -459,9 +459,8 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 	 * default mask (allow all rates) is used to save some processing for
 	 * the common case.
 	 */
-	mask = sdata->rc_rateidx_mask[info->band];
-	memcpy(mcs_mask, sdata->rc_rateidx_mcs_mask[info->band],
-	       sizeof(mcs_mask));
+	mask = txrc->rate_idx_mask;
+	memcpy(mcs_mask, txrc->rate_idx_mcs_mask, sizeof(mcs_mask));
 	if (mask != (1 << txrc->sband->n_bitrates) - 1) {
 		if (sta) {
 			/* Filter out rates that the STA does not support */
-- 
1.7.10.GIT

