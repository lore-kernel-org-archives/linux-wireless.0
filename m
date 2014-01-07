Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:45432 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbaAGWSw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 17:18:52 -0500
Received: by mail-lb0-f178.google.com with SMTP id c11so729071lbj.23
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jan 2014 14:18:51 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 7 Jan 2014 17:18:51 -0500
Message-ID: <CAN44aq1zfHb_fCkGgQdrQV8u3umcvygdo=wE8A+SwRNgEGm7fw@mail.gmail.com> (sfid-20140107_231856_271974_6330759E)
Subject: [PATCH] Fixing TX power bug for wl12xx.
From: Alex Gal <a.gal@motsai.com>
To: linux-wireless@vger.kernel.org
Cc: Jean-Samuel Chenard <js.chenard@motsai.com>, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I posted a thread a few days ago about the possibly broken tx power
change in kernel 3.10 and possibly mainline.

I added a patch in here for driver wl12xx which seems to properly set
the tx power.

---
 drivers/net/wireless/ti/wlcore/main.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c
b/drivers/net/wireless/ti/wlcore/main.c
index 953111a..62d1ec1 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4331,6 +4331,16 @@ static void wl1271_op_bss_info_changed(struct
ieee80211_hw *hw,
        if (ret < 0)
                goto out;

+       if ((changed & BSS_CHANGED_TXPOWER) && bss_conf->txpower !=
wlvif->power_level) {
+
+               ret = wl1271_acx_tx_power(wl, wlvif, bss_conf->txpower);
+
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
