Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:36651 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbcCRCYg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 22:24:36 -0400
Received: by mail-pf0-f170.google.com with SMTP id u190so146146624pfb.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 19:24:36 -0700 (PDT)
From: Julian Calaby <julian.calaby@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Jia-Ju Bai <baijiaju1990@163.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: [PATCH 10/19] b43: Fix memory leaks in b43_bus_dev_ssb_init and b43_bus_dev_bcma_init
Date: Fri, 18 Mar 2016 13:24:28 +1100
Message-Id: <4193d5f8e6288b463252fbbb6fae0e9950d83677.1458262312.git.julian.calaby@gmail.com> (sfid-20160318_032439_514336_DDD216E1)
In-Reply-To: <cover.1458262312.git.julian.calaby@gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jia-Ju Bai <baijiaju1990@163.com>

The memory allocated by kzalloc in b43_bus_dev_ssb_init and
b43_bus_dev_bcma_init is not freed.
This patch fixes the bug by adding kfree in b43_ssb_remove,
b43_bcma_remove and error handling code of b43_bcma_probe.

Thanks Michael for his suggestion.

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>

---

This stalled waiting for testing on BCMA.

The fix _looks_ correct.

For BCMA, b43_bus_dev_bcma_init() allocs the memory that wldev->dev ends
up pointing to, however it appears that this memory is never freed. Hunks
1 and 2 add that freeing to the probe and remove functions respectively.

Hunk 1 makes b43_bcma_probe()'s error handling look like b43_ssb_probe()'s.

Thanks,

Julian Calaby
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
2.7.0

