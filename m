Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:48239 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525Ab2ECHep (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 03:34:45 -0400
Received: by lbjn8 with SMTP id n8so1495264lbj.14
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 00:34:42 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: dan.carpenter@oracle.com, Luciano Coelho <coelho@ti.com>
Subject: [PATCH] wlcore: use GFP_KERNEL together with GFP_DMA
Date: Thu,  3 May 2012 10:34:35 +0300
Message-Id: <1336030475-28943-1-git-send-email-coelho@ti.com> (sfid-20120503_093449_016515_288D3087)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

GFP_DMA should not be used by itself, it still needs GFP_KERNEL or
such.  Fix two occurrences of allocations with GFP_DMA only.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---

This is a follow-up on Dan's patch.  He fixed one occurence of
allocation with only the GFP_DMA flag set.  This fixes the other two
allocations where this was done.


 drivers/net/wireless/ti/wlcore/boot.c |    2 +-
 drivers/net/wireless/ti/wlcore/main.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index 3a2207d..eb204ba 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -72,7 +72,7 @@ static int wlcore_boot_fw_version(struct wl1271 *wl)
 	struct wl1271_static_data *static_data;
 	int ret;
 
-	static_data = kmalloc(sizeof(*static_data), GFP_DMA);
+	static_data = kmalloc(sizeof(*static_data), GFP_KERNEL | GFP_DMA);
 	if (!static_data) {
 		wl1271_error("Couldn't allocate memory for static data!");
 		return -ENOMEM;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 2b0f987..b156bc6 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4861,7 +4861,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size)
 		goto err_dummy_packet;
 	}
 
-	wl->mbox = kmalloc(sizeof(*wl->mbox), GFP_DMA);
+	wl->mbox = kmalloc(sizeof(*wl->mbox), GFP_KERNEL | GFP_DMA);
 	if (!wl->mbox) {
 		ret = -ENOMEM;
 		goto err_fwlog;
-- 
1.7.10

