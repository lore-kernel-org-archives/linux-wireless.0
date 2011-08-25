Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46313 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab1HYJn0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 05:43:26 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so1509667wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 02:43:25 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 3/6] wl12xx: support up to 8 stations in AP-mode
Date: Thu, 25 Aug 2011 12:43:14 +0300
Message-Id: <1314265397-19873-3-git-send-email-arik@wizery.com> (sfid-20110825_114330_210488_B999AAA5)
In-Reply-To: <1314265397-19873-1-git-send-email-arik@wizery.com>
References: <1314265397-19873-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change the max number of AP stations to 8, up from 5.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/wl12xx.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 61a7c21..27961e2 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -234,14 +234,14 @@ struct wl1271_stats {
 #define NUM_TX_QUEUES              4
 #define NUM_RX_PKT_DESC            8
 
-#define AP_MAX_STATIONS            5
+#define AP_MAX_STATIONS            8
 
 /* Broadcast and Global links + system link + links to stations */
 /*
  * TODO: when WL1271_AP_STA_HLID_START is no longer constant, change all
  * the places that use this.
  */
-#define AP_MAX_LINKS               (AP_MAX_STATIONS + 3)
+#define AP_MAX_LINKS               (AP_MAX_STATIONS + WL1271_AP_STA_HLID_START)
 
 /* FW status registers */
 struct wl12xx_fw_status {
-- 
1.7.4.1

