Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55180 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab2AXQPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 11:15:47 -0500
Received: by wics10 with SMTP id s10so3075059wic.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2012 08:15:45 -0800 (PST)
MIME-Version: 1.0
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] wl12xx: check bss_conf->assoc on CHANGED_BSSID
Date: Tue, 24 Jan 2012 18:18:42 +0200
Message-Id: <1327421923-25586-1-git-send-email-eliad@wizery.com> (sfid-20120124_171550_907538_C344C60E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

with the new auth/assoc redesign, we get CHANGED_BSSID
indication before CHANGED_ASSOC indication, while our
CHANGED_BSSID handling block assumes we are already
associated.

Fix it by checking we are either in ibss mode, or
already associated.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 915d56c..91c03d8 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3639,7 +3639,8 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 		wlvif->rssi_thold = bss_conf->cqm_rssi_thold;
 	}
 
-	if (changed & BSS_CHANGED_BSSID)
+	if (changed & BSS_CHANGED_BSSID &&
+	    (is_ibss || bss_conf->assoc))
 		if (!is_zero_ether_addr(bss_conf->bssid)) {
 			ret = wl12xx_cmd_build_null_data(wl, wlvif);
 			if (ret < 0)
-- 
1.7.6.401.g6a319

