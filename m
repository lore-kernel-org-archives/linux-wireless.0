Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:65043 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753343AbaB0ELd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 23:11:33 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.14] mwifiex: do not advertise usb autosuspend support
Date: Wed, 26 Feb 2014 20:11:22 -0800
Message-ID: <1393474282-30188-1-git-send-email-bzhao@marvell.com> (sfid-20140227_051137_303667_B0888543)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As many Surface Pro I & II users have found out, the mwifiex_usb
doesn't support usb autosuspend, and it has caused some system
stability issues.

Bug 69661 - mwifiex_usb on MS Surface Pro 1 is unstable
Bug 60815 - Interface hangs in mwifiex_usb
Bug 64111 - mwifiex_usb USB8797 crash failed to get signal
 	    information

USB autosuspend get triggered when Surface Pro's AC power is
removed or powertop enables power saving on USB8797 device.
Driver's suspend handler is called here, but resume handler
won't be called until the AC power is put back on or powertop
disables power saving for USB8797.

We need to refactor the suspend/resume handlers to support
usb autosuspend properly. For now let's just remove it.

Cc: <stable@vger.kernel.org> # 3.5+
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/usb.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index cb6b70a..2087488 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -525,13 +525,6 @@ static int mwifiex_usb_resume(struct usb_interface *intf)
 						   MWIFIEX_BSS_ROLE_ANY),
 				  MWIFIEX_ASYNC_CMD);
 
-#ifdef CONFIG_PM
-	/* Resume handler may be called due to remote wakeup,
-	 * force to exit suspend anyway
-	 */
-	usb_disable_autosuspend(card->udev);
-#endif /* CONFIG_PM */
-
 	return 0;
 }
 
@@ -571,7 +564,6 @@ static struct usb_driver mwifiex_usb_driver = {
 	.id_table = mwifiex_usb_table,
 	.suspend = mwifiex_usb_suspend,
 	.resume = mwifiex_usb_resume,
-	.supports_autosuspend = 1,
 };
 
 static int mwifiex_usb_tx_init(struct mwifiex_adapter *adapter)
-- 
1.8.2.3

