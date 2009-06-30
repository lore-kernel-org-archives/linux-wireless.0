Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:39855 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbZF3MtO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 08:49:14 -0400
Received: by fxm18 with SMTP id 18so104979fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2009 05:49:16 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] mac80211: shorten the passive dwell time for sw scans
Date: Tue, 30 Jun 2009 14:49:18 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Holger Schurig <hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200906301449.18911.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211's software scan implementation uses a passive dwell time of
(HZ / 5) which means we stay 200ms on each passive channel. Compared
to iwlwifi's hw scan and the old ipw* drivers which use values around
120ms this is quite long.

Reducing the passive dwell time from 200ms to 125ms should save us
something around a second on cards capable of 11a and we should still be
able to catch beacons from most access points (assuming a ~100ms beacon
interval).

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index df24f8e..c075d34 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -26,7 +28,7 @@
 
 #define IEEE80211_PROBE_DELAY (HZ / 33)
 #define IEEE80211_CHANNEL_TIME (HZ / 33)
-#define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 5)
+#define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 8)
 
 struct ieee80211_bss *
 ieee80211_rx_bss_get(struct ieee80211_local *local, u8 *bssid, int freq,
