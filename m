Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44318 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab2BBLvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 06:51:07 -0500
Received: by wics10 with SMTP id s10so1677445wic.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 03:51:06 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/4] wl12xx: don't fail on AP scan
Date: Thu,  2 Feb 2012 13:54:26 +0200
Message-Id: <1328183669-21059-2-git-send-email-eliad@wizery.com> (sfid-20120202_125112_290179_FA9EB237)
In-Reply-To: <1328183669-21059-1-git-send-email-eliad@wizery.com>
References: <1328183669-21059-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AP role uses its own role_id for scans, so there's
no reason to fail the scan if dev_role_id is invalid.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/scan.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 848a165..e3566ca 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -175,16 +175,17 @@ static int wl1271_scan_send(struct wl1271 *wl, struct ieee80211_vif *vif,
 	if (passive)
 		scan_options |= WL1271_SCAN_OPT_PASSIVE;
 
-	if (WARN_ON(wlvif->role_id == WL12XX_INVALID_ROLE_ID ||
-		    wlvif->dev_role_id == WL12XX_INVALID_ROLE_ID)) {
-		ret = -EINVAL;
-		goto out;
-	}
-	if (test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
+	if (wlvif->bss_type == BSS_TYPE_AP_BSS ||
+	    test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
 		cmd->params.role_id = wlvif->role_id;
 	else
 		cmd->params.role_id = wlvif->dev_role_id;
 
+	if (WARN_ON(cmd->params.role_id == WL12XX_INVALID_ROLE_ID)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	cmd->params.scan_options = cpu_to_le16(scan_options);
 
 	cmd->params.n_ch = wl1271_get_scan_channels(wl, wl->scan.req,
-- 
1.7.6.401.g6a319

