Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35244 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754117Ab3IYCbi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 22:31:38 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Dmitry Khromov <icechrome@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.12 2/2] mwifiex: fix NULL pointer dereference in usb suspend handler
Date: Tue, 24 Sep 2013 19:31:25 -0700
Message-ID: <1380076285-29930-2-git-send-email-bzhao@marvell.com> (sfid-20130925_043143_623659_81D14349)
In-Reply-To: <1380076285-29930-1-git-send-email-bzhao@marvell.com>
References: <1380076285-29930-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bug 60815 - Interface hangs in mwifiex_usb
https://bugzilla.kernel.org/show_bug.cgi?id=60815

[ 2.883807] BUG: unable to handle kernel NULL pointer dereference
            at 0000000000000048
[ 2.883813] IP: [<ffffffff815a65e0>] pfifo_fast_enqueue+0x90/0x90

[ 2.883834] CPU: 1 PID: 3220 Comm: kworker/u8:90 Not tainted
            3.11.1-monotone-l0 #6
[ 2.883834] Hardware name: Microsoft Corporation Surface with
            Windows 8 Pro/Surface with Windows 8 Pro,
            BIOS 1.03.0450 03/29/2013

On Surface Pro, suspend to ram gives a NULL pointer dereference in
pfifo_fast_enqueue(). The stack trace reveals that the offending
call is clearing carrier in mwifiex_usb suspend handler.

Since commit 1499d9f "mwifiex: don't drop carrier flag over suspend"
has removed the carrier flag handling over suspend/resume in SDIO
and PCIe drivers, I'm removing it in USB driver too. This also fixes
the bug for Surface Pro.

Cc: <stable@vger.kernel.org> # 3.5+
Tested-by: Dmitry Khromov <icechrome@gmail.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/usb.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 2472d4b..1c70b8d 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -447,9 +447,6 @@ static int mwifiex_usb_suspend(struct usb_interface *intf, pm_message_t message)
 	 */
 	adapter->is_suspended = true;
 
-	for (i = 0; i < adapter->priv_num; i++)
-		netif_carrier_off(adapter->priv[i]->netdev);
-
 	if (atomic_read(&card->rx_cmd_urb_pending) && card->rx_cmd.urb)
 		usb_kill_urb(card->rx_cmd.urb);
 
@@ -509,10 +506,6 @@ static int mwifiex_usb_resume(struct usb_interface *intf)
 						  MWIFIEX_RX_CMD_BUF_SIZE);
 	}
 
-	for (i = 0; i < adapter->priv_num; i++)
-		if (adapter->priv[i]->media_connected)
-			netif_carrier_on(adapter->priv[i]->netdev);
-
 	/* Disable Host Sleep */
 	if (adapter->hs_activated)
 		mwifiex_cancel_hs(mwifiex_get_priv(adapter,
-- 
1.8.2.3

