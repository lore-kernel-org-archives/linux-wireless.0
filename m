Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59070 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbbAPKjl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 05:39:41 -0500
Received: by mail-wi0-f181.google.com with SMTP id hi2so2937070wib.2
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 02:39:40 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFCv2 5/6] mac80211: ibss/mesh move bw checking
Date: Fri, 16 Jan 2015 11:38:43 +0100
Message-Id: <1421404724-32326-5-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150116_113947_285492_F84FDDB6)
In-Reply-To: <1421404724-32326-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1421404724-32326-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We will need this as a preparetion for VHT.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/mac80211/ht.c         | 2 --
 net/mac80211/ibss.c       | 4 ++++
 net/mac80211/mesh_plink.c | 4 ++++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index ff630be..7a76ce6 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -252,8 +252,6 @@ bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 		break;
 	}
 
-	if (bw != sta->sta.bandwidth)
-		changed = true;
 	sta->sta.bandwidth = bw;
 
 	sta->cur_max_bandwidth =
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index b1e9e9b..3c6df2b 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1064,6 +1064,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 			/* we both use HT */
 			struct ieee80211_ht_cap htcap_ie;
 			struct cfg80211_chan_def chandef;
+			enum ieee80211_sta_rx_bandwidth bw = sta->sta.bandwidth;
 
 			ieee80211_ht_oper_to_chandef(channel,
 						     elems->ht_operation,
@@ -1082,6 +1083,9 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 
 			rates_updated |= ieee80211_ht_cap_ie_to_sta_ht_cap(
 						sdata, sband, &htcap_ie, sta);
+
+			if (bw != sta->sta.bandwidth)
+				rates_updated |= true;
 		}
 
 		if (sta && rates_updated) {
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index fa94ca1..de5b8ac 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -382,6 +382,7 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
 	struct ieee80211_supported_band *sband;
 	u32 rates, basic_rates = 0, changed = 0;
+	enum ieee80211_sta_rx_bandwidth bw = sta->sta.bandwidth;
 
 	sband = local->hw.wiphy->bands[band];
 	rates = ieee80211_sta_get_rates(sdata, elems, band, &basic_rates);
@@ -401,6 +402,9 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 					      elems->ht_cap_elem, sta))
 		changed |= IEEE80211_RC_BW_CHANGED;
 
+	if (bw != sta->sta.bandwidth)
+		changed |= IEEE80211_RC_BW_CHANGED;
+
 	/* HT peer is operating 20MHz-only */
 	if (elems->ht_operation &&
 	    !(elems->ht_operation->ht_param &
-- 
1.9.1

