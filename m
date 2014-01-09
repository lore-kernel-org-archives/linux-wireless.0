Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:42901 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbaAITCC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 14:02:02 -0500
Received: by mail-lb0-f169.google.com with SMTP id u14so2686989lbd.28
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jan 2014 11:02:01 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 9 Jan 2014 14:02:00 -0500
Message-ID: <CAN44aq1AQYHDUsU6wVf01NcWS9EWnJe0BwF+Ygv1kqZ7M8AwgA@mail.gmail.com> (sfid-20140109_200207_631965_78552137)
Subject: [PATCH v3] wl12xx: fix tx power setting
From: Alex Gal <a.gal@motsai.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for the previous format.

Fixes wl12xx tx power.

Signed-off-by: Alex Gal <a.gal@motsai.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c
b/drivers/net/wireless/ti/wlcore/main.c
index e9da47c..cbbfc50 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4457,6 +4457,16 @@ static void wl1271_op_bss_info_changed(struct
ieee80211_hw *hw,
        if (ret < 0)
                goto out;

+       if ((changed & BSS_CHANGED_TXPOWER) &&
+               bss_conf->txpower != wlvif->power_level) {
+
+               ret = wl1271_acx_tx_power(wl, wlvif, bss_conf->txpower);
+               if (ret < 0)
+                       goto out;
+
+               wlvif->power_level = bss_conf->txpower;
+       }
+
        if (is_ap)
                wl1271_bss_info_changed_ap(wl, vif, bss_conf, changed);
        else
-- 
1.8.5.2
