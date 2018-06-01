Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51500 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751600AbeFAKl1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Jun 2018 06:41:27 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 1/2] Revert "mwifiex: handle race during mwifiex_usb_disconnect"
Date: Fri, 1 Jun 2018 16:11:19 +0530
Message-ID: <1527849680-31445-1-git-send-email-gbhat@marvell.com> (sfid-20180601_124144_598449_32C80A77)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit b817047ae70c0bd67b677b65d0d69d72cd6e9728.

We have a better fix for this issue, which will be sent on top
of this revert.

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 6e3cf98..bc475b8 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -644,9 +644,6 @@ static void mwifiex_usb_disconnect(struct usb_interface *intf)
 					 MWIFIEX_FUNC_SHUTDOWN);
 	}
 
-	if (adapter->workqueue)
-		flush_workqueue(adapter->workqueue);
-
 	mwifiex_usb_free(card);
 
 	mwifiex_dbg(adapter, FATAL,
-- 
1.9.1
