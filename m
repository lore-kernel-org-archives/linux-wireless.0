Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:42863 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202Ab1ALN0q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 08:26:46 -0500
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id p0CDQkbm028838
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 07:26:46 -0600
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep34.itg.ti.com (8.13.7/8.13.7) with ESMTP id p0CDQj97025466
	for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 07:26:45 -0600 (CST)
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id p0CDQjt2011980
	for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 07:26:45 -0600 (CST)
From: <coelho@ti.com>
To: <coelho@ti.com>
CC: linux-wireless@vger.kernel.org
Subject: [PATCH v2] wl12xx: add hw configuration for max supported AMDPU size
Date: Wed, 12 Jan 2011 15:27:03 +0200
Message-ID: <1294838823-444-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

The wl12xx chips do the AMDPU aggregation work in the firmware, but it
supports a maximum of 8 frames per block.  Configure the mac80211 hw
structure accordingly.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Tested-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
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

