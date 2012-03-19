Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52904 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066Ab2CSJci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 05:32:38 -0400
Received: by wibhq7 with SMTP id hq7so3555150wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2012 02:32:37 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: free ap keys only in ap mode
Date: Mon, 19 Mar 2012 11:32:55 +0200
Message-Id: <1332149575-22284-1-git-send-email-eliad@wizery.com> (sfid-20120319_103240_827772_6BE49549)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ap keys should be freed only when removing
ap role (otherwise, some arbitrary data might
get freed).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 3900236..8cfbc95 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2360,10 +2360,10 @@ deinit:
 		for (i = 0; i < CONF_TX_MAX_AC_COUNT; i++)
 			wl12xx_free_rate_policy(wl,
 						&wlvif->ap.ucast_rate_idx[i]);
+		wl1271_free_ap_keys(wl, wlvif);
 	}
 
 	wl12xx_tx_reset_wlvif(wl, wlvif);
-	wl1271_free_ap_keys(wl, wlvif);
 	if (wl->last_wlvif == wlvif)
 		wl->last_wlvif = NULL;
 	list_del(&wlvif->list);
-- 
1.7.6.401.g6a319

