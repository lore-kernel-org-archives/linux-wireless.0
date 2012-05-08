Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:53756 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530Ab2EHLH2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 07:07:28 -0400
Received: by obbwd18 with SMTP id wd18so4880158obb.28
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 04:07:25 -0700 (PDT)
From: Yoni Divinsky <yoni.divinsky@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <arik@wizery.com>, <coelho@ti.com>
Subject: [PATCH 1/4] wlcore: use psd_type indexing according to spec
Date: Tue,  8 May 2012 14:02:11 +0300
Message-Id: <1336474934-22069-1-git-send-email-yoni.divinsky@ti.com> (sfid-20120508_130731_999622_D9C1F923)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In ieee80211.h the uapsd bit mask is defined such that
VO=BIT(0), VI=BIT(1), BK=BIT(2), BE=BIT(3).
The firmware uses the indexing as defined in the ieee80211
spec, meaning that VO=3, VI=2, BK=1, BE=0.

In AP mode when adding peer wlcore needs to convert
the indexing accordingly.

Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 5b128a9..576c5bc 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1346,9 +1346,12 @@ int wl12xx_cmd_add_peer(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 	for (i = 0; i < NUM_ACCESS_CATEGORIES_COPY; i++)
 		if (sta->wme && (sta->uapsd_queues & BIT(i)))
-			cmd->psd_type[i] = WL1271_PSD_UPSD_TRIGGER;
+			cmd->psd_type[NUM_ACCESS_CATEGORIES_COPY-1-i] =
+					WL1271_PSD_UPSD_TRIGGER;
 		else
-			cmd->psd_type[i] = WL1271_PSD_LEGACY;
+			cmd->psd_type[NUM_ACCESS_CATEGORIES_COPY-1-i] =
+					WL1271_PSD_LEGACY;
+
 
 	sta_rates = sta->supp_rates[wlvif->band];
 	if (sta->ht_cap.ht_supported)
-- 
1.7.0.4

