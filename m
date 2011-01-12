Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:50950 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331Ab1ALMkj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 07:40:39 -0500
From: <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: juuso.oikarinen@nokia.com
Subject: [PATCH 2/2] wl12xx: add hw configuration for max supported AMDPU size
Date: Wed, 12 Jan 2011 14:40:52 +0200
Message-ID: <1294836052-16828-2-git-send-email-coelho@ti.com>
In-Reply-To: <1294836052-16828-1-git-send-email-coelho@ti.com>
References: <1294836052-16828-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

The wl12xx chips do the AMDPU aggregation work in the firmware, but it
supports a maximum of 8 frames per block.  Configure the mac80211 hw
structure accordingly.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 67732ea..463d6bf 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3178,6 +3178,8 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 
 	wl->hw->sta_data_size = sizeof(struct wl1271_station);
 
+	wl->hw->max_rx_aggregation_subframes = 8;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(wl1271_init_ieee80211);
-- 
1.7.1

