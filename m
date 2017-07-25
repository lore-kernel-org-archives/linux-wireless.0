Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:35832 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756664AbdGYBON (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 21:14:13 -0400
Received: by mail-pf0-f180.google.com with SMTP id h29so18021339pfd.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2017 18:14:13 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2 02/20] mwifiex: reset interrupt status across device reset
Date: Mon, 24 Jul 2017 18:13:18 -0700
Message-Id: <20170725011336.99993-3-briannorris@chromium.org> (sfid-20170725_031514_073169_EDA481FB)
In-Reply-To: <20170725011336.99993-1-briannorris@chromium.org>
References: <20170725011336.99993-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When resetting the device, we might have queued up interrupts that
didn't get a chance to finish processing. We really don't need to handle
them at this point; we just want to make sure they don't cause us to try
to process old commands from before the device was reset.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
v2: no change
---
 drivers/net/wireless/marvell/mwifiex/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 8615099468da..275cf8dc4f2a 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1366,6 +1366,7 @@ static void mwifiex_uninit_sw(struct mwifiex_adapter *adapter)
 
 	adapter->surprise_removed = true;
 	mwifiex_terminate_workqueue(adapter);
+	adapter->int_status = 0;
 
 	/* Stop data */
 	for (i = 0; i < adapter->priv_num; i++) {
-- 
2.14.0.rc0.284.gd933b75aa4-goog
