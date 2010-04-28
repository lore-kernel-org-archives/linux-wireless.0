Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:25504 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab0D1Gu5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 02:50:57 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
Subject: [PATCH 2/4] wl1271: Configure QOS nullfunc template for U-APSD
Date: Wed, 28 Apr 2010 09:50:00 +0300
Message-Id: <1272437402-28801-3-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1272437402-28801-1-git-send-email-luciano.coelho@nokia.com>
References: <1272437402-28801-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>

When U-APSD is enabled, device is not sending power save
state notifications to AP using QOS nullfunc frames.

This patch configures nullfunc templates needed for U-APSD.

Signed-off-by: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index e53dfc9..26e8fb1 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1708,6 +1708,10 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			if (ret < 0)
 				goto out_sleep;
 
+			ret = wl1271_build_qos_null_data(wl);
+			if (ret < 0)
+				goto out_sleep;
+
 			/* filter out all packets not from this BSSID */
 			wl1271_configure_filters(wl, 0);
 
-- 
1.6.3.3

