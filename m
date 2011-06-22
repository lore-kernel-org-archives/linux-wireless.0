Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48044 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758127Ab1FVWPd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 18:15:33 -0400
Received: by wyb38 with SMTP id 38so889109wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 15:15:31 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: reestablish mis-configured existing Rx BA sessions
Date: Thu, 23 Jun 2011 01:15:27 +0300
Message-Id: <1308780927-20987-1-git-send-email-arik@wizery.com> (sfid-20110623_001536_206292_3B0DFE44)
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
index 9c0d76c..f0a4d90 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -247,7 +247,11 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
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

