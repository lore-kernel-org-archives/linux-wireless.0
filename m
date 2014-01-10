Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:43402 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaAJPla (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 10:41:30 -0500
Received: by mail-lb0-f176.google.com with SMTP id l4so3427940lbv.21
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jan 2014 07:41:29 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 10 Jan 2014 10:41:28 -0500
Message-ID: <CAN44aq2=SLJz0e1JLEg+OmoQ8fxpmrbokvWyjW3MokLbbr1vKA@mail.gmail.com> (sfid-20140110_164135_522411_371DD129)
Subject: [PATCH v4] wl12xx: fix tx power setting
From: Alex Gal <a.gal@motsai.com>
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My bad for the wrong format.

Fixes wl12xx tx power.

Signed-off-by: Alex Gal <a.gal@motsai.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c
b/drivers/net/wireless/ti/wlcore/main.c
index e9da47c..89d2310 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4457,6 +4457,16 @@ static void wl1271_op_bss_info_changed(struct
ieee80211_hw *hw,
    if (ret < 0)
        goto out;

+   if ((changed & BSS_CHANGED_TXPOWER) &&
+       bss_conf->txpower != wlvif->power_level) {
+
+       ret = wl1271_acx_tx_power(wl, wlvif, bss_conf->txpower);
+       if (ret < 0)
+           goto out;
+
+       wlvif->power_level = bss_conf->txpower;
+   }
+
    if (is_ap)
        wl1271_bss_info_changed_ap(wl, vif, bss_conf, changed);
    else
-- 
1.8.5.2
