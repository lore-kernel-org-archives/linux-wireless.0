Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:59668 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbZGaQRH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 12:17:07 -0400
Received: by fxm17 with SMTP id 17so1463985fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 09:17:07 -0700 (PDT)
Subject: [PATCH 002/002] [MAC80211] Increase timeouts for station polling
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1249056817.20593.1.camel@maxim-laptop>
References: <1249056817.20593.1.camel@maxim-laptop>
Content-Type: text/plain
Date: Fri, 31 Jul 2009 19:17:00 +0300
Message-Id: <1249057021.20593.5.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 04976d22d45f26aa4b4dece5dd520e3347ac32d7 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Fri, 31 Jul 2009 18:54:23 +0300
Subject: [PATCH] [MAC80211] Increase timeouts for station polling

Do a probe request every 30 seconds, and wait for probe response, half a second
This should lower the traffic that card sends, thus save power
Wainting longer for response makes probe more robust against 'slow' access points

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 net/mac80211/mlme.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1d8640a..e4bb590 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -42,13 +42,13 @@
  * Time the connection can be idle before we probe
  * it to see if we can still talk to the AP.
  */
-#define IEEE80211_CONNECTION_IDLE_TIME	(2 * HZ)
+#define IEEE80211_CONNECTION_IDLE_TIME	(30 * HZ)
 /*
  * Time we wait for a probe response after sending
  * a probe request because of beacon loss or for
  * checking the connection still works.
  */
-#define IEEE80211_PROBE_WAIT		(HZ / 5)
+#define IEEE80211_PROBE_WAIT		(HZ / 2)
 
 #define TMR_RUNNING_TIMER	0
 #define TMR_RUNNING_CHANSW	1
-- 
1.6.0.4



