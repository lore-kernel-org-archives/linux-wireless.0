Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49430 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932707AbcJRUMX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 16:12:23 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date: Tue, 18 Oct 2016 23:12:09 +0300
Message-Id: <20161018201213.18873-4-luca@coelho.fi> (sfid-20161018_221230_138902_29F23C09)
In-Reply-To: <20161018201213.18873-1-luca@coelho.fi>
References: <20161018201213.18873-1-luca@coelho.fi>
Subject: [PATCH 3/7] mac80211: improve RX aggregation data in debugfs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the driver sets the SUPPORTS_REORDERING_BUFFER hardware flag,
the debugfs data for RX aggregation sessions won't even indicate
that a session is open. Since the previous fix to store the dialog
token separately, we can indicate that it's open and add the token
so that there's at least some data (ssn is not available.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_sta.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 14ec63a..f6003b8 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -199,13 +199,18 @@ static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
 		       "TID\t\tRX\tDTKN\tSSN\t\tTX\tDTKN\tpending\n");
 
 	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
+		bool tid_rx_valid;
+
 		tid_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[i]);
 		tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[i]);
+		tid_rx_valid = test_bit(i, sta->ampdu_mlme.agg_session_valid);
 
 		p += scnprintf(p, sizeof(buf) + buf - p, "%02d", i);
-		p += scnprintf(p, sizeof(buf) + buf - p, "\t\t%x", !!tid_rx);
+		p += scnprintf(p, sizeof(buf) + buf - p, "\t\t%x",
+			       tid_rx_valid);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.2x",
-				tid_rx ? sta->ampdu_mlme.tid_rx_token[i] : 0);
+			       tid_rx_valid ?
+					sta->ampdu_mlme.tid_rx_token[i] : 0);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.3x",
 				tid_rx ? tid_rx->ssn : 0);
 
-- 
2.9.3
