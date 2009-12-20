Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:44986 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840AbZLTSHW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2009 13:07:22 -0500
Message-ID: <4B2E67CD.409@openwrt.org>
Date: Sun, 20 Dec 2009 19:07:09 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: fix ibss join with fixed-bssid
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When fixed bssid is requested when joining an ibss network, incoming 
beacons that match the configured bssid cause mac80211 to create new
sta entries, even before the ibss interface is in joined state.
When that happens, it fails to bring up the interface entirely, because
it checks for existing sta entries before joining.
This patch fixes this bug by refusing to create sta info entries before
the interface is fully operational.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---

--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -382,6 +382,7 @@ static void ieee80211_rx_bss_info(struct
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 					u8 *bssid,u8 *addr, u32 supp_rates)
 {
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	int band = local->hw.conf.channel->band;
@@ -397,6 +398,9 @@ struct sta_info *ieee80211_ibss_add_sta(
 		return NULL;
 	}
 
+	if (ifibss->state == IEEE80211_IBSS_MLME_SEARCH)
+		return NULL;
+
 	if (compare_ether_addr(bssid, sdata->u.ibss.bssid))
 		return NULL;
 
