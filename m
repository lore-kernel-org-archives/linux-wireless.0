Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:33785 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaAIRGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 12:06:38 -0500
Received: by mail-lb0-f169.google.com with SMTP id u14so2581032lbd.28
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jan 2014 09:06:36 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 9 Jan 2014 12:06:36 -0500
Message-ID: <CAN44aq1na7XbhArseUVwKybMS7bhn_0uCFXxVvEvgX=RfUbBGQ@mail.gmail.com> (sfid-20140109_180642_166802_512E25DC)
Subject: [PATCH v2] wl12xx: fix tx power setting
From: Alex Gal <a.gal@motsai.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes wl12xx tx power.

Signed-off-by: Alex Gal <a.gal@motsai.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c
b/drivers/net/wireless/ti/wlcore/main.c
index e9da47c..3f77a8d 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4457,6 +4457,15 @@ static void wl1271_op_bss_info_changed(struct
ieee80211_hw *hw,
        if (ret < 0)
                goto out;

+    if ((changed & BSS_CHANGED_TXPOWER) && bss_conf->txpower !=
wlvif->power_level) {
+
+        ret = wl1271_acx_tx_power(wl, wlvif, bss_conf->txpower);
+        if (ret < 0)
+            goto out;
+
+        wlvif->power_level = bss_conf->txpower;
+    }
+
        if (is_ap)
                wl1271_bss_info_changed_ap(wl, vif, bss_conf, changed);
        else
-- 
1.8.5.2
