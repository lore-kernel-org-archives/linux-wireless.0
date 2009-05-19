Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58986 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbZESRiD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 13:38:03 -0400
Subject: Re: [PATCH v2] mac80211: split out and decrease probe wait time
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1242151886.11924.5.camel@johannes.local>
References: <1242151393.11924.3.camel@johannes.local>
	 <1242151886.11924.5.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 19 May 2009 19:37:28 +0200
Message-Id: <1242754648.4797.46.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You know ... somehow I managed to send out v2 with a wrong interval.

This was supposed to be / 5 not / 20, should I send a separate patch or
would you roll this into the original? The commit log says 200ms, but
the code uses 50ms which is far too short.

johannes

---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-05-19 19:36:00.564057102 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-05-19 19:36:04.773067791 +0200
@@ -33,7 +33,7 @@
 #define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
 #define IEEE80211_ASSOC_MAX_TRIES 3
 #define IEEE80211_MONITORING_INTERVAL (2 * HZ)
-#define IEEE80211_PROBE_WAIT (HZ / 20)
+#define IEEE80211_PROBE_WAIT (HZ / 5)
 #define IEEE80211_PROBE_IDLE_TIME (60 * HZ)
 #define IEEE80211_RETRY_AUTH_INTERVAL (1 * HZ)
 


