Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:62665 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650Ab3EGMlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 08:41:21 -0400
Received: by mail-we0-f170.google.com with SMTP id u54so446520wes.29
        for <linux-wireless@vger.kernel.org>; Tue, 07 May 2013 05:41:20 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] wlcore: configure rates in multiple cases
Date: Tue,  7 May 2013 15:41:08 +0300
Message-Id: <1367930469-29826-2-git-send-email-eliad@wizery.com> (sfid-20130507_144126_250500_4E286FB4)
In-Reply-To: <1367930469-29826-1-git-send-email-eliad@wizery.com>
References: <1367930469-29826-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current code configures the peer caps only on BSS_CHANGED_HT
notification. However, we have to configure the peer caps
(and rates) even when HT is not enabled. Otherwise, the fw
continues working with low rates.

Configure the peer caps when sta_exists is true (i.e. when
we extracted the sta rates, e.g. on association).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d220ae6..26d0d757 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4230,8 +4230,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 	}
 
 	/* Handle new association with HT. Do this after join. */
-	if (sta_exists &&
-	    (changed & BSS_CHANGED_HT)) {
+	if (sta_exists) {
 		bool enabled =
 			bss_conf->chandef.width != NL80211_CHAN_WIDTH_20_NOHT;
 
-- 
1.8.1.2

