Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:48501 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbbIRXnb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 19:43:31 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  ensure association req uses configured ratemask.
Date: Fri, 18 Sep 2015 16:43:26 -0700
Message-Id: <1442619806-29917-1-git-send-email-greearb@candelatech.com> (sfid-20150919_014336_409915_154F8D93)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

When sending the association request, pay attention to the
legacy rates configured by the user, and do not advertise support
for any that are not configured.

This makes the assoc request packet look more correct when
making modern hardware act like a /b mode station, for instance.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/ieee80211_i.h |  2 +-
 net/mac80211/mlme.c        | 36 ++++++++++++++++++++++++++++++++++--
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2c3842e..b6042f2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -388,7 +388,7 @@ struct ieee80211_mgd_auth_data {
 
 struct ieee80211_mgd_assoc_data {
 	struct cfg80211_bss *bss;
-	const u8 *supp_rates;
+	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 
 	unsigned long timeout;
 	int tries;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 83c445b4..bce467c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -635,6 +635,8 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 						     assoc_data->supp_rates_len,
 						     &rates);
 	} else {
+		u32 msk = sdata->cfg_bitrate_mask.control[chan->band].legacy;
+
 		/*
 		 * In case AP not provide any supported rates information
 		 * before association, we send information element(s) with
@@ -645,6 +647,9 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 			if ((rate_flags & sband->bitrates[i].flags)
 			    != rate_flags)
 				continue;
+			if (sdata->cfg_bitrate_mask_set &&
+			    (!(msk & (1 << i))))
+				continue;
 			rates |= BIT(i);
 			rates_len++;
 		}
@@ -4735,8 +4740,35 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		sdata->smps_mode = ifmgd->req_smps;
 
 	assoc_data->capability = req->bss->capability;
-	assoc_data->supp_rates = bss->supp_rates;
-	assoc_data->supp_rates_len = bss->supp_rates_len;
+	if (sdata->cfg_bitrate_mask_set) {
+		int band = req->bss->channel->band;
+		u32 msk = sdata->cfg_bitrate_mask.control[band].legacy;
+		u8 all_rates[12] = {0x82, 0x84, 0x8b, 0x96,
+				    12, 18, 24, 36, 48, 72, 96, 108};
+		int i;
+		int q = 0;
+
+		for (i = 0; i < 12; i++) {
+			int j;
+
+			if (!(msk & (1 << i)))
+				break;
+
+			for (j = 0; j < bss->supp_rates_len; j++) {
+				if (bss->supp_rates[j] == all_rates[i]) {
+					assoc_data->supp_rates[q] =
+						all_rates[i];
+					q++;
+					break;
+				}
+			}
+		}
+		assoc_data->supp_rates_len = q;
+	} else {
+		memcpy(assoc_data->supp_rates, bss->supp_rates,
+		       bss->supp_rates_len);
+		assoc_data->supp_rates_len = bss->supp_rates_len;
+	}
 
 	rcu_read_lock();
 	ht_ie = ieee80211_bss_get_ie(req->bss, WLAN_EID_HT_OPERATION);
-- 
2.4.3

