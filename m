Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:46791 "EHLO
        devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755461AbcHVOGp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 10:06:45 -0400
From: Maxim Altshul <maxim.altshul@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <kvalo@codeaurora.org>, <johannes@sipsolutions.net>,
        Maxim Altshul <maxim.altshul@ti.com>
Subject: [PATCH 1/3 v3] mac80211: RX BA support for sta max_rx_aggregation_subframes
Date: Mon, 22 Aug 2016 17:14:04 +0300
Message-ID: <20160822141404.12814-1-maxim.altshul@ti.com> (sfid-20160822_160649_488669_08094CB2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ability to change the max_rx_aggregation frames is useful
in cases of IOP.

There exist some devices (latest mobile phones and some AP's)
that tend to not respect a BA sessions maximum size (in Kbps).
These devices won't respect the AMPDU size that was negotiated during
associasion (even though they do respect the maximal number of packets).

This violation is characterized by a valid number of packets in
a single AMPDU. Even so, the total size will exceed the size negotiated
during association.

Eventually, this will cause some undefined behavior, which in turn
causes the hw to drop packets, causing the throughput to plummet.

This patch will make the subframe limitation to be held by each station,
instead of being held only by hw.

Signed-off-by: Maxim Altshul <maxim.altshul@ti.com>
---
No need to change the lock, since the driver changes the value of 
sta->sta.max_rx_aggregation_subframes without locking.
Add the station's address to debug, and change the commit message
a little bit.

 include/net/mac80211.h  | 4 ++++
 net/mac80211/agg-rx.c   | 7 +++++--
 net/mac80211/sta_info.c | 3 +++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cca510a..a1457ca 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1735,6 +1735,9 @@ struct ieee80211_sta_rates {
  * @supp_rates: Bitmap of supported rates (per band)
  * @ht_cap: HT capabilities of this STA; restricted to our own capabilities
  * @vht_cap: VHT capabilities of this STA; restricted to our own capabilities
+ * @max_rx_aggregation_subframes: maximal amount of frames in a single AMPDU
+ *	that this station is allowed to transmit to us.
+ *	Can be modified by driver.
  * @wme: indicates whether the STA supports QoS/WME (if local devices does,
  *	otherwise always false)
  * @drv_priv: data area for driver use, will always be aligned to
@@ -1775,6 +1778,7 @@ struct ieee80211_sta {
 	u16 aid;
 	struct ieee80211_sta_ht_cap ht_cap;
 	struct ieee80211_sta_vht_cap vht_cap;
+	u8 max_rx_aggregation_subframes;
 	bool wme;
 	u8 uapsd_queues;
 	u8 max_sp;
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index a9aff60..bcf8a7e 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -298,10 +298,13 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 		buf_size = IEEE80211_MAX_AMPDU_BUF;
 
 	/* make sure the size doesn't exceed the maximum supported by the hw */
-	if (buf_size > local->hw.max_rx_aggregation_subframes)
-		buf_size = local->hw.max_rx_aggregation_subframes;
+	if (buf_size > sta->sta.max_rx_aggregation_subframes)
+		buf_size = sta->sta.max_rx_aggregation_subframes;
 	params.buf_size = buf_size;
 
+	ht_dbg(sta->sdata, "AddBA Req buf_size=%d for %pM\n",
+			buf_size, sta->sta.addr);
+
 	/* examine state machine */
 	mutex_lock(&sta->ampdu_mlme.mtx);
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 19f14c9..5e70fa5 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -340,6 +340,9 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 
 	memcpy(sta->addr, addr, ETH_ALEN);
 	memcpy(sta->sta.addr, addr, ETH_ALEN);
+	sta->sta.max_rx_aggregation_subframes =
+		local->hw.max_rx_aggregation_subframes;
+
 	sta->local = local;
 	sta->sdata = sdata;
 	sta->rx_stats.last_rx = jiffies;
-- 
2.9.0
