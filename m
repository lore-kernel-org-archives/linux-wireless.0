Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:43996 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab2CDIzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 03:55:50 -0500
Received: by wgbds11 with SMTP id ds11so565481wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 Mar 2012 00:55:49 -0800 (PST)
MIME-Version: 1.0
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/11] wl12xx: consider bss_conf->idle instead of hw->conf.flags
Date: Sun,  4 Mar 2012 10:55:46 +0200
Message-Id: <1330851355-24459-3-git-send-email-eliad@wizery.com> (sfid-20120304_095622_392960_B57B173D)
In-Reply-To: <1330851355-24459-1-git-send-email-eliad@wizery.com>
References: <1330851355-24459-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On disassociation, check only whether the current vif
is idle, instead of checking whether the device is idle.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 93636ea..b771106 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3901,7 +3901,6 @@ sta_not_found:
 
 			/* restore the bssid filter and go to dummy bssid */
 			if (was_assoc) {
-				u32 conf_flags = wl->hw->conf.flags;
 				/*
 				 * we might have to disable roc, if there was
 				 * no IF_OPER_UP notification.
@@ -3924,7 +3923,7 @@ sta_not_found:
 				}
 
 				wl1271_unjoin(wl, wlvif);
-				if (!(conf_flags & IEEE80211_CONF_IDLE))
+				if (!bss_conf->idle)
 					wl12xx_start_dev(wl, wlvif);
 			}
 		}
-- 
1.7.6.401.g6a319

