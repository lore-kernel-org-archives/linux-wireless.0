Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54215 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab1FXKDs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 06:03:48 -0400
Received: by wwe5 with SMTP id 5so2727527wwe.1
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jun 2011 03:03:47 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Ido Yariv <ido@wizery.com>
Subject: [PATCH 2/3] wl12xx: Increase low & high TX watermarks
Date: Fri, 24 Jun 2011 13:03:36 +0300
Message-Id: <1308909817-25689-2-git-send-email-arik@wizery.com> (sfid-20110624_120352_707972_31C5BCDB)
In-Reply-To: <1308909817-25689-1-git-send-email-arik@wizery.com>
References: <1308909817-25689-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

The current TX watermark settings cause the driver to stop queues too
frequently. Among other things, this can have a negative impact on WMM
prioritization, since mac80211 sorts pending packets by their ACs.

Fix this by increasing the high watermark to 256 packets. Increase the
low watermark to 32 to minimize periods with queues being stopped.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/wl12xx.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index a476fea..89ba1fc 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -616,8 +616,8 @@ int wl1271_recalc_rx_streaming(struct wl1271 *wl);
 
 #define WL1271_DEFAULT_POWER_LEVEL 0
 
-#define WL1271_TX_QUEUE_LOW_WATERMARK  10
-#define WL1271_TX_QUEUE_HIGH_WATERMARK 25
+#define WL1271_TX_QUEUE_LOW_WATERMARK  32
+#define WL1271_TX_QUEUE_HIGH_WATERMARK 256
 
 #define WL1271_DEFERRED_QUEUE_LIMIT    64
 
-- 
1.7.4.1

