Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33521 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932643AbcCKROx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2016 12:14:53 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, netdev@vger.kernel.org,
	Jia-Ju Bai <baijiaju1990@163.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>
Subject: [PATCH] b43: Fix memory leaks in b43_bus_dev_ssb_init and b43_bus_dev_bcma_init
Date: Fri, 11 Mar 2016 22:44:37 +0530
Message-Id: <1457716477-6287-1-git-send-email-sudipm.mukherjee@gmail.com> (sfid-20160311_181523_605180_E89251FE)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jia-Ju Bai <baijiaju1990@163.com>

The memory allocated by kzalloc in b43_bus_dev_ssb_init and
b43_bus_dev_bcma_init is not freed.
This patch fixes the bug by adding kfree in b43_ssb_remove,
b43_bcma_remove and error handling code of b43_bcma_probe.

Thanks Michael for his suggestion.

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
Acked-by: Michael Büsch <m@bues.ch>
Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
---
 drivers/net/wireless/broadcom/b43/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
index 72380af..b0603e7 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -5680,11 +5680,12 @@ static int b43_bcma_probe(struct bcma_device *core)
 	INIT_WORK(&wl->firmware_load, b43_request_firmware);
 	schedule_work(&wl->firmware_load);
 
-bcma_out:
 	return err;
 
 bcma_err_wireless_exit:
 	ieee80211_free_hw(wl->hw);
+bcma_out:
+	kfree(dev);
 	return err;
 }
 
@@ -5712,8 +5713,8 @@ static void b43_bcma_remove(struct bcma_device *core)
 	b43_rng_exit(wl);
 
 	b43_leds_unregister(wl);
-
 	ieee80211_free_hw(wl->hw);
+	kfree(wldev->dev);
 }
 
 static struct bcma_driver b43_bcma_driver = {
@@ -5796,6 +5797,7 @@ static void b43_ssb_remove(struct ssb_device *sdev)
 
 	b43_leds_unregister(wl);
 	b43_wireless_exit(dev, wl);
+	kfree(dev);
 }
 
 static struct ssb_driver b43_ssb_driver = {
-- 
1.9.1

