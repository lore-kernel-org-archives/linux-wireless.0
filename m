Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33734 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbbHFVri (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 17:47:38 -0400
Received: by wijp15 with SMTP id p15so38588666wij.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2015 14:47:37 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 1/4] mac80211: remove ieee80211_tx_info from rate_control_apply_mask signature
Date: Thu,  6 Aug 2015 23:47:30 +0200
Message-Id: <1438897653-4629-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20150806_234742_809413_78217585)
In-Reply-To: <1438897653-4629-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1438897653-4629-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unnecessary ieee80211_tx_info pointer from rate_control_apply_mask
signature. rate_control_apply_mask() will be used to define a ratemask in
rate_control_set_rates() for station rate table

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 net/mac80211/rate.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 03687d2..4f02e07 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -631,7 +631,6 @@ static void rate_control_fill_sta_table(struct ieee80211_sta *sta,
 static void rate_control_apply_mask(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_sta *sta,
 				    struct ieee80211_supported_band *sband,
-				    struct ieee80211_tx_info *info,
 				    struct ieee80211_tx_rate *rates,
 				    int max_rates)
 {
@@ -647,8 +646,8 @@ static void rate_control_apply_mask(struct ieee80211_sub_if_data *sdata,
 	 * default mask (allow all rates) is used to save some processing for
 	 * the common case.
 	 */
-	mask = sdata->rc_rateidx_mask[info->band];
-	has_mcs_mask = sdata->rc_has_mcs_mask[info->band];
+	mask = sdata->rc_rateidx_mask[sband->band];
+	has_mcs_mask = sdata->rc_has_mcs_mask[sband->band];
 	rate_flags =
 		ieee80211_chandef_rate_flags(&sdata->vif.bss_conf.chandef);
 	for (i = 0; i < sband->n_bitrates; i++)
@@ -659,14 +658,14 @@ static void rate_control_apply_mask(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	if (has_mcs_mask)
-		memcpy(mcs_mask, sdata->rc_rateidx_mcs_mask[info->band],
+		memcpy(mcs_mask, sdata->rc_rateidx_mcs_mask[sband->band],
 		       sizeof(mcs_mask));
 	else
 		memset(mcs_mask, 0xff, sizeof(mcs_mask));
 
 	if (sta) {
 		/* Filter out rates that the STA does not support */
-		mask &= sta->supp_rates[info->band];
+		mask &= sta->supp_rates[sband->band];
 		for (i = 0; i < sizeof(mcs_mask); i++)
 			mcs_mask[i] &= sta->ht_cap.mcs.rx_mask[i];
 	}
@@ -707,7 +706,7 @@ void ieee80211_get_tx_rates(struct ieee80211_vif *vif,
 	sband = sdata->local->hw.wiphy->bands[info->band];
 
 	if (ieee80211_is_data(hdr->frame_control))
-		rate_control_apply_mask(sdata, sta, sband, info, dest, max_rates);
+		rate_control_apply_mask(sdata, sta, sband, dest, max_rates);
 
 	if (dest[0].idx < 0)
 		__rate_control_send_low(&sdata->local->hw, sband, sta, info,
-- 
2.1.4

