Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38325 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab1IVGwN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 02:52:13 -0400
Received: by fxe4 with SMTP id 4so2424791fxe.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 23:52:12 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 1/2] wl12xx: correct fw_status structure for 8 sta support in AP-mode
Date: Thu, 22 Sep 2011 09:52:05 +0300
Message-Id: <1316674326-4873-1-git-send-email-arik@wizery.com> (sfid-20110922_085216_614545_785DA2C7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix an erroneous labeling of array boundaries in the fw_status structure.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |    2 ++
 drivers/net/wireless/wl12xx/wl12xx.h |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 680f558..8768b77 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4585,6 +4585,8 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	int i, j, ret;
 	unsigned int order;
 
+	BUILD_BUG_ON(AP_MAX_LINKS > WL12XX_MAX_LINKS);
+
 	hw = ieee80211_alloc_hw(sizeof(*wl), &wl1271_ops);
 	if (!hw) {
 		wl1271_error("could not alloc ieee80211_hw");
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 3ceb20c..1b45e87 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -138,7 +138,7 @@ extern u32 wl12xx_debug_level;
 #define WL1271_DEFAULT_DTIM_PERIOD 1
 
 #define WL12XX_MAX_ROLES           4
-#define WL12XX_MAX_LINKS           8
+#define WL12XX_MAX_LINKS           12
 #define WL12XX_INVALID_ROLE_ID     0xff
 #define WL12XX_INVALID_LINK_ID     0xff
 
@@ -279,7 +279,7 @@ struct wl12xx_fw_status {
 
 	/* Cumulative counter of released Voice memory blocks */
 	u8 tx_voice_released_blks;
-	u8 padding_1[7];
+	u8 padding_1[3];
 	__le32 log_start_addr;
 } __packed;
 
-- 
1.7.4.1

