Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57714 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2KTLUR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 06:20:17 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1625946eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 03:20:16 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 04/11] wlcore: get channel from bss_conf instead of hw->conf
Date: Tue, 20 Nov 2012 13:20:04 +0200
Message-Id: <1353410411-18833-5-git-send-email-eliad@wizery.com> (sfid-20121120_122025_083640_451834D1)
In-Reply-To: <1353410411-18833-1-git-send-email-eliad@wizery.com>
References: <1353410411-18833-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We care only about the operational channel, not
about the temporal hw channel (which won't have
any real meaning in multi-channel env anyway)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index e9a8092..18ac8d1 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3977,7 +3977,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			goto sta_not_found;
 
 		/* save the supp_rates of the ap */
-		sta_rate_set = sta->supp_rates[wl->hw->conf.channel->band];
+		sta_rate_set = sta->supp_rates[wlvif->band];
 		if (sta->ht_cap.ht_supported)
 			sta_rate_set |=
 			  (sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET) |
-- 
1.7.6.401.g6a319

