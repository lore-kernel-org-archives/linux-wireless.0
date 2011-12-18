Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51079 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab1LRSZB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Dec 2011 13:25:01 -0500
Received: by werm1 with SMTP id m1so927002wer.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Dec 2011 10:25:00 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 6/7] wl12xx: stop device role on remove_interface
Date: Sun, 18 Dec 2011 20:25:44 +0200
Message-Id: <1324232745-22928-7-git-send-email-eliad@wizery.com> (sfid-20111218_192504_910665_C2207B47)
In-Reply-To: <1324232745-22928-1-git-send-email-eliad@wizery.com>
References: <1324232745-22928-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When removing a sta/ibss role, the device role has to
stopped (and disabled) as well.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 7a2ed34..4b68b2a 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2189,7 +2189,11 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 		if (ret < 0)
 			goto deinit;
 
-		if (wlvif->bss_type == BSS_TYPE_STA_BSS) {
+		if (wlvif->bss_type == BSS_TYPE_STA_BSS ||
+		    wlvif->bss_type == BSS_TYPE_IBSS) {
+			if (wl12xx_dev_role_started(wlvif))
+				wl12xx_stop_dev(wl, wlvif);
+
 			ret = wl12xx_cmd_role_disable(wl, &wlvif->dev_role_id);
 			if (ret < 0)
 				goto deinit;
-- 
1.7.6.401.g6a319

