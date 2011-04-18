Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43854 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1DRLQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 07:16:16 -0400
Received: by wwa36 with SMTP id 36so5507192wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 04:16:15 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 07/10] wl12xx: AP-mode - reconfigure templates after basic rates change
Date: Mon, 18 Apr 2011 14:15:26 +0300
Message-Id: <1303125329-27214-7-git-send-email-arik@wizery.com>
In-Reply-To: <1303125329-27214-1-git-send-email-arik@wizery.com>
References: <1303125329-27214-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When there's a change in the basic rates of the AP, reconfigure relevant
templates with the new rates.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/init.c |    7 ++++++-
 drivers/net/wireless/wl12xx/init.h |    1 +
 drivers/net/wireless/wl12xx/main.c |    4 ++++
 3 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 5fc69de..b615275 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -434,7 +434,7 @@ static int wl1271_ap_hw_init(struct wl1271 *wl)
 	return 0;
 }
 
-static int wl1271_ap_hw_init_post_mem(struct wl1271 *wl)
+int wl1271_ap_init_templates(struct wl1271 *wl)
 {
 	int ret;
 
@@ -461,6 +461,11 @@ static int wl1271_ap_hw_init_post_mem(struct wl1271 *wl)
 	return 0;
 }
 
+static int wl1271_ap_hw_init_post_mem(struct wl1271 *wl)
+{
+	return wl1271_ap_init_templates(wl);
+}
+
 int wl1271_init_ap_rates(struct wl1271 *wl)
 {
 	int i, ret;
diff --git a/drivers/net/wireless/wl12xx/init.h b/drivers/net/wireless/wl12xx/init.h
index 0dd2414..3a3c230 100644
--- a/drivers/net/wireless/wl12xx/init.h
+++ b/drivers/net/wireless/wl12xx/init.h
@@ -34,5 +34,6 @@ int wl1271_init_energy_detection(struct wl1271 *wl);
 int wl1271_chip_specific_init(struct wl1271 *wl);
 int wl1271_hw_init(struct wl1271 *wl);
 int wl1271_init_ap_rates(struct wl1271 *wl);
+int wl1271_ap_init_templates(struct wl1271 *wl);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index c7e2c09..d2a8b83 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2480,6 +2480,10 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 			wl1271_error("AP rate policy change failed %d", ret);
 			goto out;
 		}
+
+		ret = wl1271_ap_init_templates(wl);
+		if (ret < 0)
+			goto out;
 	}
 
 	ret = wl1271_bss_beacon_info_changed(wl, vif, bss_conf, changed);
-- 
1.7.1

