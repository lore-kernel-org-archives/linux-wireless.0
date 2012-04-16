Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:45857 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab2DPKtF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 06:49:05 -0400
Date: Mon, 16 Apr 2012 13:48:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: mgherzan@gmail.com
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Subject: re: wl12xx: fix DMA-API-related warnings
Message-ID: <20120416104858.GA24159@elgon.mountain> (sfid-20120416_124911_729622_DCD3B1EA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Mircea Gherzan,

The patch 690142e98826: "wl12xx: fix DMA-API-related warnings" from
Mar 17, 2012, leads to the following Smatch warning:
drivers/net/wireless/ti/wlcore/cmd.c:126 wl1271_cmd_wait_for_event_or_timeout()
	 error: no modifiers for allocation.

 static void wl1271_boot_fw_version(struct wl1271 *wl)
 {
-       struct wl1271_static_data static_data;
+       struct wl1271_static_data *static_data;
 
-       wl1271_read(wl, wl->cmd_box_addr, &static_data, sizeof(static_data),
+       static_data = kmalloc(sizeof(*static_data), GFP_DMA);
                                                    ^^^^^^^
You can't use GFP_DMA by itself like that, it needs to ORed with
GFP_KERNEL or GFP_ATOMIC or something like that:

	static_data = kmalloc(sizeof(*static_data), GFP_KERNEL | GFP_DMA);

+       if (!static_data) {
+               __WARN();
+               return;

There are a couple other places in this patch which do the same thing.
Could you fix it, please?

regards,
dan carpenter

