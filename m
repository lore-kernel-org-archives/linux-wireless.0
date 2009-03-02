Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36093 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbZCBICd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 03:02:33 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2009 00:02:32 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18859.37287.333376.924937@gargle.gargle.HOWL> (sfid-20090302_090237_069581_E3580A95)
Date: Mon, 2 Mar 2009 13:28:31 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	<Jouni.Malinen@Atheros.com>
Subject: [PATCH] mac80211: Fix TKIP/WEP HT capability handling
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to parse the AP's HT capabilities if
the STA uses TKIP/WEP cipher. This allows the rate control
module to choose the correct(legacy) rate table.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 net/mac80211/mlme.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7f23858..52d876e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1307,7 +1307,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	else
 		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
 
-	if (elems.ht_cap_elem)
+	/* If TKIP/WEP is used, no need to parse AP's HT capabilities */
+	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_TKIP_WEP_USED))
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
 				elems.ht_cap_elem, &sta->sta.ht_cap);
 
-- 
1.6.1

