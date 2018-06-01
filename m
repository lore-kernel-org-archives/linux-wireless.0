Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51086 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751346AbeFAKlh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Jun 2018 06:41:37 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 2/2] mwifiex: handle race during mwifiex_usb_disconnect
Date: Fri, 1 Jun 2018 16:11:20 +0530
Message-ID: <1527849680-31445-2-git-send-email-gbhat@marvell.com> (sfid-20180601_124145_156612_15E7EC42)
In-Reply-To: <1527849680-31445-1-git-send-email-gbhat@marvell.com>
References: <1527849680-31445-1-git-send-email-gbhat@marvell.com>
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

To fix this, move mwifiex_usb_free() from mwifiex_usb_disconnect
to mwifiex_unregister_dev(). Function mwifiex_unregister_dev() is
called after flushing the command and RX work queues.

Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index bc475b8..88f4c89 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -644,8 +644,6 @@ static void mwifiex_usb_disconnect(struct usb_interface *intf)
 					 MWIFIEX_FUNC_SHUTDOWN);
 	}
 
-	mwifiex_usb_free(card);
-
 	mwifiex_dbg(adapter, FATAL,
 		    "%s: removing card\n", __func__);
 	mwifiex_remove_card(adapter);
@@ -1353,6 +1351,8 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 {
 	struct usb_card_rec *card = (struct usb_card_rec *)adapter->card;
 
+	mwifiex_usb_free(card);
+
 	mwifiex_usb_cleanup_tx_aggr(adapter);
 
 	card->adapter = NULL;
-- 
1.9.1
