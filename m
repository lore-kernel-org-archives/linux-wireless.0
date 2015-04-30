Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:34098 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbbD3XwI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2015 19:52:08 -0400
Date: Thu, 30 Apr 2015 16:52:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Avinash Patil <patila@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mwifiex: do not return success when command times out
Message-ID: <20150430235202.GA35256@dtor-ws> (sfid-20150501_015234_797355_5B3566EF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wait_event_interruptible_timeout() returns 0 upon timeout. We should
convert it to a negative error code (such as -ETIMEDOUT) instead of
returning it directly, as return code of 0 indicates that command was
executed.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 0599e41..a0bc26c 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -64,6 +64,8 @@ int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter,
 						  *(cmd_queued->condition),
 						  (12 * HZ));
 	if (status <= 0) {
+		if (status == 0)
+			status = -ETIMEDOUT;
 		dev_err(adapter->dev, "cmd_wait_q terminated: %d\n", status);
 		mwifiex_cancel_all_pending_cmd(adapter);
 		return status;
-- 
2.2.0.rc0.207.ga3a616c


-- 
Dmitry
