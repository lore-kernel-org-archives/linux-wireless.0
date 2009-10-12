Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:64659 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927AbZJLMLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 08:11:05 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 15/16] wl1271: use acx_rx_config instead of join when updating filters
Date: Mon, 12 Oct 2009 15:08:56 +0300
Message-Id: <1255349337-9776-16-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
References: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We shouldn't use a join command to change the filter settings while
associated.  The right way to do it is to use ACX_RX_CFG.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 5ef0bd5..fc0d03f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -422,7 +422,7 @@ static void wl1271_filter_work(struct work_struct *work)
 		goto out;
 
 	/* apply configured filters */
-	ret = wl1271_cmd_join(wl);
+	ret = wl1271_acx_rx_config(wl, wl->rx_config, wl->rx_filter);
 	if (ret < 0)
 		goto out_sleep;
 
@@ -869,6 +869,8 @@ static u64 wl1271_op_prepare_multicast(struct ieee80211_hw *hw, int mc_count,
 			wl1271_warning("Unknown mc address length.");
 	}
 
+	/* FIXME: We still need to set our filters properly */
+
 	spin_lock_irqsave(&wl->wl_lock, flags);
 	kfree(wl->filter_params);
 	wl->filter_params = fp;
-- 
1.5.6.5

