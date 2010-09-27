Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:56014 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932833Ab0I0IiS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:38:18 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8bvwV023998
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 11:38:15 +0300
Received: from localhost.localdomain (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-da02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8boh1022566
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 11:37:57 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 05/25] wl1271: remove useless 11a check when scanning
Date: Mon, 27 Sep 2010 11:37:29 +0300
Message-Id: <1285576669-8070-6-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This code was a leftover of the previous scanning mechanism.  The if is
totally unnecessary, since both branches do the same thing.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 02ad6c6..b42ee48 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1624,10 +1624,7 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
-	if (wl1271_11a_enabled())
-		ret = wl1271_scan(hw->priv, ssid, len, req);
-	else
-		ret = wl1271_scan(hw->priv, ssid, len, req);
+	ret = wl1271_scan(hw->priv, ssid, len, req);
 
 	wl1271_ps_elp_sleep(wl);
 
-- 
1.6.3.3

