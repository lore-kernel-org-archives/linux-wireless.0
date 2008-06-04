Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608AbYFDR74 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 13:59:56 -0400
Subject: [PATCH] mac80211: decrease IBSS creation latency
From: Dan Williams <dcbw@redhat.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 13:59:34 -0400
Message-Id: <1212602374.20764.22.camel@localhost.localdomain> (sfid-20080604_200010_457432_D97BD493)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sufficient scans (at least 2 or 3) should have been done within 7
seconds to find an existing IBSS to join.  This should improve IBSS
creation latency; and since IBSS merging is still in effect, shouldn't
have detrimental effects on eventual IBSS convergence.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c220bed..a345ded 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -44,7 +44,7 @@
 #define IEEE80211_RETRY_AUTH_INTERVAL (1 * HZ)
 #define IEEE80211_SCAN_INTERVAL (2 * HZ)
 #define IEEE80211_SCAN_INTERVAL_SLOW (15 * HZ)
-#define IEEE80211_IBSS_JOIN_TIMEOUT (20 * HZ)
+#define IEEE80211_IBSS_JOIN_TIMEOUT (7 * HZ)
 
 #define IEEE80211_PROBE_DELAY (HZ / 33)
 #define IEEE80211_CHANNEL_TIME (HZ / 33)


