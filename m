Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51917 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934362Ab3DHHTr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 03:19:47 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: always advertise STBC/MCSes even if no AP support
Date: Mon,  8 Apr 2013 09:19:41 +0200
Message-Id: <1365405581-9842-1-git-send-email-johannes@sipsolutions.net> (sfid-20130408_091951_601288_16277AAE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Advertise STBC capabilities and MCS rates even if the AP
doesn't support them. This has always been the right thing
to do, but used to be problematic with some APs. Now WFA
testing requires this so re-enable it, problematic APs
would then presumably not pass the test and be fixed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 304d6cf..15876f3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -632,37 +632,6 @@ static void ieee80211_add_vht_ie(struct ieee80211_sub_if_data *sdata,
 			cpu_to_le32(IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE)))
 		cap &= ~IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE;
 
-	if (!(ap_vht_cap->vht_cap_info &
-			cpu_to_le32(IEEE80211_VHT_CAP_TXSTBC)))
-		cap &= ~(IEEE80211_VHT_CAP_RXSTBC_1 |
-			 IEEE80211_VHT_CAP_RXSTBC_3 |
-			 IEEE80211_VHT_CAP_RXSTBC_4);
-
-	for (i = 0; i < 8; i++) {
-		int shift = i * 2;
-		u16 mask = IEEE80211_VHT_MCS_NOT_SUPPORTED << shift;
-		u16 ap_mcs, our_mcs;
-
-		ap_mcs = (le16_to_cpu(ap_vht_cap->supp_mcs.tx_mcs_map) &
-								mask) >> shift;
-		our_mcs = (le16_to_cpu(vht_cap.vht_mcs.rx_mcs_map) &
-								mask) >> shift;
-
-		if (our_mcs == IEEE80211_VHT_MCS_NOT_SUPPORTED)
-			continue;
-
-		switch (ap_mcs) {
-		default:
-			if (our_mcs <= ap_mcs)
-				break;
-			/* fall through */
-		case IEEE80211_VHT_MCS_NOT_SUPPORTED:
-			vht_cap.vht_mcs.rx_mcs_map &= cpu_to_le16(~mask);
-			vht_cap.vht_mcs.rx_mcs_map |=
-				cpu_to_le16(ap_mcs << shift);
-		}
-	}
-
 	/* reserve and fill IE */
 	pos = skb_put(skb, sizeof(struct ieee80211_vht_cap) + 2);
 	ieee80211_ie_build_vht_cap(pos, &vht_cap, cap);
-- 
1.8.0

