Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61082 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab1ECJMQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:12:16 -0400
Received: by wya21 with SMTP id 21so4783575wya.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 02:12:15 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [RFC] mac80211: reestablish mis-configured existing Rx BA sessions
Date: Tue,  3 May 2011 12:12:08 +0300
Message-Id: <1304413928-17673-1-git-send-email-arik@wizery.com> (sfid-20110503_111219_228219_5FAC747C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When forming a Rx BA session, sometimes the ADDBA response gets lost.
This leads to a situation where the session is configured locally, but
doesn't exist on the remote side. Subsequent ADDBA requests are declined
by mac80211.

Fix this by assuming the session state of the initiator is the correct
one. When receiving an unexpected ADDBA request on a TID with an active
Rx BA session, delete the existing one and establish a new session.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/agg-rx.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 0c9d0c0..5c35bd3 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -246,7 +246,11 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 				"%pM on tid %u\n",
 				mgmt->sa, tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
-		goto end;
+
+		/* delete existing Rx BA session on the same tid */
+		___ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_RECIPIENT,
+						WLAN_STATUS_UNSPECIFIED_QOS,
+						false);
 	}
 
 	/* prepare A-MPDU MLME for Rx aggregation */
-- 
1.7.4.1

