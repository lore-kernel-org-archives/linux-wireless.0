Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:42586 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaGKACX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:02:23 -0400
Received: by mail-wi0-f173.google.com with SMTP id cc10so5424287wib.6
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:02:22 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/14] wlcore: register vendor commands
Date: Fri, 11 Jul 2014 03:01:35 +0300
Message-Id: <1405036899-27396-11-git-send-email-eliad@wizery.com> (sfid-20140711_022952_761831_C22C5C56)
In-Reply-To: <1405036899-27396-1-git-send-email-eliad@wizery.com>
References: <1405036899-27396-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All the smart config code is in place now,
so register the relevant vendor commands.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 01b4d9e..d92f578 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -37,6 +37,7 @@
 #include "init.h"
 #include "debugfs.h"
 #include "testmode.h"
+#include "vendor_cmd.h"
 #include "scan.h"
 #include "hw_ops.h"
 #include "sysfs.h"
@@ -5875,6 +5876,9 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->wiphy->iface_combinations = wl->iface_combinations;
 	wl->hw->wiphy->n_iface_combinations = wl->n_iface_combinations;
 
+	/* register vendor commands */
+	wlcore_set_vendor_commands(wl->hw->wiphy);
+
 	SET_IEEE80211_DEV(wl->hw, wl->dev);
 
 	wl->hw->sta_data_size = sizeof(struct wl1271_station);
-- 
1.8.5.1.109.g3d252a9

