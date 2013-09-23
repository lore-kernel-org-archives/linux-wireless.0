Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59255 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab3IWTav (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Sep 2013 15:30:51 -0400
Received: by mail-wg0-f51.google.com with SMTP id c11so3458770wgh.18
        for <linux-wireless@vger.kernel.org>; Mon, 23 Sep 2013 12:30:50 -0700 (PDT)
Message-ID: <1379964642.4007.10.camel@canaries64-MCP7A> (sfid-20130923_213057_379818_165D754A)
Subject: [PATCH] staging: vt6656: [BUG] iwctl_siwencodeext return if device
 not open
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 23 Sep 2013 20:30:42 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't allow entry to iwctl_siwencodeext if device not open.

This fixes a race condition where wpa supplicant/network manager
enters the function when the device is already closed.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: stable@vger.kernel.org # 3.8+
---
 drivers/staging/vt6656/iwctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 033cb50..5968888 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1634,6 +1634,9 @@ int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 	if (pMgmt == NULL)
 		return -EFAULT;
 
+	if (!(pDevice->flags & DEVICE_FLAGS_OPENED))
+		return -ENODEV;
+
 	buf = kzalloc(sizeof(struct viawget_wpa_param), GFP_KERNEL);
 	if (buf == NULL)
 		return -ENOMEM;
-- 
1.8.3.2

