Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65056 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab2KSQjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 11:39:44 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1209576eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 08:39:43 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 07/15] wlcore: get channel from bss_conf instead of hw->conf
Date: Mon, 19 Nov 2012 18:39:22 +0200
Message-Id: <1353343170-26516-8-git-send-email-eliad@wizery.com> (sfid-20121119_173951_029276_5B8956F9)
In-Reply-To: <1353343170-26516-1-git-send-email-eliad@wizery.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
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
index ef299f9..4f4a9e5 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3833,7 +3833,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			goto sta_not_found;
 
 		/* save the supp_rates of the ap */
-		sta_rate_set = sta->supp_rates[wl->hw->conf.channel->band];
+		sta_rate_set = sta->supp_rates[wlvif->band];
 		if (sta->ht_cap.ht_supported)
 			sta_rate_set |=
 			  (sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET) |
-- 
1.7.6.401.g6a319

