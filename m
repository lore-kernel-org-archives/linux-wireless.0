Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40236 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S966066AbeEXNse (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 09:48:34 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH] mwifiex: handle race during mwifiex_usb_disconnect
Date: Thu, 24 May 2018 19:18:27 +0530
Message-ID: <1527169707-27317-1-git-send-email-gbhat@marvell.com> (sfid-20180524_154953_907328_1211896F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Race condition is observed during rmmod of mwifiex_usb:

1. The rmmod thread will call mwifiex_usb_disconnect(), download
   SHUTDOWN command and do wait_event_interruptible_timeout(),
   waiting for response.

2. The main thread will handle the response and will do a
   wake_up_interruptible(), unblocking rmmod thread.

3. On getting unblocked, rmmod thread  will make rx_cmd.urb = NULL in
   mwifiex_usb_free().

4. The main thread will try to resubmit rx_cmd.urb in
   mwifiex_usb_submit_rx_urb(), which is NULL.

To fix, wait for main thread to complete before calling
mwifiex_usb_free().

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index bc475b8..6e3cf98 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -644,6 +644,9 @@ static void mwifiex_usb_disconnect(struct usb_interface *intf)
 					 MWIFIEX_FUNC_SHUTDOWN);
 	}
 
+	if (adapter->workqueue)
+		flush_workqueue(adapter->workqueue);
+
 	mwifiex_usb_free(card);
 
 	mwifiex_dbg(adapter, FATAL,
-- 
1.9.1
