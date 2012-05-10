Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51169 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758512Ab2EJJQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:36 -0400
Received: by mail-wi0-f172.google.com with SMTP id hr2so244170wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:35 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 57/78] wlcore: reorder identify_chip and get_hw_info
Date: Thu, 10 May 2012 12:14:02 +0300
Message-Id: <1336641263-5761-58-git-send-email-arik@wizery.com> (sfid-20120510_111848_474427_CCC097B6)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

We can do get the HW information and identify the chip already at
probe time.  This makes it easier to mangle with the parameters during
identify chip before registering the hardware with mac80211.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 2c78057..9b8f6a2 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -962,10 +962,6 @@ static int wl12xx_chip_wakeup(struct wl1271 *wl, bool plt)
 	if (wl1271_set_block_size(wl))
 		wl->quirks |= WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN;
 
-	ret = wl->ops->identify_chip(wl);
-	if (ret < 0)
-		goto out;
-
 	/* TODO: make sure the lower driver has set things up correctly */
 
 	ret = wl1271_setup(wl);
@@ -4871,12 +4867,6 @@ static int wl1271_register_hw(struct wl1271 *wl)
 	if (wl->mac80211_registered)
 		return 0;
 
-	ret = wl12xx_get_hw_info(wl);
-	if (ret < 0) {
-		wl1271_error("couldn't get hw info");
-		goto out;
-	}
-
 	ret = wl1271_fetch_nvs(wl);
 	if (ret == 0) {
 		/* NOTE: The wl->nvs->nvs element must be first, in
@@ -5281,6 +5271,16 @@ int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
 	}
 	disable_irq(wl->irq);
 
+	ret = wl12xx_get_hw_info(wl);
+	if (ret < 0) {
+		wl1271_error("couldn't get hw info");
+		goto out;
+	}
+
+	ret = wl->ops->identify_chip(wl);
+	if (ret < 0)
+		goto out;
+
 	ret = wl1271_init_ieee80211(wl);
 	if (ret)
 		goto out_irq;
-- 
1.7.9.5

