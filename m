Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45540 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727222AbeHaNBK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 09:01:10 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date: Fri, 31 Aug 2018 11:31:19 +0300
Message-Id: <20180831083130.15525-18-luca@coelho.fi> (sfid-20180831_105449_387424_290EC0E6)
In-Reply-To: <20180831083130.15525-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
Subject: [PATCH 17/28] mac80211: copy VHT EXT NSS BW Support/Capable data to station
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When taking VHT capabilities for a station, copy the new
fields if we support them as a transmitter. Also adjust
the maximum bandwidth the station supports appropriately.

Also, since it was missing, copy tx_highest and rx_highest.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/vht.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 259325cbcc31..006d82e4a397 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -3,6 +3,7 @@
  *
  * Portions of this file
  * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -231,6 +232,13 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
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
@@ -294,6 +302,18 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 		break;
 	default:
 		sta->cur_max_bandwidth = IEEE80211_STA_RX_BW_80;
+
+		if (!(vht_cap->vht_mcs.tx_highest &
+				cpu_to_le16(IEEE80211_VHT_EXT_NSS_BW_CAPABLE)))
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
2.18.0
