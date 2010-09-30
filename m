Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:55953 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0I3Ko1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 06:44:27 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8UAi0KV030856
	for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 05:44:26 -0500
From: juuso.oikarinen@nokia.com
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] wl1271: Indicate disconnection on hardware failure
Date: Thu, 30 Sep 2010 13:43:27 +0300
Message-Id: <1285843408-6726-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

In the event of a hardware failure, reconfiguring a live connection back
with the wl1271 chip does not work as expected. The chip has management
features which require setting up the association from scratch to work
correctly. To ensure this is done every time, in managed mode, when associated,
indicate connection loss to the mac80211 before asking to reconfigure the
hardware.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index cb18f22..2253458 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -636,6 +636,9 @@ static void wl1271_recovery_work(struct work_struct *work)
 
 	wl1271_info("Hardware recovery in progress.");
 
+	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
+		ieee80211_connection_loss(wl->vif);
+
 	/* reboot the chipset */
 	__wl1271_op_remove_interface(wl);
 	ieee80211_restart_hw(wl->hw);
-- 
1.6.3.3

