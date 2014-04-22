Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:43433 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbaDVAK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 20:10:26 -0400
Received: by mail-ee0-f50.google.com with SMTP id c13so4070591eek.9
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2014 17:10:24 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Pavel Machek <pavel@ucw.cz>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
	David Gnedt <david.gnedt@davizone.at>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 1/4] Revert "wl1251: enforce changed hw encryption support on monitor state change"
Date: Tue, 22 Apr 2014 03:09:52 +0300
Message-Id: <1398125395-5579-2-git-send-email-notasas@gmail.com> (sfid-20140422_021031_775183_D5E2B831)
In-Reply-To: <1398125395-5579-1-git-send-email-notasas@gmail.com>
References: <1398125395-5579-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit b90a1165a72fabdc260abaa9eeadcbfd29e267eb.

That commit (or rather, hack) triggers a scary WARN in IBSS (ad-hoc) mode.
Steps to reproduce:
    ifconfig wlan0 down
    iwconfig wlan0 mode ad-hoc
    ifconfig wlan0 up
------------[ cut here ]------------
WARNING: CPU: 0 PID: 905 at kernel/workqueue.c:1400 __queue_work+0x21c/0x2f4()
Modules linked in: wl1251_sdio wl1251 mac80211 cfg80211
CPU: 0 PID: 905 Comm: ifconfig Not tainted 3.15.0-rc2#233
[<c0015f38>] (unwind_backtrace) from [<c0012938>]
[<c0012938>] (show_stack) from [<c05d4034>]
[<c05d4034>] (dump_stack) from [<c0043984>]
[<c0043984>] (warn_slowpath_common) from [<c00439c0>]
[<c00439c0>] (warn_slowpath_null) from [<c005b6c8>]
[<c005b6c8>] (__queue_work) from [<c005b820>]
[<c005b820>] (queue_work_on) from [<bf134ac0>]
[<bf134ac0>] (wl1251_op_config [wl1251])
[<bf099a70>] (ieee80211_hw_config [mac80211])
...
This happens because ieee80211_connection_loss() is not expected to be
called in IBSS mode (mac80211 ends up queuing uninitialized work
in that case).

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/ti/wl1251/main.c |   13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 757e257..c22e225 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -687,16 +687,6 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 		wl->power_level = conf->power_level;
 	}
 
-	/*
-	 * Tell stack that connection is lost because hw encryption isn't
-	 * supported in monitor mode.
-	 * This requires temporary enabling of the hw connection monitor flag
-	 */
-	if ((changed & IEEE80211_CONF_CHANGE_MONITOR) && wl->vif) {
-		wl->hw->flags |= IEEE80211_HW_CONNECTION_MONITOR;
-		ieee80211_connection_loss(wl->vif);
-	}
-
 out_sleep:
 	wl1251_ps_elp_sleep(wl);
 
@@ -1129,9 +1119,6 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_ASSOC) {
-		/* Disable temporary enabled hw connection monitor flag */
-		wl->hw->flags &= ~IEEE80211_HW_CONNECTION_MONITOR;
-
 		if (bss_conf->assoc) {
 			wl->beacon_int = bss_conf->beacon_int;
 
-- 
1.7.9.5

