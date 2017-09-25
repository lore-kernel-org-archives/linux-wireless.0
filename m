Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:43829 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933306AbdIYTJV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 15:09:21 -0400
From: <mpubbise@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>
Subject: [PATCH] mac80211: fix bandwidth computation for TDLS peers
Date: Tue, 26 Sep 2017 00:39:15 +0530
Message-ID: <1506366555-21862-1-git-send-email-mpubbise@qti.qualcomm.com> (sfid-20170925_211236_568121_80CB0400)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>

Section 11.23.1 of 80211-2016 specification allows TDLS peers
to operate on wider bandwidths though they are connected to a BSS
which do not support wider bandwidth operations, provided both the
peers advertize wider banwidth capabilities.

The existing logic considers the minimum of station's and AP's
capability for bandwidth computation. The same logic applies for
TDLS peers as well, this restricts operating on wider bandwidths
over a TDLS link when the peers are connected to legacy APs.

As an example,
If 80Mhz VHT capable peers are connected to a 20Mhz 11a AP, then as per
the existing logic TDLS operation will be restricted to 20Mhz.

Addressing this problem by not considering BSS capability in bandwidth
computaion if the participating TDLS peers have wider bandwidth
capability.

Signed-off-by: Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>
---
 net/mac80211/vht.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 19ec218..b9276ac 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -386,6 +386,16 @@ enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta)
 
 	bw = ieee80211_sta_cap_rx_bw(sta);
 	bw = min(bw, sta->cur_max_bandwidth);
+
+	/* Don't consider AP's bandwidth for TDLS peers, section 11.23.1 of
+	 * IEEE80211-2016 specification makes higher bandwidth operation
+	 * possible on the TDLS link if the peers have wider bandwidth
+	 * capability.
+	 */
+	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) &&
+	    test_sta_flag(sta, WLAN_STA_TDLS_WIDER_BW))
+		return bw;
+
 	bw = min(bw, ieee80211_chan_width_to_rx_bw(bss_width));
 
 	return bw;
-- 
1.7.9.5
