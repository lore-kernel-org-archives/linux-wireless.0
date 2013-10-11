Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46809 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab3JKNsr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 09:48:47 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Thomas Lindroth <thomas.lindroth@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix crash if bitrate calculation goes wrong
Date: Fri, 11 Oct 2013 15:48:43 +0200
Message-Id: <1381499323-6502-1-git-send-email-johannes@sipsolutions.net> (sfid-20131011_154850_844212_E7EE972C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If a frame's timestamp is calculated, and the bitrate
calculation goes wrong and returns zero, the system
will attempt to divide by zero and crash. Catch this
case and print the rate information that the driver
reported when this happens.

Reported-by: Thomas Lindroth <thomas.lindroth@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 9c3200b..69e4ef5 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2238,6 +2238,10 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 	}
 
 	rate = cfg80211_calculate_bitrate(&ri);
+	if (WARN_ONCE(!rate,
+		      "Invalid bitrate: flags=0x%x, idx=%d, vht_nss=%d\n",
+		      status->flag, status->rate_idx, status->vht_nss))
+		return 0;
 
 	/* rewind from end of MPDU */
 	if (status->flag & RX_FLAG_MACTIME_END)
-- 
1.8.4.rc3

