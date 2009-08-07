Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:46047 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442AbZHGKfs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 06:35:48 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 23/23] wl1251: hack to disable filters for fixing association
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Aug 2009 13:35:33 +0300
Message-ID: <20090807103533.31717.69122.stgit@tikku>
In-Reply-To: <20090807102732.31717.84006.stgit@tikku>
References: <20090807102732.31717.84006.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Commit 9cef8737 "mac80211: fix managed mode BSSID handling" broke
association in wl1251, most probably because the driver configured
the bssid filter incorrectly. Workaround this by disabling filter
altogether. This needs to be fixed properly soon.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_cmd.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.c b/drivers/net/wireless/wl12xx/wl1251_cmd.c
index 6cd024b..770f260 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.c
@@ -276,6 +276,15 @@ int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u8 channel,
 	join->rx_config_options = wl->rx_config;
 	join->rx_filter_options = wl->rx_filter;
 
+	/*
+	 * FIXME: disable temporarily all filters because after commit
+	 * 9cef8737 "mac80211: fix managed mode BSSID handling" broke
+	 * association. The filter logic needs to be implemented properly
+	 * and once that is done, this hack can be removed.
+	 */
+	join->rx_config_options = 0;
+	join->rx_filter_options = WL1251_DEFAULT_RX_FILTER;
+
 	join->basic_rate_set = RATE_MASK_1MBPS | RATE_MASK_2MBPS |
 		RATE_MASK_5_5MBPS | RATE_MASK_11MBPS;
 

