Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:32946 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751168AbcGEMX2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 08:23:28 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  5 Jul 2016 15:23:14 +0300
Message-Id: <1467721394-8195-8-git-send-email-luca@coelho.fi> (sfid-20160705_142334_960416_282FA36F)
In-Reply-To: <1467721394-8195-1-git-send-email-luca@coelho.fi>
References: <1467721394-8195-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 7/7] mac80211: parse wide bandwidth channel switch IE with workaround
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Continuing the workaround implemented in commit 23665aaf9170
("mac80211: Interoperability workaround for 80+80 and 160 MHz channels")
use the same code to parse the Wide Bandwidth Channel Switch element
by converting to VHT Operation element since the spec also just refers
to that for parsing semantics, particularly with the workaround.

While at it, remove some dead code - the IEEE80211_STA_DISABLE_40MHZ
flag can never be set at this point since it's checked earlier and the
wide_bw_chansw_ie pointer is set to NULL if it's set.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/spectmgmt.c | 45 +++++++++++++++++----------------------------
 1 file changed, 17 insertions(+), 28 deletions(-)

diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index 2ddc661..97f4c9d 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -129,42 +129,31 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (wide_bw_chansw_ie) {
-		new_vht_chandef.chan = new_chan;
-		new_vht_chandef.center_freq1 =
-			ieee80211_channel_to_frequency(
+		struct ieee80211_vht_operation vht_oper = {
+			.chan_width =
+				wide_bw_chansw_ie->new_channel_width,
+			.center_freq_seg1_idx =
 				wide_bw_chansw_ie->new_center_freq_seg0,
-				new_band);
-
-		switch (wide_bw_chansw_ie->new_channel_width) {
-		default:
-			/* hmmm, ignore VHT and use HT if present */
-		case IEEE80211_VHT_CHANWIDTH_USE_HT:
+			.center_freq_seg2_idx =
+				wide_bw_chansw_ie->new_center_freq_seg1,
+			/* .basic_mcs_set doesn't matter */
+		};
+
+		/* default, for the case of IEEE80211_VHT_CHANWIDTH_USE_HT,
+		 * to the previously parsed chandef
+		 */
+		new_vht_chandef = csa_ie->chandef;
+
+		/* ignore if parsing fails */
+		if (!ieee80211_chandef_vht_oper(&vht_oper, &new_vht_chandef))
 			new_vht_chandef.chan = NULL;
-			break;
-		case IEEE80211_VHT_CHANWIDTH_80MHZ:
-			new_vht_chandef.width = NL80211_CHAN_WIDTH_80;
-			break;
-		case IEEE80211_VHT_CHANWIDTH_160MHZ:
-			new_vht_chandef.width = NL80211_CHAN_WIDTH_160;
-			break;
-		case IEEE80211_VHT_CHANWIDTH_80P80MHZ:
-			/* field is otherwise reserved */
-			new_vht_chandef.center_freq2 =
-				ieee80211_channel_to_frequency(
-					wide_bw_chansw_ie->new_center_freq_seg1,
-					new_band);
-			new_vht_chandef.width = NL80211_CHAN_WIDTH_80P80;
-			break;
-		}
+
 		if (sta_flags & IEEE80211_STA_DISABLE_80P80MHZ &&
 		    new_vht_chandef.width == NL80211_CHAN_WIDTH_80P80)
 			ieee80211_chandef_downgrade(&new_vht_chandef);
 		if (sta_flags & IEEE80211_STA_DISABLE_160MHZ &&
 		    new_vht_chandef.width == NL80211_CHAN_WIDTH_160)
 			ieee80211_chandef_downgrade(&new_vht_chandef);
-		if (sta_flags & IEEE80211_STA_DISABLE_40MHZ &&
-		    new_vht_chandef.width > NL80211_CHAN_WIDTH_20)
-			ieee80211_chandef_downgrade(&new_vht_chandef);
 	}
 
 	/* if VHT data is there validate & use it */
-- 
2.8.1

