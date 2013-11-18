Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:58413 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3KRW2U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 17:28:20 -0500
Received: by mail-ie0-f179.google.com with SMTP id u16so9402328iet.24
        for <linux-wireless@vger.kernel.org>; Mon, 18 Nov 2013 14:28:20 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
	Bob Copeland <bob@cozybit.com>
Subject: [PATCH] mac80211: mesh: only get tsf if we need it
Date: Mon, 18 Nov 2013 17:25:28 -0500
Message-Id: <1384813528-30359-1-git-send-email-me@bobcopeland.com> (sfid-20131118_232824_493982_042F3AF5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The local TSF timer is used to compute the timing offset between
mesh peers on beacon reception.  However, asking the device for
the TSF is not very accurate, so we prefer to use rx->mactime
if available.  In the latter case, calling drv_get_tsf() just
adds more delay into the RX path, so skip it if we can.

Signed-off-by: Bob Copeland <bob@cozybit.com>
---
 net/mac80211/mesh_sync.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index 05a256b..d1cf2d5 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -92,12 +92,20 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	if (stype != IEEE80211_STYPE_BEACON)
 		return;
 
-	/* The current tsf is a first approximation for the timestamp
-	 * for the received beacon.  Further down we try to get a
-	 * better value from the rx_status->mactime field if
-	 * available. Also we have to call drv_get_tsf() before
-	 * entering the rcu-read section.*/
-	t_r = drv_get_tsf(local, sdata);
+	/*
+	 * Get time when timestamp field was received.  If we don't
+	 * have rx timestamps, then use current tsf as an approximation.
+	 * drv_get_tsf() must be called before entering the rcu-read
+	 * section.
+	 */
+	if (ieee80211_have_rx_timestamp(rx_status))
+		t_r = ieee80211_calculate_rx_timestamp(local, rx_status,
+						       24 + 12 +
+						       elems->total_len +
+						       FCS_LEN,
+						       24);
+	else
+		t_r = drv_get_tsf(local, sdata);
 
 	rcu_read_lock();
 	sta = sta_info_get(sdata, mgmt->sa);
@@ -117,14 +125,6 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 		goto no_sync;
 	}
 
-	if (ieee80211_have_rx_timestamp(rx_status))
-		/* time when timestamp field was received */
-		t_r = ieee80211_calculate_rx_timestamp(local, rx_status,
-						       24 + 12 +
-						       elems->total_len +
-						       FCS_LEN,
-						       24);
-
 	/* Timing offset calculation (see 13.13.2.2.2) */
 	t_t = le64_to_cpu(mgmt->u.beacon.timestamp);
 	sta->t_offset = t_t - t_r;
-- 
1.7.10.4

