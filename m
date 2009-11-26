Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:27788 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760648AbZKZPJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 10:09:30 -0500
Subject: [PATCH 05/12] wl1251: simplify ELP wakeup time calculation
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Nov 2009 17:08:57 +0200
Message-ID: <20091126150857.917.36804.stgit@tikku>
In-Reply-To: <20091126150141.917.35278.stgit@tikku>
References: <20091126150141.917.35278.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

The wakeup time calculation was too complicated, simplify it.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_ps.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_ps.c b/drivers/net/wireless/wl12xx/wl1251_ps.c
index 54a2720..851dfb6 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ps.c
+++ b/drivers/net/wireless/wl12xx/wl1251_ps.c
@@ -68,7 +68,7 @@ void wl1251_ps_elp_sleep(struct wl1251 *wl)
 
 int wl1251_ps_elp_wakeup(struct wl1251 *wl)
 {
-	unsigned long timeout;
+	unsigned long timeout, start;
 	u32 elp_reg;
 
 	if (!wl->elp)
@@ -76,6 +76,7 @@ int wl1251_ps_elp_wakeup(struct wl1251 *wl)
 
 	wl1251_debug(DEBUG_PSM, "waking up chip from elp");
 
+	start = jiffies;
 	timeout = jiffies + msecs_to_jiffies(WL1251_WAKEUP_TIMEOUT);
 
 	wl1251_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_WAKE_UP);
@@ -96,8 +97,7 @@ int wl1251_ps_elp_wakeup(struct wl1251 *wl)
 	}
 
 	wl1251_debug(DEBUG_PSM, "wakeup time: %u ms",
-		     jiffies_to_msecs(jiffies) -
-		     (jiffies_to_msecs(timeout) - WL1251_WAKEUP_TIMEOUT));
+		     jiffies_to_msecs(jiffies - start));
 
 	wl->elp = false;
 

