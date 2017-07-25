Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:34283 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756570AbdGYBO0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 21:14:26 -0400
Received: by mail-pg0-f54.google.com with SMTP id 123so64047721pgj.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2017 18:14:25 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2 16/20] mwifiex: debugfs: allow card_reset() to cancel things
Date: Mon, 24 Jul 2017 18:13:32 -0700
Message-Id: <20170725011336.99993-17-briannorris@chromium.org> (sfid-20170725_031748_810916_9BE369EF)
In-Reply-To: <20170725011336.99993-1-briannorris@chromium.org>
References: <20170725011336.99993-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The card_reset() implementation should be setting our state flags and
cancelling commands for us (i.e., in mwifiex_shutdown_drv()), so let's
not do it here.

Also, this debugfs file is useful for testing and debugging the reset
feature, so we shouldn't do extra preparatory steps here, as that might
cause different reset behavior, which could either cause new bugs or
paper over existing ones that this debug feature should otherwise help
us catch.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
new in v2
---
 drivers/net/wireless/marvell/mwifiex/debugfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/debugfs.c b/drivers/net/wireless/marvell/mwifiex/debugfs.c
index f6f105a7d3ff..6f4239be609d 100644
--- a/drivers/net/wireless/marvell/mwifiex/debugfs.c
+++ b/drivers/net/wireless/marvell/mwifiex/debugfs.c
@@ -940,8 +940,6 @@ mwifiex_reset_write(struct file *file,
 
 	if (adapter->if_ops.card_reset) {
 		dev_info(adapter->dev, "Resetting per request\n");
-		adapter->hw_status = MWIFIEX_HW_STATUS_RESET;
-		mwifiex_cancel_all_pending_cmd(adapter);
 		adapter->if_ops.card_reset(adapter);
 	}
 
-- 
2.14.0.rc0.284.gd933b75aa4-goog
