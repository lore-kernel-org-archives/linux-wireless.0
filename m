Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:20693 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab0KVK7e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 05:59:34 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-sa02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oAMAxWBM013101
	for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 12:59:32 +0200
From: juuso.oikarinen@nokia.com
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCHv3] wl12xx: Unset bssid filter, ssid and bssid from firmware on disassoc
Date: Mon, 22 Nov 2010 12:59:08 +0200
Message-Id: <1290423548-29861-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

On the disassociation event from the mac80211, the wl12xx driver does not
clear the chipset configuration related to the AP - i.e. it does not perform
a DISCONNECT and then a JOIN with zero SSID and dummy BSSID. Also, it does not
unset the BSSID filter.

Often this is not a problem, as the above is performed upon entering idle
state. But if a scenario arises where a new association is attempted without
cycling through idle state, the new association will fail.

Fix this by resetting the firmware state on disassociation.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
v2: Changed the function calls to ones with a bit narrower scope
v3: Moved the function calls slightly forward, no functional change
v4: This time the v3 changes also committed. Sorry for this :(

 drivers/net/wireless/wl12xx/main.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 31f0e2f..708ffe3 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2011,9 +2011,12 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 
 			/* Disable the keep-alive feature */
 			ret = wl1271_acx_keep_alive_mode(wl, false);
-
 			if (ret < 0)
 				goto out_sleep;
+
+			/* restore the bssid filter and go to dummy bssid */
+			wl1271_unjoin(wl);
+			wl1271_dummy_join(wl);
 		}
 
 	}
-- 
1.7.1

