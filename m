Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60964 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab3IIJZK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 05:25:10 -0400
Received: by mail-we0-f174.google.com with SMTP id q58so3970159wes.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 02:25:09 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 12/13] wlcore: fix started_vifs calculation
Date: Mon,  9 Sep 2013 12:24:43 +0300
Message-Id: <1378718684-14430-12-git-send-email-eliad@wizery.com> (sfid-20130909_112516_766087_F76F4CF4)
In-Reply-To: <1378718684-14430-1-git-send-email-eliad@wizery.com>
References: <1378718684-14430-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wlcore configures different dwell times according to number
of active interfaces (in order to prevent hurting VO during
scan).

However, determining active vif only according to
bss_conf->idle is not explicit enough, and might result
in non-started vifs being counted as started as well
(e.g. unassociated sta during sta).

Fix it by checking for explicit conditions according
to the vif type.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/scan.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index bbe0bc4..867e64b 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -92,9 +92,31 @@ out:
 static void wlcore_started_vifs_iter(void *data, u8 *mac,
 				     struct ieee80211_vif *vif)
 {
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	bool active = false;
 	int *count = (int *)data;
 
-	if (!vif->bss_conf.idle)
+	/*
+	 * count active interfaces according to interface type.
+	 * checking only bss_conf.idle is bad for some cases, e.g.
+	 * we don't want to count sta in p2p_find as active interface.
+	 */
+	switch (wlvif->bss_type) {
+	case BSS_TYPE_STA_BSS:
+		if (test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
+			active = true;
+		break;
+
+	case BSS_TYPE_AP_BSS:
+		if (wlvif->wl->active_sta_count > 0)
+			active = true;
+		break;
+
+	default:
+		break;
+	}
+
+	if (active)
 		(*count)++;
 }
 
-- 
1.8.3.rc1.35.g9b79519

