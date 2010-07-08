Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:32075 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab0GHOui (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 10:50:38 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 13/13] wl1271: use per-channel max tx power passed by mac80211 when scanning
Date: Thu,  8 Jul 2010 17:50:08 +0300
Message-Id: <1278600608-22411-14-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
References: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were always using the max transmit power when scanning.  Now we use the
values passed to the driver by the mac80211 stack, so that we comply with
regulations.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_scan.c b/drivers/net/wireless/wl12xx/wl1271_scan.c
index 567d759..e13c559 100644
--- a/drivers/net/wireless/wl12xx/wl1271_scan.c
+++ b/drivers/net/wireless/wl12xx/wl1271_scan.c
@@ -65,7 +65,7 @@ static int wl1271_get_scan_channels(struct wl1271 *wl,
 			channels[j].max_duration =
 				cpu_to_le32(WL1271_SCAN_CHAN_MAX_DURATION);
 			channels[j].early_termination = 0;
-			channels[j].tx_power_att = WL1271_SCAN_CURRENT_TX_PWR;
+			channels[j].tx_power_att = req->channels[i]->max_power;
 			channels[j].channel = req->channels[i]->hw_value;
 
 			memset(&channels[j].bssid_lsb, 0xff, 4);
-- 
1.6.3.3

