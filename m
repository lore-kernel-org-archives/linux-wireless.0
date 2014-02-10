Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:42714 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbaBJLsL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 06:48:11 -0500
Received: by mail-we0-f174.google.com with SMTP id x55so4059360wes.5
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 03:48:10 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 18/18] wlcore: add support for STA CSA with chan contexts
Date: Mon, 10 Feb 2014 13:47:34 +0200
Message-Id: <1392032854-28126-19-git-send-email-eliad@wizery.com> (sfid-20140210_130007_320704_54A93ABE)
In-Reply-To: <1392032854-28126-1-git-send-email-eliad@wizery.com>
References: <1392032854-28126-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

TI wl12xx/wl18xx cards support channel switch via a driver specific
switch_channel op while operating with channel contexts.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 82d5461..7aae5b3 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5737,7 +5737,8 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 		IEEE80211_HW_AP_LINK_PS |
 		IEEE80211_HW_AMPDU_AGGREGATION |
 		IEEE80211_HW_TX_AMPDU_SETUP_IN_HW |
-		IEEE80211_HW_QUEUE_CONTROL;
+		IEEE80211_HW_QUEUE_CONTROL |
+		IEEE80211_HW_CHANCTX_STA_CSA;
 
 	wl->hw->wiphy->cipher_suites = cipher_suites;
 	wl->hw->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
-- 
1.8.5.2.229.g4448466.dirty

