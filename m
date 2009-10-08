Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:23083 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759686AbZJHS6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 14:58:43 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>
Subject: [PATCH 12/20] wl1271: hack to disable filters
Date: Thu,  8 Oct 2009 21:56:28 +0300
Message-Id: <1255028196-6565-13-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
References: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a hack to disable all filters in the join command.  This is based on
Kalle Valo's patch for wl1251.

Cc: Kalle Valo <kalle.valo@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 35a6e67..ac93efd 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -208,6 +208,15 @@ int wl1271_cmd_join(struct wl1271 *wl)
 	join->rx_config_options = wl->rx_config;
 	join->rx_filter_options = wl->rx_filter;
 
+	/*
+	 * FIXME: disable temporarily all filters because after commit
+	 * 9cef8737 "mac80211: fix managed mode BSSID handling" broke
+	 * association. The filter logic needs to be implemented properly
+	 * and once that is done, this hack can be removed.
+	 */
+	join->rx_config_options = 0;
+	join->rx_filter_options = WL1271_DEFAULT_RX_FILTER;
+
 	join->basic_rate_set = RATE_MASK_1MBPS | RATE_MASK_2MBPS |
 		RATE_MASK_5_5MBPS | RATE_MASK_11MBPS;
 
-- 
1.5.6.5

