Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:34544 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761097Ab2DKTyM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:54:12 -0400
Received: by lagj5 with SMTP id j5so1408597lag.17
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:54:08 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 21/24] wlcore: set max_rx_agg_subframes in mac80211 according to HT conf
Date: Wed, 11 Apr 2012 22:53:37 +0300
Message-Id: <1334174020-18957-22-git-send-email-coelho@ti.com> (sfid-20120411_215443_633705_80DC486E)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The max Rx aggregation subframes configured to FW must be the same
number given to the upper layers (mac80211). Derive both from the same
value, given in the conf struct.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index ef0d04e..730bbb1 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4740,7 +4740,7 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->sta_data_size = sizeof(struct wl1271_station);
 	wl->hw->vif_data_size = sizeof(struct wl12xx_vif);
 
-	wl->hw->max_rx_aggregation_subframes = 8;
+	wl->hw->max_rx_aggregation_subframes = wl->conf.ht.rx_ba_win_size;
 
 	return 0;
 }
-- 
1.7.5.4

