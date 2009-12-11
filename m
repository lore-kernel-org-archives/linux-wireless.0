Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:50873 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762210AbZLKLmc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 06:42:32 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 08/31] wl1271: check result code from the join command
Date: Fri, 11 Dec 2009 13:40:59 +0200
Message-Id: <1260531682-4695-9-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
References: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were not checking the return value from the call to wl1271_cmd_join().
Added a check to make things more reliable.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index f6d42e6..ffd615e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1545,7 +1545,11 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	    memcmp(wl->bssid, bss_conf->bssid, ETH_ALEN)) {
 			wl->rx_config |= CFG_BSSID_FILTER_EN;
 			memcpy(wl->bssid, bss_conf->bssid, ETH_ALEN);
-			wl1271_cmd_join(wl);
+			ret = wl1271_cmd_join(wl);
+			if (ret < 0) {
+				wl1271_warning("cmd join failed %d", ret);
+				goto out_sleep;
+			}
 			wl->joined = true;
 	}
 
-- 
1.6.3.3

