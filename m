Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43574 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab2KSPOG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 10:14:06 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1153182eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 07:14:05 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] wlcore: print role_id on bss_info_changed
Date: Mon, 19 Nov 2012 17:14:05 +0200
Message-Id: <1353338046-12625-1-git-send-email-eliad@wizery.com> (sfid-20121119_161411_629482_F443675F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In multi-vif setup it's useful to know the role_id
being configured.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 25530c8..8f06c88 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4156,8 +4156,8 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
 	int ret;
 
-	wl1271_debug(DEBUG_MAC80211, "mac80211 bss info changed 0x%x",
-		     (int)changed);
+	wl1271_debug(DEBUG_MAC80211, "mac80211 bss info role %d changed 0x%x",
+		     wlvif->role_id, (int)changed);
 
 	/*
 	 * make sure to cancel pending disconnections if our association
-- 
1.7.6.401.g6a319

