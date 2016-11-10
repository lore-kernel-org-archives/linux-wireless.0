Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36062 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755708AbcKJL6A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Nov 2016 06:58:00 -0500
Received: by mail-pf0-f194.google.com with SMTP id n85so3971901pfi.3
        for <linux-wireless@vger.kernel.org>; Thu, 10 Nov 2016 03:58:00 -0800 (PST)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH RESEND v2 08/11] mwifiex: usb: handle HS failures
Date: Thu, 10 Nov 2016 19:57:09 +0800
Message-Id: <1478779032-5165-8-git-send-email-huxinming820@marvell.com> (sfid-20161110_125818_186837_3743295D)
In-Reply-To: <1478779032-5165-1-git-send-email-huxinming820@marvell.com>
References: <1478779032-5165-1-git-send-email-huxinming820@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brian Norris <briannorris@chromium.org>

SDIO and PCIe drivers handle this. Let's imitate it.

Not tested.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
v2: Same as v1
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 671702c..8bcfd92 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -521,7 +521,14 @@ static int mwifiex_usb_suspend(struct usb_interface *intf, pm_message_t message)
 		mwifiex_dbg(adapter, WARN,
 			    "Device already suspended\n");
 
-	mwifiex_enable_hs(adapter);
+	/* Enable the Host Sleep */
+	if (!mwifiex_enable_hs(adapter)) {
+		mwifiex_dbg(adapter, ERROR,
+			    "cmd: failed to suspend\n");
+		adapter->hs_enabling = false;
+		return -EFAULT;
+	}
+
 
 	/* 'is_suspended' flag indicates device is suspended.
 	 * It must be set here before the usb_kill_urb() calls. Reason
-- 
1.8.1.4
