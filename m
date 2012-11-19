Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:56242 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab2KSPOJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 10:14:09 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so2019442eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 07:14:07 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] wlcore: don't leak wl->mbox
Date: Mon, 19 Nov 2012 17:14:06 +0200
Message-Id: <1353338046-12625-2-git-send-email-eliad@wizery.com> (sfid-20121119_161415_848986_8502017B)
In-Reply-To: <1353338046-12625-1-git-send-email-eliad@wizery.com>
References: <1353338046-12625-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

free it on wlcore_free_hw()

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 8f06c88..41ed1d5 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5479,6 +5479,7 @@ int wlcore_free_hw(struct wl1271 *wl)
 	device_remove_file(wl->dev, &dev_attr_hw_pg_ver);
 
 	device_remove_file(wl->dev, &dev_attr_bt_coex_state);
+	kfree(wl->mbox);
 	free_page((unsigned long)wl->fwlog);
 	dev_kfree_skb(wl->dummy_packet);
 	free_pages((unsigned long)wl->aggr_buf, get_order(wl->aggr_buf_size));
-- 
1.7.6.401.g6a319

