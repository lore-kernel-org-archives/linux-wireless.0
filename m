Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:57872 "EHLO bear.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751694AbcHULRK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Aug 2016 07:17:10 -0400
From: Maxim Altshul <maxim.altshul@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <kvalo@codeaurora.org>, <johannes@sipsolutions.net>,
        Maxim Altshul <maxim.altshul@ti.com>
Subject: [PATCH 1/3 v2] mac80211: RX BA support for sta max_rx_aggregation_subframes
Date: Sun, 21 Aug 2016 14:24:23 +0300
Message-ID: <20160821112425.11302-1-maxim.altshul@ti.com> (sfid-20160821_131718_993574_4B8311A3)
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

This patch will:
a. Make the subframe limitation to be held by each station,
instead of being held only by hw.
b. Create an api for the driver to call which will remove violating
BA sessions with a specific peer. When the session is reopened, it
will use the new size, limiting the aggregation.

Signed-off-by: Maxim Altshul <maxim.altshul@ti.com>
---
Change documentation and removed unnecessary function

 include/net/mac80211.h  |  4 ++++
 net/mac80211/agg-rx.c   | 10 ++++++----
 net/mac80211/sta_info.c |  3 +++
 3 files changed, 13 insertions(+), 4 deletions(-)

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
index a9aff60..8532e36 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -297,13 +297,15 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 	if (buf_size == 0)
 		buf_size = IEEE80211_MAX_AMPDU_BUF;
 
+	/* examine state machine */
+	mutex_lock(&sta->ampdu_mlme.mtx);
+
 	/* make sure the size doesn't exceed the maximum supported by the hw */
-	if (buf_size > local->hw.max_rx_aggregation_subframes)
-		buf_size = local->hw.max_rx_aggregation_subframes;
+	if (buf_size > sta->sta.max_rx_aggregation_subframes)
+		buf_size = sta->sta.max_rx_aggregation_subframes;
 	params.buf_size = buf_size;
 
-	/* examine state machine */
-	mutex_lock(&sta->ampdu_mlme.mtx);
+	ht_dbg(sta->sdata, "AddBA Req buf_size=%d\n", buf_size);
 
 	if (test_bit(tid, sta->ampdu_mlme.agg_session_valid)) {
 		tid_agg_rx = rcu_dereference_protected(
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
