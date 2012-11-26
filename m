Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:51368 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753110Ab2KZMRk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 07:17:40 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 26 Nov 2012 04:17:40 -0800
From: saravanad@posedge.com
To: <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [RFC] mac80211: re-organize the rx rate calculation logic
Message-ID: <d4c0566bd33c1afdcc0f7b820024d19f@posedge.com> (sfid-20121126_131744_235348_42BFE476)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mac80211: currently the logic to calculate the rx rate is accessible 
only in the cfg.c as the rate_idx_to_bitrate() is static function.
The rx rate calculation might be needed by other files(modules) of 
mac80211(possibly debugfs). So grouping the rx rate calculation logic to
a separate function which can be accessed from other files. This change 
will make the rx rate calculation implementation similar to tx rate.

Signed-off-by: Saravana <saravanad@posedge.com>
---
The diff file is generated from wireless-testing git tree.
  net/mac80211/cfg.c      |   21 +++++++++++++--------
  net/mac80211/sta_info.h |    2 ++
  2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6733b374..0999547 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -396,6 +396,18 @@ void sta_set_rate_info_tx(struct sta_info *sta,
  	rate_idx_to_bitrate(rinfo, sta, rate->idx);
  }

+void sta_set_rate_info_rx(struct sta_info *sta, struct rate_info 
*rinfo)
+{
+	rinfo->flags = 0;
+	if (sta->last_rx_rate_flag & RX_FLAG_HT)
+		rinfo->flags |= RATE_INFO_FLAGS_MCS;
+	if (sta->last_rx_rate_flag & RX_FLAG_40MHZ)
+		rinfo->flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
+	if (sta->last_rx_rate_flag & RX_FLAG_SHORT_GI)
+		rinfo->flags |= RATE_INFO_FLAGS_SHORT_GI;
+	rate_idx_to_bitrate(rinfo, sta, sta->last_rx_rate_idx);
+
+}
  static void sta_set_sinfo(struct sta_info *sta, struct station_info 
*sinfo)
  {
  	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -443,14 +455,7 @@ static void sta_set_sinfo(struct sta_info *sta, 
struct station_info *sinfo)

  	sta_set_rate_info_tx(sta, &sta->last_tx_rate, &sinfo->txrate);

-	sinfo->rxrate.flags = 0;
-	if (sta->last_rx_rate_flag & RX_FLAG_HT)
-		sinfo->rxrate.flags |= RATE_INFO_FLAGS_MCS;
-	if (sta->last_rx_rate_flag & RX_FLAG_40MHZ)
-		sinfo->rxrate.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
-	if (sta->last_rx_rate_flag & RX_FLAG_SHORT_GI)
-		sinfo->rxrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
-	rate_idx_to_bitrate(&sinfo->rxrate, sta, sta->last_rx_rate_idx);
+	sta_set_rate_info_rx(sta, &sinfo->rxrate);

  	if (ieee80211_vif_is_mesh(&sdata->vif)) {
  #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 776f3d0..122d853 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -550,6 +550,8 @@ int sta_info_flush(struct ieee80211_local *local,
  void sta_set_rate_info_tx(struct sta_info *sta,
  			  const struct ieee80211_tx_rate *rate,
  			  struct rate_info *rinfo);
+void sta_set_rate_info_rx(struct sta_info *sta,
+			struct rate_info *rinfo);
  void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
  			  unsigned long exp_time);

