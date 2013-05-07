Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54483 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650Ab3EGMlT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 08:41:19 -0400
Received: by mail-wi0-f172.google.com with SMTP id hm14so3690890wib.11
        for <linux-wireless@vger.kernel.org>; Tue, 07 May 2013 05:41:18 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] wlcore: allow TX BA on all TIDs
Date: Tue,  7 May 2013 15:41:07 +0300
Message-Id: <1367930469-29826-1-git-send-email-eliad@wizery.com> (sfid-20130507_144124_096161_A383B9FA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previous fw limitation prevented us from from doing
TX BA on TIDs 6/7. However, this restriction no
longer exists, so enable TX BA on all TIDs.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/conf.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index 2b96ff8..80c1ac1 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -590,8 +590,8 @@ struct conf_tx_ac_category {
 
 #define CONF_TX_MAX_TID_COUNT 8
 
-/* Allow TX BA on all TIDs but 6,7. These are currently reserved in the FW */
-#define CONF_TX_BA_ENABLED_TID_BITMAP 0x3F
+/* Allow TX BA on all TIDs */
+#define CONF_TX_BA_ENABLED_TID_BITMAP 0xFF
 
 enum {
 	CONF_CHANNEL_TYPE_DCF = 0,   /* DC/LEGACY*/
-- 
1.8.1.2

