Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60522 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab2BBLvK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 06:51:10 -0500
Received: by wgbdt10 with SMTP id dt10so2459551wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 03:51:08 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>, Ido Reis <idor@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/4] wl12xx: increase max probe-req template size to WL1271_CMD_TEMPL_MAX_SIZE
Date: Thu,  2 Feb 2012 13:54:27 +0200
Message-Id: <1328183669-21059-3-git-send-email-eliad@wizery.com> (sfid-20120202_125114_809593_9C227E53)
In-Reply-To: <1328183669-21059-1-git-send-email-eliad@wizery.com>
References: <1328183669-21059-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Reis <idor@ti.com>

Increase max scan IEs to allow big probe-req frames

Report a correct max-length for the scan IEs we can support, according
to the now larger size of the probe-req template.

Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/init.c |    4 ++--
 drivers/net/wireless/wl12xx/main.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index acc0379..203fbeb 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -42,14 +42,14 @@ int wl1271_init_templates_config(struct wl1271 *wl)
 	/* send empty templates for fw memory reservation */
 	ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
 				      CMD_TEMPL_CFG_PROBE_REQ_2_4, NULL,
-				      WL1271_CMD_TEMPL_DFLT_SIZE,
+				      WL1271_CMD_TEMPL_MAX_SIZE,
 				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
 	ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
 				      CMD_TEMPL_CFG_PROBE_REQ_5,
-				      NULL, WL1271_CMD_TEMPL_DFLT_SIZE, 0,
+				      NULL, WL1271_CMD_TEMPL_MAX_SIZE, 0,
 				      WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index ad7f1fe..1a12d8c 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4926,10 +4926,10 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 	 * should be the maximum length possible for a template, without
 	 * the IEEE80211 header of the template
 	 */
-	wl->hw->wiphy->max_scan_ie_len = WL1271_CMD_TEMPL_DFLT_SIZE -
+	wl->hw->wiphy->max_scan_ie_len = WL1271_CMD_TEMPL_MAX_SIZE -
 			sizeof(struct ieee80211_header);
 
-	wl->hw->wiphy->max_sched_scan_ie_len = WL1271_CMD_TEMPL_DFLT_SIZE -
+	wl->hw->wiphy->max_sched_scan_ie_len = WL1271_CMD_TEMPL_MAX_SIZE -
 		sizeof(struct ieee80211_header);
 
 	wl->hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
-- 
1.7.6.401.g6a319

