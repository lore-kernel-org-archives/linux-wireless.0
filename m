Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56093 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab1HWMzN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 08:55:13 -0400
Received: by fxh19 with SMTP id 19so213188fxh.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 05:55:12 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] wl12xx: initialize rate_set on band rates initialization
Date: Tue, 23 Aug 2011 15:56:23 +0300
Message-Id: <1314104183-31612-2-git-send-email-eliad@wizery.com> (sfid-20110823_145518_568495_07FCB3D2)
In-Reply-To: <1314104183-31612-1-git-send-email-eliad@wizery.com>
References: <1314104183-31612-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some corner cases, (invalid) 11g rates were used while
working on 11a band.

Take care of it by initializing rate_set according to the
configured band.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 82f4408..9094fa5 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2199,10 +2199,14 @@ out:
 
 static void wl1271_set_band_rate(struct wl1271 *wl)
 {
-	if (wl->band == IEEE80211_BAND_2GHZ)
+	if (wl->band == IEEE80211_BAND_2GHZ) {
 		wl->basic_rate_set = wl->conf.tx.basic_rate;
-	else
+		wl->rate_set = wl->conf.tx.basic_rate;
+	} else {
 		wl->basic_rate_set = wl->conf.tx.basic_rate_5;
+		wl->rate_set = wl->conf.tx.basic_rate_5;
+	}
+
 }
 
 static bool wl12xx_is_roc(struct wl1271 *wl)
-- 
1.7.6.401.g6a319

