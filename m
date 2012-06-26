Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:52941 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752054Ab2FZUDO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 16:03:14 -0400
Received: by lbol5 with SMTP id l5so538152lbo.6
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 13:03:11 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 2/5] wlcore: fix some failure cases in wlcore_probe()
Date: Tue, 26 Jun 2012 23:02:57 +0300
Message-Id: <1340740980-22284-3-git-send-email-coelho@ti.com> (sfid-20120626_220318_721600_F6EC3F05)
In-Reply-To: <1340740980-22284-1-git-send-email-coelho@ti.com>
References: <1340740980-22284-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to release the IRQ if hw_info() or identify_chip() fails.  And
we need unregister the HW with mac80211 if there are any failures
after it's registered.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 372ccf2..c5a9ffe 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5520,12 +5520,12 @@ int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
 	ret = wl12xx_get_hw_info(wl);
 	if (ret < 0) {
 		wl1271_error("couldn't get hw info");
-		goto out;
+		goto out_irq;
 	}
 
 	ret = wl->ops->identify_chip(wl);
 	if (ret < 0)
-		goto out;
+		goto out_irq;
 
 	ret = wl1271_init_ieee80211(wl);
 	if (ret)
@@ -5539,7 +5539,7 @@ int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
 	ret = device_create_file(wl->dev, &dev_attr_bt_coex_state);
 	if (ret < 0) {
 		wl1271_error("failed to create sysfs file bt_coex_state");
-		goto out_irq;
+		goto out_unreg;
 	}
 
 	/* Create sysfs file to get HW PG version */
@@ -5564,6 +5564,9 @@ out_hw_pg_ver:
 out_bt_coex_state:
 	device_remove_file(wl->dev, &dev_attr_bt_coex_state);
 
+out_unreg:
+	wl1271_unregister_hw(wl);
+
 out_irq:
 	free_irq(wl->irq, wl);
 
-- 
1.7.10

