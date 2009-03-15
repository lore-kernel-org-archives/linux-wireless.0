Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:43190 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbZCOUIk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2009 16:08:40 -0400
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [PATCH v2] mac80211: don't drop null frames during software scan
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Date: Sun, 15 Mar 2009 22:07:39 +0200
Message-ID: <20090315200738.17370.29374.stgit@tikku> (sfid-20090315_210843_679772_0C91E0A5)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_tx_h_check_assoc() was dropping everything else than probe
requests during software scan. So the null frame with the power save
bit was dropped and AP never received it. This meant that AP never
buffered any frames for the station during software scan.

Fix this by allowing to transmit both probe request and null frames
during software scan. Tested with stlc45xx.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 net/mac80211/scan.c |    5 +++++
 net/mac80211/tx.c   |    9 ++++++++-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 0e81e16..fae18c3 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -397,6 +397,11 @@ int ieee80211_start_scan(struct ieee80211_sub_if_data *scan_sdata,
 		return 0;
 	}
 
+	/*
+	 * While local->sw_scanning is true everything else but null
+	 * frames and probe requests will be dropped in
+	 * ieee80211_tx_h_check_assoc().
+	 */
 	local->sw_scanning = true;
 	if (local->ops->sw_scan_start)
 		local->ops->sw_scan_start(local_to_hw(local));
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c3f0e95..bfe6ecd 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -193,7 +193,14 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 		return TX_CONTINUE;
 
 	if (unlikely(tx->local->sw_scanning) &&
-	    !ieee80211_is_probe_req(hdr->frame_control))
+	    !ieee80211_is_probe_req(hdr->frame_control) &&
+	    !ieee80211_is_nullfunc(hdr->frame_control))
+		/*
+		 * When software scanning only null frames (to notify the
+		 * sleep state to the AP) and probe requests (for the
+		 * active scan) are allowed, everything else should be
+		 * dropped.
+		 */
 		return TX_DROP;
 
 	if (tx->sdata->vif.type == NL80211_IFTYPE_MESH_POINT)

