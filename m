Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:36084 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754977AbdDNVvs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2017 17:51:48 -0400
Received: by mail-pf0-f174.google.com with SMTP id 194so5564091pfv.3
        for <linux-wireless@vger.kernel.org>; Fri, 14 Apr 2017 14:51:48 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 2/4] mwifiex: reset timeout flag when resetting device
Date: Fri, 14 Apr 2017 14:51:18 -0700
Message-Id: <20170414215120.145038-2-briannorris@chromium.org> (sfid-20170414_235227_616169_13AF825B)
In-Reply-To: <20170414215120.145038-1-briannorris@chromium.org>
References: <20170414215120.145038-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we reset because of a command timeout, we should reset this flag.
Otherwise, we might erroneously think the next command after reset is
timing out, and trigger another reset.

The above behavior effectively neuters the automatic card_reset()
behavior, as it means we will never recover from a command timeout
properly (and in fact, we might enter an infinite loop:

  timeout -> reset -> (fake) timeout -> reset -> ...

This fixes a bug introduced with introduction of PCIe function level
reset support, but it was carried into the SDIO driver when it was
converted to use the same codepaths. And this is currently mostly a
problem only in the SDIO driver, because it's the only one with
automatic card_reset() support (e.g., on command timeout). But it will
be a problem for PCIe too, as I'm working on supporting automatic
card_reset() for PCIe.

Fixes: c742e623e941 ("mwifiex: sdio card reset enhancement")
Fixes: 4c5dae59d2e9 ("mwifiex: add PCIe function level reset support")
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 912b687f4671..89eccd7adbe5 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1441,6 +1441,7 @@ mwifiex_reinit_sw(struct mwifiex_adapter *adapter)
 	init_waitqueue_head(&adapter->init_wait_q);
 	adapter->is_suspended = false;
 	adapter->hs_activated = false;
+	adapter->is_cmd_timedout = 0;
 	init_waitqueue_head(&adapter->hs_activate_wait_q);
 	init_waitqueue_head(&adapter->cmd_wait_q.wait);
 	adapter->cmd_wait_q.status = 0;
-- 
2.12.2.762.g0e3151a226-goog
