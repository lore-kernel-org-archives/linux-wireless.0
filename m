Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59840 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751306AbdBOODB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 09:03:01 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 4/5] mac80211: copy VHT EXT NSS BW Support/Capable data to station
Date: Wed, 15 Feb 2017 15:02:55 +0100
Message-Id: <20170215140256.19455-4-johannes@sipsolutions.net> (sfid-20170215_150306_365042_0D5F079D)
In-Reply-To: <20170215140256.19455-1-johannes@sipsolutions.net>
References: <20170215140256.19455-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When taking VHT capabilities for a station, copy the new
fields if we support them as a transmitter. Also adjust
the maximum bandwidth the station supports appropriately.

Also, since it was missing, copy tx_highest and rx_highest.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/vht.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 19ec2189d3ac..2d1e72747ab8 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -231,6 +231,13 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 	memcpy(&vht_cap->vht_mcs, &vht_cap_ie->supp_mcs,
 	       sizeof(struct ieee80211_vht_mcs_info));
 
+	/* copy EXT_NSS_BW Support value or remove the capability */
+	if (ieee80211_hw_check(&sdata->local->hw, SUPPORTS_VHT_EXT_NSS_BW))
+		vht_cap->cap |= (cap_info & IEEE80211_VHT_CAP_EXT_NSS_BW_MASK);
+	else
+		vht_cap->vht_mcs.tx_highest &=
+			~cpu_to_le16(IEEE80211_VHT_EXT_NSS_BW_CAPABLE);
+
 	/* but also restrict MCSes */
 	for (i = 0; i < 8; i++) {
 		u16 own_rx, own_tx, peer_rx, peer_tx;
@@ -294,6 +301,18 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 		break;
 	default:
 		sta->cur_max_bandwidth = IEEE80211_STA_RX_BW_80;
+
+		if (!(vht_cap->vht_mcs.tx_highest &
+				cpu_to_le16(IEEE80211_VHT_EXT_NSS_BW_CAPABLE))
+			break;
+
+		/*
+		 * If this is non-zero, then it does support 160 MHz after all,
+		 * in one form or the other. We don't distinguish here (or even
+		 * above) between 160 and 80+80 yet.
+		 */
+		if (cap_info & IEEE80211_VHT_CAP_EXT_NSS_BW_MASK)
+			sta->cur_max_bandwidth = IEEE80211_STA_RX_BW_160;
 	}
 
 	sta->sta.bandwidth = ieee80211_sta_cur_vht_bw(sta);
-- 
2.9.3
