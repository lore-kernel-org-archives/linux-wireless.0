Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35863 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab1HIJOm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:14:42 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so2430702wwf.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:14:42 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 38/40] wl12xx: set the AP-started flag only after setting keys
Date: Tue,  9 Aug 2011 12:13:51 +0300
Message-Id: <1312881233-9366-39-git-send-email-eliad@wizery.com> (sfid-20110809_111446_801965_C028FB91)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

This fix eliminates a potential race between starting the AP role
and setting encryption keys.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 9f60f0f..e3c77da 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3105,18 +3105,18 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 		if (bss_conf->enable_beacon) {
 			if (!test_bit(WL1271_FLAG_AP_STARTED, &wl->flags)) {
 				ret = wl1271_cmd_role_start_ap(wl);
 				if (ret < 0)
 					goto out;
 
-				set_bit(WL1271_FLAG_AP_STARTED, &wl->flags);
-				wl1271_debug(DEBUG_AP, "started AP");
-
 				ret = wl1271_ap_init_hwenc(wl);
 				if (ret < 0)
 					goto out;
+
+				set_bit(WL1271_FLAG_AP_STARTED, &wl->flags);
+				wl1271_debug(DEBUG_AP, "started AP");
 			}
 		} else {
 			if (test_bit(WL1271_FLAG_AP_STARTED, &wl->flags)) {
 				ret = wl1271_cmd_role_stop_ap(wl);
 				if (ret < 0)
 					goto out;
-- 
1.7.6.401.g6a319

