Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43624 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753838AbdBNNWP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 08:22:15 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, greearb@candelatech.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 7/7] mac80211: copy VHT EXT NSS BW Support/Capable data to station
Date: Tue, 14 Feb 2017 14:22:08 +0100
Message-Id: <20170214132208.8715-8-johannes@sipsolutions.net> (sfid-20170214_142251_529302_B8E8134F)
In-Reply-To: <20170214132208.8715-1-johannes@sipsolutions.net>
References: <20170214132208.8715-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When taking VHT capabilities for a station, copy the new
fields if we support them as a transmitted.

Also, since it was missing, copy tx_highest and rx_highest.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/vht.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 19ec2189d3ac..c75d37f9bff0 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -197,6 +197,20 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 		break;
 	}
 
+	/* keep these, no need to limit to our own */
+	vht_cap->vht_mcs.tx_highest = vht_cap_ie->supp_mcs.tx_highest;
+	vht_cap->vht_mcs.rx_highest = vht_cap_ie->supp_mcs.rx_highest;
+
+	/*
+	 * copy these only if rate control supports it, since otherwise some
+	 * helper functions might return data that's not valid
+	 */
+	if (ieee80211_hw_check(&sdata->local->hw, SUPPORTS_VHT_EXT_NSS_BW))
+		vht_cap->cap |= (cap_info & IEEE80211_VHT_CAP_EXT_NSS_BW_MASK);
+	else
+		vht_cap->vht_mcs.tx_highest &=
+			~cpu_to_le16(IEEE80211_VHT_EXT_NSS_BW_CAPABLE);
+
 	/* symmetric capabilities */
 	vht_cap->cap |= cap_info & own_cap.cap &
 			(IEEE80211_VHT_CAP_SHORT_GI_80 |
-- 
2.9.3
