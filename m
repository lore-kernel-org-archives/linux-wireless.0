Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34879 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761936AbcJaIC6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Oct 2016 04:02:58 -0400
Received: by mail-pf0-f195.google.com with SMTP id s8so8097819pfj.2
        for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2016 01:02:57 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 09/12] mwifiex: usb: handle HS failures
Date: Mon, 31 Oct 2016 16:02:17 +0800
Message-Id: <1477900940-10549-9-git-send-email-huxinming820@marvell.com> (sfid-20161031_090306_217994_EFF26D68)
In-Reply-To: <1477900940-10549-1-git-send-email-huxinming820@marvell.com>
References: <1477900940-10549-1-git-send-email-huxinming820@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brian Norris <briannorris@chromium.org>

SDIO and PCIe drivers handle this. Let's imitate it.

Not tested.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 70126c3..c26daf4 100644
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
