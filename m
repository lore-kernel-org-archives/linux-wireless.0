Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46680 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758441Ab2EJJQb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:31 -0400
Received: by mail-wi0-f170.google.com with SMTP id hm4so231590wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:31 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 55/78] wlcore: add space for private area when allocating fw_status
Date: Thu, 10 May 2012 12:14:00 +0300
Message-Id: <1336641263-5761-56-git-send-email-arik@wizery.com> (sfid-20120510_111916_450188_4B171C67)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

When allocating the fw_status structure, the space for the
lower-driver private area was missing.  This was causing an illegal
write outside the allocated area, which was causing random oopses
around the kernel.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 3e3dce9..2c78057 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -904,7 +904,8 @@ static void wl1271_fw_wakeup(struct wl1271 *wl)
 static int wl1271_setup(struct wl1271 *wl)
 {
 	wl->fw_status_1 = kmalloc(WLCORE_FW_STATUS_1_LEN(wl->num_rx_desc) +
-				  sizeof(*wl->fw_status_2), GFP_KERNEL);
+				  sizeof(*wl->fw_status_2) +
+				  wl->fw_status_priv_len, GFP_KERNEL);
 	if (!wl->fw_status_1)
 		return -ENOMEM;
 
-- 
1.7.9.5

