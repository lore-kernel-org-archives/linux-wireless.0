Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:34415 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932623AbdC1X7j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 19:59:39 -0400
Received: by mail-pg0-f42.google.com with SMTP id 21so366993pgg.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Mar 2017 16:59:38 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Cc: <linux-kernel@vger.kernel.org>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 1/2] mwifiex: fix use-after-free for FW reinit errors
Date: Tue, 28 Mar 2017 16:59:32 -0700
Message-Id: <20170328235933.950-1-briannorris@chromium.org> (sfid-20170329_020121_934430_12CC456A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we fail to reinit the FW when resetting the device (in the
synchronous version of mwifiex_init_hw_fw() -> mwifiex_fw_dpc()),
mwifiex_fw_dpc() will tear down the interface and free up the adapter.
But we don't actually check for all failure cases of mwifiex_fw_dpc(),
so some of them fall through and dereference adapter->fw_done with a
freed adapter, causing a use-after-free bug.

In any case, mwifiex_fw_dpc() will always signal FW completion -- in the
error OR success case -- so at best, this was repeat work. Let's not do
it.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 30f49944661f..98c83453ba5b 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1475,7 +1475,6 @@ mwifiex_reinit_sw(struct mwifiex_adapter *adapter)
 	}
 	mwifiex_dbg(adapter, INFO, "%s, successful\n", __func__);
 
-	complete_all(adapter->fw_done);
 	return 0;
 
 err_init_fw:
-- 
2.12.2.564.g063fe858b8-goog
