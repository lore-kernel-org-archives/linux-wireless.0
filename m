Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:34384 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164718AbdEYALm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 20:11:42 -0400
Received: by mail-pf0-f175.google.com with SMTP id 9so150116762pfj.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 17:11:37 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 03/14] mwifiex: reset interrupt status across device reset
Date: Wed, 24 May 2017 17:11:08 -0700
Message-Id: <20170525001119.64791-3-briannorris@chromium.org> (sfid-20170525_023118_868994_361C3C8E)
In-Reply-To: <20170525001119.64791-1-briannorris@chromium.org>
References: <20170525001119.64791-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When resetting the device, we might have queued up interrupts that
didn't get a chance to finish processing. We really don't need to handle
them at this point; we just want to make sure they don't cause us to try
to process old commands from before the device was reset.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index a1e98e36c1ce..3b7316b537ea 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1362,6 +1362,7 @@ static void mwifiex_uninit_sw(struct mwifiex_adapter *adapter)
 
 	adapter->surprise_removed = true;
 	mwifiex_terminate_workqueue(adapter);
+	adapter->int_status = 0;
 
 	/* Stop data */
 	for (i = 0; i < adapter->priv_num; i++) {
-- 
2.13.0.219.gdb65acc882-goog
